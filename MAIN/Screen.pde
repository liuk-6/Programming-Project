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
  buttons.add(new Button(x1, yPos, buttonW, buttonH, "QUERIES", "queries",20, true));
  buttons.add(new Button(x3, yPos, buttonW, buttonH, "GRAPHS", "graphs",20, true));
  buttons.add(new Button(30, 22, 50, 30, "EXIT", "exit", 20, true));
  
  
  }
  void draw() {
  drawBackground();   // draws the plane
  fill(255);
  textAlign(CENTER);
  textSize(60);
  text("F  L  I  G  H  T   S  C  A  N  N  E  R", width/2, height/3);
  textSize(18);
  text("Select a button to explore flight data", width/2, 150);
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
     image(backgroundImg, 0, 0, width, height);
     
     fill(69, 87, 107, 200);
     rect(0, 0, width, height);
     
     // Rectangular Box
     noStroke();
     fill(196, 196, 196, 200);
     rect(0, height * 0.75, width, height * 0.55);
     
     //Plane Shadow
     noStroke();
     fill(0, 70);
     ellipse( width/2, height/1.95 + 200, 800, 80);
     
     //Line at top
     fill(255, 50);
     noStroke();
     rect(0, 70, width, 2);
     
     imageMode(CENTER);
     image(planeHomeScreen, width/2, height/1.5, width * 0.85, height*0.8);
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
    int xq3 = xq;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "backQ", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(xs, yq, 200, 50, "Search", "flightsOutput", 20, false));
    
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "Enter origin", "enter", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "Enter destination", "enter", 15, 20, false,2);
    inputButton3 = new TextEntryButton(xq3, yq+buttonH+10, queryW, queryH, "Enter date", "enter", 15, 20, false,3);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
    buttons.add(inputButton3);
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--FLIGHT SEARCH--", width/2, 130);
    
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
    else if (currentInput == inputButton3) {
      selection.date = currentInput.label;
      println(selection.date);
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
  TextEntryButton inputButton3;
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
    text("--DATE SEARCH--", width/2, 130);
    
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
    else if (currentInput == inputButton3) {
      selection.date = currentInput.label;
      println(selection.date);
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
    int xq = width/4 -queryW/2;
    int xq2 = xq+queryW;
    int yq = height/4;
    int xs = xq2 + queryW ;
    int xq3 = xq;
    

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "backQ", 20, true));
    textAlign(CORNER);
    
    buttons.add(new Button(xs, yq, 200, 50, "Search", "trafficOutput", 20, false));
    
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "Enter origin", "enter", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "Enter destination", "enter", 15, 20, false,2);
    inputButton3 = new TextEntryButton(xq3, yq+buttonH+10, queryW, queryH, "Enter date", "enter", 15, 20, false,3);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
    buttons.add(inputButton3);
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--AIRPORT TRAFFIC--", width/2, 130);
    
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
    else if (currentInput == inputButton3) {
      selection.date = currentInput.label;
      println(selection.date);
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
class TrafficOutputScreen extends Screen {

  TrafficOutputScreen() {
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
    text("--BUSIEST ROUTES--", width/2, 80);
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
