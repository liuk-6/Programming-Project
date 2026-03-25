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
  int buttonW = 80*2;
  int buttonH = 50;
  int yPos = height/2 - buttonH; // 20 px padding from bottom
  float x1 = width * 3/8.0 - buttonW/2;  // 1st button
  float x3 = width * 5/8.0 - buttonW/2;  // 2nd button
  buttons.add(new Button(x1, yPos + 250, buttonW, buttonH, "QUERIES", "queries",20, true));
  buttons.add(new Button(x3, yPos + 250, buttonW, buttonH, "GRAPHS", "graphs",20, true));
  buttons.add(new Button(30, 22, 50, 30, "EXIT", "exit", 20, true));
  
  
  }
  void draw() {
  drawBackground();   // draws the plane
  fill(0);
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

     fill(240, 200);
     rect(0, 0, width, height);
     
     //Line at top
     fill(0, 50);
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
    int buttonW = 180;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    
    int queryX = width/4;
    int queryY = height/4;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(queryX, queryY, buttonW, buttonH, "FLIGHT SEARCH", "flightQuery", 20, false));
    buttons.add(new Button(queryX+buttonW, queryY, buttonW, buttonH, "TRAFFIC SEARCH", "airlineQuery", 20, false));
    buttons.add(new Button(queryX+buttonW*2, queryY, buttonW, buttonH, "DATE SEARCH", "dateQuery", 20, false));
    
    
   
    
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--QUERY SEARCH--", width/2, 50);
    textSize(30);
    
    text("Select the search you are interested in:", width/2, 150);
    
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
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  TextEntryButton inputButton3;
  boolean typingFirst = true;
  TextEntryButton currentInput;

  QueriesFlights() {
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
    
    buttons.add(new Button(xs, yq, 200, 50, "Search", "flightsOutput", 20, false));
    
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "", "enter", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "", "enter", 15, 20, false,2);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--FLIGHT SEARCH--", width/2, 50);
    
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
      selection.origin = currentInput.label;
      println(selection.origin);
    }
    else if (currentInput == inputButton2) {
      selection.destination = currentInput.label;
      println(selection.destination);
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
  if (inputButton3 != null &&
      mouseX > inputButton3.x && mouseX < inputButton3.x + inputButton3.w &&
      mouseY > inputButton3.y && mouseY < inputButton3.y + inputButton3.h) {
    currentInput = inputButton3;
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
            searchEurope(); 
            currentScreen = trafficOutputEastCoast;
        }
        if (b.type.equals("trafficOutputWestCoast")) {
            searchWorldwide(); 
            currentScreen = trafficOutputWestCoast;
        }
        if (b.type.equals("trafficOutputCentral")) {
            searchAmerica(); 
            currentScreen = trafficOutputCentral;
        }
      }
    }
  }
}
////////////////////////OUTPUT RESULTS OF QUERIES CHOOSEN //////////////////////////////////////
class FlightsOutputScreen extends Screen {

  FlightsOutputScreen() {
    int buttonW = 100;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 20, buttonH - 20, "BACK", "backQueries", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("--FLIGHTS FOUND--", width/2, 80);
    textSize(24);
    text(flightsFound, width-250,100);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myFlights.display();
  }
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("backQueries")) currentScreen = queries;
    }
  }
  }
}
class DatesOutputScreen extends Screen {

  DatesOutputScreen() {
    int buttonW = 100;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 20, buttonH - 20, "BACK", "backQueries", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("--FLIGHTS FOUND WITHIN DATE RANGE--", width/2, 80);
    textSize(24);
    text(flightsFound, width-250,120);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myFlights.display();
  }
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("backQueries")) currentScreen = queries;
    }
  }
  }
}
class TrafficOutputScreenWestCoast extends Screen {

  TrafficOutputScreenWestCoast() {
    int buttonW = 100;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 20, buttonH - 20, "BACK", "backTraffic", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("--BUSIEST ROUTES WESTCOAST--", width/2, 80);
    textSize(24);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myTrafficRoutes.display();
  }
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("backTraffic")) currentScreen = flightsTraffic;
    }
  }
  }
}
class TrafficOutputScreenEastCoast extends Screen {

  TrafficOutputScreenEastCoast() {
    int buttonW = 100;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 20, buttonH - 20, "BACK", "backTraffic", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("--BUSIEST ROUTES EASTCOAST--", width/2, 80);
    textSize(24);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myTrafficRoutes.display();
  }
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("backTraffic")) currentScreen = flightsTraffic;
    }
  }
  }
}
class TrafficOutputScreenCentral extends Screen {

  TrafficOutputScreenCentral() {
    int buttonW = 100;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 20, buttonH - 20, "BACK", "backTraffic", 20, true));
    textAlign(CORNER);
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("--BUSIEST ROUTES CENTRAL--", width/2, 80);
    textSize(24);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myTrafficRoutes.display();
  }
  void mousePressed() {
  for (Button b : buttons) {
    if (b.over(mouseX, mouseY)) {
      println("Clicked: " + b.type);
      if (b.type.equals("backTraffic")) currentScreen = flightsTraffic;
    }
  }
  }
}
