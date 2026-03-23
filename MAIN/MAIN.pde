import java.util.Collections;
import java.util.Comparator;
///////////// CONSTANT VALUES////////////////
String[] lines;
int home = 1;
int queries = 2;
int flights = 3;
int data = 4;
int exit = 5;
int currentScreen = home;


UserSelection selection;

Table myData;
TableDisplay myFlights;


int SCREENX = 800;
int SCREENY = 600;


Table table;
Flight flight;

// Home Screen
PImage planeHomeScreen;
HomeScreen homeScreen;
Screen current;

QueriesScreen queriesScreen;
FlightsScreen flightsScreen;
DataScreen dataScreen;

ArrayList<Flight> flightsList;  //list where all the flights are stored
ArrayList<UserSelection> searchHistory; // input
ArrayList<Flight> results; //if flights found they will be stored in result
String flightsFound ="";

//////////////////////METHODS///////////////////////
void addFlightsToTable(ArrayList<Flight> list) {
  myData.clearRows();
  for (Flight f : list) {
    TableRow row = myData.addRow();
    row.setString("Flight ID", str(f.flightNumber));
    row.setString("Origin", f.origin);
    row.setString("Departure", formatTime(f.scheduledDepartureTime));
    row.setString("Arrival", formatTime(f.scheduledArrivalTime));
    row.setString("Destination", f.destination);
  }
}

String formatTime(int time) {
  String t = nf(time, 4);
  return t.substring(0, 2) + ":" + t.substring(2, 4);
}

void searchFlight() {
  results.clear();
  for (Flight f : flightsList) {
    if (f.origin.equals(selection.origin) && 
        f.destination.equals(selection.destination)) {
      results.add(f);
    }
  }
  Collections.sort(results, new Comparator<Flight>(){
    public int compare(Flight a, Flight b){
      return a.scheduledDepartureTime - b.scheduledDepartureTime;
    }
  });
  ArrayList<Flight> fiveFlights = new ArrayList<Flight>();
  int count = min(5, results.size());
  for (int i = 0; i < count; i++) {
    fiveFlights.add(results.get(i));
  }
  addFlightsToTable(fiveFlights);
  flightsFound = " Flights found: "+ results.size();
}
/////////////////////////////////////////////

void setup() {
  fullScreen();
  textSize(18);

  // Load CSV
  lines = loadStrings("flights2k.csv");
  if (lines == null) {
    println("Error reading file");
    exit();
  }
  println("CSV loaded: " + lines.length + " lines");

  // Load flights into list
  table = loadTable("flights2k.csv", "header");
  flightsList = new ArrayList<Flight>();
  for (int row = 0; row < table.getRowCount(); row++) {
    flightsList.add(new Flight(row));
  }

  searchHistory = new ArrayList<UserSelection>();
  results = new ArrayList<Flight>();

  // Screens setup
  queriesScreen = new QueriesScreen();
  flightsScreen = new FlightsScreen();
  dataScreen = new DataScreen();

  // Home Screen
  planeHomeScreen = loadImage("PlaneImg.jpg");
  homeScreen = new HomeScreen();
  current = homeScreen;

  // User selection
  selection = new UserSelection("", "");

  // Table setup
  myData = new Table();
  myData.addColumn("Flight ID");
  myData.addColumn("Origin");
  myData.addColumn("Departure");
  myData.addColumn("Arrival");
  myData.addColumn("Destination");

  addFlightsToTable(flightsList);

  myFlights = new TableDisplay(myData, 150, 200);
}

void draw() {
  if (currentScreen == home) {
    current = homeScreen;
    homeScreen.draw();
  } else if (currentScreen == queries) {
    current = queriesScreen;
    queriesScreen.draw();
  } else if (currentScreen == flights) {
    current = flightsScreen;
    flightsScreen.draw();
  } else if (currentScreen == data) {
    current = dataScreen;
    dataScreen.draw();
  }
}

void mousePressed() {
  if (currentScreen == home)
    homeScreen.mousePressed();
  else if (currentScreen == queries)
    queriesScreen.mousePressed();
  else if (currentScreen == flights)
    flightsScreen.mousePressed();
  else if (currentScreen == data)
    dataScreen.mousePressed();
  else if (currentScreen == exit)
    exit();
}

void mouseMoved() {
}

void keyPressed() {
  if (current != null) {
    if (keyCode == SHIFT) return;
    current.keyPressed(key);
  }
}
