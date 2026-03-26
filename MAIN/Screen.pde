class Screen {
  ArrayList<Button> buttons = new ArrayList<Button>();

  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
  }

  void drawBackground() {
    background(100); // default
  }

  void mousePressed() {
    for (Button b : buttons) b.click();
  }

  void mouseMoved() {
    for (Button b : buttons) b.over(mouseX,mouseY);
  }

  void keyPressed(char k) {} //Optional if a feature is to be added
}
///////////////////////MENU SCREEN//////////////////////////////////////
class HomeScreen extends Screen{

  HomeScreen()
  {
    int buttonW = 80*6;
    int buttonH = 50;
    int yPos = height/2; // 20 px padding from bottom
    float x1 = 100 ;  // 1st button
    float x3 = 1100 - buttonW;  // 2nd button
    buttons.add(new Button(x1, yPos, buttonW, buttonH, "QUERIES", "queries",20, true));
    buttons.add(new Button(x3, yPos, buttonW, buttonH, "DASHBOARD", "dashboard",20, true));
    buttons.add(new Button(30, 22, 50, 30, "EXIT", "exit", 20, true));
  }
  void draw() {
  drawBackground();   // draws the plane
  fill(255);
  textAlign(CENTER);
  textSize(60);
  text("F  L  I  G  H  T   S  C  A  N  N  E  R", width/2, height/5);
  for (Button b : buttons) b.display();  // draws buttons on top
  }
  
  void planeImage(int x, int y)  {
    int planeX = x + 150;
    int planeY = y + 100;
    int planeW = 600;
    int planeH = 200;
    
    fill(200);
    rect(planeX, planeY, planeW, planeH);
      
   }
   void drawBackground(){

     fill(43, 71, 121);
     rect(0, 0, width, height);
     
     //Line at top
     fill(255);
     noStroke();
     rect(0, 70, width, 2);
     
     imageMode(CENTER);
     image(planeHomeScreen, width/2, height/1.9, width * 0.85, height*0.7);
     imageMode(CORNER);
   }
   void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("queries")) goTo(queries);
      if (b.type.equals("dashboard")) goTo(dashboard);
      if (b.type.equals("exit")) exit();
    }
  }
  }
}
/////////////////////////////////FIRST OPTIONS SCREENS /////////////////////////////////
class QueriesScreen extends Screen {
 
  boolean typingFirst = true;
  TextEntryButton currentInput;

  QueriesScreen() {
    // Add back button at bottom center
    int buttonW = 250;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    
    int queryX = 150;
    int queryY = height/4;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(queryX, queryY, buttonW, buttonH, "FLIGHT SEARCH", "flightQuery", 20, false));
    buttons.add(new Button(queryX+buttonW+50, queryY, buttonW, buttonH, "TRAFFIC SEARCH", "airlineQuery", 20, false));
    buttons.add(new Button(queryX+buttonW*2+100, queryY, buttonW, buttonH, "DATE SEARCH", "dateQuery", 20, false));
    
    
  }

  void drawBackground() {
    background(RY_BLUE); // Clean light background
    // 1. Primary Blue Header
    fill(RY_BLUE);
    noStroke();
    rect(0, 0, width, 80); 
    
    fill(255);
    textSize(40);
    textAlign(CENTER,CENTER);
    text("F L I G H T   S E A R C H", width/2, 50);
    
    fill(150);
    rect(20, height-330, 1160, 210,20);
    
    fill(RY_BG);
    textSize(24);
    textAlign(CORNER, CORNER);
    text("Select the search you are interested in:", 50, height-300);
    text("1. FLIGHT SEARCH: if you want to search for a specific flight from one place to another", 50, height-250);
    text("2. TRAFFIC SEARCH: if you want to search about which are the most busy routes", 50,height-200);
    text("3. DATE SEARCH: if you want to search for flights available within a date range", 50, height-150);
    
    //Line at top
     fill(255, 50);
     noStroke();
     rect(0, 70, width, 2);
    
  }
  
  void draw(){
    drawBackground();
    
    
    
    
    for(Button b : buttons){
      b.display();
    }
    
  }
  

  void keyPressed(char k) {

  
  }
  
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("back")) goBack();
      if (b.type.equals("flightQuery")) goTo(flightsSearch);
      if (b.type.equals("airlineQuery")) goTo(flightsTraffic);
      if (b.type.equals("dateQuery")) goTo(flightsDate);
    }
  }
  }
}

