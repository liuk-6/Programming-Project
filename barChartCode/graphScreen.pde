class graphScreen{
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  color bg;

  graphScreen(color bg) {
    this.bg = bg;
  }

  void addWidget(Widget w) {
    widgets.add(w);
  }

  void draw() {
    background(bg);
    for (Widget w : widgets) {
      w.draw();
    }
  }

  Widget getEvent(int mx, int my) {
    for (Widget w : widgets) {
      if (w.isInside(mx, my)) return w;
    }
    return null;
  } 
  void updateHover(int mx, int my){
    for (Widget w : widgets) {
      w.hover = w.isInside(mx, my);
    }
  }
}
