WorldMap world;
FlightManager manager;
InteractionManager interaction;
InfoPanel panel;
AirportManager airportManager;
Table table;
FlightLocation flight;

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
}
void draw() {
  background(255);

  world.display();

  ArrayList<FlightLocation> flights = manager.getFlights();

  for (FlightLocation f : flights) {
    boolean selected = (panel.selected == f);
    f.display(world, selected);
  }

  //panel.display();
  PVector ny = world.geoToScreen(40.7128, -74.0060);
  fill(255, 0, 0);
  ellipse(ny.x, ny.y, 10, 10);

  PVector la = world.geoToScreen(34.0522, -118.2437);
  ellipse(la.x, la.y, 10, 10);
}

void mousePressed() {
  FlightLocation clicked = interaction.checkClick(manager.getFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
