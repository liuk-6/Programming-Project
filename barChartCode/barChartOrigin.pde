class OriginBarChart {
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  ArrayList<AirportButton> buttons = new ArrayList<AirportButton>();
  OriginBarChart(){
  }
    void setup() {
      buttons.clear();
      
      pg = createGraphics(530, 400);
      Table table = loadTable("flights100k.csv", "header");
    
      // Count flights per Origin airport
      HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
      for (TableRow row : table.rows()) {
        if (row.getInt("CANCELLED") == 1) continue;
    
        String dest = row.getString("ORIGIN");
        if (dest == null || dest.trim().equals("")) continue;
    
        counts.put(dest, counts.getOrDefault(dest, 0) + 1);
      }
    
      // Sort by count (high to low)
      ArrayList<String> keys = new ArrayList<String>(counts.keySet());
      keys.sort((a, b) -> counts.get(b) - counts.get(a));
    
      // Keep only the top 10
      int limit = min(10, keys.size());
      airports = new String[limit];
      values = new float[limit];
    
      for (int i = 0; i < limit; i++) {
        airports[i] = keys.get(i);
        values[i] = counts.get(airports[i]);
      }
      
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
        float x = 40 + i * barWidth;
        float bx = x + (barWidth - 5)/2 - 30;
        float by = pg.height - 25;
        float bw = 60;
        float bh = 20;
    
        buttons.add(new AirportButton(bx, by, bw, bh, airports[i]));
      }

    }
    
    void draw() {
      pg.beginDraw();
      pg.background(255);
      pg.stroke(0);
      
      // --- drawing the y-axis ---
      pg.stroke(0);
      pg.line(40, 10, 40, pg.height - 30);  // x1,y1,x2,y2
    
      // --- Y‑axis ticks + labels ---
      int ticks = 5;
      float maxVal = 0;
      for (float v : values) maxVal = max(maxVal, v);
    
      pg.textAlign(RIGHT, CENTER);
      pg.fill(0);
      for (int i = 0; i <= ticks; i++) {
        float tVal = (maxVal / ticks) * i;
        float y = map(tVal, 0, maxVal, pg.height - 30, 10);
        pg.line(35, y, 40, y);               // tick mark
        pg.text(int(tVal), 30, y);           // label
      }
    
      // --- Bars ---
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
    
        // changing colours between bars 
        if (i % 2 == 0) {
          pg.fill(100, 0, 100);
        } else {
          pg.fill(0, 200, 175);
        }
    
        float h = map(values[i], 0, maxVal, 0, pg.height - 40);
        float x = 40 + i * barWidth;
        float y = pg.height - 30 - h;
    
        pg.rect(x, y, barWidth - 5, h);
    
        // airport labels
        pg.fill(0);
        pg.textAlign(CENTER, TOP);
        pg.text(airports[i], x + (barWidth - 5)/2, pg.height - 25);
        
      }
      pg.text("Bar chart of most popular origin airports", pg.width/2, 10);
      pg.text("Most popular origin airports", pg.width/2, pg.height-15);
      // --- Y-axis label (rotated) ---
        pg.pushMatrix();
        pg.translate(10, pg.height/2);  // move to left side, halfway down
        pg.rotate(-HALF_PI);            // rotate 90° counter‑clockwise
        pg.textAlign(CENTER, CENTER);
        pg.fill(0);
        pg.text("Quantity of flights", 0, 0);
        pg.popMatrix();
      pg.endDraw();
    
      image(pg, 0, 0);
    }
   String checkClick(float mx, float my) {
      float localX = mx - 630;   // X offset of the origin chart
      float localY = my - 200;   // Y offset of the origin chart
    
      for (AirportButton b : buttons) {
        if (b.isInside(localX, localY)) {
          return b.code;
        }
      }
      return null;
    }
}
