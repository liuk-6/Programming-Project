PGraphics pg;
String[] airports;   // top 10 airport codes
float[] values;      // top 10 counts

void setup() {
  size(800, 400);
  pg = createGraphics(600, 300);

  Table table = loadTable("flights2k.csv", "header");

  // Count flights per DEST airport
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
}

void draw() {
  pg.beginDraw();
  pg.background(240);
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

  pg.endDraw();

  background(200);
  image(pg, 100, 50);
}
