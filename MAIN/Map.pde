
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

class FlightManager {
  ArrayList<FlightLocation> allFlights      = new ArrayList<FlightLocation>();
  ArrayList<FlightLocation> filteredFlights = new ArrayList<FlightLocation>();

  // Only flights involving these airports are shown
  HashSet<String> allowedAirports = new HashSet<String>();

  // How many minutes late counts as a delay
  final int DELAY_THRESHOLD = 30;

  void loadFromTable(Table table, LocationManager loc) {
    allFlights.clear();

    // Define the airports we want to show
    String[] airports = { "DFW","ATL","CLT","ORD","DEN",
                          "LAX","PHX","SEA","LGA","MCO" };
    for (String a : airports) allowedAirports.add(a);

    for (int row = 0; row < table.getRowCount(); row++) {
      Flight raw = new Flight(row);

      String originCode = raw.origin.trim().toUpperCase();
      String destCode   = raw.destination.trim().toUpperCase();

      // Skip if either airport has no coordinates
      PVector origin = loc.getCoords(originCode);
      PVector dest   = loc.getCoords(destCode);
      if (origin == null || dest == null) {
        //println("Missing coords for:", originCode, destCode);
        continue;
      }

      // Restrict to continental US latitude band
      float oLat = origin.x, oLon = origin.y;
      float dLat = dest.x,   dLon = dest.y;
      if (oLat < 24 || oLat > 50 || dLat < 24 || dLat > 50) continue;

      // Compute status
      String status;
      if (raw.cancelled) {
        status = "CANCELLED";
      } else {
        int delay = timeToMinutes(raw.actualDepartureTime)
                  - timeToMinutes(raw.scheduledDepartureTime);
        status = (delay > DELAY_THRESHOLD) ? "DELAYED" : "ON_TIME";
      }

      allFlights.add(new FlightLocation(
        originCode, destCode,
        oLat, oLon, dLat, dLon,
        str(raw.scheduledDepartureTime),
        str(raw.scheduledArrivalTime),
        raw.distance, raw.date, status
      ));
    }

    // Start with all flights visible
    filteredFlights = new ArrayList<FlightLocation>(allFlights);
  }

  // Optional: filter to a single date
  void filterByDate(String date) {
    filteredFlights.clear();
    for (FlightLocation f : allFlights) {
      if (f.date.equals(date)) filteredFlights.add(f);
    }
  }

  ArrayList<FlightLocation> getFlights() {
    return filteredFlights;
  }

  // Converts a time integer like 1435 → minutes (14*60 + 35 = 875)
  int timeToMinutes(int t) {
    return (t / 100) * 60 + (t % 100);
  }
}

class InfoPanel {
  // The flight currently shown in the panel (null = hidden)
  private FlightLocation currentFlight;

  void setFlight(FlightLocation f) {
    currentFlight = f;
  }

  // Safe getter — used in main draw() to avoid direct field access
  FlightLocation getFlight() {
    return currentFlight;
  }

  void display() {
    if (currentFlight == null) return;

    // Semi-transparent dark background box
    fill(0, 180);
    noStroke();
    rect(20, 65, 240, 170, 10);

    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    text("From:      " + currentFlight.origin,      30, 80);
    text("To:        " + currentFlight.destination,  30, 100);
    text("Departure: " + currentFlight.depTime,      30, 120);
    text("Arrival:   " + currentFlight.arrTime,      30, 140);
    text("Distance:  " + currentFlight.distance + " mi", 30, 160);
    text("Status:    " + currentFlight.status,       30, 180);
  }
}

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

class Legend { //<>// //<>//
  // Position and size of the legend box
  float legendX, legendY;
  float legendW = 200;
  float legendH = 160;

