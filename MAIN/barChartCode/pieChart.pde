class PieChart {
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

  // Button position
  int btnX = 10, btnY = 260, btnW = 180, btnH = 30;

  PieChart(){
    colours = new color[] {
      color(40, 200, 40),   // on-time
      color(250, 255, 80),    // delayed
      color(255, 80, 80)    // cancelled
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
    void draw(){
      pg.beginDraw();
      pg.background(255);
      pg.noStroke();
    
      float total = 0;
      for (float v : values) total += v;
    
      float start = 0;
      float cx = pg.width/2;
      float cy = pg.height/2;
      float diameter = 250;
    
      for (int i = 0; i < values.length; i++) {
        float angle = TWO_PI * (values[i] / total);
        pg.fill(colours[i]);
        pg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
        pg.fill(0);
        pg.text(percentOnTime+"%", cx-diameter/8, cy+diameter/8);
        pg.text(percentDelayed+"%", cx, cy-diameter/8);
        pg.text(percentCancelled+"%", cx+diameter/4, cy-diameter/25);
        start += angle;
      }
      // --- Legend ---
        int lx = 10;      // legend x-position inside pg
        int ly = 10;      // legend y-position
        int box = 15;     // size of colour squares
        
        String[] labels = {
          "On Time",
          "Delayed > 30min",
          "Cancelled"
        };
        
        pg.textAlign(LEFT, CENTER);
        pg.textSize(12);
        
        for (int i = 0; i < labels.length; i++) {
          pg.fill(colours[i]);
          pg.rect(lx, ly + i * 25, box, box);
        
          pg.fill(0);
          pg.text(labels[i], lx + box + 10, ly + i * 25 + box/2);
        }
      
      pg.fill(0);
      pg.text("Percentage of On Time flights", pg.width/2 , 10); 
    
      // --- Button ---
      pg.fill(200);
      pg.rect(btnX, btnY, btnW, btnH, 5);
      pg.fill(0);
      pg.textAlign(CENTER, CENTER);
      pg.text("Show Top Airports", btnX + btnW/2, btnY + btnH/2);
 
      pg.endDraw();
    
      image(pg, 0, 0);
    }
    void mousePressed() {
      // Adjust for translate(200, 300)
      int mx = mouseX - 200;
      int my = mouseY - 300;
    
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
