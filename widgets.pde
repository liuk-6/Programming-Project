class Widget {
  int x, y, w, h;
  String label;
  boolean hover = false;

  Widget(int x, int y, int w, int h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void draw() {
  if (hover) stroke(255);
  else stroke(0);
  fill(127);
  rect(x, y, w, h);

  fill(255);
  text(label, x + 10, y + 20);
  }

  boolean isInside(int mx, int my) {
    return mx > x && mx < x+w && my > y && my < y+h;
  }
}
