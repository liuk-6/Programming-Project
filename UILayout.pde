class UILayout {

  final int NAV_HEIGHT = 80;
  final int PAGE_PADDING = 40;

  // ===============================
  // FULL PAGE LAYOUT
  // ===============================
  void beginPage(String title) {

    drawBackground();
    drawNavbar(title);
  }

  // ===============================
  // BACKGROUND (shared everywhere)
  // ===============================
  void drawBackground() {

    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(lerpColor(BG_TOP, BG_BOTTOM, inter));
      line(0, i, width, i);
    }
    noStroke();
  }

  // ===============================
  // NAVBAR
  // ===============================
  void drawNavbar(String title) {

  fill(PANEL);
  rect(0, 0, width, NAV_HEIGHT);

  stroke(255, 30);
  line(0, NAV_HEIGHT, width, NAV_HEIGHT);
  noStroke();

  fill(150);
  textAlign(RIGHT, CENTER);   // anchor text to right side
  textSize(26);

  // draw near right edge with padding
  text(title, width - PAGE_PADDING, NAV_HEIGHT/2);
}

  // ===============================
  // CONTENT AREA HELPERS
  // ===============================
  float contentTop() {
    return NAV_HEIGHT + PAGE_PADDING;
  }

  float contentLeft() {
    return PAGE_PADDING;
  }

  float contentWidth() {
    return width - PAGE_PADDING * 2;
  }
}
