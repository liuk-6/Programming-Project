import java.util.HashSet;

String selectedAirport = null;
WorldMap world;
FlightManager manager;
InteractionManager interaction;
InfoPanel panel;
AirportManagerr airportManager;
Table table;
FlightLocationn flight;
Legend legend;

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

  ArrayList<FlightLocation> flights = getVisibleFlights();

  for (FlightLocation f : flights) {
    boolean selected = (panel.selected == f);
    f.display(world, selected);
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

    if (selectedAirport != null) {
      if (!f.origin.equals(selectedAirport) && !f.destination.equals(selectedAirport)) {
        continue;
      }
    }

    visible.add(f);
  }

  return visible;
}



void mousePressed() {

  // ✅ Check airport click FIRST
  String airport = checkAirportClick(mouseX, mouseY);

  if (airport != null) {
    if (airport.equals(selectedAirport)) {
      selectedAirport = null; // toggle off
    } else {
      selectedAirport = airport;
    }
    panel.setFlight(null);
    return;
  }
  // ✅ Otherwise check flight click
  FlightLocation clicked = interaction.checkClick(getVisibleFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
