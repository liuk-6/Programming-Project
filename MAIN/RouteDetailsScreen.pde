class RouteDetailsScreen extends Screen {

  RouteDetailsScreen() {
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }

  void drawContent() {
    background(BG);

    // Header
    fill(RY_BLUE);
    noStroke();
    rect(0, 0, width, 80);

    fill(RY_GOLD);
    textAlign(CENTER, CENTER);
    textSize(26);
    text("ROUTE DETAILS", width/2, 40);

    if (selectedRoute == null) return;

    // Route title
    fill(TEXT_MAIN);
    textSize(36);
    textAlign(CENTER, CENTER);
    text(selectedRoute.origin + "  →  " + selectedRoute.destination, width/2, 130);

    fill(TEXT_SUB);
    textSize(15);
    text("Based on " + selectedRoute.passengers + " flights", width/2, 165);

    // ---- STAT CARDS ----
    drawStatCard(width/2 - 380, 200, "TOTAL FLIGHTS",
                 str(selectedRoute.passengers), color(60, 120, 200));

    drawStatCard(width/2 - 120, 200, "ON TIME",
                 nf(selectedRoute.onTimeRate, 1, 1) + "%", color(40, 180, 40));

    drawStatCard(width/2 + 140, 200, "DELAYED",
                 nf(selectedRoute.delayRate, 1, 1) + "%",
                 selectedRoute.delayRate > 20 ? color(220, 100, 50) : color(255, 160, 0));

    drawStatCard(width/2 + 380, 200, "CANCELLED",  // <-- moved further right
                 nf(selectedRoute.cancelRate, 1, 1) + "%",
                 selectedRoute.cancelRate > 10 ? color(220, 50, 50) : color(200, 80, 80));

    // ---- PIE CHART ----
    drawPieChart(width/2, 480, 160);

    // ---- LEGEND ----
    drawLegend(width/2 + 200, 420);
  }

  void drawStatCard(float cx, float y, String label, String value, color c) {
    float w = 200;
    float h = 110;
    float x = cx - w/2;

    // shadow
    fill(0, 60);
    rect(x + 4, y + 4, w, h, 12);

    // card
    fill(c);
    noStroke();
    rect(x, y, w, h, 12);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(13);
    text(label, cx, y + 30);

    textSize(30);
    text(value, cx, y + 75);
  }

  void drawPieChart(float cx, float cy, float diam) {
    if (selectedRoute == null) return;

    float total = selectedRoute.onTime + selectedRoute.delayed + selectedRoute.cancelled;
    if (total == 0) return;

    float[] vals = { selectedRoute.onTime, selectedRoute.delayed, selectedRoute.cancelled };
    color[] cols = { color(40, 180, 40), color(255, 160, 0), color(220, 50, 50) };

    float start = -HALF_PI; // start from top
    for (int i = 0; i < vals.length; i++) {
      float angle = TWO_PI * (vals[i] / total);
      fill(cols[i]);
      noStroke();
      arc(cx, cy, diam, diam, start, start + angle, PIE);
      start += angle;
    }

    // Centre hole (donut effect)
    fill(BG);
    ellipse(cx, cy, diam * 0.5, diam * 0.5);

    // Centre label
    fill(TEXT_MAIN);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("flights", cx, cy + 12);
    textSize(18);
    text(str(selectedRoute.passengers), cx, cy - 8);
  }

  void drawLegend(float x, float y) {
    String[] labels = { "On Time", "Delayed", "Cancelled" };
    color[]  cols   = { color(40, 180, 40), color(255, 160, 0), color(220, 50, 50) };

    for (int i = 0; i < labels.length; i++) {
      fill(cols[i]);
      noStroke();
      rect(x, y + i * 35, 16, 16, 3);

      fill(TEXT_MAIN);
      textAlign(LEFT, CENTER);
      textSize(14);
      text(labels[i], x + 24, y + i * 35 + 8);
    }
  }

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) goBack();
    }
  }
}
