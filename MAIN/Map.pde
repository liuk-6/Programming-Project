// written by: Diya Reddy Sama //<>//

// FlightLocation
// Represents a single flight that has been geo-resolved and status-labelled.
// Responsible for drawing itself as a curved arc on the map.
class FlightLocation {
  String origin, destination;      // IATA airport codes
  String originCity, destCity;     // City names
  float  oLat, oLon;               // origin latitude & longitude
  float  dLat, dLon;               // destination latitude & longitude
  String depTime, arrTime;         // Scheduled departure and arrival times (HH:MM)
  float  distance;                 // distance in miles
  String date;                     // Flight date as MM/DD/YYYY
  String status;                   // "ON_TIME", "DELAYED", or "CANCELLED"

  FlightLocation(String o, String d,
    String oc, String dc,
    float olat, float olon,
    float dlat, float dlon,
    String dep, String arr,
    float dist, String date, String status) {
    origin      = o;
    destination = d;
    originCity  = oc;
    destCity    = dc;
    oLat = olat;
    oLon = olon;
    dLat = dlat;
    dLon = dlon;
    depTime  = dep;
    arrTime  = arr;
    distance = dist;
    this.date   = date;
    this.status = status;
  }
  // Draw this flight as a quadratic Bezier arc on the map.
  void display(WorldMap map, boolean isSelected, String selectedAirport) {
    // Convert geographic coordinates to screen pixels
    PVector p1 = map.geoToScreen(oLat, oLon, contentX, contentY, contentW, contentH);
    PVector p2 = map.geoToScreen(dLat, dLon, contentX, contentY, contentW, contentH);

    // Bezier point sits above the midpoint — higher arc for longer flights
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
      if      (status.equals("CANCELLED")) stroke(214, 32, 32, 200);
      else if (status.equals("DELAYED"))   stroke(242, 165, 24, 160);
      else                                 stroke(36, 191, 36, 140);

      // Slightly thicker lines when an airport is selected so the filtered set is easier to see
      strokeWeight(selectedAirport != null ? 3 : 2);
      drawCurve(p1, p2, cx, cy);
    }
  }

  // Shared helper — draws the quadratic bezier arc between p1 and p2 using (cx, cy) as the single control point.
  void drawCurve(PVector p1, PVector p2, float cx, float cy) {
    beginShape();
    vertex(p1.x, p1.y);
    quadraticVertex(cx, cy, p2.x, p2.y);
    endShape();
  }
}                                                                                                     // Diya Reddy Sama - 19/03/2025 - created flightLocation class
// FlightManager
// Loads raw flight rows from a CSV table, resolves coordinates via LocationManager, computes each flight's status, 
// and provides a filtered view of the resulting FlightLocation list.
class FlightManager {
  ArrayList<FlightLocation> allFlights      = new ArrayList<FlightLocation>();
  ArrayList<FlightLocation> filteredFlights = new ArrayList<FlightLocation>();  // active view

  // Only flights involving these airports are shown
  HashSet<String> allowedAirports = new HashSet<String>();

  final int DELAY_THRESHOLD = 30;  //30 minutes counts as delay

