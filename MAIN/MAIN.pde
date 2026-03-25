import java.util.Collections;
import java.util.Comparator;
///////////// CONSTANT VALUES ////////////////
String[] lines;

/////////// MAIN SCREENS AT START ////////////////
int home = 1;
int queries = 2;
int graphs = 3;
int exit = 4;

////////// SECOND LAYER SCREENS ////////////////
int flightsSearch = 5;
int flightsDate = 6;
int flightsTraffic = 7;

/////////THIRD LAYER - OUTPUT SCREENS ///////////
int flightsOutput = 8;
int dateOutput = 9;
int trafficOutput = 10;
int trafficOutputEastCoast = 11;
int trafficOutputWestCoast = 12;
int trafficOutputCentral = 13;

//////// STROING CHOICE //////////////////////
int currentScreen;
UserSelection selection;

////////DISPLAY TABLE FOOTPRINT ///////////
Table myData;
TableDisplay myFlights;

int SCREENX = 800;
int SCREENY = 600;

Table table;
Flight flight;

////////////TABLE FOR ROUTES DISPLAY//////////////
Table myTrafficData;
TableDisplay myTrafficRoutes;


///////// DECLARING SCREENS ////////////////
PImage backgroundImg;
HomeScreen homeScreen;
Screen current;
PImage planeHomeScreen;
PImage SearchButton;
PImage sunset;
PImage arrow;

QueriesScreen queriesScreen;
QueriesFlights flightsSearchScreen;

QueriesDate flightDateScreen;
QueriesTraffic flightTrafficScreen;

FlightsOutputScreen flightsOutputScreen;
DatesOutputScreen datesOutputScreen;
TrafficOutputScreenEastCoast trafficOutputScreenEastCoast;
TrafficOutputScreenWestCoast trafficOutputScreenWestCoast;
TrafficOutputScreenCentral trafficOutputScreenCentral;


GraphsScreen graphsScreen;

///////// CREATING ARRAY LISTS ///////////////////////////////////////////////

ArrayList<Flight> flightsList;  //list where all the flights are stored
ArrayList<Flight> flightsRoutes;
ArrayList<UserSelection> searchHistory; // input
ArrayList<Flight> results; //if flights found they will be stored in result
String flightsFound ="";

//////////////////////METHODS/////////////////////////////////////////////////////
void addFlightsToTable(ArrayList<Flight> list) {
  myData.clearRows();
  for (Flight f : list) {
    TableRow row = myData.addRow();
    row.setString("Date", f.date);
    row.setString("Flight ID", str(f.flightNumber));
    row.setString("Origin", f.origin);
    row.setString("Departure", formatTime(f.scheduledDepartureTime));
    row.setString("Arrival", formatTime(f.scheduledArrivalTime));
    row.setString("Destination", f.destination);
  }
}
void addFlightsRoutesToTable(ArrayList<Flight> list) {
  myTrafficData.clearRows();
  for (Flight f : list) {
    TableRow row = myTrafficData.addRow();
    row.setString("Flight ID", str(f.flightNumber));
    row.setString("Origin", f.origin);
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
    return Integer.compare(a.scheduledDepartureTime, b.scheduledDepartureTime);    }
  });
  ArrayList<Flight> fiveFlights = new ArrayList<Flight>();
  int count = min(8, results.size());
  for (int i = 0; i < count; i++) {
    fiveFlights.add(results.get(i));
  }
  addFlightsToTable(fiveFlights);
  flightsFound = " Flights found: "+ results.size();
}
void searchFlightsDateRange(){

}
void searchBusiestRoutes(){

}
void searchAmerica(){

}
void searchWorldwide(){

}
void searchEurope(){

}
////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1200,700);
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

////////////////////Main Screens First Choice Setup/////////////
  currentScreen = home;
  queriesScreen = new QueriesScreen();
  graphsScreen = new GraphsScreen();

///////////////////Second Choice Screens Setup/////////////////
  flightsSearchScreen = new QueriesFlights();
  flightDateScreen = new QueriesDate();
  flightTrafficScreen  = new QueriesTraffic();
  
