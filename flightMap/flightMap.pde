import java.util.HashSet;
import java.util.ArrayList;
import java.util.HashMap;

String selectedAirport = null;

WorldMap world;
FlightManager manager;
InteractionManager interaction;
InfoPanel panel;
LocationManager locationManager;
Table table;
Legend legend;

FlightLocation hoveredFlight = null;

//filter settings
String statusFilter = "ALL";


float headerH;
float footerH;

float contentX;
float contentY;
float contentW;
float contentH;

void setup() {
  size(1200, 700);

  world = new WorldMap("usa.svg");

  locationManager = new LocationManager();
  locationManager.loadLocations("airports.csv");

  table = loadTable("flights2k.csv", "header");

  manager = new FlightManager();
  manager.loadFromTable(table, locationManager);

  interaction = new InteractionManager();
  panel = new InfoPanel();
  legend = new Legend();

  headerH = 60;
  footerH = 40;

  contentX = 0;
  contentY = headerH;
  contentW = width;
  contentH = height - headerH - footerH;
}

void draw() {
  background(14, 42, 71);

  // 1. Website layout (header/footer)
  drawLayout();

  // draw map
  world.display(contentX, contentY, contentW, contentH);
  // draw flights
  ArrayList<FlightLocation> flights = getVisibleFlights();

  hoveredFlight = interaction.checkClick(getVisibleFlights(), mouseX, mouseY - 60, world);

  for (FlightLocation f : flights) {
    boolean selected = (panel.selected == f);
    boolean hovered = (hoveredFlight == f);

    f.display(world, selected || hovered, selectedAirport);
  }

  // draw airports
  for (String code : locationManager.locations.keySet()) {

    PVector geo = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(
      geo.x, geo.y,
      contentX, contentY, contentW, contentH
      );

    // 🔴 Draw interactive airports on top
    if (manager.allowedAirports.contains(code)) {

      fill(255, 0, 0);
      ellipse(screen.x, screen.y, 8, 8);

      // hover tooltip
      if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
        fill(0);
        rect(mouseX + 10, mouseY - 20, 60, 20, 5);

        fill(255);
        textSize(12);
        text(code, mouseX + 15, mouseY - 5);
      }
    }
  }

  // 3. UI elements on top
  legend.display();
  panel.display();
  drawSelectedAirportBox();
}
String checkAirportClick(float mx, float my) {

  float contentX = 0;
  float contentY = headerH;
  float contentW = width;
  float contentH = height - headerH - footerH;

  for (String code : locationManager.locations.keySet()) {

    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(
      geo.x, geo.y,
      contentX, contentY, contentW, contentH
      );

    if (dist(mx, my, screen.x, screen.y) < 10) {
      return code;
    }
  }

  return null;
}

ArrayList<FlightLocation> getVisibleFlights() {

  ArrayList<FlightLocation> visible = new ArrayList<FlightLocation>();

  for (FlightLocation f : manager.getFlights()) {

    // ✈️ Airport filter
    if (selectedAirport != null) {
      if (!f.origin.equals(selectedAirport) && !f.destination.equals(selectedAirport)) {
        continue;
      }
    }

    // 🎨 Status filter
    if (!statusFilter.equals("ALL") && !f.status.equals(statusFilter)) {
      continue;
    }

    visible.add(f);
  }

  return visible;
}

void drawLayout() {

  // HEADER
  fill(14, 42, 71); // dark modern colour
  noStroke();
  rect(0, 0, width, 60);

  fill(255);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Flight Paths", 20, 30);

  // FOOTER
  fill(14, 42, 71);
  rect(0, height - 40, width, 40);

  // CONTENT BACKGROUND
  fill(218, 224, 242);
  rect(0, 60, width, height - 100, 25);
}

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
  text(selectedAirport, x + 10, y + 35);
}

void mousePressed() {

  // Legend click FIRST
  String legendClick = legend.checkClick(mouseX, mouseY);
  if (legendClick != null) {
    statusFilter = legendClick;
    panel.setFlight(null);
    return;
  }

  // Airport click
  String airport = checkAirportClick(mouseX, mouseY);
  if (airport != null) {
    selectedAirport = airport.equals(selectedAirport) ? null : airport;
    panel.setFlight(null);
    return;
  }

  // Flight click
  FlightLocation clicked = interaction.checkClick(getVisibleFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
