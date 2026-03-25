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

  HomeScreen(){
  int buttonW = 80*6;
  int buttonH = 50;
  int yPos = height/2; // 20 px padding from bottom
  float x1 = 100 ;  // 1st button
  float x3 = 1100 - buttonW;  // 2nd button
  buttons.add(new Button(x1, yPos, buttonW, buttonH, "QUERIES", "queries",20, true));
  buttons.add(new Button(x3, yPos, buttonW, buttonH, "GRAPHS", "graphs",20, true));
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
     image(sunset, (width/2), height/2, width/1.7, height/2.5);
     image(planeHomeScreen, width/2, height/1.9, width * 0.85, height*0.7);
     imageMode(CORNER);
   }
   void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("queries")) currentScreen = queries;
      if (b.type.equals("graphs")) currentScreen = graphs;
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
      if (b.type.equals("back")) currentScreen = home;
      if (b.type.equals("flightQuery")) currentScreen = flightsSearch;
      if (b.type.equals("airlineQuery")) currentScreen = flightsTraffic;
      if (b.type.equals("dateQuery")) currentScreen = flightsDate;
    }
  }
  }
}
class GraphsScreen extends Screen {

  GraphsScreen() {
    
    int buttonW = 180;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(209, 222, 218);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--Graphs--", width/2, 130);
    
    //Line at top
     fill(255, 50);
     noStroke();
     rect(0, 70, width, 2);
  }
  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        if (b.type.equals("back")) currentScreen = home;
      }
    }
  }
}
//////////////////// SECOND SELECTION CLASSES AFTER CHOOSEN QUERIES SEARCH //////////////////////////////////////
class QueriesFlights extends Screen {
  TextEntryButton inputFrom, inputTo, inputStart, inputEnd;
  TextEntryButton currentInput;

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
    buttons.add(new Button(30, 22, 80, 30, "BACK", "backQ", 15, false));
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
    
    for (Button b : buttons) {
      b.display(); 
    }
  }

  void mousePressed() {
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
          currentScreen = flightsOutput;
        }
        if (b.type.equals("backQ")) currentScreen = queries;
      }
    }
  }

  void keyPressed(char k) {
    if (currentInput != null) currentInput.addChar(k);
  }
}




class QueriesDate extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  boolean typingFirst = true;
  TextEntryButton currentInput;

  QueriesDate() {
    // Add back button at bottom center
    int buttonW = 180;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    int queryW = width/4+100;
    int queryH = 50;
    int xq = width/4 -queryW/2;
    int xq2 = xq+queryW;
    int yq = height/4;
    int xs = xq2 + queryW ;
    
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "backQ", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(xs, yq, 200, 50, "Search", "dateOutput", 20, false));
    
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "", "date1", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "", "date2", 15, 20, false,2);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--DATE SEARCH--", width/2, 50);
    
    
    
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
    textSize(24);
    fill(255);
    text("From: ", width/4 -(width/4 +100)/2 +40, height/4+25);
    text("To: ", width/4 +(width/4 +100)/2 +40, height/4+25);
    image(SearchButton, 1080.0-20, 192.0, 20.0, 20.0);
  }

  void keyPressed(char k) {

  if (currentInput == null) return;

  if (keyCode == ENTER) {

    if (currentInput == inputButton) {
      selection.dateStart = currentInput.label;
      println(selection.dateStart);
    }
    else if (currentInput == inputButton2) {
      selection.dateEnd = currentInput.label;
      println(selection.dateEnd);
    }
    

  } else {
    currentInput.addChar(k);
  }
}
  
  void mousePressed() {
  currentInput = null;

  // Check TextEntryButtons
  if (mouseX > inputButton.x && mouseX < inputButton.x + inputButton.w &&
      mouseY > inputButton.y && mouseY < inputButton.y + inputButton.h) {
    currentInput = inputButton;
  }
  if (mouseX > inputButton2.x && mouseX < inputButton2.x + inputButton2.w &&
      mouseY > inputButton2.y && mouseY < inputButton2.y + inputButton2.h) {
    currentInput = inputButton2;
  }
  

  // Handle regular buttons
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        if (b.type.equals("backQ")) currentScreen = queries;
        if (b.type.equals("flightsOutput")) {
            searchFlight(); 
            currentScreen = flightsOutput;
        }
        if (b.type.equals("dateOutput")) {
            searchFlight(); 
            currentScreen = dateOutput;
        }
        if (b.type.equals("trafficOutput")) {
            searchFlight(); 
            currentScreen = trafficOutput;
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
    int x = 30;
    int y = 22;
    int queryW = width/4+100;
    int queryH = 50;
    int xq = width/4;
    int xq2 = xq+queryW;
    int yq = height/2;
    int xs = xq2 + queryW ;
    int xq3 = xq;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "backQ", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(xq, yq, 200, 50, "EAST-COAST", "trafficOutputEastCoast", 20, false));
    buttons.add(new Button(xq2, yq, 200, 50, "WEST-COAST", "trafficOutputWestCoast", 20, false));
    buttons.add(new Button((xq+xq2)/2, yq, 200, 50, "CENTRAL", "trafficOutputCentral", 20, false));
    
    
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--AIRPORT TRAFFIC--", width/2, 50);
    
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
    textSize(32);
    textAlign(CENTER,CENTER);
    fill(0);
    text("Select which traffic pattern you want to observe", width/2, height/2-100);
  }

  void keyPressed(char k) {

  
}
  
  void mousePressed() {

  // Handle regular buttons
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        if (b.type.equals("backQ")) currentScreen = queries;

        if (b.type.equals("trafficOutputEastCoast")) {
            searchEastCoast(); 
            currentScreen = trafficOutputEastCoast;
        }
        if (b.type.equals("trafficOutputWestCoast")) {
            searchWestCoast(); 
            currentScreen = trafficOutputWestCoast;
        }
        if (b.type.equals("trafficOutputCentral")) {
            searchCentral(); 
            currentScreen = trafficOutputCentral;
        }
      }
    }
  }
}
////////////////////////OUTPUT RESULTS OF QUERIES CHOOSEN //////////////////////////////////////
class FlightsOutputScreen extends Screen {

