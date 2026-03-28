class FlightLocation {
  String origin, destination;
  float oLat, oLon, dLat, dLon;
  String depTime, arrTime;
  float distance;
  String date;

  String status; // "ON_TIME", "DELAYED", "CANCELLED"

  FlightLocation(String o, String d, float olat, float olon, float dlat, float dlon,
    String dep, String arr, float dist, String date, String status) {

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
    this.status = status;
  }

  void display(WorldMap map, boolean isSelected, String selectedAirport) {
    PVector p1 = map.geoToScreen(oLat, oLon);
    PVector p2 = map.geoToScreen(dLat, dLon);

    noFill();

    // Calculate curve control point
    float cx = ((p1.x + p2.x) / 2);
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * (0.17);

    if (isSelected) {
      // 🔥 Glow layer
      stroke(0, 100, 255, 80);
      strokeWeight(8);
      drawCurve(p1, p2, cx, cy);

      // 🔵 Main blue line
      stroke(0, 100, 255, 255);
      strokeWeight(4);
      drawCurve(p1, p2, cx, cy);
    } else {

      // 🎨 Status colours with transparency
      if (status.equals("CANCELLED")) {
        stroke(255, 0, 0, 180); // red
      } else if (status.equals("DELAYED")) {
        stroke(255, 165, 0, 140); // orange
      } else {
        stroke(0, 200, 0, 120); // green
      }

      strokeWeight(selectedAirport != null ? 3 : 2);
      drawCurve(p1, p2, cx, cy);
    }
  }

  // ✅ Reusable curve drawing function
  void drawCurve(PVector p1, PVector p2, float cx, float cy) {
    beginShape();
    vertex(p1.x, p1.y);
    quadraticVertex(cx, cy, p2.x, p2.y);
    endShape();
  }

  boolean isClicked(float mx, float my, WorldMap map) {
    PVector p1 = map.geoToScreen(oLat, oLon);
    PVector p2 = map.geoToScreen(dLat, dLon);

    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * (2/10);

    // sample along curve
    for (float t = 0; t <= 1; t += (5/100)) {
      float x = bezierPoint(p1.x, cx, cx, p2.x, t);
      float y = bezierPoint(p1.y, cy, cy, p2.y, t);

      if (dist(mx, my, x, y) < 8) {
        return true;
      }
    }

    return false;
  }
}
