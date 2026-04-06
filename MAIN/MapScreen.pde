class MapScreen extends Screen {

  // Core objects
  WorldMap         world;
  FlightManager    manager;
  InteractionManager interaction;
  InfoPanel        panel;
  LocationManager  locationManager;
  Legend           legend;
  AirportSearch airportSearch;


  FlightLocation hoveredFlight = null;

  // ── Setup ─────────────────────────────────────────────────────
  MapScreen() {

    // Layout measurements
    headerH  = 60;
    footerH  = 40;
    contentX = 0;
    contentY = headerH;
    contentW = width;
    contentH = height - headerH - footerH;

    // Load map and data
    world         = new WorldMap("usa.svg");
    locationManager = new LocationManager();
    locationManager.loadLocations("airports.csv");

    manager = new FlightManager();
    manager.loadFromTable(table, locationManager);

    // UI components
    interaction = new InteractionManager();
    panel       = new InfoPanel();
    legend      = new Legend();

    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));

    airportSearch = new AirportSearch();
    airportSearch.load(table, locationManager);
  }

  void reset()  {
    selectedAirport = null;
    statusFilter = "ALL";
    panel.setFlight(null);
    airportSearch.clear();
  }
  // ── Draw loop ─────────────────────────────────────────────────
  void draw() {
    background(14, 42, 71);

    drawLayout();

    // Draw the SVG map
    world.display(contentX, contentY, contentW, contentH);

    // Get the flights that pass the current filters
    ArrayList<FlightLocation> flights = getVisibleFlights();

    // Update hovered flight based on mouse position
    // mouseY - headerH converts screen coords to content coords
    hoveredFlight = interaction.checkHover(flights, mouseX, mouseY, world);

    // Draw each flight arc
    for (FlightLocation f : flights) {
      boolean isSelected = (panel.getFlight() == f);
      boolean isHovered  = (hoveredFlight == f);
      f.display(world, isSelected || isHovered, selectedAirport);
    }

    // Draw airport dots on top of arcs
    drawAirports();

    // Draw UI panels on top of everything
    legend.display();
    panel.display();
    drawSelectedAirportBox();

    airportSearch.display(headerH);

    for  (Button b : buttons) b.display();
  }

  // ── Draw airport dots and hover tooltips ──────────────────────
  void drawAirports() {
    for (String code : locationManager.locations.keySet()) {
      PVector geo    = locationManager.getCoords(code);
      PVector screen = world.geoToScreen(geo.x, geo.y,
        contentX, contentY, contentW, contentH);

      boolean isAllowed   = manager.allowedAirports.contains(code);
      boolean isSelected  = code.equals(selectedAirport);
      boolean isSearched  = code.equals(airportSearch.query.toUpperCase().trim())
        && airportSearch.query.length() > 0;

      if (isAllowed || isSearched || isSelected) {
        // Highlight ring for the searched airport
        if (isSearched || isSelected) {
          noFill();
          stroke(255);
          strokeWeight(2.5);
          ellipse(screen.x, screen.y, 20, 20);  // outer glow ring
          stroke(143, 242, 255, 120);
          strokeWeight(6);
          ellipse(screen.x, screen.y, 26, 26);  // soft outer ring
        }

        // The dot itself
        fill(color(26, 58, 92));
        noStroke();
        ellipse(screen.x, screen.y, isSearched ? 10 : 8, isSearched ? 10 : 8);

        // Tooltip on hover
        if (dist(mouseX, mouseY, screen.x, screen.y) < 10) {
          fill(0);
          rect(mouseX + 10, mouseY - 20, 60, 20, 5);
          fill(255);
          textSize(12);
          text(code, mouseX + 40, mouseY - 10);
        }
      }
    }
  }

  void keyPressed(char k) {
    String result = airportSearch.handleKey(k, keyCode);
    if (result != null) {
      if (result.equals(selectedAirport)) {
        selectedAirport = null;
        airportSearch.clear();
      } else {
        selectedAirport = result;
      }
      panel.setFlight(null);
    }
  }

  // ── Header / footer / content background ─────────────────────
  void drawLayout() {
    noStroke();

    // Header bar
    fill(14, 42, 71);
    rect(0, 0, width, headerH);

    // Footer bar
    fill(14, 42, 71);
    rect(0, height - footerH, width, footerH);

    // Content area background
    fill(218, 224, 242);
    rect(0, headerH, width, height - headerH - footerH, 25);

    fill(150);
    textAlign(RIGHT, CENTER);
    textSize(26);
    text("Flight Map", width-85, headerH-30);
  }

  // ── Small box showing the currently selected airport ─────────
  void drawSelectedAirportBox() {
    if (selectedAirport == null) return;

    float x = 20;
    float y = height - footerH - 80;

    String cityName = getCityName(selectedAirport);

    fill(0, 180);
    noStroke();
    rect(x, y, 220, 62, 10);

    fill(255);
    textSize(14);
    textAlign(LEFT, CENTER);
    text("Selected Airport:", x + 10, y + 14);
    textSize(18);
    text(selectedAirport, x + 10, y + 34);

    fill(180);
    textSize(11);
    text(cityName, x + 10, y + 52);

    // ── Clear button ─────────────────────────────────────────────
    float btnX = x + 175;
    float btnY = y + 8;
    float btnW = 35;
    float btnH = 35;

    boolean overClear = mouseX > btnX && mouseX < btnX + btnW &&
      mouseY > btnY && mouseY < btnY + btnH;
    fill(overClear ? color(200, 50, 50) : color(160, 40, 40));
    noStroke();
    rect(btnX, btnY, btnW, btnH, 6);

    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text("X", btnX + btnW / 2, btnY + btnH / 2);
  }

  String getCityName(String code) {
    for (FlightLocation f : manager.allFlights) {
      if (f.origin.equals(code))      return f.originCity;
      if (f.destination.equals(code)) return f.destCity;
    }
    return "";
  }

  // Add this helper method to MapScreen:
  boolean checkClearButtonClick(float mx, float my) {
    if (selectedAirport == null) return false;
    float x    = 20;
    float y    = height - footerH - 80;
    float btnX = x + 175;
    float btnY = y + 8;
    float btnW = 35;
    float btnH = 35;
    return mx > btnX && mx < btnX + btnW && my > btnY && my < btnY + btnH;
  }
  // ── Returns flights that match the active airport + status filters ──
  ArrayList<FlightLocation> getVisibleFlights() {
    ArrayList<FlightLocation> visible = new ArrayList<FlightLocation>();

    for (FlightLocation f : manager.getFlights()) {

      // Airport filter: only show flights connected to selected airport
      if (selectedAirport != null) {
        if (!f.origin.equals(selectedAirport) &&
          !f.destination.equals(selectedAirport)) continue;
      }

      // Status filter: skip flights that don't match legend selection
      if (!statusFilter.equals("ALL") && !f.status.equals(statusFilter)) continue;

      visible.add(f);
    }
    return visible;
  }

  // ── Check if user clicked on an airport dot ──────────────────
  String checkAirportClick(float mx, float my) {
    for (String code : locationManager.locations.keySet()) {
      if (!manager.allowedAirports.contains(code)) continue;

      PVector geo    = locationManager.getCoords(code);
      PVector screen = world.geoToScreen(geo.x, geo.y,
        contentX, contentY, contentW, contentH);

      if (dist(mx, my, screen.x, screen.y) < 10) return code;
    }
    return null;
  }

  void mouseWheel(MouseEvent event) {
    airportSearch.handleScroll(mouseX, mouseY, event.getCount());
  }

  // ── Mouse click handler ───────────────────────────────────────
  void mousePressed() {

    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) {
        goBack();
        return;
      }
    }
    if (checkClearButtonClick(mouseX, mouseY)) {
      selectedAirport = null;
      airportSearch.clear();
      panel.setFlight(null);
      return;
    }
    String searchResult = airportSearch.handleClick(mouseX, mouseY);
    if (searchResult != null) {
      // Toggle: clicking Search on the already-selected airport clears it
      if (searchResult.equals(selectedAirport)) {
        selectedAirport = null;
        airportSearch.clear();
      } else {
        selectedAirport = searchResult;
      }
      panel.setFlight(null);
      return;
    }

    if (airportSearch.focused || airportSearch.dropOpen) return;


    // 1. Check legend buttons first
    String legendClick = legend.checkClick(mouseX, mouseY);
    if (legendClick != null) {
      statusFilter = legendClick;
      panel.setFlight(null);
      return;
    }

    // 2. Check airport dots
    String airport = checkAirportClick(mouseX, mouseY);
    if (airport != null) {
      // Toggle: clicking the same airport deselects it
      selectedAirport = airport.equals(selectedAirport) ? null : airport;
      airportSearch.clear();
      panel.setFlight(null);
      return;
    }

    // 3. Check flight arcs
    FlightLocation clicked = interaction.checkClick(
      getVisibleFlights(), mouseX, mouseY, world);
    panel.setFlight(clicked);
  }
}
