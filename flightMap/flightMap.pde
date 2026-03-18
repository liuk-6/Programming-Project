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

  world = new WorldMap("america.jpg");

  airportManager = new AirportManager();
  airportManager.loadAirports("airports.csv");

  table = loadTable("flights2k.csv", "header");

  manager = new FlightManager();
  manager.loadFromTable(table, airportManager);

  interaction = new InteractionManager();
  panel = new InfoPanel();
}
void draw() {
  background(0);

  world.display();

  ArrayList<FlightLocation> flights = manager.getFlights();

  for (FlightLocation f : flights) {
    boolean selected = (panel.selected == f);
    f.display(world, selected);
  }

  panel.display();
}

void mousePressed() {
  FlightLocation clicked = interaction.checkClick(manager.getFlights(), mouseX, mouseY, world);
  panel.setFlight(clicked);
}
