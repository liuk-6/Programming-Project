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
  int buttonW = 180;
  int buttonH = 50;
  int yPos = height - buttonH - 60; // 20 px padding from bottom
  float x1 = width * 1/4.0 - buttonW/2;  // 1st button
  float x2 = width * 2/4.0 - buttonW/2;  // 2nd button (middle)
  float x3 = width * 3/4.0 - buttonW/2;  // 3rd button
  buttons.add(new Button(x1, yPos, buttonW, buttonH, "QUERIES", "queries"));
  buttons.add(new Button(x2, yPos, buttonW, buttonH, "FLIGHTS", "flights"));
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

  QueriesScreen() {
    // Add back button at bottom center
    int buttonW = 180;
    int buttonH = 50;
    int x = 50;
    int y = 50;
    int queryW = width/2;
    int queryH = 50;
    int xq = width/2 -queryW/2;
    int yq = height/4;
    buttons.add(new Button(x, y, buttonW, buttonH, "BACK", "back"));
    buttons.add(new TextEntryButton(xq,yq, queryW, queryH, "Enter query", "enter", 15));
  }

  void drawBackground() {
    background(220, 240, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("Queries Screen", width/2, 80);
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
    text("Flights Screen", width/2, 80);
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
    text("Data Screen", width/2, 80);
  }
}