  FlightsOutputScreen() {
    // Back button in the navy header area
    buttons.add(new Button(30, 22, 80, 30, "BACK", "backQueries", 15, false));
  }

  void draw() {
    // 1. Background and Header
    background(#F2F5F7); // RY_BG (Clean light grey)
    fill(RY_BLUE);
    noStroke();
    rect(0, 0, width, 80);
    
    // 2. Header Content
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    String route = selection.origin.toUpperCase() + "  →  " + selection.destination.toUpperCase();
    text(route, width/2, 35);
    
    textSize(14);
    fill(255, 200);
    text(results.size() + " flights found • " + selection.dateStart + " - " + selection.dateEnd, width/2, 60);

    // 3. Draw Results as Cards
    if (results.size() > 0) {
      // Display top 5 results (scroll logic can be added later)
      for (int i = 0; i < min(5, results.size()); i++) {
        drawFlightCard(width/2 - 450, 110 + (i * 110), results.get(i));
      }
    } else {
      drawEmptyState();
    }

    for (Button b : buttons) b.display();
  }

  void drawFlightCard(float x, float y, Flight f) {
    float w = 900;
    float h = 100; // Increased slightly for spacing
    
    // Card Body
    fill(255);
    stroke(220);
    strokeWeight(1);
    rect(x, y, w, h, 8);
    
    // --- ADD THIS SECTION FOR THE DATE ---
    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    // This displays the specific date and flight number for this card
    text(f.date + " | Flight: " + f.carrier + " " + f.flightNumber, x + 40, y + 12);
    // -------------------------------------

    // Times and Route (Adjusted Y to not overlap with date)
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(22);
    text(formatTime(f.scheduledDepartureTime), x + 40, y + 45);
    
    textAlign(RIGHT, CENTER);
    text(formatTime(f.scheduledArrivalTime), x + w - 240, y + 45);
    
    // Airport Codes
    textSize(14);
    fill(120);
    textAlign(LEFT);
    text(f.origin, x + 40, y + 75);
    textAlign(RIGHT);
    text(f.destination, x + w - 240, y + 75);
    
    // The "Journey Line" in the middle
    stroke(200);
    line(x + 130, y + 55, x + w - 330, y + 55);
    fill(200);
    triangle(x + w - 340, y + 50, x + w - 330, y + 55, x + w - 340, y + 60);
    
    // Price/Select Action (Ryanair Yellow)
    fill(RY_GOLD);
    noStroke();
    rect(x + w - 180, y + 15, 150, 70, 6);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("SELECT", x + w - 105, y + 50);
  }


  void drawEmptyState() {
    fill(150);
    textAlign(CENTER);
    textSize(20);
    text("No flights found for this route or date.", width/2, height/2);
  }

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("backQueries")) {
        currentScreen = queries;
      }
    }
  }
}
