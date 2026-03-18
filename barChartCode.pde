PGraphics pg;
float[] values = {10, 40, 25, 60, 30};

void setup() {
  size(300, 300);
  pg = createGraphics(200, 200);
}

void draw() {
  pg.beginDraw();
  pg.background(240);
  pg.stroke(0);
  pg.fill(100, 150, 255);

  float maxVal = 0;
  for (float v : values) maxVal = max(maxVal, v);

  float barWidth = pg.width / (float)values.length;

  for (int i = 0; i < values.length; i++) {
    float h = map(values[i], 0, maxVal, 0, pg.height - 20);
    pg.rect(i * barWidth, pg.height - h, barWidth - 5, h);
  }

  pg.endDraw();

  background(200);
  image(pg, 50, 50);
}
