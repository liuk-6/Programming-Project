import java.util.Collections;
import java.util.Comparator;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

///////////// CONSTANT VALUES ////////////////
String[] lines;
color RY_BLUE = #2B4779;
color RY_GOLD = #F4CA35;
color RY_WHITE = #FFFFFF;
color RY_BG = #F2F5F7; // Light grey-blue background found on their site

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
  DateTimeFormatter csvFormat = DateTimeFormatter.ofPattern("M/d/yyyy");

  try {
    LocalDate start = LocalDate.parse(selection.dateStart, csvFormat);
    LocalDate end = LocalDate.parse(selection.dateEnd, csvFormat);

    for (Flight f : flightsList) {
      // Clean date and match city/code
      LocalDate flightDate = LocalDate.parse(f.date, csvFormat);
      String userOrigin = selection.origin.toLowerCase().trim();
      String userDest = selection.destination.toLowerCase().trim();

      boolean originMatch = f.origin.equalsIgnoreCase(userOrigin) || f.originCityName.toLowerCase().contains(userOrigin);
      boolean destMatch = f.destination.equalsIgnoreCase(userDest) || f.destinationCityName.toLowerCase().contains(userDest);

      if (originMatch && destMatch && !flightDate.isBefore(start) && !flightDate.isAfter(end)) {
        results.add(f);
      }
    }
  } catch (Exception e) {
    println("Search Error: Check date format");
  }

  // Sort by time for a professional "Timeline" feel
  Collections.sort(results, (a, b) -> Integer.compare(a.scheduledDepartureTime, b.scheduledDepartureTime));
  
  // SWITCH SCREEN
  currentScreen = flightsOutput; 
}








void searchFlightsDateRange()
{
  DateTimeFormatter df = DateTimeFormatter.ofPattern("MM/dd/yyyy");
    try {
    LocalDate start = LocalDate.parse(selection.dateStart, df);
    LocalDate end = LocalDate.parse(selection.dateEnd, df);

    for (Flight f : flightsList) {
      LocalDate flightDate = LocalDate.parse(f.date, df);

      if (!flightDate.isBefore(start) && !flightDate.isAfter(end)) {
        results.add(f);
      }
    }
    
      Collections.sort(results, (a, b) -> {
      LocalDate d1 = LocalDate.parse(a.date, df);
      LocalDate d2 = LocalDate.parse(b.date, df);
      return d1.compareTo(d2);
    });

    println("Date Search Complete: Found " + results.size() + " flights.");

  } catch (Exception e) {
    println("Error: Please use the format M/D/YYYY (e.g. 1/1/2022)");
  }
}
void searchBusiestRoutes(){

}
void searchEastCoast(){

}
void searchWestCoast(){

}
void searchCentral(){

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
  // Update which screen 'current' points to based on currentScreen ID
  if (currentScreen == home)            current = homeScreen;
  else if (currentScreen == queries)     current = queriesScreen;
  else if (currentScreen == flightsSearch) current = flightsSearchScreen;
  else if (currentScreen == flightsDate)   current = flightDateScreen;
  else if (currentScreen == flightsTraffic)current = flightTrafficScreen;
  else if (currentScreen == graphs)      current = graphsScreen;
  else if (currentScreen == flightsOutput) current = flightsOutputScreen;
  // ... add the rest of your output screens here ...

  if (current != null) {
    current.draw();
  }
}

void mousePressed() {
  // This single line handles EVERY screen automatically 
  // because every screen inherits from the Screen class
  if (current != null) {
    current.mousePressed();
  }
}

void keyPressed() {
  if (current != null) {
    current.keyPressed(key);
  }
}
