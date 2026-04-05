// A flight that has been matched to geographic coordinates
// and had its status (ON_TIME / DELAYED / CANCELLED) computed
class FlightLocation {
  String origin, destination;
  float  oLat, oLon;   // origin lat/lon
  float  dLat, dLon;   // destination lat/lon
  String depTime, arrTime;
  float  distance;
  String date;
  String status; // "ON_TIME", "DELAYED", or "CANCELLED"

  FlightLocation(String o, String d,
                 float olat, float olon,
                 float dlat, float dlon,
                 String dep, String arr,
                 float dist, String date, String status) {
    origin      = o;
    destination = d;
    oLat = olat; oLon = olon;
    dLat = dlat; dLon = dlon;
    depTime  = dep;
    arrTime  = arr;
    distance = dist;
    this.date   = date;
    this.status = status;
  }

  // Draw this flight as a curved arc on the map
  void display(WorldMap map, boolean isSelected, String selectedAirport) {
    PVector p1 = map.geoToScreen(oLat, oLon, contentX, contentY, contentW, contentH);
    PVector p2 = map.geoToScreen(dLat, dLon, contentX, contentY, contentW, contentH);

    // Control point sits above the midpoint — higher arc for longer flights
    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.17;

    noFill();

    if (isSelected) {
      // Glow effect: wide semi-transparent stroke behind a sharp stroke
      stroke(0, 100, 255, 80);
      strokeWeight(8);
      drawCurve(p1, p2, cx, cy);

      stroke(0, 100, 255, 255);
      strokeWeight(4);
      drawCurve(p1, p2, cx, cy);

    } else {
      // Colour by status
      if      (status.equals("CANCELLED")) stroke(255, 0,   0,   180);
      else if (status.equals("DELAYED"))   stroke(255, 165, 0,   140);
      else                                 stroke(0,   200, 0,   120);

      // Slightly thicker lines when an airport is selected
      // so the filtered set is easier to see
      strokeWeight(selectedAirport != null ? 3 : 2);
      drawCurve(p1, p2, cx, cy);
    }
  }

  // Shared helper — draws the quadratic bezier arc
  void drawCurve(PVector p1, PVector p2, float cx, float cy) {
    beginShape();
    vertex(p1.x, p1.y);
    quadraticVertex(cx, cy, p2.x, p2.y);
    endShape();
  }
}
