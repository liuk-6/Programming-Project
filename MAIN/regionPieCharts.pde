////////// REGIONS //////////////////////////////////////////////////////

/////////////// AIRLINES/////////////////////////////////////////////////////
// =========================================================
//  AIRLINE CODE → AIRLINE NAME MAP
// =========================================================

// =========================================================
//  AIRLINE CODE → AIRLINE NAME MAP
// =========================================================

HashMap<String, String> airlineNames = new HashMap<String, String>();

void loadAirlineNames() {
  airlineNames.put("AA", "American Airlines");
  airlineNames.put("AS", "Alaska Airlines");
  airlineNames.put("B6", "JetBlue Airways");
  airlineNames.put("DL", "Delta Air Lines");
  airlineNames.put("UA", "United Airlines");
  airlineNames.put("WN", "Southwest Airlines");
  airlineNames.put("NK", "Spirit Airlines");
  airlineNames.put("F9", "Frontier Airlines");
  airlineNames.put("G4", "Allegiant Air");
  airlineNames.put("HA", "Hawaiian Airlines");
  airlineNames.put("SY", "Sun Country Airlines");
  airlineNames.put("MQ", "Envoy Air");
  airlineNames.put("YX", "Republic Airways");
  airlineNames.put("OH", "PSA Airlines");
  airlineNames.put("OO", "SkyWest Airlines");
  airlineNames.put("QX", "Horizon Air");
  airlineNames.put("YV", "Mesa Airlines");
  airlineNames.put("EV", "ExpressJet Airlines");
  airlineNames.put("9E", "Endeavor Air");
  airlineNames.put("G7", "GoJet Airlines");
  airlineNames.put("CP", "Compass Airlines");
  airlineNames.put("AX", "Trans States Airlines");
  airlineNames.put("ZW", "Air Wisconsin");
  airlineNames.put("C5", "CommutAir");
  airlineNames.put("PT", "Piedmont Airlines");
  airlineNames.put("KS", "PenAir");
  airlineNames.put("XP", "Xtra Airways");

  // ICAO 3‑letter codes (sometimes appear)
  airlineNames.put("AAY", "Allegiant Air");
  airlineNames.put("ASH", "Mesa Airlines");
  airlineNames.put("ENY", "Envoy Air");
  airlineNames.put("SKW", "SkyWest Airlines");
  airlineNames.put("RPA", "Republic Airways");
  airlineNames.put("EDV", "Endeavor Air");
  airlineNames.put("JIA", "PSA Airlines");
  airlineNames.put("QXE", "Horizon Air");
  airlineNames.put("GJS", "GoJet Airlines");
  airlineNames.put("CPZ", "Compass Airlines");
  airlineNames.put("TSU", "Trans States Airlines");
}

String getAirlineName(String code) {
  return airlineNames.getOrDefault(code, code);
}



// =========================================================
//  COUNT AIRLINE TRAFFIC
// =========================================================

HashMap<String, Integer> countAirlineTraffic() {
  HashMap<String, Integer> counts = new HashMap<String, Integer>();

  Table table = loadTable("flights100k.csv", "header");

  for (TableRow row : table.rows()) {
    String carrier = row.getString("MKT_CARRIER");
    if (carrier == null || carrier.trim().equals("")) continue;

    counts.put(carrier, counts.getOrDefault(carrier, 0) + 1);
  }

  return counts;
}



// =========================================================
//  TOP 10 PLUS OTHER PIE CHART CLASS (AIRLINES)
// =========================================================

class TopAirlinesPie {
  String[] labels;
  float[] values;
  color[] colours;
  PGraphics pg;
  int selectedSlice = -1;
  float expandDist = 14;