class DashboardScreen extends Screen {

  DashboardScreen() {
    
    int buttonW = 180;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x + 30, y + 230, buttonW, buttonH, "Home", "home", 30, false));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(RY_BLUE);
  }
  
  void draw(){
    drawBackground();
    drawSidebar();
    dashboardCards();
    for(Button b : buttons){
      b.display();
    }  
  }
  
  void drawSidebar(){
    fill(240, 231, 213);
    noStroke();
    rect(40, 40, 220, 640, 20);
    
    fill(255);
    ellipse(150, 120, 80, 80);
    image(logo, 110, 80, 90, 90);
    
    fill(0);
    textAlign(CENTER);
    textSize(18);
    text("FLIGHT SCANNER", 150, 180); 
  }
  
  void dashboardCards(){
  fill(255);
  rect(300, 400, 270, 270, 20);
  
  fill(255);
  rect(580, 400, 600, 270, 20);
  
  fill(255);
  rect(300, 60, 880, 300, 20);
}

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        if (b.type.equals("home")){
          goTo(home);
        }
      }
    }
  }
}
//////////////////// SECOND SELECTION CLASSES AFTER CHOOSEN QUERIES SEARCH //////////////////////////////////////
class QueriesFlights extends Screen {
  TextEntryButton inputFrom, inputTo, inputStart, inputEnd;
  TextEntryButton currentInput;
  ArrayList<String> suggestions = new ArrayList<String>();
  QueriesFlights() {
    int buttonH = 45;
    int yq = height/3; 
    int margin = 100;
    int spacing = 15;
    // Calculate widths to fit 4 boxes across the white card
    int queryW = (width - (margin * 2) - (spacing * 3)) / 4; 

    // Initialize 4 fields with US Date hints
    inputFrom  = new TextEntryButton(margin, yq, queryW, buttonH, "Origin", "enter", 25, 16, false, 1);
    inputTo    = new TextEntryButton(margin + (queryW + spacing), yq, queryW, buttonH, "Destination", "enter", 25, 16, false, 2);
    inputStart = new TextEntryButton(margin + (queryW + spacing) * 2, yq, queryW, buttonH, "MM/DD/YYYY", "enter", 10, 16, false, 3);
    inputEnd   = new TextEntryButton(margin + (queryW + spacing) * 3, yq, queryW, buttonH, "MM/DD/YYYY", "enter", 10, 16, false, 4);
    
    buttons.add(inputFrom);
    buttons.add(inputTo);
    buttons.add(inputStart);
    buttons.add(inputEnd);
    
    // Position the Search Button at the bottom right of the white card for a "Form" look
    buttons.add(new Button(width - margin - 200, yq + 75, 200, 50, "Search flights", "flightsOutput", 20, false));
    
    // Back button in the top left header
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }
  void updateSuggestions(String input) {
  suggestions.clear();

  if (input.length() < 2) return;

  input = input.toLowerCase();

  for (Flight f : flightsList) {
    String origin = f.origin.toLowerCase();
    String originCity = f.originCityName.toLowerCase();

    if (origin.contains(input) || originCity.contains(input)) {
      String suggestion = f.origin + " - " + f.originCityName;

      if (!suggestions.contains(suggestion)) {
        suggestions.add(suggestion);
      }
    }

    if (suggestions.size() >= 5) break; // limit results
  }
}
  void drawBackground() {
    background(RY_BLUE); 
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("FLIGHT SEARCH", width/2, 40);
    stroke(255, 60);
    line(0, 80, width, 80);
  }
  
