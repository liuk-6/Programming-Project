///////////// CONSTANT VALUES////////////////
String[] lines;
int home = 1;
int queries =2;
int flights = 3;
int data = 4;
int exit = 5;
int currentScreen = home; 
//homeScreen = 1; queriesScreen = 2; flightScreen =3; dataScreen =4;

// User selection for queries
UserSelection selection;

//SCREEN DIMENSIONS
int SCREENX = 800;
int SCREENY = 600;

// Flights data management
Table table;
Flight flight;
  
// Home Screen
PImage planeHomeScreen;
HomeScreen homeScreen;
Screen current;

QueriesScreen queriesScreen;
FlightsScreen flightsScreen;
DataScreen dataScreen;

/////////////////////////////////////////////

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

  // Files to array
  table = loadTable("flights2k.csv", "header");
  ArrayList<Flight> flights = new ArrayList<Flight>();
  for (int row = 0; row < table.getRowCount(); row++)
  {
    flights.add(new Flight(row));
  }
  // Screens setup
  queriesScreen = new QueriesScreen();
  flightsScreen = new FlightsScreen();
  dataScreen = new DataScreen();
  // Home Screen
  planeHomeScreen = loadImage("PlaneImg.jpg");
  homeScreen = new HomeScreen();
  current = homeScreen;
  
  // User selection definition
  selection = new UserSelection("","");

}

void draw() {

  // Draw screen buttons
  if (currentScreen == home){
    current=homeScreen;
    homeScreen.draw();
  }

  else if (currentScreen == queries){
    current = queriesScreen;
    queriesScreen.draw();
  }

  else if (currentScreen == flights){
    current = flightsScreen;
    flightsScreen.draw();
  }

  else if (currentScreen == data){
    current = dataScreen;
    dataScreen.draw();
  }
}


// Mouse interaction
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

// Key interaction
void keyPressed() {
  
  if(current!=null){
    if(keyCode==SHIFT) return;
    
    
    current.keyPressed(key);
  }
}
