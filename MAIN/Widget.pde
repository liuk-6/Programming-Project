class Widget {
  float x, y, w, h;
  boolean hover;

  Widget(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void draw() {}
  void mousePressed() {}
  void mouseMoved() {
    hover = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
