PImage planeHomeScreen;
PFont planeFont;

void setup()  {
  size(1200,700);
  planeHomeScreen = loadImage("Plane.png");
  planeFont = loadFont("ArialNarrow-Bold-48.vlw");
}

void draw()  {
  background(106, 137, 167);
  drawCard();
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
  
  fill(0);
  textAlign(CENTER);
  textSize(40);
  text("Flight Scanner", width/2, cardY + 60);
  
  planeImage(cardX, cardY);
}

void planeImage(int x, int y)  {
  int planeX = x + 150;
  int planeY = y + 100;
  int planeW = 600;
  int planeH = 200;
  
  fill(200);
  rect(planeX, planeY, planeW, planeH);
    
 }
  
