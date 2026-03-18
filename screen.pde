class Screen {
  ArrayList<Widget> widgets = new ArrayList<Widget>();

  void draw() {
    drawBackground();
    for (Widget w : widgets) {
      w.draw();
    }
  }

  void drawBackground() {
    background(100); // default
  }

  void mousePressed() {
    for (Widget w : widgets) w.mousePressed();
  }

  void mouseMoved() {
    for (Widget w : widgets) w.mouseMoved();
  }

  void keyPressed(char k) {}
}
