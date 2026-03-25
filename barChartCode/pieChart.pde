class PieChart {
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  color[] colours;
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
    
        int isCancelled = row.getInt("CANCELLED");
        if (isCancelled == 1) {
          cancelled++;
          continue;
        }
    
        // Clean missing times
        String depStr = row.getString("DEP_TIME");
        String crsStr = row.getString("CRS_DEP_TIME");
        if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
          cancelled++;   // treat missing times as unusable
          continue;
        }
    
        int dep = row.getInt("DEP_TIME");
        int crs = row.getInt("CRS_DEP_TIME");
    
        // Convert HHMM to minutes
        int depMin = (dep / 100) * 60 + (dep % 100);
        int crsMin = (crs / 100) * 60 + (crs % 100);
    
        int delay = depMin - crsMin;
    
        if (delay > 30) delayed++;
        else onTime++;
      }
    
      values = new float[] { onTime, delayed, cancelled };
      
      int total = onTime + cancelled + delayed;
      percentOnTime = round((float(onTime)/ total)*100);
      percentDelayed = round((float(delayed)/ total)*100);
      percentCancelled = round((float(cancelled)/ total)*100);
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
        pg.text(percentDelayed+"%", cx-diameter/20, cy-diameter/8);
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
    
      pg.endDraw();
    
      image(pg, 0, 0);
    }
}
