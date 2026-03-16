Screen screen1, screen2;
Screen currentScreen;

void setup() {

  size(400, 400);

  screen1 = new Screen(color(150, 200, 255));
  screen2 = new Screen(color(255, 200, 150));

  // Screen 1 widgets
  screen1.addWidget(new Widget(20, 20, 120, 40, "Next"));
  screen1.addWidget(new Widget(20, 80, 120, 40, "Hello"));

  // Screen 2 widgets
  screen2.addWidget(new Widget(20, 20, 120, 40, "Back"));
  screen2.addWidget(new Widget(20, 80, 120, 40, "Heya "));

  currentScreen = screen1;
}
void draw() {
  currentScreen.draw();
}
void mousePressed(){
  Widget w = currentScreen.getEvent(mouseX, mouseY);

  if (w == null) return;

  if (w.label.equals("Next")) currentScreen = screen2;
  else if (w.label.equals("Back")) currentScreen = screen1;
  else println("Pressed: " + w.label);
}
void mouseMoved(){
  currentScreen.updateHover(mouseX, mouseY);
}