  // Parse the CSV table into FlightLocation objects.
  void loadFromTable(Table table, LocationManager loc) {
    allFlights.clear();

    // Top 10 airports without flights from Hawaii and Alaska
    String[] airports = {"LAS", "HOU", "DAL", "BOS", "FLL",
                         "LAX", "PHX", "SEA", "JFK", "MCO" };
    for (String a : airports) allowedAirports.add(a);

    for (int row = 0; row < table.getRowCount(); row++) {
      Flight raw = new Flight(row);

      String originCode = raw.origin.trim().toUpperCase();
      String destCode   = raw.destination.trim().toUpperCase();

       // Read city names and strip any stray quote characters
      String originCity = table.getString(row, "ORIGIN_CITY_NAME").replace("\"", "").trim();
      String destCity   = table.getString(row, "DEST_CITY_NAME").replace("\"", "").trim();

      // Skip rows whose airports have no coordinate entry in airports.csv
      PVector origin = loc.getCoords(originCode);
      PVector dest   = loc.getCoords(destCode);
      if (origin == null || dest == null) continue;

      float oLat = origin.x, oLon = origin.y;
      float dLat = dest.x, dLon = dest.y;
      
      // Restrict to continental US latitude and longitude to only mainland USA
      if (oLat < 24.336 || oLat > 50.668 || dLat < 24.336 || dLat > 50.668) continue;
      if (oLon < -127.553 || oLon > -64.549 || dLon < -127.553 || dLon > -64.549) continue;

      // Derive flight status from cancellation flag and departure delay
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
        originCity, destCity,
        oLat, oLon, dLat, dLon,
        formatTime(raw.scheduledDepartureTime),
        formatTime(raw.scheduledArrivalTime),
        raw.distance, raw.date, status
        ));
    }


    // Default view shows every loaded flight
    filteredFlights = new ArrayList<FlightLocation>(allFlights);
  }
  
  // Format an integer time value (e.g. 1435) as "HH:MM"
  String formatTime(int t) {
    int hours   = (t / 100) % 24;
    int minutes = t % 100;
    return nf(hours, 2) + ":" + nf(minutes, 2);
  }

  /*
  // Optional: filter to a single date
  void filterByDate(String date) {
    filteredFlights.clear();
    for (FlightLocation f : allFlights) {
      if (f.date.equals(date)) filteredFlights.add(f);
    }
  }
  */
  
  // Return whichever subset is currently active (all or date-filtered)
  ArrayList<FlightLocation> getFlights() {
    return filteredFlights;
  }

  // Convert an integer time (HHMM) to total minutes since midnight to help calculate delay
  int timeToMinutes(int t) {
    return (t / 100) * 60 + (t % 100);
  }
}                                                                                                            // Diya Reddy Sama - 19/03/2026 - created FlightManager

// InfoPanel
// Renders a floating card showing details of the currently selected flight.
class InfoPanel {
  // The flight currently shown (null = hidden panel)
  private FlightLocation currentFlight;

  void setFlight(FlightLocation f) {
    currentFlight = f;
  }

  FlightLocation getFlight() {
    return currentFlight;
  }

  // Draw the panel. Returns immediately if nothing is selected.
  void display() {
    if (currentFlight == null) return;

    // Semi-transparent dark background box
    fill(0, 180);
    noStroke();
    rect(20, 65, 260, 220, 10);

    fill(255);
    textSize(13);
    textAlign(LEFT, TOP);
    text("From:      " + currentFlight.origin, 30, 80);
    fill(180);
    textSize(11);
    text("           " + currentFlight.originCity, 30, 96);

    fill(255);
    textSize(13);
    text("To:        " + currentFlight.destination, 30, 114);
    fill(180);
    textSize(11);
    text("           " + currentFlight.destCity, 30, 130);

    fill(255);
    textSize(13);
    text("Date:      " + formatDate(currentFlight.date), 30, 148);
    text("Departure: " + currentFlight.depTime, 30, 166);
    text("Arrival:   " + currentFlight.arrTime, 30, 184);
    text("Distance:  " + currentFlight.distance + " mi", 30, 202);
    text("Status:    " + currentFlight.status, 30, 220);
  }

  // Reformat the CSV date from MM/DD/YYYY to the more readable DD/MM/YYYY
  String formatDate(String raw) {
    String[] parts = raw.split("/");
    if (parts.length != 3) return raw;  // return unchanged if format is unexpected
    return parts[1] + "/" + parts[0] + "/" + parts[2];
  }
}                                                                                          // Diya Reddy Sama - 19/03/2025 - created info panel

// InteractionManager
// Checks if mouse clicks or hovers against the set of visible flight arcs.
class InteractionManager {
  // Returns the flight arc closest to (mx, my), or null if none is close enough
  FlightLocation checkClick(ArrayList<FlightLocation> flights,
                            float mx, float my, WorldMap map) {
    FlightLocation closest     = null;
    float closestDist = 9999;

    for (FlightLocation f : flights) {
      float d = distanceToCurve(f, mx, my, map);
      if (d < 12 && d < closestDist) {
        closestDist = d;
        closest     = f;
      }
    }
    return closest;
  }

  // Same logic as checkClick()
  FlightLocation checkHover(ArrayList<FlightLocation> flights,
    float mx, float my, WorldMap map) {
    return checkClick(flights, mx, my, map);
  }

