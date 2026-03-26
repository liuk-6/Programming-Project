import java.util.HashMap;
import java.util.HashSet;
import java.util.Collections;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

///////////// CONSTANT VALUES ////////////////
String[] lines;
color RY_BLUE = #2B4779;
color RY_GOLD = #F4CA35;
color RY_WHITE = #FFFFFF;
color RY_BG = #F2F5F7;

/////////////GLOBAL VARIABLES///////////////////////
TrafficResultsScreen trafficResults;

/////////// MAIN SCREENS AT START ////////////////
final int home = 1;
final int queries = 2;
final int graphs = 3;
final int exit = 4;

////////// SECOND LAYER SCREENS ////////////////
final int flightsSearch = 5;
final int flightsDate = 6;
final int flightsTraffic = 7;

/////////THIRD LAYER - OUTPUT SCREENS ///////////
final int flightsOutput = 8;
final int dateOutput = 9;
final int trafficOutput = 10;
final int trafficOutputEastCoast = 11;
final int trafficOutputWestCoast = 12;
final int trafficOutputCentral = 13;

//////// STORING CHOICE //////////////////////
int currentScreen;
ArrayList<Integer> screenHistory = new ArrayList<Integer>();
UserSelection selection;

////////DISPLAY TABLE FOOTPRINT ///////////
Table myData;
TableDisplay myFlights;

int SCREENX = 800;
int SCREENY = 600;

Table table;
Flight flight;

///////// AIRPORT REGIONS ///////////////////
String[] westCoastAirports = {
  "LAX","SFO","SAN","OAK","SJC","BUR","LGB","SNA","SMF","ONT","SBA","MRY","FAT","PSP","SCK","SMX",
  "PDX","SEA","EUG","MFR","BLI","GEG",
  "LAS","RNO","PHX","TUS","AZA",
  "SLC",
  "BOI","IDA","BZN","GTF","MSO","FCA","BIL","JAC",
  "DEN","EGE","HDN","DRO","GJT","COS","PSC","RDM",
  "ANC","FAI","JNU","KTN","SIT","BET","BRW","OME","OTZ","ADK","ADQ","CDV","SCC","PSG","WRG","YAK",
  "HNL","OGG","KOA","LIH","ITO","GUM","SPN"
};
String[] eastCoastAirports = {
  "BOS","BDL","PVD","BTV","MHT",
  "JFK","LGA","EWR","HPN","ISP","ALB","BUF","ROC","SYR",
  "PHL","PIT","ABE","LBE","MDT","BWI","DCA","IAD","RIC","ORF",
  "RDU","CLT","AVL","GSP","MYR","CHA","SAV","ATL","USA",
  "MIA","FLL","MCO","TPA","JAX","RSW","PBI","EYW","PIE","SRQ","PGD","SFB","PNS","VPS","ECP",
  "BNA","MEM","SDF",
  "STT","STX","SJU","BQN","ACY"
};
String[] centralAirports = {
  "ORD","MDW","IND","CMH","CLE","CVG","DTW","FNT","GRR","SBN",
  "MKE","ATW","MSN","MLI","CID","PIA","BMI","RFD","BLV",
  "MSP","DSM","STL","MCI","OMA","ICT","SGF","GRI",
  "FAR","FSD","MOT","BIS","RAP",
  "DFW","DAL","HOU","IAH","AUS","SAT","ELP","TUL","OKC",
  "LBB","MAF","HRL","MFE","LRD","CRP","SHV",
  "LIT","XNA","MSY","JAN",
  "BHM"
};

////////////TABLE FOR ROUTES DISPLAY//////////////
Table myTrafficData;
TableDisplay myTrafficRoutes;

///////// DECLARING SCREENS ////////////////
PImage backgroundImg;
HomeScreen homeScreen;
Screen currentScreenObject;
PImage planeHomeScreen;
PImage SearchButton;
PImage sunset;
PImage arrow;

QueriesScreen queriesScreen;
QueriesFlights flightsSearchScreen;
QueriesDate flightDateScreen;
QueriesTraffic flightTrafficScreen;

TrafficResultsScreen trafficOutputScreen;
FlightsOutputScreen flightsOutputScreen;

GraphsScreen graphsScreen;

///////// ARRAY LISTS ///////////////////////////////////////////////
ArrayList<Flight> flightsList;
ArrayList<Flight> flightsRoutes;
ArrayList<UserSelection> searchHistory;
ArrayList<Flight> results;
String flightsFound = "";

ArrayList<Route> eastCoastRoutes;
ArrayList<Route> westCoastRoutes;
ArrayList<Route> centralRoutes;

PFont font;

//////////////////////METHODS/////////////////////////////////////////////////////
void goTo(int nextScreen) {
  screenHistory.add(currentScreen);
  currentScreen = nextScreen;
}

void goBack() {
  if (screenHistory.size() > 0) {
    currentScreen = screenHistory.remove(screenHistory.size() - 1);
  }
}
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

