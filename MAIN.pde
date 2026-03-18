UIManager ui;
UserSelection selection;
String[] lines;



void setup() {
  size(800, 600);
  textSize(18);

  // Load CSV
  lines = loadStrings("flights2k.csv");
  if (lines == null) {
    println("Error reading file");
    exit();
  }
  println("CSV loaded: " + lines.length + " lines");

  selection = new UserSelection();
  ui = new UIManager();

  // Start on first screen
  ui.switchScreen(new Screen1(ui, selection));
}

void draw() {
  background(50);
  ui.draw();
  pg.beginDraw();
  pg.background(240);
  pg.stroke(0);
  pg.fill(100, 150, 255);

  
}

void mousePressed() {
  ui.mousePressed();
}

void mouseMoved() {
  ui.mouseMoved();
}

void keyPressed() {
  ui.keyPressed(key);
}
