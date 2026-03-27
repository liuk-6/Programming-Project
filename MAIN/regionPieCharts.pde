class RegionPieChart {
  float onTime = 0;
  float delayed = 0;
  float cancelled = 0;
  float percentOnTime;
  float percentDelayed;
  float percentCancelled;

  float[] values;
  color[] colours = {
    color(40, 200, 40),
    color(250, 255, 80),
    color(255, 80, 80)
  };

  PGraphics pg;

  RegionPieChart(String[] regionAirports) {
    pg = createGraphics(350, 260);
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

    pg.textAlign(LEFT, CENTER);
    pg.textSize(12);

    for (int i = 0; i < labels.length; i++) {
      pg.fill(colours[i]);
      pg.rect(lx, ly + i * 20, box, box);
      pg.fill(0);
      pg.text(labels[i], lx + box + 8, ly + i * 20 + box/2);
    }
    pg.text("Percentage of On Time flights", pg.width/2 , 10); 
    
    pg.endDraw();
    image(pg, x, y);
  }
}