// ---- CORE ROUTE COMPUTATION FROM REAL CSV DATA ----
ArrayList<Route> computeTopRoutes(String[] airports, int topN) {
  HashMap<String, Integer> counts = new HashMap<String, Integer>();

  HashSet<String> airportSet = new HashSet<String>();
  for (String code : airports) airportSet.add(code);

  for (Flight f : flightsList) {
    if (airportSet.contains(f.origin) && airportSet.contains(f.destination)) {
      String key = f.origin + ">" + f.destination;
      counts.put(key, counts.getOrDefault(key, 0) + 1);
    }
  }

  ArrayList<String> keys = new ArrayList<String>(counts.keySet());
  Collections.sort(keys, (a, b) -> counts.get(b) - counts.get(a));

  ArrayList<Route> routes = new ArrayList<Route>();
  for (int i = 0; i < min(topN, keys.size()); i++) {
    String key = keys.get(i);
    String[] parts = key.split(">");
    routes.add(new Route(parts[0], parts[1], counts.get(key)));
  }
  return routes;
}

void loadRouteData() {
  eastCoastRoutes = computeTopRoutes(eastCoastAirports, 15);
  westCoastRoutes = computeTopRoutes(westCoastAirports, 15);
  centralRoutes   = computeTopRoutes(centralAirports,   15);
}

void searchEastCoast()  { eastCoastRoutes = computeTopRoutes(eastCoastAirports, 15); }
void searchWestCoast()  { westCoastRoutes = computeTopRoutes(westCoastAirports, 15); }
void searchCentral()    { centralRoutes   = computeTopRoutes(centralAirports,   15); }
void searchBusiestRoutes() { loadRouteData(); }
void searchFlightsDateRange() { searchFlightsByDate(); }

// ---- FLIGHT SEARCH METHODS ----
void searchFlightsByDate() {
  results.clear();
  DateTimeFormatter csvFormat = DateTimeFormatter.ofPattern("M/d/yyyy");
  try {
    LocalDate start = LocalDate.parse(selection.dateStart, csvFormat);
    LocalDate end   = LocalDate.parse(selection.dateEnd,   csvFormat);
    for (Flight f : flightsList) {
      LocalDate flightDate = LocalDate.parse(f.date, csvFormat);
      if (!flightDate.isBefore(start) && !flightDate.isAfter(end)) {
        results.add(f);
      }
    }
    Collections.sort(results, (a, b) -> Integer.compare(a.scheduledDepartureTime, b.scheduledDepartureTime));
  } catch (Exception e) {
    println("Error: check date format");
  }
}

void searchFlight() {
  results.clear();
  DateTimeFormatter csvFormat = DateTimeFormatter.ofPattern("M/d/yyyy");
  try {
    LocalDate start = LocalDate.parse(selection.dateStart, csvFormat);
    LocalDate end   = LocalDate.parse(selection.dateEnd,   csvFormat);
    for (Flight f : flightsList) {
      LocalDate flightDate = LocalDate.parse(f.date, csvFormat);
      String userOrigin = selection.origin.toLowerCase().trim();
      String userDest   = selection.destination.toLowerCase().trim();
      boolean originMatch = f.origin.equalsIgnoreCase(userOrigin) || f.originCityName.toLowerCase().contains(userOrigin);
      boolean destMatch   = f.destination.equalsIgnoreCase(userDest) || f.destinationCityName.toLowerCase().contains(userDest);
      if (originMatch && destMatch && !flightDate.isBefore(start) && !flightDate.isAfter(end)) {
        results.add(f);
      }
    }
  } catch (Exception e) {
    println("Search Error: Check date format");
  }
  Collections.sort(results, (a, b) -> Integer.compare(a.scheduledDepartureTime, b.scheduledDepartureTime));
  goTo(flightsOutput);
}

// ---- DRAWING METHODS FOR TRAFFIC PANEL ----
void drawPanel() {
  background(RY_BLUE);

  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("MOST BUSY TRAFFIC ROUTES", width/2, 50);

  // Back button
  fill(RY_GOLD);
  noStroke();
  rect(30, 22, 80, 30, 8);
  fill(RY_BLUE);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("BACK", 70, 37);
}

void drawAllZones() {
  float padding = 30;
  float cardW = (width - padding * 4) / 3;
  float cardH = 450;
  float startY = 100;

  drawZoneCard(eastCoastRoutes, "EAST COAST",  padding,             startY, cardW, cardH, color(135, 206, 250, 180));
  drawZoneCard(centralRoutes,   "CENTRAL",     padding*2 + cardW,   startY, cardW, cardH, color(255, 223, 130, 180));
  drawZoneCard(westCoastRoutes, "WEST COAST",  padding*3 + cardW*2, startY, cardW, cardH, color(144, 238, 144, 180));
}