  TopAirlinesPie(HashMap<String, Integer> counts) {
    pg = createGraphics(550, 350);

    // Sort airlines by flight count
    ArrayList<String> keys = new ArrayList<String>(counts.keySet());
    keys.sort((a, b) -> counts.get(b) - counts.get(a));

    int limit = min(10, keys.size());

     // Count "other" first so we know whether to include the slice
    float otherTotal = 0;

    for (int i = 0; i < keys.size(); i++) {
        otherTotal += counts.get(keys.get(i));
    }

    // Only add an "Other" slice when it actually has flights
    int slices = (otherTotal > 0) ? limit + 1 : limit;
    labels = new String[slices];
    values = new float[slices];
 
    for (int i = 0; i < limit; i++) {
      labels[i] = getAirlineName(keys.get(i));
      values[i] = counts.get(keys.get(i));
    }
 
    if (otherTotal > 0) {
      labels[limit] = "Other Airlines";
      values[limit] = otherTotal;
    }

    color[] palette = {
      color(#f0c571),
      color(#59a89c),
      color(#0b81a2),
      color(#7E4794),
      color(#9d2c00),
      color(#e25759),
      color(#36b700),
      color(#ff9d3a),
      color(#003a7d),
      color(#98c127),
      color(#E8B298),
      color(#c8c8c8)
    };
    // Generate random colours
    colours = new color[labels.length];
    for (int i = 0; i < colours.length; i++) {
      colours[i] = palette[i % palette.length];
    }
  }


  // ---------------------------------------------------------
  // DRAW PIE CHART
  // ---------------------------------------------------------
  void draw(float x, float y) {
    float total = 0;
    for (float v : values) total += v;

    pg.beginDraw();
    pg.background(RY_BG);
    pg.noStroke();

    float start = 0;
    float cx = pg.width/2 - 80;
    float cy = pg.height/2;
    float diameter = 250;

    for (int i = 0; i < values.length; i++) {
      float angle = TWO_PI * (values[i] / total);
      boolean hov = (selectedSlice == i);
      float midAngle = start + angle / 2;
      float ox = hov ? cos(midAngle) * expandDist : 0;
      float oy = hov ? sin(midAngle) * expandDist : 0;
      pg.fill(colours[i]);
      pg.arc(cx + ox, cy + oy, diameter, diameter, start, start + angle, PIE);

      // Show percentage label on the selected slice
      if (hov && angle > 0.05) {
        float labelX = cx + ox + cos(midAngle) * (diameter * 0.32);
        float labelY = cy + oy + sin(midAngle) * (diameter * 0.32);
        pg.fill(0, 180);
        pg.textAlign(CENTER, CENTER);
        pg.textSize(14);
        pg.text(nf((values[i] / total) * 100, 1, 1) + "%", labelX, labelY);
      }

      start += angle;
    }

    // Legend
    pg.textAlign(LEFT, CENTER);
    int lx = 350;
    int ly = 60;
    int box = 12;

    for (int i = 0; i < labels.length; i++) {
      // Highlight selected row
      if (i == selectedSlice) {
        pg.noStroke();
        pg.fill(230, 240, 255);
        pg.rect(lx - 4, ly + i * 20 - 3, 190, box + 6, 4);
      }
      pg.fill(colours[i]);
      pg.rect(lx, ly + i * 20, box, box);
      pg.fill(i == selectedSlice ? color(0, 80, 200) : 0);
      pg.textSize(i == selectedSlice ? 13 : 12);
      pg.text(labels[i] + " (" + int(values[i]) + ")", lx + box + 8, ly + i * 20 + box/2);
    }

    // Hint text
    pg.fill(120);
    pg.textSize(10);
    pg.textAlign(LEFT, TOP);
    pg.text("Click a label to highlight", lx, ly + labels.length * 20 + 6);

    // Title
    pg.textSize(15);
    pg.fill(0);
    pg.textAlign(LEFT, CENTER);
    pg.text("Percentage of Flights per Airline", pg.width/2 - 180, 20);

    pg.endDraw();
    image(pg, x - 50, y);
  }
  void mousePressed(float x, float y) {
    // x - 50 matches image(pg, x - 50, y) in draw()
    float drawX = x - 50;
    int lx = 350;
    int ly = 60;
    int box = 12;
    int rowH = 20;

    for (int i = 0; i < labels.length; i++) {
      float rowY = y + ly + i * rowH;
      // Hit area covers the full legend row width
      if (mouseX > drawX + lx - 4 && mouseX < drawX + lx + 194 &&
          mouseY > rowY - 3       && mouseY < rowY + box + 3) {
        // Toggle: clicking the same row again deselects it
        selectedSlice = (selectedSlice == i) ? -1 : i;
        return;
      }
    }
  }
}

/////////PIE CHART///////
class PieChart {
  float percentOnTime;
  float percentDelayed;
  float percentCancelled;
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  color[] colours;
 
  HashMap<String, Integer> onTimeByAirport = new HashMap<String, Integer>();
  HashMap<String, Integer> delayedByAirport = new HashMap<String, Integer>();
  HashMap<String, Integer> cancelledByAirport = new HashMap<String, Integer>();

  String topOnTimeAirport = "";
  String topDelayedAirport = "";
  String topCancelledAirport = "";

  boolean showTopAirports = false;
   int hoveredSlice = -1;
   float expandDist = 14;

  // Button position
  int btnX = 10, btnY = 260, btnW = 180, btnH = 30;

  PieChart(){
    colours = new color[] {
      color(#4F772D),
      color(#FCBF49),
      color(#D62828)
    };
  }
    
    void setup() {
      pg = createGraphics(400, 300);
    
      Table table = loadTable("flights100k.csv", "header");
      int onTime = 0;
      int delayed = 0;
      int cancelled = 0;
    
      for (TableRow row : table.rows()) {
        String airport = row.getString("ORIGIN");

        int isCancelled = row.getInt("CANCELLED");
        if (isCancelled == 1) {
          cancelled++;
          increment(cancelledByAirport, airport);
          continue;
        }
    
        // Clean missing times
        String depStr = row.getString("DEP_TIME");
        String crsStr = row.getString("CRS_DEP_TIME");
        if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
          cancelled++;   // treat missing times as unusable
          increment(cancelledByAirport, airport);

          continue;
        }
    
        int dep = row.getInt("DEP_TIME");
        int crs = row.getInt("CRS_DEP_TIME");
    
        // Convert HHMM to minutes
        int depMin = (dep / 100) * 60 + (dep % 100);
        int crsMin = (crs / 100) * 60 + (crs % 100);
    
        int delay = depMin - crsMin;
    
        if (delay > 30) {
          delayed++;
           increment(delayedByAirport, airport);
        }
        else {
          onTime++;
          increment(onTimeByAirport, airport);
        }
      }
    
      values = new float[] { onTime, delayed, cancelled };
      
      int total = onTime + cancelled + delayed;
      percentOnTime = round((float(onTime)/ total)*100);
      percentDelayed = round((float(delayed)/ total)*100);
      percentCancelled = round((float(cancelled)/ total)*100);
      computeTopAirports();
    }
    void increment(HashMap<String, Integer> map, String key) {
      if (!map.containsKey(key)) map.put(key, 1);
      else map.put(key, map.get(key) + 1);
    }
  
    // Find max airport for each category
    void computeTopAirports() {
      topOnTimeAirport = findMax(onTimeByAirport);
      topDelayedAirport = findMax(delayedByAirport);
      topCancelledAirport = findMax(cancelledByAirport);
    }
  
    String findMax(HashMap<String, Integer> map) {
      String best = "";
      int max = -1;
      for (String k : map.keySet()) {
        int v = map.get(k);
        if (v > max) {
          max = v;
          best = k;
        }
      }
      return best + " (" + max + ")";
    }
   void draw() {
    // Calculate hover BEFORE drawing so expanded slices are correct
    float[] vals = values;
    float total = 0;
    for (float v : vals) total += v;

    // Pie is drawn at centre of pg
    float cx = pg.width / 2;
    float cy = pg.height / 2;
    float radius = 125;

    // Hover detection happens in pg-local coords (mouseX/Y minus the translate applied in drawContent)
    // We store result in hoveredSlice each frame
    float pieX = width/2 - 400/2;
    float pieY = height/2 - 300/2 + 20;
    float localMX = mouseX - pieX;
    float localMY = mouseY - pieY;
    float dx = localMX - cx;
    float dy = localMY - cy;
    float dist = sqrt(dx*dx + dy*dy);
    hoveredSlice = -1;
    if (dist <= radius + 20 && dist >= 5) {
      float ang = atan2(dy, dx) + HALF_PI;
      if (ang < 0)      ang += TWO_PI;
      if (ang > TWO_PI) ang -= TWO_PI;
      float cumul = 0;
      for (int i = 0; i < vals.length; i++) {
        cumul += TWO_PI * (vals[i] / total);
        if (ang <= cumul) { hoveredSlice = i; break; }
      }
    }

    pg.beginDraw();
    pg.background(RY_BG);
    pg.noStroke();

    float start = -HALF_PI;
    for (int i = 0; i < vals.length; i++) {
      float angle = TWO_PI * (vals[i] / total);
      boolean hov = (hoveredSlice == i);
      float midAngle = start + angle / 2;
      float ox = hov ? cos(midAngle) * expandDist : 0;
      float oy = hov ? sin(midAngle) * expandDist : 0;

      pg.fill(colours[i]);
      pg.arc(cx + ox, cy + oy, radius * 2, radius * 2, start, start + angle, PIE);

      // Percentage label inside slice
      if (angle > 0.2) {
        float lx = cx + ox + cos(midAngle) * radius * 0.65;
        float ly = cy + oy + sin(midAngle) * radius * 0.65;
        pg.fill(0, 180);
        pg.textAlign(CENTER, CENTER);
        pg.textSize(hov ? 15 : 13);
        float pct = (vals[i] / total) * 100;
        pg.text(nf(pct, 1, 1) + "%", lx, ly);
      }
      start += angle;
    }

    // Legend
    int lx = 10, ly = 10, box = 15;
    String[] labels = { "On Time", "Delayed > 30min", "Cancelled" };
    pg.textAlign(LEFT, CENTER);
    pg.textSize(12);
    for (int i = 0; i < labels.length; i++) {
      pg.fill(colours[i]);
      pg.rect(lx, ly + i * 25, box, box);
      pg.fill(0);
      pg.text(labels[i], lx + box + 10, ly + i * 25 + box/2);
    }

    // Show Top Airports button
    pg.fill(200);
    pg.rect(btnX, btnY, btnW, btnH, 5);
    pg.fill(0);
    pg.textAlign(CENTER, CENTER);
    pg.text("Show Top Airports", btnX + btnW/2, btnY + btnH/2);

    pg.endDraw();
    image(pg, 0, 0);

    // Tooltip drawn in screen coords (after image stamp, outside pg)
    if (hoveredSlice >= 0) {
      String[] tipLabels = { "On Time", "Delayed > 30min", "Cancelled" };
      float pct = (vals[hoveredSlice] / total) * 100;
      String tip = tipLabels[hoveredSlice] + "\n" +
                   int(vals[hoveredSlice]) + " flights (" + nf(pct, 1, 1) + "%)";
      float pieScreenX = width/2 - 400/2;
      float pieScreenY = height/2 - 300/2 + 20;
      float tx = mouseX - pieScreenX + 14;
      float ty = mouseY - pieScreenY - 10;
      float tw = 200, th = 48;
      fill(255); stroke(RY_BLUE); strokeWeight(1);
      rect(tx, ty, tw, th, 7);
      noStroke(); fill(RY_BLUE);
      textAlign(LEFT, TOP);
      textSize(12);
      text(tip, tx + 9, ty + 7, tw - 18, th - 14);
    }
  }
    void mousePressed() {
      // Adjust for translate(200, 300)
      float pieX = width/2 - 400/2;
      float pieY = height/2 - 300/2 + 20;
      int mx = (int)(mouseX - pieX);
      int my = (int)(mouseY - pieY);
    
      if (mx > btnX && mx < btnX + btnW &&
          my > btnY && my < btnY + btnH) {
        showTopAirports = !showTopAirports;
      }
    }
  boolean isShowingTop() {
      return showTopAirports;
    }
    
    String[] getTopAirportInfo() {
      return new String[] {
        "Most On-Time: " + topOnTimeAirport,
        "Most Delayed: " + topDelayedAirport,
        "Most Cancelled: " + topCancelledAirport
      };
    }
    
}