  // Estimate the minimum distance from point (mx, my) to the Bézier arc
  // of flight f by sampling 50 evenly-spaced points along the curve (t step = 0.02).
  float distanceToCurve(FlightLocation f, float mx, float my, WorldMap map) {
    PVector p1 = map.geoToScreen(f.oLat, f.oLon, contentX, contentY, contentW, contentH);
    PVector p2 = map.geoToScreen(f.dLat, f.dLon, contentX, contentY, contentW, contentH);

    // Reproduce the same control point used in FlightLocation.display()
    float cx = (p1.x + p2.x) / 2;
    float cy = (p1.y + p2.y) / 2 - dist(p1.x, p1.y, p2.x, p2.y) * 0.17;

    float minDist = 9999;

    // Sample 50 points along the curve (t = 0.02 step)
    for (float t = 0; t <= 1; t += 0.02) {
      // Processing's bezierPoint() needs both control points; repeat cx/cy
      // because quadraticVertex() uses a single control point internally
      float x = bezierPoint(p1.x, cx, cx, p2.x, t);
      float y = bezierPoint(p1.y, cy, cy, p2.y, t);
      float d = dist(mx, my, x, y);
      if (d < minDist) minDist = d;
    }
    return minDist;
  }
}                                                                                                  // Diya Reddy Sama - 19/03/2025 - created interaction manager 


// Legend
// Draws the colour-key overlay and handles clicks that toggle the statusFilter variable in the main sketch.
class Legend {
  float legendX, legendY;
  float legendW = 200;
  float legendH = 160;

  void display() {
    legendX = width  - legendW - 20;
    legendY = height - legendH - footerH - 10;

    fill(43, 180);
    noStroke();
    rect(legendX, legendY, legendW, legendH, 10);

    textSize(13);
    fill(255);
    textAlign(LEFT, CENTER);
    text("Flight Status", legendX + 15, legendY + 28);

    // Each entry highlights if it is the active filter
    drawEntry(legendX, legendY + 55, color(0, 200, 0), "On Time", "ON_TIME");
    drawEntry(legendX, legendY + 80, color(255, 165, 0), "Delayed", "DELAYED");
    drawEntry(legendX, legendY + 105, color(255, 0, 0), "Cancelled", "CANCELLED");
    drawEntry(legendX, legendY + 130, color(200, 200, 200), "All", "ALL");
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

    if (over(mx, my, legendX, legendY + 43, legendW, 24)) return "ON_TIME";
    if (over(mx, my, legendX, legendY + 68, legendW, 24)) return "DELAYED";
    if (over(mx, my, legendX, legendY + 93, legendW, 24)) return "CANCELLED";
    if (over(mx, my, legendX, legendY + 118, legendW, 24)) return "ALL";
    return null;
  }

  // Axis-aligned bounding-box click test
  boolean over(float mx, float my, float x, float y, float w, float h) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}                                                                                                // Diya Reddy Sama - 25/03/2026 - created legend and filtering by status 

// LocationManager
// Loads and stores a mapping from IATA airport code → (lat, lon).
// Used for geographic coordinates throughout the sketch.
class LocationManager {
  // Maps airport code → PVector(lat, lon)
  HashMap<String, PVector> locations = new HashMap<String, PVector>();

  // Load coordinates from a CSV file and skips any missing/malformed values
  void loadLocations(String filename) {
    String[] lines = loadStrings(filename);
    if (lines == null) return;
    
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
      }
      catch (Exception e) {
        // Skip unparseable lines without crashing
      }
    }
  }
  // Return the PVector(lat, lon) for a code, or null if unknown
  PVector getCoords(String code) {
    return locations.get(code);
  }
  // Convenience check — used by AirportSearch to filter the dropdown
  // to only airports that actually have coordinates
  boolean hasLocation(String code) {
    return locations.containsKey(code);
  }
}                                                                                                  // Diya Reddy Sama - 24/03/2025 - filter by airports

// WorldMap
// Wraps a USA SVG file and provides two services:
//   1. display() — scales and centres the SVG inside a content rectangle
//   2. geoToScreen() — converts (lat, lon) to screen pixels using the same
//      Mercator projection that MapSVG used when it generated the SVG
class WorldMap {
  PShape mapShape;

