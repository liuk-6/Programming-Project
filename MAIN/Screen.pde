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
class HomeScreen extends Screen{

  HomeScreen(){
  int buttonW = 280*2;
  int buttonH = 50;
  int yPos = height/2 - buttonH; // 20 px padding from bottom
  float x1 = width * 1/4.0 - buttonW/2;  // 1st button
  float x3 = width * 3/4.0 - buttonW/2;  // 2nd button
  buttons.add(new Button(x1, yPos, buttonW, buttonH, "QUERIES", "queries"));
  buttons.add(new Button(x3, yPos, buttonW, buttonH, "DATA", "data"));
  buttons.add(new Button(50, 50, 180, 50, "EXIT", "exit"));
  
  
  }
  void draw() {
  drawBackground();   // draws the plane
  for (Button b : buttons) b.display();  // draws buttons on top
  }
    //Card Size
  void drawCard()  {
    int cardX = 30;
    int cardY = 30;
    int cardW = width - 60;
    int cardH = height - 60;
    
    fill(255);

    stroke(0);
    rect(cardX, cardY, cardW, cardH, 20);

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
       image(planeHomeScreen, 0, 0, width, height);
   }
}
class QueriesScreen extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  boolean typingFirst = true;

  QueriesScreen() {
    // Add back button at bottom center
    int buttonW = 180;
    int buttonH = 50;
    int x = 50;
    int y = 50;
    int queryW = width/4;
    int queryH = 50;
    int xq = width/4 -queryW/2 +150;
    int xq2 = width*3/4 -queryW/2 -150;
    int yq = height/4;
    int xs = xq2 + queryW +50;
    
    buttons.add(new Button(x, y, buttonW, buttonH, "BACK", "back"));
    buttons.add(new Button(xs, yq, buttonW, buttonH, "Search", "flights"));
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "Enter origin", "enter", 15);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "Enter destination", "enter", 15);
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }

  void drawBackground() {
    background(220, 240, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--QUERIES--", width/2, 80);
  }
  void keyPressed(char k) {
  if (typingFirst)
    if(keyCode==ENTER){
      selection.origin = inputButton.label;
      println(selection.origin);
    }else{
          inputButton.addChar(k);
    } 
  else
    if(keyCode==ENTER){
      selection.destination = inputButton2.label;
      println(selection.destination);
    }else{
          inputButton2.addChar(k);
    } 
  }
  
  void mousePressed() {

  // check first box
  if (mouseX > inputButton.x && mouseX < inputButton.x + inputButton.w &&
      mouseY > inputButton.y && mouseY < inputButton.y + inputButton.h) {
    typingFirst = true;
  }

  // check second box
  if (mouseX > inputButton2.x && mouseX < inputButton2.x + inputButton2.w &&
      mouseY > inputButton2.y && mouseY < inputButton2.y + inputButton2.h) {
    typingFirst = false;
  }

  // keep normal button behaviour
  for (Button b : buttons) b.click();
  
  }
}
class FlightsScreen extends Screen {

  FlightsScreen() {
    int buttonW = 180;
    int buttonH = 50;
    int x = 50;
    int y = 50;
    buttons.add(new Button(x, y, buttonW, buttonH, "BACK", "back"));
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--FLIGHTS FOUND--", width/2, 80);
    textSize(20);
    fill(0);
    textAlign(LEFT, TOP);
    text(flightsFound, 20, height - 40);
  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myFlights.display();
  }
}
class DataScreen extends Screen {

  DataScreen() {
    
    int buttonW = 180;
    int buttonH = 50;
    int x = 50;
    int y = 50;
    buttons.add(new Button(x, y, buttonW, buttonH, "BACK", "back"));
  }

  void drawBackground() {
    background(220, 255, 220);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--DATA--", width/2, 80);
  }
}