  void draw() {
    drawBackground();
    // 1. Draw the "Search Card" (Professional White Container)
    fill(255);
    noStroke();
    rect(70, height/3 - 60, width - 140, 210, 12); 
    
    // 2. Card Title
    fill(RY_BLUE);
    textAlign(LEFT);
    textSize(22);
    text("Book your next trip", 100, height/3 - 25);
    
    // 3. Labels (Small, Grey, and Professional)
    fill(120);
    textSize(12);
    text("FLY FROM", inputFrom.x, inputFrom.y - 10);
    text("FLY TO", inputTo.x, inputTo.y - 10);
    text("DEPARTURE", inputStart.x, inputStart.y - 10);
    text("RETURN", inputEnd.x, inputEnd.y - 10);
    drawSuggestions();
    
    for (Button b : buttons) {
      b.display(); 
    }
  }
 void drawSuggestions() {
  if (suggestions.size() == 0 || currentInput == null) return;

  float x = currentInput.x;
  float y = currentInput.y + currentInput.h;
  float w = currentInput.w;
  float h = 35;

  for (int i = 0; i < suggestions.size(); i++) {
    // background
    fill(255);
    stroke(200);
    rect(x, y + i*h, w, h);

    // text
    fill(0);
    textAlign(LEFT, CENTER);
    text(suggestions.get(i), x + 10, y + i*h + h/2);
  }
}

  void mousePressed() {
    // Check suggestions first
if (currentInput != null && suggestions.size() > 0) {
  float x = currentInput.x;
  float y = currentInput.y + currentInput.h;
  float h = 35;

  for (int i = 0; i < suggestions.size(); i++) {
    if (mouseX > x && mouseX < x + currentInput.w &&
        mouseY > y + i*h && mouseY < y + (i+1)*h) {
      
      String selected = suggestions.get(i);

      currentInput.label = selected;

      suggestions.clear(); // hide dropdown
      return;
    }
  }
}
    currentInput = null;
    TextEntryButton[] allInputs = {inputFrom, inputTo, inputStart, inputEnd};
    
    for (TextEntryButton b : allInputs) {
      if (b.over(mouseX, mouseY)) {
        currentInput = b;
        if (b.label.equals("MM/DD/YYYY") || b.label.equals("Origin") || b.label.equals("Destination")) {
          b.label = "";
        }
      }
    }

    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        if (b.type.equals("flightsOutput")) {
          selection.origin = inputFrom.label;
          selection.destination = inputTo.label;
          selection.dateStart = inputStart.label;
          selection.dateEnd = inputEnd.label;
          searchFlight(); 
          goTo(flightsOutput);        }
        if (b.type.equals("back")) goBack();
      }
    }
  }

  void keyPressed(char k) {
    if (currentInput != null) currentInput.addChar(k);
    if (currentInput == inputFrom || currentInput == inputTo) {
      updateSuggestions(currentInput.label);
    }
  }
}




