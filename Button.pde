class Button extends Widget {
  String label;
  Runnable action;

  Button(float x, float y, float w, float h, String label, Runnable action) {
    super(x, y, w, h);
    this.label = label;
    this.action = action;
  }

  void draw() {
    fill(hover ? color(100, 140, 255) : color(70));
    stroke(255);
    rect(x, y, w, h, 8);
    fill(255);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }

  void mousePressed() {
    if (hover && action != null) action.run();
  }
}
class Screen1 extends Screen {
  UIManager ui;
  UserSelection selection;

  Screen1(UIManager ui, UserSelection selection) {
    this.ui = ui;
    this.selection = selection;

    widgets.add(new Button(300, 150, 200, 50, "Next →", () -> {
      ui.switchScreen(new Screen2(ui, selection));
    }));

    widgets.add(new Button(300, 230, 200, 50, "Hello", () -> {
      println("Hello button clicked!");
    }));
  }

  void drawBackground() {
    background(150, 200, 255);
    fill(0);
    textAlign(CENTER);
    text("Screen 1", width/2, 80);
  }
}
class Screen2 extends Screen {
  UIManager ui;
  UserSelection selection;

  Screen2(UIManager ui, UserSelection selection) {
    this.ui = ui;
    this.selection = selection;

    widgets.add(new Button(300, 150, 200, 50, "Back ←", () -> {
      ui.switchScreen(new Screen1(ui, selection));
    }));

    widgets.add(new Button(300, 230, 200, 50, "Heya", () -> {
      println("Heya button clicked!");
    }));
  }

  void drawBackground() {
    background(255, 200, 150);
    fill(0);
    textAlign(CENTER);
    text("Screen 2", width/2, 80);
  }
}