  void display() {
    legendX = width  - legendW - 20;
    legendY = height - legendH - footerH - 10;

    fill(0, 180);
    noStroke();
    rect(legendX, legendY, legendW, legendH, 10);

    textSize(13);
    fill(255);
    textAlign(LEFT, CENTER);
    text("Flight Status", legendX + 15, legendY + 18);

    // Each entry highlights if it is the active filter
    drawEntry(legendX, legendY + 38, color(0, 200, 0),   "On Time",   "ON_TIME");
    drawEntry(legendX, legendY + 63, color(255, 165, 0),  "Delayed",   "DELAYED");
    drawEntry(legendX, legendY + 88, color(255, 0, 0),    "Cancelled", "CANCELLED");
    drawEntry(legendX, legendY + 113, color(200, 200, 200),"All",      "ALL");
  }

  // Draw one coloured line + label; bolder when this filter is active
  void drawEntry(float x, float y, color c, String label, String filterVal) {
    strokeWeight(statusFilter.equals(filterVal) ? 5 : 2);
    stroke(c);
    line(x + 15, y, x + 55, y);
    noStroke();
    fill(255);
    text(label, x + 65, y);
  }

  // Returns the filter string if a legend entry was clicked, else null
  String checkClick(float mx, float my) {
    legendX = width  - legendW - 20;
    legendY = height - legendH - footerH - 10;

    if (over(mx, my, legendX, legendY + 26,  legendW, 24)) return "ON_TIME";
    if (over(mx, my, legendX, legendY + 51,  legendW, 24)) return "DELAYED";
    if (over(mx, my, legendX, legendY + 76,  legendW, 24)) return "CANCELLED";
    if (over(mx, my, legendX, legendY + 101, legendW, 24)) return "ALL";
    return null;
  }

  boolean over(float mx, float my, float x, float y, float w, float h) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

class LocationManager {
  // Maps airport code → PVector(lat, lon)
  HashMap<String, PVector> locations = new HashMap<String, PVector>();

  // Expects CSV lines in the format: CODE,lat,lon
  void loadLocations(String filename) {
    String[] lines = loadStrings(filename);
    if (lines == null) {
      //println("LocationManager: file not found ->", filename);
      return;
    }

    for (String line : lines) {
      line = trim(line);
      if (line.length() == 0) continue;

      String[] parts = split(line, ",");
      if (parts.length < 3) continue;

      try {
        String code = trim(parts[0]).toUpperCase();
        float  lat  = Float.valueOf(trim(parts[1]));
        float  lon  = Float.valueOf(trim(parts[2]));
        locations.put(code, new PVector(lat, lon));
      } catch (Exception e) {
        //println("LocationManager: skipping bad line:", line);
      }
    }
  }

  PVector getCoords(String code)    { return locations.get(code); }
  boolean hasLocation(String code)  { return locations.containsKey(code); }
}

class WorldMap {
  PShape mapShape;

  // SVG viewBox origin and size (from the usa.svg file)
  float svgMinX  =  11.1;
  float svgMinY  =  -2.5;
  float svgWidth = 937.81;
  float svgHeight = 545.0;

  // Geographic bounds of the continental US
  float minLon = -125, maxLon = -66;
  float minLat =   24, maxLat =  50;

  WorldMap(String filename) {
    mapShape = loadShape(filename);
  }

  // Draw the SVG scaled and centred inside the content area
  void display(float x, float y, float w, float h) {
    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;
    shape(mapShape, offsetX, offsetY, svgWidth * scale, svgHeight * scale);
  }

  // Convert geographic (lat, lon) to screen (px, py)
  PVector geoToScreen(float lat, float lon,
                      float x, float y, float w, float h) {
    // Map lon → SVG x, lat → SVG y (note: lat is flipped)
    float px = map(lon, minLon, maxLon, svgMinX, svgMinX + svgWidth);
    float py = map(lat, maxLat, minLat, svgMinY, svgMinY + svgHeight);

    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;

    return new PVector(
      offsetX + (px - svgMinX) * scale,
      offsetY + (py - svgMinY) * scale
    );
  }
}