class QueriesDate extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  TextEntryButton currentInput;
  
  // Button bounds for the manual Search button
  float btnX, btnY, btnW = 120, btnH = 40;

  QueriesDate() {
    int buttonW = 180;
    int buttonH = 50;
    int x = (width/2);
    int y = height - 50;
    
    int queryW = width/4 + 100;
    int queryH = 50;
    int xq = width/4 - queryW/2;
    int xq2 = xq + queryW;
    int yq = height/4;
    int xs = xq2 + queryW;

    // Standard Back Button
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
    
    // The Search Button
    buttons.add(new Button(xs, yq, 200, 50, "Search", "dateOutput", 20, false));
    
    // Initialize Input Boxes
    inputButton = new TextEntryButton(xq, yq, queryW, queryH, "MM/DD/YYYY", "date1", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2, yq, queryW, queryH, "MM/DD/YYYY", "date2", 15, 20, false, 2);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }

  void drawBackground() {
    background(RY_BLUE); 
    
    // Header
    fill(255);
    textSize(40);
    textAlign(CENTER);
    text("DATE SEARCH", width/2, 50);
    
    // Decorative Line
    stroke(255, 50);
    line(0, 80, width, 80);
    
    // Instruction text
    fill(255);
    textSize(20);
    textAlign(LEFT);
    text("Enter date range to find available flights:", 100, 150);
  }

  void draw() {
    drawBackground();
    
    for (Button b : buttons) {
      b.display();
    }
    
    textSize(18);
    fill(255);
    textAlign(LEFT);
    text("From:", inputButton.x, inputButton.y - 10);
    text("To:", inputButton2.x, inputButton2.y - 10);
  }

  void keyPressed(char k) {
    if (currentInput != null) {
      currentInput.addChar(k);
    }
  }

  void mousePressed() {
    currentInput = null;

    // 1. Handle Input Focus
    if (inputButton.over(mouseX, mouseY)) {
      currentInput = inputButton;
      if(inputButton.label.equals("MM/DD/YYYY")) inputButton.label = "";
    }
    if (inputButton2.over(mouseX, mouseY)) {
      currentInput = inputButton2;
      if(inputButton2.label.equals("MM/DD/YYYY")) inputButton2.label = "";
    }

    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        
        if (b.type.equals("back")) goBack();
        
        
        if (b.type.equals("dateOutput")) {
          selection.dateStart = inputButton.label;
          selection.dateEnd = inputButton2.label;
          
          searchFlightsDateRange(); 
          
          goTo(flightsOutput); 
        }
      }
    }
  }
}


class QueriesTraffic extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  TextEntryButton inputButton3;
  boolean typingFirst = true;
  TextEntryButton currentInput;

  QueriesTraffic() {
    // Add back button at bottom center
    int buttonW = 180;
    int buttonH = 50;
    int x = 35;
    int y = 22;
    int queryW = 392;
    int queryH = 30;
    int xq = 10;
    int xq2 = xq+queryW;
    int xq3 = xq2 + queryW;
    int yq = height/8;
    int xs = xq2 + queryW ;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER,CORNER);
    
    buttons.add(new Button(xq, yq, queryW, queryH, "EAST-COAST", "trafficOutputEastCoast", 20, false));
    buttons.add(new Button(xq2, yq, queryW, queryH, "WEST-COAST", "trafficOutputWestCoast", 20, false));
    buttons.add(new Button(xq3, yq, queryW, queryH, "CENTRAL", "trafficOutputCentral", 20, false));
    
    
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--ROUTES TRAFFIC--", width/2, 50);
    
    //Line at top
     fill(255, 50);
     noStroke();
     rect(0, 70, width, 2);
    
  }
  
  void draw(){
    drawBackground();
    
    for(Button b : buttons){
      b.display();
    }
  
  }

  void keyPressed(char k) {
}
  
void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("back")) goBack();
      
      if (b.type.equals("trafficOutputEastCoast")) {
        searchEastCoast();
        goTo(trafficOutputEastCoast);
      }
      if (b.type.equals("trafficOutputWestCoast")) {
        searchWestCoast();
        goTo(trafficOutputWestCoast);
      }
      if (b.type.equals("trafficOutputCentral")) {
        searchCentral();
        goTo(trafficOutputCentral);
      }
    }
  }
}
}
////////////////////////OUTPUT RESULTS OF QUERIES CHOOSEN //////////////////////////////////////
class FlightsOutputScreen extends Screen {

  float scrollY = 0;        // current scroll offset
  float scrollSpeed = 40;   // how much the list scrolls per mouse wheel tick
  float cardHeight = 110;   // height of each flight card
  float topMargin = 110;    // space from top before first card

  FlightsOutputScreen() {
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }

  void draw() {
    background(RY_BG); 
    fill(RY_BLUE);
    noStroke();
    rect(0, 0, width, 80); // header

    // Header Content
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    String route = selection.origin.toUpperCase() + " → " + selection.destination.toUpperCase();
    text(route, width/2, 35);

    textSize(14);
    fill(255, 200);
    text(results.size() + " flights found • " + selection.dateStart + " - " + selection.dateEnd, width/2, 60);

    // --- Draw the flights with scrolling ---
    pushMatrix();
    translate(0, scrollY); // move the origin by scroll offset
    if (results.size() > 0) {
      for (int i = 0; i < results.size(); i++) {
        drawFlightCard(width/2 - 450, topMargin + i * cardHeight, results.get(i));
      }
    } else {
      drawEmptyState();
    }
    popMatrix();

    for (Button b : buttons) b.display();
  }

