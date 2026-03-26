import java.util.HashSet;

String selectedAirport = null;
WorldMap world;
FlightManager manager;
InteractionManager interaction;
InfoPanel panel;
AirportManager airportManager;
Table table;
FlightLocation flight;
Legend legend;
FlightLocation hoveredFlight = null;
String statusFilter = "ALL"; // ALL, ON_TIME, DELAYED, CANCELLED

String selectedDate = "2022-01-01"; // change this

void setup() {
  size(1200, 700);

  world = new WorldMap("usa.svg");

  airportManager = new AirportManager();
  airportManager.loadAirports("airports.csv");

  table = loadTable("flights2k.csv", "header");

  manager = new FlightManager();
  manager.loadFromTable(table, airportManager);

  interaction = new InteractionManager();
  panel = new InfoPanel();

  legend = new Legend();
}
void draw() {
  background(255);

  world.display();

  hoveredFlight = interaction.checkClick(getVisibleFlights(), mouseX, mouseY, world);

  ArrayList<FlightLocation> flights = getVisibleFlights();

  for (FlightLocation f : flights) {

    boolean selected = (panel.selected == f);
    boolean hovered = (hoveredFlight == f);

    f.display(world, selected || hovered, selectedAirport);
  }
  legend.display();

  for (String code : airportManager.airports.keySet()) {

    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = airportManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y);

    fill(255, 0, 0);
    noStroke();
    ellipse(screen.x, screen.y, 8, 8);

    if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
      fill(255, 255, 0);
      ellipse(screen.x, screen.y, 12, 12);
    }
  }

  legend.display();

  for (String code : airportManager.airports.keySet()) {

    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = airportManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y);

    fill(255, 0, 0);
    noStroke();
    ellipse(screen.x, screen.y, 8, 8);

    if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
      fill(255, 255, 0);
      ellipse(screen.x, screen.y, 12, 12);
    }
  }

  for (String code : airportManager.airports.keySet()) {

    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = airportManager.getCoords(code);
    PVector screen = world.geoToScreen(geo.x, geo.y);

    // draw airport dot
    fill(255, 0, 0);
    noStroke();
    ellipse(screen.x, screen.y, 8, 8);

    // ✅ hover detection
    if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
      fill(0);
      rect(mouseX + 10, mouseY - 20, 60, 20, 5);

      fill(255);
      textSize(12);
      text(code, mouseX + 15, mouseY - 5);
    }
  }
  
    panel.display();

}
String checkAirportClick(float mx, float my) {

  for (String code : airportManager.airports.keySet()) {

    // Only allow clicking your 10 airports
    if (!manager.allowedAirports.contains(code)) continue;

    PVector geo = airportManager.getCoords(code);
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



void mousePressed() {

  // Legend click FIRST
  String legendClick = legend.checkClick(mouseX, mouseY);
  if (legendClick != null) {
    statusFilter = legendClick;
    panel.setFlight(null); // clear selection
    return;
  }

  // Airport click
  String airport = checkAirportClick(mouseX, mouseY);
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
  FlightLocation clicked = interaction.checkClick(getVisibleFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