  // SVG viewBox origin and size (from the usa.svg file)
  float svgMinX   = 477.0;
  float svgMinY   = 421.0;
  float svgWidth  = 593.378;
  float svgHeight = 318.287;

  // Geographic bounds — taken directly from mapsvg:geoViewBox
  // Format: left, top, right, bottom
  float minLon = -127.55273;
  float maxLon =  -64.54921;
  float maxLat =   50.66829;   // top
  float minLat =   24.33587;   // bottom

  WorldMap(String filename) {
    mapShape = loadShape(filename);
  }

  // Render the SVG scaled uniformly (preserving aspect ratio) and centred within the rectangle defined by (x, y, w, h)  
  void display(float x, float y, float w, float h) {
    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;
    shape(mapShape, offsetX, offsetY, svgWidth * scale, svgHeight * scale);
  }
                                                                                          // Diya Reddy Sama - 3/04/2025 - made map more accurate
  // Convert geographic coordinates to screen pixels.
  // Uses a Web Mercator projection to match how MapSVG placed the paths, then maps from SVG space into the on-screen content rectangle.  
  PVector geoToScreen(float lat, float lon,
                      float x, float y, float w, float h) {
    float toRad    = PI / 180.0;
    // Project latitudes onto the Mercator y-axis (log-tan formula)
    float mercLat  = log(tan(PI / 4 + lat    * toRad / 2));
    float mercMin  = log(tan(PI / 4 + minLat * toRad / 2));
    float mercMax  = log(tan(PI / 4 + maxLat * toRad / 2));

    // Linear interpolation of lon and projected lat into SVG coordinate space
    float px = map(lon, minLon, maxLon, svgMinX, svgMinX + svgWidth);
    float py = map(mercLat, mercMax, mercMin, svgMinY, svgMinY + svgHeight);
    // Note: mercMax maps to svgMinY (top) and mercMin to the bottom — y-axis is flipped

    // Apply the same scale + offset used in display() to land on screen pixels
    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;

    return new PVector(
      offsetX + (px - svgMinX) * scale,
      offsetY + (py - svgMinY) * scale
      );
  }
}                                                                                               // Diya Reddy SAma - 18/03/2025 - created map display 

// AirportSearch
// A self-contained search widget: text field + Search button + scrollable dropdown.  
// Populates itself from the flight table and LocationManager, then returns the selected airport code to the main sketch via handleKey() and handleClick().
class AirportSearch {

  // Layout
  float fieldX, fieldY,        // computed each frame in display()
  fieldW = 220, fieldH = 30;
  float btnW = 70, btnH = 30;
  float dropMaxH = 180;        // max height of the dropdown list
  int scrollOffset = 0;        // first visible row index
  int visibleRows  = 6;        // number of rows visable at a time
  float rowH       = 28;       // pixel height of each dropdown row

  // State
  String query        = "";          // text entered
  boolean focused     = false;       // whether the text field has keyboard focus
  boolean dropOpen    = false;       // if dropdown is visible
  int     hoverIndex  = -1;          // which dropdown row the mouse is over

  ArrayList<String> allCodes     = new ArrayList<String>();  // every code from CSV
  ArrayList<String> filtered     = new ArrayList<String>();  // codes matching current query

  // Initialise from LocationManager 
  void load(Table table, LocationManager loc) {
    allCodes.clear();
    HashSet<String> seen = new HashSet<String>();

    for (int i = 0; i < table.getRowCount(); i++) {
      // Use the same column names your Flight class reads from
      String origin = table.getString(i, "ORIGIN").trim().toUpperCase();
      String dest   = table.getString(i, "DEST").trim().toUpperCase();

      // Only add codes that actually have coordinates in airports.csv
      // so searching them does something useful on the map
      if (origin.length() >= 2 && !seen.contains(origin) && loc.hasLocation(origin)) {
        seen.add(origin);
        allCodes.add(origin);
      }
      if (dest.length() >= 2 && !seen.contains(dest) && loc.hasLocation(dest)) {
        seen.add(dest);
        allCodes.add(dest);
      }
    }

    java.util.Collections.sort(allCodes);
    filtered = new ArrayList<String>(allCodes);
  }

