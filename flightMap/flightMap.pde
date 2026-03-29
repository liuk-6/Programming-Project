import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

// ── Global state ──────────────────────────────────────────────
String selectedAirport = null;  // currently selected airport code
String statusFilter    = "ALL"; // active legend filter

// Layout dimensions
float headerH, footerH;
float contentX, contentY, contentW, contentH;

// Core objects
WorldMap         world;
FlightManager    manager;
InteractionManager interaction;
InfoPanel        panel;
LocationManager  locationManager;
Legend           legend;
Table            table;

FlightLocation hoveredFlight = null;

// ── Setup ─────────────────────────────────────────────────────
void setup() {
  size(1200, 700);

  // Load map and data
  world         = new WorldMap("usa.svg");
  locationManager = new LocationManager();
  locationManager.loadLocations("airports.csv");
  table   = loadTable("flights2k.csv", "header");
  manager = new FlightManager();
  manager.loadFromTable(table, locationManager);

  // UI components
  interaction = new InteractionManager();
  panel       = new InfoPanel();
  legend      = new Legend();

  // Layout measurements
  headerH  = 60;
  footerH  = 40;
  contentX = 0;
  contentY = headerH;
  contentW = width;
  contentH = height - headerH - footerH;
}

// ── Draw loop ─────────────────────────────────────────────────
void draw() {
  background(14, 42, 71);

  drawLayout();

  // Draw the SVG map
  world.display(contentX, contentY, contentW, contentH);

  // Get the flights that pass the current filters
  ArrayList<FlightLocation> flights = getVisibleFlights();

  // Update hovered flight based on mouse position
  // mouseY - headerH converts screen coords to content coords
  hoveredFlight = interaction.checkHover(flights, mouseX, mouseY, world);

  // Draw each flight arc
  for (FlightLocation f : flights) {
    boolean isSelected = (panel.getFlight() == f);
    boolean isHovered  = (hoveredFlight == f);
    f.display(world, isSelected || isHovered, selectedAirport);
  }

  // Draw airport dots on top of arcs
  drawAirports();

  // Draw UI panels on top of everything
  legend.display();
  panel.display();
  drawSelectedAirportBox();
}

// ── Draw airport dots and hover tooltips ──────────────────────
void drawAirports() {
  for (String code : locationManager.locations.keySet()) {

    PVector geo    = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y,
                       contentX, contentY, contentW, contentH);

    if (manager.allowedAirports.contains(code)) {
      // Selectable airports shown in red
      fill(255, 0, 0);
      noStroke();
      ellipse(screen.x, screen.y, 8, 8);

      // Show code tooltip on hover
      if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
        fill(0);
        rect(mouseX + 10, mouseY - 20, 60, 20, 5);
        fill(255);
        textSize(12);
        text(code, mouseX + 15, mouseY - 5);
      }
    }
  }
}

// ── Header / footer / content background ─────────────────────
void drawLayout() {
  noStroke();

  // Header bar
  fill(14, 42, 71);
  rect(0, 0, width, headerH);
  fill(255);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Flight Paths", 20, headerH / 2);

  // Footer bar
  fill(14, 42, 71);
  rect(0, height - footerH, width, footerH);

  // Content area background
  fill(218, 224, 242);
  rect(0, headerH, width, height - headerH - footerH, 25);
}

// ── Small box showing the currently selected airport ─────────
void drawSelectedAirportBox() {
  if (selectedAirport == null) return;

  float x = 20;
  float y = height - footerH - 70;

  fill(0, 180);
  noStroke();
  rect(x, y, 220, 50, 10);

  fill(255);
  textSize(14);
  textAlign(LEFT, CENTER);
  text("Selected Airport:", x + 10, y + 18);
  textSize(18);
  text(selectedAirport, x + 10, y + 38);
}

// ── Returns flights that match the active airport + status filters ──
ArrayList<FlightLocation> getVisibleFlights() {
  ArrayList<FlightLocation> visible = new ArrayList<FlightLocation>();

  for (FlightLocation f : manager.getFlights()) {

    // Airport filter: only show flights connected to selected airport
    if (selectedAirport != null) {
      if (!f.origin.equals(selectedAirport) &&
          !f.destination.equals(selectedAirport)) continue;
    }

    // Status filter: skip flights that don't match legend selection
    if (!statusFilter.equals("ALL") && !f.status.equals(statusFilter)) continue;

    visible.add(f);
  }
  return visible;
}

// ── Check if user clicked on an airport dot ──────────────────
String checkAirportClick(float mx, float my) {
  for (String code : locationManager.locations.keySet()) {
    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo    = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y,
                       contentX, contentY, contentW, contentH);

    if (dist(mx, my, screen.x, screen.y) < 10) return code;
  }
  return null;
}

// ── Mouse click handler ───────────────────────────────────────
void mousePressed() {

  // 1. Check legend buttons first
  String legendClick = legend.checkClick(mouseX, mouseY);
  if (legendClick != null) {
    statusFilter = legendClick;
    panel.setFlight(null);
    return;
  }

  // 2. Check airport dots
  String airport = checkAirportClick(mouseX, mouseY);
  if (airport != null) {
    // Toggle: clicking the same airport deselects it
    selectedAirport = airport.equals(selectedAirport) ? null : airport;
    panel.setFlight(null);
    return;
  }

  // 3. Check flight arcs
  FlightLocation clicked = interaction.checkClick(
    getVisibleFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
