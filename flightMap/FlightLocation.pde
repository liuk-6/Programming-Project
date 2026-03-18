class FlightLocation {
  String origin, destination;
  float oLat, oLon, dLat, dLon;
  String depTime, arrTime;
  float distance;
  String date;

  FlightLocation(String o, String d, float olat, float olon, float dlat, float dlon,
    String dep, String arr, float dist, String date) {
    origin = o;
    destination = d;
    oLat = olat;
    oLon = olon;
    dLat = dlat;
    dLon = dlon;
    depTime = dep;
    arrTime = arr;
    distance = dist;
    this.date = date;
  }

  void display(WorldMap map, boolean isSelected) {
    PVector p1 = map.geoToScreen(oLat, oLon);
    PVector p2 = map.geoToScreen(dLat, dLon);

    if (isSelected) {
      stroke(255, 0, 0);   // bright red
      strokeWeight(4);     // thicker
    } else {
      stroke(0, 150, 255, 120);
      strokeWeight(2);
    }

    noFill();

    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.2;

    beginShape();
    vertex(p1.x, p1.y);
    quadraticVertex(cx, cy, p2.x, p2.y);
    endShape();
  }

  void drawArc(float x1, float y1, float x2, float y2) {
    float cx = (x1 + x2) / 2;
    float cy = (y1 + y2) / 2 - 80;

    beginShape();
    vertex(x1, y1);
    quadraticVertex(cx, cy, x2, y2);
    endShape();
  }

  boolean isClicked(float mx, float my, WorldMap map) {
    PVector p1 = map.geoToScreen(oLat, oLon);
    PVector p2 = map.geoToScreen(dLat, dLon);

    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.2;

    // sample along curve
    for (float t = 0; t <= 1; t += 0.05) {

      float x = bezierPoint(p1.x, cx, cx, p2.x, t);
      float y = bezierPoint(p1.y, cy, cy, p2.y, t);

      if (dist(mx, my, x, y) < 8) {
        return true;
      }
    }

    return false;
  }
}
