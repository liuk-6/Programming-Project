class InteractionManager {

  FlightLocation checkClick(ArrayList<FlightLocation> flights, float mx, float my, WorldMap map) {

    FlightLocation closestFlight = null;
    float closestDistance = 9999;

    for (FlightLocation f : flights) {

      float d = distanceToCurve(f, mx, my, map);

      if (d < 12 && d < closestDistance) {   // 12 = click tolerance
        closestDistance = d;
        closestFlight = f;
      }
    }

    return closestFlight;
  }

  float distanceToCurve(FlightLocation f, float mx, float my, WorldMap map) {

    PVector p1 = map.geoToScreen(f.oLat, f.oLon);
    PVector p2 = map.geoToScreen(f.dLat, f.dLon);

    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.2;

    float minDist = 9999;

    // more accurate sampling
    for (float t = 0; t <= 1; t += 0.02) {

      float x = bezierPoint(p1.x, cx, cx, p2.x, t);
      float y = bezierPoint(p1.y, cy, cy, p2.y, t);

      float d = dist(mx, my, x, y);
      if (d < minDist) {
        minDist = d;
      }
    }

    return minDist;
  }
}
