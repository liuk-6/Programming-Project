class AirportSearchPieScreen extends Screen {

  TextEntryButton searchInput;
  TextEntryButton currentInput;

  String searchedCode  = "";
  int    resOnTime     = 0;
  int    resDelayed    = 0;
  int    resCancelled  = 0;
  int    resTotal      = 0;
  boolean hasResult    = false;
  String  errorMsg     = "";

  int hoveredSlice = -1;

  color[] sliceColours = {
    color(149, 148, 109),
    color(216, 174, 112),
    color(193, 105, 82)
  };
  String[] sliceLabels = { "On Time", "Delayed > 30 min", "Cancelled" };

  float pieCX, pieCY, pieR;

  AirportSearchPieScreen() {
    buttons.add(new Button(30, 22, 80, 30, "BACK", "backAirport", 15, false));
    searchInput = new TextEntryButton(width/2 - 120, 130, 200, 40, "e.g. ATL", "searchCode", 6, 16, false, 1);
    buttons.add(new Button(width/2 + 100, 130, 120, 40, "Search", "doSearch", 16, true));
    currentInput = null;
    pieCX = width / 2;
    pieCY = 430;
    pieR  = 160;
  }

  @Override
  void draw() {
    // Gradient background
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      stroke(lerpColor(BG_TOP, BG_BOTTOM, inter));
      line(0, i, width, i);
    }
    noStroke();

    // Navbar
    fill(PANEL);
    noStroke();
    rect(0, 0, width, 80);
    fill(TEXT_SUB);
    textAlign(RIGHT, CENTER);
    textSize(22);
    text("Airport Flight Status Search", width - 40, 40);

    // Search panel
    fill(255, 20);
    noStroke();
    rect(width/2 - 250, 110, 500, 70, 12);
    fill(TEXT_MAIN);
    textAlign(LEFT, CENTER);
    textSize(14);
    text("Enter Airport Code:", width/2 - 230, 150);

    searchInput.display();
    for (Button b : buttons) b.display();

    // Error
    if (errorMsg != null && !errorMsg.equals("")) {
      fill(color(220, 80, 80));
      textAlign(CENTER, CENTER);
      textSize(18);
      text(errorMsg, width/2, 230);
    }

    if (hasResult) {
      drawResultTitle();
      drawInteractivePie();
      drawLegend();
      drawStatCards();
    } else if (errorMsg.equals("")) {
      fill(TEXT_SUB);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("Type an airport IATA code above and press Search", width/2, 300);
      text("(e.g. ATL, LAX, JFK, ORD, DFW, SEA ...)", width/2, 325);
    }
  }

  void drawResultTitle() {
    fill(RY_GOLD);
    textAlign(CENTER, CENTER);
    textSize(26);
    text(searchedCode + " — Flight Status Overview", width/2, 220);
    fill(TEXT_SUB);
    textSize(14);
    text("Based on " + resTotal + " flights in the dataset", width/2, 248);
  }

  void drawInteractivePie() {
    if (resTotal == 0) return;
    float[] vals = { resOnTime, resDelayed, resCancelled };
    updateHoveredSlice(vals);

    float start = -HALF_PI;
    float expandDist = 18;

    for (int i = 0; i < vals.length; i++) {
      float angle = TWO_PI * (vals[i] / resTotal);
      boolean hov = (hoveredSlice == i);
      float midAngle = start + angle / 2;
      float ox = hov ? cos(midAngle) * expandDist : 0;
      float oy = hov ? sin(midAngle) * expandDist : 0;

      fill(sliceColours[i]);
      noStroke();
      arc(pieCX + ox, pieCY + oy, pieR * 2, pieR * 2, start, start + angle, PIE);

      if (angle > 0.25) {
        float lx = pieCX + ox + cos(start + angle/2) * pieR * 0.65;
        float ly = pieCY + oy + sin(start + angle/2) * pieR * 0.65;
        fill(0, 180);
        textAlign(CENTER, CENTER);
        textSize(hov ? 16 : 14);
        text(nf((vals[i] / resTotal) * 100, 1, 1) + "%", lx, ly);
      }
      start += angle;
    }

    // Donut hole
    fill(lerpColor(BG_TOP, BG_BOTTOM, 0.5));
    noStroke();
    ellipse(pieCX, pieCY, pieR * 0.7, pieR * 0.7);
    fill(TEXT_MAIN);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("total", pieCX, pieCY + 10);
    textSize(20);
    text(str(resTotal), pieCX, pieCY - 8);

    // Tooltip
    if (hoveredSlice >= 0) {
      float[] vals2 = { resOnTime, resDelayed, resCancelled };
      String tip = sliceLabels[hoveredSlice] + "\n" +
                   int(vals2[hoveredSlice]) + " flights  (" +
                   nf((vals2[hoveredSlice] / resTotal) * 100, 1, 1) + "%)";
      float tx = mouseX + 14;
      float ty = mouseY - 10;
      float tw = 200, th = 50;
      if (tx + tw > width - 10) tx = mouseX - tw - 14;
      fill(PANEL); stroke(RY_GOLD); strokeWeight(1);
      rect(tx, ty, tw, th, 8);
      noStroke();
      fill(TEXT_MAIN);
      textAlign(LEFT, TOP);
      textSize(13);
      text(tip, tx + 10, ty + 8, tw - 20, th - 16);
    }
  }

  void updateHoveredSlice(float[] vals) {
    float dx = mouseX - pieCX;
    float dy = mouseY - pieCY;
    float dist = sqrt(dx*dx + dy*dy);
    if (dist > pieR + 30 || dist < 5) { hoveredSlice = -1; return; }

    float angle = atan2(dy, dx);
    float adj = angle + HALF_PI;
    if (adj < 0)        adj += TWO_PI;
    if (adj > TWO_PI)   adj -= TWO_PI;

    float cumulative = 0;
    for (int i = 0; i < vals.length; i++) {
      cumulative += TWO_PI * (vals[i] / resTotal);
      if (adj <= cumulative) { hoveredSlice = i; return; }
    }
    hoveredSlice = -1;
  }

  void drawLegend() {
    float lx = pieCX + pieR + 40;
    float ly = pieCY - 50;
    for (int i = 0; i < sliceLabels.length; i++) {
      fill(sliceColours[i]); noStroke();
      rect(lx, ly + i * 30, 15, 15, 3);
      fill(TEXT_MAIN);
      textAlign(LEFT, CENTER);
      textSize(14);
      text(sliceLabels[i], lx + 25, ly + i * 30 + 7);
    }
  }

  void drawStatCards() {
    float[] vals = { resOnTime, resDelayed, resCancelled };
    color[] cols = { color(40, 140, 40), color(220, 130, 30), color(200, 50, 50) };
    String[] lbls = { "ON TIME", "DELAYED", "CANCELLED" };
    float cw = 160, ch = 80;
    float startX = width/2 - (cw * 3 + 40) / 2;
    float cardY = 265;
    for (int i = 0; i < 3; i++) {
      float cx = startX + i * (cw + 20);
      float pct = (resTotal > 0) ? (vals[i] / resTotal) * 100 : 0;
      fill(0, 60); noStroke(); rect(cx+3, cardY+3, cw, ch, 10);
      fill(cols[i]); rect(cx, cardY, cw, ch, 10);
      fill(255); textAlign(CENTER, CENTER);
      textSize(12); text(lbls[i], cx + cw/2, cardY + 22);
      textSize(22); text(nf(pct, 1, 1) + "%", cx + cw/2, cardY + 58);
    }
  }

  @Override
  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        if (b.type.equals("backAirport")) { goBack(); return; }
        if (b.type.equals("doSearch"))    { doSearch(); return; }
      }
    }
    if (searchInput.over(mouseX, mouseY)) {
      currentInput = searchInput;
      if (searchInput.label.equals("e.g. ATL")) searchInput.label = "";
    } else {
      currentInput = null;
    }
  }

  @Override
  void keyPressed(char k) {
    if (currentInput != null) {
      currentInput.addChar(k);
      searchInput.label = searchInput.label.toUpperCase();
    }
    if (k == ENTER || k == RETURN) doSearch();
  }

  void doSearch() {
    String code = searchInput.label.trim().toUpperCase();
    if (code.equals("") || code.equals("E.G. ATL")) {
      errorMsg = "Please enter an airport code.";
      hasResult = false;
      return;
    }
    resOnTime = 0; resDelayed = 0; resCancelled = 0;
    resTotal = 0;  hasResult = false; errorMsg = "";

    for (Flight f : flightsList) {
      if (!f.origin.equalsIgnoreCase(code)) continue;
      resTotal++;
      if (f.cancelled) { resCancelled++; continue; }
      if (f.actualDepartureTime == 0) { resCancelled++; continue; }
      int actualMin    = (f.actualDepartureTime / 100) * 60 + (f.actualDepartureTime % 100);
      int scheduledMin = (f.scheduledDepartureTime / 100) * 60 + (f.scheduledDepartureTime % 100);
      if (actualMin - scheduledMin > 30) resDelayed++;
      else resOnTime++;
    }

    if (resTotal == 0) {
      errorMsg = "No flights found for airport code: " + code;
    } else {
      searchedCode = code;
      hasResult    = true;
    }
  }
}
