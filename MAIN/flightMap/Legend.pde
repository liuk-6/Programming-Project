class Legend { //<>// //<>//
  // Position and size of the legend box
  float legendX, legendY;
  float legendW = 200;
  float legendH = 160;

  void display() {
    legendX = width  - legendW - 20;
    legendY = height - legendH - footerH - 10;

    fill(0, 180);
    noStroke();
    rect(legendX, legendY, legendW, legendH, 10);

    textSize(13);
    fill(255);
    textAlign(LEFT, CENTER);
    text("Flight Status", legendX + 15, legendY + 18);

    // Each entry highlights if it is the active filter
    drawEntry(legendX, legendY + 38, color(0, 200, 0),   "On Time",   "ON_TIME");
    drawEntry(legendX, legendY + 63, color(255, 165, 0),  "Delayed",   "DELAYED");
    drawEntry(legendX, legendY + 88, color(255, 0, 0),    "Cancelled", "CANCELLED");
    drawEntry(legendX, legendY + 113, color(200, 200, 200),"All",      "ALL");
  }

  // Draw one coloured line + label; bolder when this filter is active
  void drawEntry(float x, float y, color c, String label, String filterVal) {
    strokeWeight(statusFilter.equals(filterVal) ? 5 : 2);
    stroke(c);
    line(x + 15, y, x + 55, y);
    noStroke();
    fill(255);
    text(label, x + 65, y);
  }

  // Returns the filter string if a legend entry was clicked, else null
  String checkClick(float mx, float my) {
    legendX = width  - legendW - 20;
    legendY = height - legendH - footerH - 10;

    if (over(mx, my, legendX, legendY + 26,  legendW, 24)) return "ON_TIME";
    if (over(mx, my, legendX, legendY + 51,  legendW, 24)) return "DELAYED";
    if (over(mx, my, legendX, legendY + 76,  legendW, 24)) return "CANCELLED";
    if (over(mx, my, legendX, legendY + 101, legendW, 24)) return "ALL";
    return null;
  }

  boolean over(float mx, float my, float x, float y, float w, float h) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