  // Render search bar 
  void display(float headerH) {
    fieldX = width - fieldW - btnW - 30;
    fieldY = headerH + 8;

    // Text field
    // Background
    fill(focused ? color(255) : color(230));
    stroke(focused ? color(0, 120, 255) : color(180));
    strokeWeight(focused ? 2 : 1);
    rect(fieldX, fieldY, fieldW, fieldH, 5);

    // Show placeholder text when empty and unfocused; typed query otherwise
    fill(query.length() == 0 && !focused ? color(160) : color(30));
    noStroke();
    textSize(13);
    textAlign(LEFT, CENTER);
    String display = query.length() == 0 && !focused ? "Search airport code…" : query;
    text(display, fieldX + 8, fieldY + fieldH / 2);

    // Blinking cursor (toggles every 30 frames)
    if (focused && (frameCount / 30) % 2 == 0) {
      float cursorX = fieldX + 8 + textWidth(query);
      stroke(30);
      strokeWeight(1.5);
      line(cursorX, fieldY + 6, cursorX, fieldY + fieldH - 6);
    }

    // Search button
    float btnX = fieldX + fieldW + 5;
    boolean overBtn = mouseX > btnX && mouseX < btnX + btnW &&
      mouseY > fieldY && mouseY < fieldY + fieldH;
    fill(overBtn ? color(45, 89, 135) : color(26, 58, 92));
    noStroke();
    rect(btnX, fieldY, btnW, btnH, 5);
    fill(255);
    textSize(13);
    textAlign(CENTER, CENTER);
    text("Search", btnX + btnW / 2, fieldY + fieldH / 2);

    // Dropdown (only when there are matching results)
    if (dropOpen && filtered.size() > 0) {
      drawDropdown();
    }
  }

  // Render the scrollable dropdown list below the text field.
  void drawDropdown() {
    float dropH = visibleRows * rowH;
    float dropX = fieldX;
    float dropY = fieldY + fieldH + 3;
    float scrollBarW = 8;

    // Keep scroll position valid as the filtered list size changes
    int maxScroll = max(0, filtered.size() - visibleRows);
    scrollOffset  = constrain(scrollOffset, 0, maxScroll);

    // Drop Shadow
    fill(0, 40);
    noStroke();
    rect(dropX + 3, dropY + 3, fieldW, dropH, 5);

    // Background
    fill(255);
    stroke(180);
    strokeWeight(1);
    rect(dropX, dropY, fieldW, dropH, 5);

    hoverIndex = -1;   
    noStroke();
    textAlign(LEFT, CENTER);
    textSize(13);

    // Draw visible rows (zebra-striped, highlighted on hover)
    for (int i = 0; i < visibleRows; i++) {
      int dataIndex = i + scrollOffset;
      if (dataIndex >= filtered.size()) break;

      float rowY = dropY + i * rowH;
      boolean over = mouseX > dropX && mouseX < dropX + fieldW - scrollBarW &&
        mouseY > rowY  && mouseY < rowY + rowH;
      if (over) hoverIndex = dataIndex;   // hoverIndex is now absolute, not relative

      fill(over ? color(0, 120, 255) : (i % 2 == 0 ? color(248) : color(255)));
      rect(dropX, rowY, fieldW - scrollBarW, rowH);

      fill(over ? color(255) : color(30));
      text(filtered.get(dataIndex), dropX + 10, rowY + rowH / 2);
    }

    // Scrollbar
    if (filtered.size() > visibleRows) {
      float trackX = dropX + fieldW - scrollBarW;
      float trackH = dropH;

      // Track
      fill(220);
      noStroke();
      rect(trackX, dropY, scrollBarW, trackH, 3);

      // Thumb
      float thumbH    = max(20, trackH * (visibleRows / (float) filtered.size()));
      float thumbY    = dropY + (trackH - thumbH) * (scrollOffset / (float) max(1, maxScroll));
      fill(160);
      rect(trackX + 1, thumbY, scrollBarW - 2, thumbH, 3);
    }

    // Border on top of rows
    noFill();
    stroke(180);
    strokeWeight(1);
    rect(dropX, dropY, fieldW, dropH, 5);
  }