  void drawFlightCard(float x, float y, Flight f) {
    float w = 900;
    float h = 100;

    fill(255);
    stroke(220);
    strokeWeight(1);
    rect(x, y, w, h, 8);

    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    text(f.date + " | Flight: " + f.carrier + " " + f.flightNumber, x + 20, y + 10);

    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(18);
    text(f.origin + " → " + f.destination, x + 20, y + 50);

    textSize(14);
    fill(120);
    text("Departure: " + formatTime(f.scheduledDepartureTime), x + 20, y + 75);
    text("Arrival: " + formatTime(f.scheduledArrivalTime), x + w - 200, y + 75);

    // SELECT button
    fill(RY_GOLD);
    noStroke();
    rect(x + w - 120, y + 25, 100, 50, 6);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("SELECT", x + w - 70, y + 50);
  }

  void drawEmptyState() {
    fill(150);
    textAlign(CENTER);
    textSize(20);
    text("No flights found for this route or date.", width/2, height/2);
  }

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) goBack();      
    }
  }

  // SCROLLING with mouse wheel
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    scrollY += -e * scrollSpeed;

    // Limit scrolling so content doesn't go too far
    float minScroll = min(0, height - (topMargin + results.size() * cardHeight));
    scrollY = constrain(scrollY, minScroll, 0);
  }
  void scrollFlights(float e) {
  scrollY += -e * scrollSpeed;

  // Limit scrolling so content doesn't go too far
  float minScroll = min(0, height - (topMargin + results.size() * cardHeight));
  scrollY = constrain(scrollY, minScroll, 0);
  }
}
class TrafficResultsScreen extends Screen {

  ArrayList<Route> east;
  ArrayList<Route> central;
  ArrayList<Route> west;

  TrafficResultsScreen(ArrayList<Route> east,
                       ArrayList<Route> central,
                       ArrayList<Route> west) {
    this.east = east;
    this.central = central;
    this.west = west;

    // Back button
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }

  void draw() {
    background(RY_BLUE);

    // Header
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("Most Busy Traffic Routes", width/2, 45);

    // Compute spacing for three columns dynamically
    float panelWidth = 300;
    float panelHeight = 420;
    float spacing = (width - panelWidth * 3) / 4; // space between panels

    float xEast = spacing + panelWidth / 2;
    float xCentral = xEast + panelWidth + spacing;
    float xWest = xCentral + panelWidth + spacing;

    // Draw the three columns
    drawZone("East Coast", east, xEast, panelWidth, panelHeight);
    drawZone("Central", central, xCentral, panelWidth, panelHeight);
    drawZone("West Coast", west, xWest, panelWidth, panelHeight);

    // Draw buttons
    for (Button b : buttons) b.display();
  }

  // Draw each zone column
  void drawZone(String title, ArrayList<Route> routes, float x, float panelW, float panelH) {

    // Panel background
    fill(150);
    rectMode(CENTER);
    rect(x, 120 + panelH/2, panelW, panelH, 20); // rounded corners
    rectMode(CORNER);

    // Column title
    fill(255);
    textAlign(CENTER);
    textSize(22);
    text(title, x, 100);

    // List of routes
    fill(255);
    textAlign(LEFT);
    textSize(16);
    float yStart = 150;
    float padding = 20; // distance from panel edge
    float y = yStart;
    int rank = 1;

    for (Route r : routes) {
      // Ensure text doesn’t overflow panel width
      text(rank + ". " + r.origin + " -> " + r.destination +
           " (" + r.passengers + ")", x - panelW/2 + padding, y);
      y += 22;
      rank++;
      if (y > 120 + panelH - 20) break; // stop if text exceeds panel
    }
  }

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) goBack();
      
    }
  }
}
