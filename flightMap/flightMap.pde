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
//String selectedDate = "01/01/2022";

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
}

void draw() {
  background(14, 42, 71);

  // 1. Website layout (header/footer)
  drawLayout();

  // 2. Push content down so it doesn't overlap header
  pushMatrix();
  translate(0, 60); // move everything below header

  // draw map
  world.display();

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

    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y);

    fill(255, 0, 0);
    noStroke();
    ellipse(screen.x, screen.y, 8, 8);

    // hover tooltip
    if (dist(mouseX, mouseY - 60, screen.x, screen.y) < 10) {
      fill(0);
      rect(mouseX + 10, mouseY - 20, 60, 20, 5);

      fill(255);
      textSize(12);
      text(code, mouseX + 15, mouseY - 5);
    }
  }

  popMatrix();

  // 3. UI elements on top
  legend.display();
  panel.display();
}
String checkAirportClick(float mx, float my) {

  for (String code : locationManager.locations.keySet()) {

    // Only allow clicking your 10 airports
    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = locationManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y);

    if (dist(mx, my, screen.x, screen.y) < 8) {
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


void mousePressed() {
  float adjustedY = mouseY - 60;
  
  // Legend click FIRST
  String legendClick = legend.checkClick(mouseX, adjustedY);
  if (legendClick != null) {
    statusFilter = legendClick;
    panel.setFlight(null); // clear selection
    return;
  }

  // Airport click
  String airport = checkAirportClick(mouseX, adjustedY);
  if (airport != null) {
    if (airport.equals(selectedAirport)) {
      selectedAirport = null;
    } else {
      selectedAirport = airport;
    }
    panel.setFlight(null);
    return;
  }

  // Flight click (ONLY visible ones)
  FlightLocation clicked = interaction.checkClick(getVisibleFlights(), mouseX, adjustedY, world);
  panel.setFlight(clicked);
}