  // Scroll the dropdown when the mouse wheel moves over it.
  // delta should be +1 (scroll down) or -1 (scroll up).
  void handleScroll(float mx, float my, int delta) {
    if (!dropOpen) return;

    float dropX = fieldX;
    float dropY = fieldY + fieldH + 3;
    float dropH = visibleRows * rowH;

    // Only scroll if mouse is over the dropdown
    if (mx > dropX && mx < dropX + fieldW &&
      my > dropY && my < dropY + dropH) {
      scrollOffset = constrain(scrollOffset + delta, 0,
        max(0, filtered.size() - visibleRows));
    }
  }
  // Key input — call from keyPressed()
  // Returns the selected airport code if Enter was pressed, else null
  String handleKey(char k, int keyCode) {
    if (!focused) return null;

    if (keyCode == BACKSPACE) {
      if (query.length() > 0) {
        query = query.substring(0, query.length() - 1);
        updateFilter();
        dropOpen = focused && filtered.size() > 0;
      }
    } else if (keyCode == ENTER || keyCode == RETURN) {
      return confirmSelection();
    } else if (k != CODED && isPrintable(k)) {
      query += Character.toUpperCase(k);
      updateFilter();
      dropOpen = filtered.size() > 0;
    }
    return null;
  }

  // Mouse press — call from mousePressed()
  // Returns selected airport code if a result was clicked or Search pressed, else null
  String handleClick(float mx, float my) {
    float btnX = fieldX + fieldW + 5;
    float btnY = fieldY;

    // Click on the Search button
    if (mx > btnX && mx < btnX + btnW &&
      my > btnY && my < btnY + btnH) {
      focused  = true;
      dropOpen = filtered.size() > 0;
      return confirmSelection();
    }

    // Click inside the text field
    if (mx > fieldX && mx < fieldX + fieldW &&
      my > fieldY && my < fieldY + fieldH) {
      focused  = true;
      dropOpen = filtered.size() > 0;
      return null;
    }

    // Click on a dropdown row
    if (dropOpen && filtered.size() > 0 && hoverIndex >= 0) {
      String chosen = filtered.get(hoverIndex);
      selectCode(chosen);
      return chosen;
    }

    // Click anywhere else — close everything
    focused  = false;
    dropOpen = false;
    return null;
  }                                                                                        // Diya Reddy Sama - 4/04/2025 - added search feature 

  // Helpers for search 

  // Rebuild `filtered` from `allCodes` based on the current query.
  void updateFilter() {
    filtered.clear();
    scrollOffset = 0;
    String q = query.toUpperCase().trim();
    if (q.length() == 0) {
      filtered = new ArrayList<String>(allCodes);  // empty query → show all
    } else {
      for (String c : allCodes) {
        if (c.startsWith(q)) filtered.add(c);      // prefix matches first
      }
      // Then add contains-matches that aren't already in
      for (String c : allCodes) {
        if (c.contains(q) && !filtered.contains(c)) filtered.add(c);
      }
    }
    dropOpen = filtered.size() > 0 && focused;
  }

  // Pick the best match and return it:
  String confirmSelection() {
    // Exactly one result -> return it
    if (filtered.size() == 1) {
      selectCode(filtered.get(0));
      return filtered.get(0);
    }
    // Query matches a code exactly -> return that code
    for (String c : filtered) {
      if (c.equals(query.toUpperCase().trim())) {
        selectCode(c);
        return c;
      }
    }
    // Multiple results -> return the top (first) result
    if (filtered.size() > 0) {
      String top = filtered.get(0);
      selectCode(top);
      return top;
    }
    // No results -> return null
    return null;
  }

  // Lock in a chosen code (fill the field and close the dropdown)
  void selectCode(String code) {
    query    = code;
    focused  = false;
    dropOpen = false;
    filtered.clear();
    filtered.add(code);
  }
  // Reset the widget to its initial empty state
  void clear() {
    query    = "";
    focused  = false;
    dropOpen = false;
    updateFilter();
  }

  // True for standard printable ASCII (space through ~)
  boolean isPrintable(char c) {
    return c >= 32 && c < 127;
  }

  char toUpperCase(char c) {
    return Character.toUpperCase(c);
  }
}
