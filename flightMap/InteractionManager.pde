class InteractionManager {

  // Returns the flight arc closest to (mx, my), or null if none is close enough
  FlightLocation checkClick(ArrayList<FlightLocation> flights,
                            float mx, float my, WorldMap map) {
    FlightLocation closest     = null;
    float          closestDist = 9999;

    for (FlightLocation f : flights) {
      float d = distanceToCurve(f, mx, my, map);
      if (d < 12 && d < closestDist) {
        closestDist = d;
        closest     = f;
      }
    }
    return closest;
  }

  // Same logic used for hover detection in draw()
  FlightLocation checkHover(ArrayList<FlightLocation> flights,
                            float mx, float my, WorldMap map) {
    return checkClick(flights, mx, my, map);
  }

  // Samples points along the bezier and returns the minimum distance
  // from (mx, my) to the curve
  float distanceToCurve(FlightLocation f, float mx, float my, WorldMap map) {
    PVector p1 = map.geoToScreen(f.oLat, f.oLon, contentX, contentY, contentW, contentH);
    PVector p2 = map.geoToScreen(f.dLat, f.dLon, contentX, contentY, contentW, contentH);

    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.2;

    float minDist = 9999;

    // Sample 50 points along the curve (t = 0.02 step)
    for (float t = 0; t <= 1; t += 0.02) {
      float x = bezierPoint(p1.x, cx, cx, p2.x, t);
      float y = bezierPoint(p1.y, cy, cy, p2.y, t);
      float d = dist(mx, my, x, y);
      if (d < minDist) minDist = d;
    }
    return minDist;
  }
}