void drawZoneCard(ArrayList<Route> routes, String title, float x, float y, float w, float h, color bgColor) {
  fill(bgColor);
  noStroke();
  rect(x, y, w, h, 20);

  fill(RY_BLUE);
  textSize(18);
  textAlign(CENTER, TOP);
  text(title, x + w/2, y + 10);

  textSize(13);
  textAlign(LEFT, TOP);
  fill(30);
  float routeY = y + 42;
  int rank = 1;

  for (Route r : routes) {
    String line = rank + ". " + r.origin + " > " + r.destination + "  (" + r.passengers + " flights)";
    text(line, x + 10, routeY);
    routeY += 24;
    stroke(150, 60);
    line(x + 5, routeY - 4, x + w - 5, routeY - 4);
    noStroke();
    rank++;
  }

  if (routes.size() == 0) {
    fill(100);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("No intra-region routes found", x + w/2, y + h/2);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1200, 700);
  textSize(18);

  // Initialise region lists early so they exist before loadRouteData()
  eastCoastRoutes = new ArrayList<Route>();
  westCoastRoutes = new ArrayList<Route>();
  centralRoutes   = new ArrayList<Route>();

  // Load CSV FIRST so flightsList exists before loadRouteData() runs
  lines = loadStrings("flights2k.csv");
  if (lines == null) {
    println("Error reading file");
    exit();
  }
  println("CSV loaded: " + lines.length + " lines");

  table = loadTable("flights2k.csv", "header");
  flightsList = new ArrayList<Flight>();
  for (int row = 0; row < table.getRowCount(); row++) {
    flightsList.add(new Flight(row));
  }
  println("Flights loaded: " + flightsList.size());

  // NOW populate routes from real data
  loadRouteData();

  trafficResults = new TrafficResultsScreen(eastCoastRoutes, centralRoutes, westCoastRoutes);

  searchHistory = new ArrayList<UserSelection>();
  results = new ArrayList<Flight>();

  //////////////////// Screens ////////////////////
  currentScreen       = home;
  queriesScreen       = new QueriesScreen();
  graphsScreen        = new GraphsScreen();
  flightsSearchScreen = new QueriesFlights();
  flightDateScreen    = new QueriesDate();
  flightTrafficScreen = new QueriesTraffic();
  flightsOutputScreen = new FlightsOutputScreen();

  planeHomeScreen = loadImage("PlaneImg.jpg");
  backgroundImg   = loadImage("BackgroundImg.jpg");
  SearchButton    = loadImage("SearchButton.png");
  arrow           = loadImage("Arrow.png");
  sunset          = loadImage("Sunset.png");
  homeScreen = new HomeScreen();
  currentScreenObject    = homeScreen;

  selection = new UserSelection("", "", "", "");

  //////////////////// Tables ////////////////////
  myData = new Table();
  myData.addColumn("Flight ID");
  myData.addColumn("Date");
  myData.addColumn("Origin");
  myData.addColumn("Departure");
  myData.addColumn("Arrival");
  myData.addColumn("Destination");
  addFlightsToTable(flightsList);
  myFlights = new TableDisplay(myData, 50, 150);

  myTrafficData = new Table();
  myTrafficData.addColumn("Origin");
  myTrafficData.addColumn("Origin City Name");
  myTrafficData.addColumn("Destination City Name");
  myTrafficData.addColumn("Destination");
  flightsRoutes = new ArrayList<Flight>();
  addFlightsRoutesToTable(flightsRoutes);
  myTrafficRoutes = new TableDisplay(myTrafficData, 250, 150);
}

void draw() {
  background(30);

  switch(currentScreen) {
  case home: currentScreenObject = homeScreen; break;
  case queries: currentScreenObject = queriesScreen; break;
  case flightsSearch: currentScreenObject = flightsSearchScreen; break;
  case flightsDate: currentScreenObject = flightDateScreen; break;
  case flightsTraffic: currentScreenObject = flightTrafficScreen; break;
  case flightsOutput: currentScreenObject = flightsOutputScreen; break;
  case trafficOutput: currentScreenObject = trafficOutputScreen; break;
  case trafficOutputEastCoast: currentScreenObject = trafficOutputScreen; break;
  case trafficOutputWestCoast: currentScreenObject = trafficOutputScreen; break;
  case trafficOutputCentral: currentScreenObject = trafficOutputScreen; break;
  case graphs: currentScreenObject = graphsScreen; break;
  default: currentScreenObject = homeScreen; break;
}

if(currentScreenObject != null) currentScreenObject.draw();


  // Traffic panel drawn ON TOP only on traffic output screens
  if (currentScreen == trafficOutput) {
    drawPanel();
    drawAllZones();
  }
}

void mousePressed() {
  // Special back button for traffic panel
  if ((currentScreen == trafficOutput ||
       currentScreen == trafficOutputEastCoast ||
       currentScreen == trafficOutputWestCoast ||
       currentScreen == trafficOutputCentral) &&
      mouseX > 30 && mouseX < 110 &&
      mouseY > 22 && mouseY < 52) {
    goBack();   
    return;
  }

  // delegate click to current screen
  if (currentScreenObject != null) {
    currentScreenObject.mousePressed();
  }
}

void keyPressed() {
  if (currentScreenObject != null) currentScreenObject.keyPressed(key);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (currentScreen == flightsOutput) {
    flightsOutputScreen.scrollFlights(e);
  }
}