//////////////Defining output screens//////////////////////////
  flightsOutputScreen = new FlightsOutputScreen();
  datesOutputScreen = new DatesOutputScreen();
  trafficOutputScreenEastCoast = new TrafficOutputScreenEastCoast();
  trafficOutputScreenWestCoast = new TrafficOutputScreenWestCoast();
  trafficOutputScreenCentral = new TrafficOutputScreenCentral();

  
//////////////// Home Screen//////////////////////////////////
  planeHomeScreen = loadImage("PlaneImg.jpg");
  backgroundImg = loadImage("BackgroundImg.jpg");
  SearchButton = loadImage("SearchButton.png");
  arrow = loadImage("Arrow.png");
  sunset = loadImage("Sunset.png");
  homeScreen = new HomeScreen();
  current = homeScreen;

///////////////User selection///////////////////////////////
  selection = new UserSelection("", "", "", "");

///////////////Table setup////////////////////////////////
  myData = new Table();
  myData.addColumn("Flight ID");
  myData.addColumn("Date");
  myData.addColumn("Origin");
  myData.addColumn("Departure");
  myData.addColumn("Arrival");
  myData.addColumn("Destination");

  addFlightsToTable(flightsList);

  myFlights = new TableDisplay(myData, 50, 150);
  
////////////////// ROUTES TABLE SETUP ////////////////////////
  myTrafficData = new Table();
  myTrafficData.addColumn("Origin");
  myTrafficData.addColumn("Origin City Name");
  myTrafficData.addColumn("Destination City Name");
  myTrafficData.addColumn("Destination");
  flightsRoutes = new ArrayList<Flight>();
  addFlightsRoutesToTable(flightsRoutes); /////////////Change to correct list

  myTrafficRoutes = new TableDisplay(myTrafficData,250,150);
}

void draw() {

  if (currentScreen == home) {
    current = homeScreen;
    current.draw();

  } else if (currentScreen == queries) {
    current = queriesScreen;
    current.draw();

  } else if (currentScreen == flightsSearch) {
    current = flightsSearchScreen;
    current.draw();

  } else if (currentScreen == flightsDate) {
    current = flightDateScreen;
    current.draw();

  } else if (currentScreen == flightsTraffic) {
    current = flightTrafficScreen;
    current.draw();

  } else if (currentScreen == graphs) {
    current = graphsScreen;
    current.draw();
  }
  else if(currentScreen ==flightsOutput){
    current = flightsOutputScreen;
    current.draw();
  }
  else if(currentScreen ==dateOutput){
    current = datesOutputScreen;
    current.draw();
  }
  else if(currentScreen ==trafficOutputEastCoast){
    current = trafficOutputScreenEastCoast;
    current.draw();
  }
  else if(currentScreen ==trafficOutputWestCoast){
    current = trafficOutputScreenWestCoast;
    current.draw();
  }
  else if(currentScreen ==trafficOutputCentral){
    current = trafficOutputScreenCentral;
    current.draw();
  }
}

void mousePressed() {
  if (currentScreen == home)
    homeScreen.mousePressed();
  else if (currentScreen == queries)
    queriesScreen.mousePressed();
  else if (currentScreen == flightsSearch)
    flightsSearchScreen.mousePressed();
  else if (currentScreen == graphs)
    graphsScreen.mousePressed();
  else if (currentScreen == exit)
    exit();
  else if(currentScreen == flightsDate)
    flightDateScreen.mousePressed();
  else if(currentScreen == flightsTraffic)
    flightTrafficScreen.mousePressed();
  else if(currentScreen == flightsOutput)
    flightsOutputScreen.mousePressed();
   else if(currentScreen == dateOutput)
    datesOutputScreen.mousePressed();
   else if(currentScreen == trafficOutputEastCoast)
    trafficOutputScreenEastCoast.mousePressed();
   else if(currentScreen == trafficOutputWestCoast)
    trafficOutputScreenWestCoast.mousePressed();
   else if(currentScreen == trafficOutputCentral)
    trafficOutputScreenCentral.mousePressed();
}

void mouseMoved() {
}

void keyPressed() {
  if (current != null) {
    if (keyCode == SHIFT) return;
    current.keyPressed(key);
  }
}
