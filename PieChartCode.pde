PGraphics pg;
float[] values = {30, 15, 10, 45};
color[] colors = { 
  color(255, 100, 100), 
  color(100, 255, 100), 
  color(100, 100, 255), 
  color(255, 200, 0)
};

void setup() {
  size(300, 300);
  pg = createGraphics(200, 200);
}

void draw() {
  pg.beginDraw();
  pg.background(240);
  pg.noStroke();

  float total = 0;
  for (float v : values) total += v;

  float start = 0;
  float cx = pg.width/2;
  float cy = pg.height/2;
  float diameter = 150;

  for (int i = 0; i < values.length; i++) {
    float angle = TWO_PI * (values[i] / total);
    pg.fill(colors[i]);
    pg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
    start += angle;
  }

  pg.endDraw();

  background(200);
  image(pg, 50, 50);
}
