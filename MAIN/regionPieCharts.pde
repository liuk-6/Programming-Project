////////// REGIONS //////////////////////////////////////////////////////
class RegionPieChart {
  float onTime = 0;
  float delayed = 0;
  float cancelled = 0;
  float percentOnTime;
  float percentDelayed;
  float percentCancelled;

  float[] values;
  color[] colours = {
    color(#2D9B2B),
    color(#FFD700),
    color(#D40000)
  };

  PGraphics pg;

  RegionPieChart(String[] regionAirports) {
    pg = createGraphics(450, 260);
    compute(regionAirports);
  }

  void compute(String[] regionAirports) {
    HashSet<String> region = new HashSet<String>();
    for (String a : regionAirports) region.add(a);

    Table table = loadTable("flights2k.csv", "header");

    for (TableRow row : table.rows()) {
      String origin = row.getString("ORIGIN");
      if (!region.contains(origin)) continue;

      int cancelledFlag = row.getInt("CANCELLED");
      if (cancelledFlag == 1) {
        cancelled++;
        continue;
      }

      String depStr = row.getString("DEP_TIME");
      String crsStr = row.getString("CRS_DEP_TIME");
      if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
        cancelled++;
        continue;
      }

      int dep = row.getInt("DEP_TIME");
      int crs = row.getInt("CRS_DEP_TIME");

      int depMin = (dep / 100) * 60 + (dep % 100);
      int crsMin = (crs / 100) * 60 + (crs % 100);

      int delay = depMin - crsMin;

      if (delay > 30) delayed++;
      else onTime++;
    }

    values = new float[]{onTime, delayed, cancelled};
    float total = onTime + cancelled + delayed;
    percentOnTime = round((onTime/ total)*100);
    percentDelayed = round((delayed/ total)*100);
    percentCancelled = round((cancelled/ total)*100);
  }

  void draw(float x, float y) {
    pg.beginDraw();
    pg.background(255);
    pg.noStroke();

    float total = onTime + delayed + cancelled;
    float start = 0;
    float cx = pg.width/2;
    float cy = pg.height/2;
    float diameter = 200;

    for (int i = 0; i < values.length; i++) {
      float angle = TWO_PI * (values[i] / total);
      pg.fill(colours[i]);
      pg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
      pg.fill(0);
      pg.text(int(percentOnTime)+"%", cx-diameter/8, cy+diameter/8);
      pg.text(int(percentDelayed)+"%", cx, cy-diameter/8);
      pg.text(int(percentCancelled)+"%", cx+diameter/4, cy-diameter/25);
      start += angle;
    }

    // Legend
    String[] labels = {"On Time", "Delayed", "Cancelled"};
    int lx = 10, ly = 10, box = 12;

    pg.textAlign(CENTER,CENTER);
    pg.textSize(15);

    for (int i = 0; i < labels.length; i++) {
      pg.fill(colours[i]);
      pg.rect(lx, ly + i * 20, box, box);
      pg.fill(0);
      pg.text(labels[i], lx + box + 8, ly + i * 20 + box/2);
    }
    pg.fill(0);
    pg.text("Percentage of On Time flights", pg.width/2 , 10); 

    pg.endDraw();
    image(pg, x, y);
  }
}
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
    pg.beginDraw();
    pg.background(RY_BG);
    pg.noStroke();

    float total = 0;
    for (float v : values) total += v;

    float start = 0;
    float cx = pg.width/2 - 80;
    float cy = pg.height/2;
    float diameter = 250;

    for (int i = 0; i < values.length; i++) {
      float angle = TWO_PI * (values[i] / total);
      pg.fill(colours[i]);
      pg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
      start += angle;
    }

    // Legend
    pg.textAlign(LEFT, CENTER);
    pg.textSize(12);

    int lx = 350;
    int ly = 60;
    int box = 12;

    for (int i = 0; i < labels.length; i++) {
      pg.fill(colours[i]);
      pg.rect(lx, ly + i * 20, box, box);

      pg.fill(0);
      pg.text(labels[i] + " (" + int(values[i]) + ")", lx + box + 8, ly + i * 20 + box/2);
    }
    pg.textSize(15);
    pg.fill(0);
    pg.text("Percentage of Flights per Airline ", pg.width/2 - 180 , 20);

    pg.endDraw();
    image(pg, x - 50, y);
  }
}
