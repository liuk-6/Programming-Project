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
}
class QueriesScreen extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  boolean typingFirst = true;

  QueriesScreen() {
    // Add back button at bottom center
    int buttonW = 180;
    int buttonH = 50;
    int x = 30;
    int y = 22;
    int queryW = width/4;
    int queryH = 50;
    int xq = width/4 -queryW/2 +150;
    int xq2 = width*3/4 -queryW/2 -150;
    int yq = height/4;
    int xs = xq2 + queryW +50;

    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER);
    buttons.add(new Button(xs, yq, buttonW, buttonH, "Search", "flights", 20, false));
    inputButton = new TextEntryButton(xq,yq, queryW, queryH, "Enter origin", "enter", 15, 20, false);
    inputButton2 = new TextEntryButton(xq2,yq, queryW, queryH, "Enter destination", "enter", 15, 20, false);
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }

  void drawBackground() {
    background(206, 216, 222);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--QUERIES--", width/2, 130);
    
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
    image(SearchButton, 1080.0, 192.0, 20.0, 20.0);
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
    int x = 30;
    int y = 22;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW - 110, buttonH - 20, "BACK", "back", 20, true));
    textAlign(CORNER);;
  }

  void drawBackground() {
    background(240, 220, 255);
    fill(0);
    textSize(40);
    textAlign(CENTER, 80);
    text("--FLIGHTS FOUND--", width/2, 80);
    text(flightsFound, width-250, 150);

  }
  void draw() {
    drawBackground();
    for (Button b : buttons) {
      b.display();
    }
    myFlights.display();
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
}
