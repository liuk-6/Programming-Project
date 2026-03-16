// =====================================================
// GLOBAL VARIABLES
// =====================================================

Screen screen1;
Screen screen2;
Screen currentScreen;


// =====================================================
// SETUP
// =====================================================

void setup() {
  size(400, 400);

  // Create screens
  screen1 = new Screen(color(150, 200, 255));
  screen2 = new Screen(color(255, 200, 150));

  setupScreen1();
  setupScreen2();

  // Start on first screen
  currentScreen = screen1;
  //Create lines array
  String[] lines;

  // Load all lines from the file
  lines = loadStrings("flights2k.csv");

  if (lines == null) {
    println("Error reading file");
    exit();
  }

  // Print each line
  for (int i = 0; i < lines.length; i++) {
    println(lines[i]);
  }

  

}


// =====================================================
// DRAW LOOP
// =====================================================

void draw() {
  currentScreen.draw();
}


// =====================================================
// MOUSE EVENTS
// =====================================================

void mousePressed() {
  Widget w = currentScreen.getEvent(mouseX, mouseY);

  if (w == null) return;

  handleButtonPress(w);
}

void mouseMoved() {
  currentScreen.updateHover(mouseX, mouseY);
}


// =====================================================
// SCREEN SETUP FUNCTIONS
// =====================================================

void setupScreen1() {
  screen1.addWidget(new Widget(20, 20, 120, 40, "Next"));
  screen1.addWidget(new Widget(20, 80, 120, 40, "Hello"));
}

void setupScreen2() {
  screen2.addWidget(new Widget(20, 20, 120, 40, "Back"));
  screen2.addWidget(new Widget(20, 80, 120, 40, "Heya"));
}


// =====================================================
// INPUT HANDLING
// =====================================================

void handleButtonPress(Widget w) {

  if (w.label.equals("Next")) {
    currentScreen = screen2;

  } else if (w.label.equals("Back")) {
    currentScreen = screen1;

  } else {
    println("Pressed: " + w.label);
  }
}
