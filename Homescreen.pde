PImage planeHomeScreen;
PImage backgroundImg;
PFont planeFont;

void setup()  {
  size(1200,700);
  planeHomeScreen = loadImage("Plane.png");
  planeFont = loadFont("ArialNarrow-Bold-48.vlw");
  backgroundImg = loadImage("PlaneBackground.jpg");
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
  image(backgroundImg, (width/2) - 250, 150, 500, 200);
  
  if(planeHomeScreen!= null)  {
    image(planeHomeScreen, (width/2) - 400 , 60, 800, 400);
  }
  
  int boxY = y +350;
  int buttonW = 180;
  int buttonH = 70;
  int gap = 40;
  
  int totalWidth = buttonW * 3 + gap * 2;
  int start = x + ((width - totalWidth)/2);
  
  drawButton(start, boxY, buttonW, buttonH);
  drawButton(start + buttonW + gap, boxY, buttonW, buttonH);
  drawButton(start +(buttonW + gap) * 2, boxY, buttonW, buttonH);
}
  
  void drawButton(int x, int y, int w, int h)  {
    noStroke();
    fill(200,200,200,100);
    rect(x,y+5, w, h, 20);
    
    fill(255);
    rect(x, y, w, h, 20);
    
    
 }
  
