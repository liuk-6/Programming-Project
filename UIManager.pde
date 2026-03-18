class UIManager {
  Screen currentScreen;

  void switchScreen(Screen next) {
    currentScreen = next;
  }

  void draw() {
    if (currentScreen != null) currentScreen.draw();
  }

  void mousePressed() {
    if (currentScreen != null) currentScreen.mousePressed();
  }

  void mouseMoved() {
    if (currentScreen != null) currentScreen.mouseMoved();
  }

  void keyPressed(char k) {
    if (currentScreen != null) currentScreen.keyPressed(k);
  }
}
