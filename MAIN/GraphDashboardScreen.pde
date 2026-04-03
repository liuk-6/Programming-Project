class GraphDashboardScreen extends Screen {
  BarChart destChart;
  OriginBarChart originChart;
  PieChart pieChart;
  graphScreen screen1, screen2;
  graphScreen currentScreen;
  TopAirlinesPie airlinePie;
  
  String activeFact = "";
  String activeBarView = "Destination";
  AirlineRateChart cancelRateChart;
  AirlineRateChart delayRateChart;
  HashMap<String, AirlineStats> airlineStats;
  
  String activePieView = "Overall Flights";
    // --- NEW: Airport search pie chart fields ---
  String airportSearchInput = "";        // what the user has typed
  boolean airportInputActive = false;    // is the text box focused?
  String airportSearchCode = "";         // last successfully searched code
  String airportSearchError = "";        // error message if not found
  boolean airportSearchHasResult = false;
  ArrayList<String> airportSuggestions = new ArrayList<String>();
  
  // Results from airport search
  int airportOnTime = 0;
  int airportDelayed = 0;
  int airportCancelled = 0;
  int airportTotal = 0;
  
  // Text input box bounds (screen coords, set once)
  float searchBoxX, searchBoxY, searchBoxW = 200, searchBoxH = 38;
  // Search button bounds
  float searchBtnX, searchBtnY, searchBtnW = 100, searchBtnH = 38;
  
  // Pie chart PGraphics for airport result
  PGraphics airportPg;
  color[] airportColours = {
     color(#4F772D),
      color(#FCBF49),
      color(#D62828)
  }; 
  
  boolean showDestinationChart = true; // default view
  PImage currentAirportImg;
  float ImgX;
  float ImgY;
  float w;
  float h;

  Dropdown barDropdown;
  Dropdown pieDropdown;
  
  GraphDashboardScreen() {
    // for top airlines
    loadAirlineNames();
    HashMap<String, Integer> counts = countAirlineTraffic();
    airlinePie = new TopAirlinesPie(counts);

    // --- Create chart objects ---
    destChart = new BarChart();
    originChart = new OriginBarChart();
    pieChart = new PieChart();
  
    // --- Run their setup() methods ---
    destChart.setup();
    originChart.setup();
    pieChart.setup();
  
    screen1 = new graphScreen(color(150, 200, 255));
    screen2 = new graphScreen(color(255, 200, 150));
  
        // --- Rate charts (setup) ---
    airlineStats = computeAirlineStats();
    cancelRateChart = new AirlineRateChart();
    cancelRateChart.mode = "cancel";
    cancelRateChart.compute(airlineStats);
    delayRateChart = new AirlineRateChart();
    delayRateChart.mode = "delay";
    delayRateChart.compute(airlineStats);
 
    // Screen 1: bar chart dropdown + Pie Charts widget (kept)
    String[] barOptions = {"Destination", "Origin", "% Cancelled", "% Delayed"};
    barDropdown = new Dropdown(30, 75, 280, 40, barOptions);
    
    String[] pieOptions = {"Overall Flights", "By Airline", "Search Airport"};
    pieDropdown = new Dropdown(30, 75, 220, 38, pieOptions);
    airportPg = createGraphics(400, 300);
 
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
    
    searchBoxX = width/2 - 160;
    searchBoxY = 160;
    searchBtnX = searchBoxX + searchBoxW + 15;
    searchBtnY = searchBoxY;
  
    currentScreen = screen1;
    
  }
  
  void draw() {
    layout.beginPage(title);
    drawContent();
    drawImages();
  }
  void drawContent() {
    
     for (Button b: buttons) b.display();
    
    float panelW = width - 50;
    float panelH = 560;
    float panelX = width/2;
    float panelY = 120;
    fill(RY_BG);
    rectMode(CENTER);
    rect(panelX, panelY + panelH/2, panelW, panelH, 20);
    rectMode(CORNER);
    
    if (currentScreen == screen1) {
      barDropdown.draw();
    } else if (currentScreen == screen2) {
      pieDropdown.draw();
    }
  
    // Draw charts
    if (currentScreen == screen1) {
      
      float chartX = (width - 530)/2;
      float chartY = (height - 250) /2;
      pushMatrix();
      translate(chartX, chartY);
      
       if (activeBarView.equals("Destination")) {
        destChart.draw();
      } else if (activeBarView.equals("Origin")) {
        originChart.draw();
      } else if (activeBarView.equals("% Cancelled")) {
        cancelRateChart.drawnAtX = chartX;  // ADD: save position for click detection
        cancelRateChart.drawnAtY = chartY;
        cancelRateChart.draw(0, 0);
      } else if (activeBarView.equals("% Delayed")) {
         delayRateChart.drawnAtX = chartX;   // ADD: save position for click detection
        delayRateChart.drawnAtY = chartY;
        delayRateChart.draw(0, 0);
      }
    
      popMatrix();
      
        if (activeBarView.equals("% Cancelled") || activeBarView.equals("% Delayed")) {
        AirlineRateChart chart = activeBarView.equals("% Cancelled") ? cancelRateChart : delayRateChart;
        
        // Y-axis label (rotated) — now in screen coords
        pushMatrix();
        translate(chartX - 15, chartY + chart.pg.height/2);
        rotate(-HALF_PI);
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(13);
        text("Rate (%)", 0, 0);
        popMatrix();
        
        // Chart title
        fill(0);
        textAlign(CENTER, TOP);
        textSize(20);
        text((chart.mode.equals("cancel") ? "Cancellation" : "Delay") + " Rate by Airline",
             chartX + chart.pg.width/2, chartY - 50);
        
        // X-axis label
        textSize(14);
        textAlign(CENTER, BOTTOM);
        text("Airlines", chartX + chart.pg.width/2, chartY + chart.pg.height + 25);
        
        // Legend panel — now in screen coords, no translate active
        if (chart.showLegend && chart.airlines != null) {
          chart.drawLegendPanel();
        }
      }
    }
    if (currentScreen == screen2) {
     if (activePieView.equals("Overall Flights")) {
        // Original pie chart — unchanged
        float pieX = width/2 - 400/2;
        float pieY = height/2 - 300/2 + 20;  // slight downward offset for the dropdown
        pushMatrix();
        translate(pieX, pieY);
        pieChart.draw();
        popMatrix();
        
      } else if (activePieView.equals("By Airline")) {
        // Original airline pie — unchanged
         airlinePie.draw(width/2 - 450/2, height/2 - 350/2 + 20);
        
      } else if (activePieView.equals("Search Airport")) {
        // NEW: draw the airport search UI
        drawAirportSearchView();
      }
    }
        if (airportInputActive && airportSuggestions.size() > 0) {
      float sugH = 30;
      for (int i = 0; i < airportSuggestions.size(); i++) {
        float sy = searchBoxY + searchBoxH + i * sugH;
        boolean sugHov = (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
                          mouseY > sy && mouseY < sy + sugH);

        // Background row — highlight on hover
        noStroke();
        fill(sugHov ? color(220, 230, 255) : 255);
        rect(searchBoxX, sy, searchBoxW, sugH);

        // Border between rows
        stroke(200);
        strokeWeight(1);
        line(searchBoxX, sy + sugH, searchBoxX + searchBoxW, sy + sugH);

        // Text
        fill(RY_BLUE);
        textAlign(LEFT, CENTER);
        textSize(13);
        noStroke();
        text(airportSuggestions.get(i), searchBoxX + 8, sy + sugH/2);
      }
      // Draw an outer border around the whole list
      stroke(RY_BLUE);
      strokeWeight(1);
      noFill();
      rect(searchBoxX, searchBoxY + searchBoxH,
           searchBoxW, airportSuggestions.size() * sugH, 0, 0, 4, 4);
      noStroke();
        }
  
    // Draw airport fact box
    if (activeFact != "" && currentScreen == screen1) {
      drawInfoBox(activeFact);
    }
  
    // ⭐ DRAW THE TOP-AIRPORT BOX LAST ⭐
    if (currentScreen == screen2 && pieChart.isShowingTop()) {
      drawTopAirportBox();
    }
    for(Button b : buttons) b.display();
    
     // Draw dropdown on top of everything else
    if (currentScreen == screen1) {
      barDropdown.draw();
    }
  }
  
    void highlightButton(Button b)  {
      fill(255,215,0);
      rect(b.x - 5, b.y - 5, b.w + 10, b.h + 10, 8);
      b.display();
    
     // Draw dropdown on top of everything else
    if (currentScreen == screen1) {
      barDropdown.draw();
    }
  }
  void mousePressed() {
    for (Button b : buttons) {
      if(b.over(mouseX, mouseY)) {
        if(b.type.equals("back")) {
          goBack();
          return;
        }
      }
    }
    
    if (currentScreen == screen1) {
    
      String chosen = barDropdown.mousePressed(mouseX, mouseY);
      if(chosen != null)  {
        activeBarView = chosen;
        activeFact = "";
        return;
      }
      
      // Destination chart buttons
      if(activeBarView.equals("Destination"))  {
      String airport = destChart.checkClick(mouseX, mouseY);
      if (airport != null) {
        showAirportFacts(airport);
        return;
      }
    
      // Origin chart buttons
     }else if (activeBarView.equals("Origin"))  {
      String airport = originChart.checkClick(mouseX, mouseY);
        if (airport != null) {
          showAirportFacts(airport);
          return;
        }
      }
      if (activeBarView.equals("% Cancelled")) {
        cancelRateChart.mousePressed();
      }
      if (activeBarView.equals("% Delayed")) {
        delayRateChart.mousePressed();
      }
    }
    if (currentScreen == screen2) {
      String chosen = pieDropdown.mousePressed(mouseX, mouseY);
      if (chosen != null) {
        if (chosen.equals("Bar Charts")) {
          currentScreen = screen1;
          activeFact = "";
        } else {
          // NEW: update which pie view is showing
          activePieView = chosen;
          // Reset search state when switching away from Search Airport
          if (!chosen.equals("Search Airport")) {
            airportInputActive = false;
          }
        }
        return;
      }
    }
        if (currentScreen == screen2) {
      if (activePieView.equals("Overall Flights")) {
        pieChart.mousePressed();
      } else if (activePieView.equals("Search Airport")) {
        // NEW: handle clicks on the text box and search button
        // Text box click — activate it
                if (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
            mouseY > searchBoxY && mouseY < searchBoxY + searchBoxH) {
          airportInputActive = true;
          if (airportSearchInput.equals("e.g. ATL")) airportSearchInput = "";

        // Check if a suggestion was clicked
        } else if (airportSuggestions.size() > 0 && airportInputActive) {
          float sugH = 30;
          boolean clickedSuggestion = false;
          for (int i = 0; i < airportSuggestions.size(); i++) {
            float sy = searchBoxY + searchBoxH + i * sugH;
            if (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
                mouseY > sy && mouseY < sy + sugH) {
              // Extract just the IATA code (the part before " - ")
              String picked = airportSuggestions.get(i).split(" - ")[0].trim();
              airportSearchInput = picked;
              airportSuggestions.clear();
              airportInputActive = false;
              runAirportSearch();  // auto-search when suggestion selected
              clickedSuggestion = true;
              break;
            }
          }
          if (!clickedSuggestion) {
            airportInputActive = false;
            airportSuggestions.clear();
          }
        } else {
          airportInputActive = false;
          airportSuggestions.clear();
        }
        // Search button click
        if (mouseX > searchBtnX && mouseX < searchBtnX + searchBtnW &&
            mouseY > searchBtnY && mouseY < searchBtnY + searchBtnH) {
          runAirportSearch();
        }
      }
    }
  
    Widget w = currentScreen.getEvent(mouseX, mouseY);
  
    if (w == null) return;
  
    if (w.label.equals("Pie Charts")) {
      currentScreen = screen2;
      activeFact = "";
      currentAirportImg = null;
    }
    else if (w.label.equals("Bar Chart")) {
      currentScreen = screen1;
      activeFact = "";
      currentAirportImg = null;
    }
  }
  
  void mouseMoved() {
    currentScreen.updateHover(mouseX, mouseY);
  }
  void keyPressed(char k) {
    // NEW: route keyboard input to airport search box when it's active
    if (currentScreen == screen2 && activePieView.equals("Search Airport") && airportInputActive) {
      if (k == BACKSPACE) {
        if (airportSearchInput.length() > 0) {
          airportSearchInput = airportSearchInput.substring(0, airportSearchInput.length() - 1);
          updateAirportSuggestions(airportSearchInput); 
        }
      } else if (k == ENTER || k == RETURN) {
        runAirportSearch();
      }  else if (k != CODED && k != TAB && airportSearchInput.length() < 4) {
        airportSearchInput += Character.toUpperCase(k);
        updateAirportSuggestions(airportSearchInput);  // rebuild suggestions after each keystroke
      }
    }
  }
  
  void showAirportFacts(String code) {
    if (code.equals("LAX")) {
      activeFact = "LAX — \nLos Angeles International Airport. \n \n The eighth-busiest airport in the world serving over 75 million guests in 2023 \n \n It has an official song.";
      currentAirportImg = loadImage("LAX.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 45;
      
    } else if (code.equals("JFK")) {
      activeFact = "JFK — \n John F Kennedy International Airport \n \n There is a pet-only terminal.";
      currentAirportImg = loadImage("JFK.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
      
    } else if (code.equals("SEA")) {
      activeFact = "SEA — \n Seattle-Tacoma International Airport.  \n SEA Airports parking garage is the second largest parking lot (under one roof) in the world.";
      currentAirportImg = loadImage("SEA.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 40;
      
    } else if (code.equals("HON")) {
      activeFact = "HON — \n Honolulu International Airport. \n \n The largest airport in Hawaii.";
      currentAirportImg = loadImage("HON.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
  
    } else if (code.equals("LGA")) {
      activeFact = "LGA — \n LaGuardia Airport. \n \n The airport lies partly on reclaimed land, created using landfill .";
      currentAirportImg = loadImage("LGA.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 40;
    
    } else if (code.equals("PHX")) {
      activeFact = "PHX — \n Phoenix Sky Harbor International Airport. \n \n It is Arizona's largest and busiest airport. .";
      currentAirportImg = loadImage("PHX.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    }else if (code.equals("MCO")) {
      activeFact = "MCO — \n Orlando International Airport. \n \n Has over $41 billion in economic impact.";
      currentAirportImg = loadImage("MCO.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 80;
      h = 60;
    
    } else if (code.equals("ATL")) {
      activeFact = "ATL —  Hartsfield-Jackson Atlanta International Airport. \n \n Since 1998, Hartsfield-Jackson has been the busiest airport in the world for 23 out of 24 years.";
      currentAirportImg = loadImage("ATL.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    }else if (code.equals("DFW")) {
      activeFact = "DFW — \n Dallas/Fort Worth International Airport. \n \n it serves 269 destinations (196 domestic and 73 international).";
      currentAirportImg = loadImage("Dallas.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 60;
    
    }else if (code.equals("CLT")) {
      activeFact = "CLT — \n Charlotte Douglas International Airport. \n \n Contributes about 5% of North Carolinas GDP.";
      currentAirportImg = loadImage("CLT.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
    
    }else if (code.equals("DEN")) {
      activeFact = "DEN — \n Denver International Airport . \n \n Legend is that there are miles of underground tunnels and layer upon layer of secret buildings and bunkers beneath the airport.";
      currentAirportImg = loadImage("DEN.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
    
    } else if (code.equals("ORD")) {
      activeFact = "ORD — \n Chicago Ohare International Airport. \n \n  Built in February of 1944.";
      currentAirportImg = loadImage("ORD.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    } else {
      activeFact = code + " — No facts available yet.";
    }
  }

  void drawInfoBox(String msg) {
    int boxW = 250;
    int boxH = 120;
    int x = 700;
    int y = height - 460;
  
    // background rectangle
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(x, y, boxW, boxH, 12);
  
    // text
    fill(0);
    textSize(14);
    textAlign(LEFT, TOP);
    text(msg, x + 20, y + 25, boxW - 30, boxH - 30);
    
    if( currentAirportImg !=null)  {
      imageMode(CENTER);
      image(currentAirportImg, ImgX, ImgY, w, h);
      stroke(0);
      strokeWeight(2);
      noFill();
      rectMode(CENTER);
      rect(ImgX, ImgY, w, h);
      rectMode(CORNER);
      imageMode(CORNER);
    }
 }
  void drawTopAirportBox() {
    pushStyle(); 
    pushMatrix();
    String[] lines = pieChart.getTopAirportInfo();
  
    int boxW = 260;
    int boxH = 120;
    int x = width/2 +200;                 // right side of screen
    int y = 500;                 // adjust as needed
  
    // Background
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(x, y, boxW, boxH, 12);
  
    // Text
    color[] textColours = {
      color(34, 139, 34),
      color(255, 140, 0),
      color(200, 0, 0)
    };
    
    textAlign(LEFT, TOP);
  
    for (int i = 0; i < lines.length; i++) {
      fill(textColours[i]);
      
      String[] parts = lines[i].split(":");
      
      textSize(15);
      text(parts[0] + ":", x + 15, y + 30 + i * 25);
      
      textSize(13);
      fill(0);
      float labelW = textWidth(parts[0] + ":");
      if(parts.length > 1) {
        text(parts[1], x + 35 + labelW, y + 32 + i * 25);
      }
    }
     popMatrix();
     popStyle();
  }
    // NEW: draws the entire "Search Airport" view on screen2
  // Follows the same layout pattern as other views — white card panel, dropdown on top
  void drawAirportSearchView() {
    pushStyle();
        
    // ---- text input box ---- (styled to match TextEntryButton in Button.pde)
    boolean inputHovered = (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
                            mouseY > searchBoxY && mouseY < searchBoxY + searchBoxH);
    stroke(RY_BLUE);
    strokeWeight(airportInputActive ? 2 : 1);
    fill(255);
    rect(searchBoxX, searchBoxY, searchBoxW, searchBoxH, 5);
    
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(16);
    String displayText = airportSearchInput.length() == 0 ? "e.g. ATL" : airportSearchInput;
    // Blink cursor when active — same frameCount trick as TextEntryButton
    if (airportInputActive && (frameCount / 25) % 2 == 0) displayText += "|";
    text(displayText, searchBoxX + 10, searchBoxY + searchBoxH/2);
    
    // ---- search button ---- (styled like "flightsOutput" button type in Button.pde)
    boolean btnHovered = (mouseX > searchBtnX && mouseX < searchBtnX + searchBtnW &&
                          mouseY > searchBtnY && mouseY < searchBtnY + searchBtnH);
    noStroke();
    fill(btnHovered ? color(255, 215, 0) : RY_YELLOW);
    rect(searchBtnX, searchBtnY, searchBtnW, searchBtnH, 8);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Search", searchBtnX + searchBtnW/2, searchBtnY + searchBtnH/2);
    
    // ---- error message ----
    if (!airportSearchError.equals("")) {
      fill(color(180, 50, 50));
      textAlign(CENTER, TOP);
      textSize(14);
      text(airportSearchError, width/2, searchBoxY + searchBoxH + 15);
    }
    
    // ---- result pie chart ----
    if (airportSearchHasResult) {
      // Stamp the pre-rendered pg (same as PieChart.draw())
      pushMatrix();
      translate(width/2 - airportPg.width/2, 230);
      image(airportPg, 0, 0);
      popMatrix();
      
      // Title below the chart
      fill(0);
      textAlign(CENTER, TOP);
      textSize(18);
      text("Flight status for airport: " + airportSearchCode, width/2, 230 + airportPg.height + 10);
    }
    
    popStyle();
  }
  void updateAirportSuggestions(String input) {
    airportSuggestions.clear();
    if (input.length() < 1) return;
    input = input.toLowerCase();

    // Use flightsList (global from MAIN.pde) — same source as QueriesFlights
    for (Flight f : flightsList) {
      String code     = f.origin.toLowerCase();
      String cityName = f.originCityName != null ? f.originCityName.toLowerCase() : "";

      if (code.startsWith(input) || cityName.contains(input)) {
        // Format: "ATL - Atlanta, GA"  matching QueriesFlights style
        String suggestion = f.origin + " - " + f.originCityName;
        if (!airportSuggestions.contains(suggestion)) {
          airportSuggestions.add(suggestion);
        }
        if (airportSuggestions.size() >= 6) break;
      }
    }
  }
  // NEW: compute results and render into airportPg
  // Logic mirrors PieChart.setup() exactly — same CSV, same delay threshold
  void runAirportSearch() {
    String code = airportSearchInput.trim().toUpperCase();
    if (code.equals("") || code.equals("E.G. ATL")) {
      airportSearchError = "Please enter an airport code.";
      airportSearchHasResult = false;
      return;
    }
    
    // Reset counts
    airportOnTime = 0;
    airportDelayed = 0;
    airportCancelled = 0;
    airportTotal = 0;
    airportSearchError = "";
    airportSearchHasResult = false;
    
    Table table = loadTable("flights100k.csv", "header");
    
    for (TableRow row : table.rows()) {
      String origin = row.getString("ORIGIN");
      if (origin == null || !origin.trim().equalsIgnoreCase(code)) continue;
      
      airportTotal++;
      
      if (row.getInt("CANCELLED") == 1) {
        airportCancelled++;
        continue;
      }
      
      // Same missing-time guard as PieChart.setup()
      String depStr = row.getString("DEP_TIME");
      String crsStr = row.getString("CRS_DEP_TIME");
      if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
        airportCancelled++;
        continue;
      }
      
      int dep = row.getInt("DEP_TIME");
      int crs = row.getInt("CRS_DEP_TIME");
      int depMin = (dep / 100) * 60 + (dep % 100);
      int crsMin = (crs / 100) * 60 + (crs % 100);
      int delay = depMin - crsMin;
      
      if (delay > 30) {
        airportDelayed++;
      } else {
        airportOnTime++;
      }
    }
    if (airportTotal == 0) {
      airportSearchError = "No flights found for code: " + code +
                           ". Try a 3-letter IATA code like ATL, LAX or ORD.";
      return;
    }
    
    airportSearchCode = code;
    airportSearchHasResult = true;
    
    // Render the result into airportPg — same structure as PieChart.draw()
    float onTimePct  = round((float(airportOnTime)  / airportTotal) * 100);
    float delayedPct = round((float(airportDelayed) / airportTotal) * 100);
    float cancelPct  = round((float(airportCancelled) / airportTotal) * 100);
    float[] vals = { airportOnTime, airportDelayed, airportCancelled };
    
    airportPg.beginDraw();
    airportPg.background(255);
    airportPg.noStroke();
    
    float total = airportOnTime + airportDelayed + airportCancelled;
    float start = 0;
    float cx = airportPg.width/2;
    float cy = airportPg.height/2;
    float diameter = 220;
    
    for (int i = 0; i < vals.length; i++) {
      float angle = TWO_PI * (vals[i] / total);
      airportPg.fill(airportColours[i]);
      airportPg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
      start += angle;
    }
    
    // Percentage labels — same positions as PieChart
    airportPg.fill(0);
    airportPg.textAlign(CENTER, CENTER);
    airportPg.textSize(13);
    airportPg.text(int(onTimePct)  + "%", cx - diameter/8, cy + diameter/8);
    airportPg.text(int(delayedPct) + "%", cx,               cy - diameter/8);
    airportPg.text(int(cancelPct)  + "%", cx + diameter/4,  cy - diameter/25);
    
    // Legend — same style as PieChart
    String[] labels = { "On Time", "Delayed > 30min", "Cancelled" };
    int lx = 10, ly = 10, box = 15;
    airportPg.textAlign(LEFT, CENTER);
    airportPg.textSize(12);
    for (int i = 0; i < labels.length; i++) {
      airportPg.fill(airportColours[i]);
      airportPg.rect(lx, ly + i * 25, box, box);
      airportPg.fill(0);
      airportPg.text(labels[i], lx + box + 10, ly + i * 25 + box/2);
    }
    
    // Total flight count below the pie
    airportPg.fill(80);
    airportPg.textAlign(CENTER, BOTTOM);
    airportPg.textSize(12);
    airportPg.text("Based on " + airportTotal + " flights", cx, airportPg.height - 5);
    
    airportPg.endDraw();
  }
  void goToPieCharts()  {
    currentScreen = screen2;
  }
  
  void onEnter()  {
    currentScreen = screen1;
    activeFact = "";
  }
}

/////////WIDGETS////////////
class Widget {
  int x, y, w, h;
  String label;
  boolean hover = false;

  Widget(int x, int y, int w, int h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }

  void draw() {
  boolean hovers = isInside(mouseX, mouseY);
  
  rectMode(CORNER);
  
  noStroke();
  fill(0, 40);
  rect(x +2, y + 4, w, h, 10);
  
  noStroke();
  fill(hovers ? color(61, 90, 128) :(RY_BLUE));;
  rect(x, y, w, h, 10);

  fill(255);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
  }

  boolean isInside(int mx, int my) {
    return mx > x && mx < x+w && my > y && my < y+h;
  }
}

////////////AIRPORT////////////

class AirportButton {
  float x, y, w, h;
  String code;

  AirportButton(float x, float y, float w, float h, String code) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.code = code;
  }

  boolean isInside(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}

/////////// BAR CHART ORIGIN//////////
class OriginBarChart {
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  ArrayList<AirportButton> buttons = new ArrayList<AirportButton>();
  HashMap<String, Integer> airportColours = new HashMap<String, Integer>();
  OriginBarChart(){
    airportColours.put("ATL", color(78, 96, 129));
    airportColours.put("LAX", color(65, 74, 90));
    airportColours.put("ORD", color(51));
    airportColours.put("DFW", color(101, 110, 93));
    airportColours.put("DEN", color(151, 168, 135));
    airportColours.put("JFK", color(203, 208, 181));
    airportColours.put("SEA", color(255, 247, 227));
    airportColours.put("LAS", color(187, 159, 136));
    airportColours.put("MCO", color(153, 115, 90));
    airportColours.put("CLT", color(142, 89, 99));
    airportColours.put("PHX", color(103, 71, 44));
    airportColours.put("LGA", color(236, 174, 164));
  }
    void setup() {
      buttons.clear();
      
      pg = createGraphics(530, 400);
      Table table = loadTable("flights100k.csv", "header");
    
      // Count flights per Origin airport
      HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
      for (TableRow row : table.rows()) {
        if (row.getInt("CANCELLED") == 1) continue;
    
        String dest = row.getString("ORIGIN");
        if (dest == null || dest.trim().equals("")) continue;
    
        counts.put(dest, counts.getOrDefault(dest, 0) + 1);
      }
    
      // Sort by count (high to low)
      ArrayList<String> keys = new ArrayList<String>(counts.keySet());
      keys.sort((a, b) -> counts.get(b) - counts.get(a));
    
      // Keep only the top 10
      int limit = min(10, keys.size());
      airports = new String[limit];
      values = new float[limit];
    
      for (int i = 0; i < limit; i++) {
        airports[i] = keys.get(i);
        values[i] = counts.get(airports[i]);
      }
      
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
        float x = 40 + i * barWidth;
        float bx = x;
        float by = pg.height - 25;
        float bw = barWidth - 5;
        float bh = 20;
    
        buttons.add(new AirportButton(bx, by, bw, bh, airports[i]));
      }

    }
    
    void draw() {
      pg.beginDraw();
      pg.background(RY_BG);
      pg.stroke(0);
      
      // --- drawing the y-axis ---
      pg.stroke(0);
      pg.line(40, 10, 40, pg.height - 30);  // x1,y1,x2,y2
    
      // --- Y axis ticks + labels ---
      int ticks = 5;
      float maxVal = 0;
      for (float v : values) maxVal = max(maxVal, v);
    
      pg.textAlign(RIGHT, CENTER);
      pg.fill(0);
      for (int i = 0; i <= ticks; i++) {
        float tVal = (maxVal / ticks) * i;
        float y = map(tVal, 0, maxVal, pg.height - 30, 10);
        pg.line(35, y, 40, y);               // tick mark
        pg.text(int(tVal), 30, y);           // label
      }
    
      // --- Bars ---
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
          if(airportColours.containsKey(airports[i]))  {
          pg.fill((int)airportColours.get(airports[i]));
        }else {
          pg.fill(0);
        }
    
        float h = map(values[i], 0, maxVal, 0, pg.height - 40);
        float x = 40 + i * barWidth;
        float y = pg.height - 30 - h;
    
        pg.rect(x, y, barWidth - 5, h);
    
        // airport labels
        pg.fill(0);
        pg.textAlign(CENTER, TOP);
        pg.text(airports[i], x + (barWidth - 5)/2, pg.height - 25);
        
      }
      
      pg.endDraw();
      image(pg, 0, 0);
      
      // --- Y-axis label (rotated) ---
        pushMatrix();
        translate(-15, pg.height/2);  // move to left side, halfway down
        rotate(-HALF_PI);            // rotate 90° counter‑clockwise
        textAlign(CENTER, CENTER);
        fill(0);
        text("Quantity of flights", 0, 0);
        popMatrix();
      
      fill(0);
      textAlign(CENTER, TOP);
      textSize(20);
      text("Bar Chart of Most Popular Origin Airports", pg.width/2, -50);
      
      textSize(14);
      textAlign(CENTER, BOTTOM);
      text("Most popular origin airports", pg.width/2, pg.height + 5);
    }
   String checkClick(float mx, float my) {
      float localX = mx - (width - 530)/2;   // X offset of the origin chart
      float localY = my - (height - 250)/2;   // Y offset of the origin chart
    
      for (AirportButton b : buttons) {
        if (b.isInside(localX, localY)) {
          return b.code;
        }
      }
      return null;
    }
}

//////////GRAPHS SCREEN////////
class graphScreen{
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  color bg;

  graphScreen(color bg) {
    this.bg = bg;
  }

  void addWidget(Widget w) {
    widgets.add(w);
  }

  void draw() {
    for (Widget w : widgets) {
      w.draw();
    }
  }

  Widget getEvent(int mx, int my) {
    for (Widget w : widgets) {
      if (w.isInside(mx, my)) return w;
    }
    return null;
  } 
  void updateHover(int mx, int my){
    for (Widget w : widgets) {
      w.hover = w.isInside(mx, my);
    }
  }
}
/////////PIE CHART///////
class PieChart {
  float percentOnTime;
  float percentDelayed;
  float percentCancelled;
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  color[] colours;
 
  HashMap<String, Integer> onTimeByAirport = new HashMap<String, Integer>();
  HashMap<String, Integer> delayedByAirport = new HashMap<String, Integer>();
  HashMap<String, Integer> cancelledByAirport = new HashMap<String, Integer>();

  String topOnTimeAirport = "";
  String topDelayedAirport = "";
  String topCancelledAirport = "";

  boolean showTopAirports = false;

  // Button position
  int btnX = 10, btnY = 260, btnW = 180, btnH = 30;

  PieChart(){
    colours = new color[] {
      color(#4F772D),
      color(#FCBF49),
      color(#D62828)
    };
  }
    
    void setup() {
      pg = createGraphics(400, 300);
    
      Table table = loadTable("flights100k.csv", "header");
      int onTime = 0;
      int delayed = 0;
      int cancelled = 0;
    
      for (TableRow row : table.rows()) {
        String airport = row.getString("ORIGIN");

        int isCancelled = row.getInt("CANCELLED");
        if (isCancelled == 1) {
          cancelled++;
          increment(cancelledByAirport, airport);
          continue;
        }
    
        // Clean missing times
        String depStr = row.getString("DEP_TIME");
        String crsStr = row.getString("CRS_DEP_TIME");
        if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
          cancelled++;   // treat missing times as unusable
          increment(cancelledByAirport, airport);

          continue;
        }
    
        int dep = row.getInt("DEP_TIME");
        int crs = row.getInt("CRS_DEP_TIME");
    
        // Convert HHMM to minutes
        int depMin = (dep / 100) * 60 + (dep % 100);
        int crsMin = (crs / 100) * 60 + (crs % 100);
    
        int delay = depMin - crsMin;
    
        if (delay > 30) {
          delayed++;
           increment(delayedByAirport, airport);
        }
        else {
          onTime++;
          increment(onTimeByAirport, airport);
        }
      }
    
      values = new float[] { onTime, delayed, cancelled };
      
      int total = onTime + cancelled + delayed;
      percentOnTime = round((float(onTime)/ total)*100);
      percentDelayed = round((float(delayed)/ total)*100);
      percentCancelled = round((float(cancelled)/ total)*100);
      computeTopAirports();
    }
    void increment(HashMap<String, Integer> map, String key) {
      if (!map.containsKey(key)) map.put(key, 1);
      else map.put(key, map.get(key) + 1);
    }
  
    // Find max airport for each category
    void computeTopAirports() {
      topOnTimeAirport = findMax(onTimeByAirport);
      topDelayedAirport = findMax(delayedByAirport);
      topCancelledAirport = findMax(cancelledByAirport);
    }
  
    String findMax(HashMap<String, Integer> map) {
      String best = "";
      int max = -1;
      for (String k : map.keySet()) {
        int v = map.get(k);
        if (v > max) {
          max = v;
          best = k;
        }
      }
      return best + " (" + max + ")";
    }
    void draw(){
      pg.beginDraw();
      pg.background(RY_BG);
      pg.noStroke();
    
      float total = 0;
      for (float v : values) total += v;
    
      float start = 0;
      float cx = pg.width/2;
      float cy = pg.height/2;
      float diameter = 250;
    
      for (int i = 0; i < values.length; i++) {
        float angle = TWO_PI * (values[i] / total);
        pg.fill(colours[i]);
        pg.arc(cx, cy, diameter, diameter, start, start + angle, PIE);
        pg.fill(0);
        pg.text(int(percentOnTime)+"%", cx-diameter/8, cy+diameter/8);
        pg.text(int(percentDelayed)+"%", cx, cy-diameter/8);
        pg.text(int(percentCancelled)+"%", cx+diameter/4, cy-diameter/25);
        start += angle;
      }
      // --- Legend ---
        int lx = 10;      // legend x-position inside pg
        int ly = 10;      // legend y-position
        int box = 15;     // size of colour squares
        
        String[] labels = {
          "On Time",
          "Delayed > 30min",
          "Cancelled"
        };
        
        pg.textAlign(LEFT, CENTER);
        pg.textSize(12);
        
        for (int i = 0; i < labels.length; i++) {
          pg.fill(colours[i]);
          pg.rect(lx, ly + i * 25, box, box);
        
          pg.fill(0);
          pg.text(labels[i], lx + box + 10, ly + i * 25 + box/2);
        }
      
     
      // --- Button ---
      pg.fill(200);
      pg.rect(btnX, btnY, btnW, btnH, 5);
      pg.fill(0);
      pg.textAlign(CENTER, CENTER);
      pg.text("Show Top Airports", btnX + btnW/2, btnY + btnH/2);
 
      pg.endDraw();
    
      image(pg, 0, 0);
    }
    void mousePressed() {
      // Adjust for translate(200, 300)
      float pieX = width/2 - 400/2;
      float pieY = height/2 - 300/2 + 20;
      int mx = (int)(mouseX - pieX);
      int my = (int)(mouseY - pieY);
    
      if (mx > btnX && mx < btnX + btnW &&
          my > btnY && my < btnY + btnH) {
        showTopAirports = !showTopAirports;
      }
    }
  boolean isShowingTop() {
      return showTopAirports;
    }
    
    String[] getTopAirportInfo() {
      return new String[] {
        "Most On-Time: " + topOnTimeAirport,
        "Most Delayed: " + topDelayedAirport,
        "Most Cancelled: " + topCancelledAirport
      };
    }

}

class BarChart {
  String[] airports;   // top 10 airport codes
  float[] values;      // top 10 counts
  PGraphics pg;
  ArrayList<AirportButton> buttons = new ArrayList<AirportButton>();
  HashMap<String, Integer> airportColours = new HashMap<String, Integer>();
  BarChart(){
    airportColours.put("ATL", color(78, 96, 129));
    airportColours.put("LAX", color(65, 74, 90));
    airportColours.put("ORD", color(51));
    airportColours.put("DFW", color(101, 110, 93));
    airportColours.put("DEN", color(151, 168, 135));
    airportColours.put("JFK", color(203, 208, 181));
    airportColours.put("SEA", color(255, 247, 227));
    airportColours.put("LAS", color(187, 159, 136));
    airportColours.put("MCO", color(153, 115, 90));
    airportColours.put("CLT", color(142, 89, 99));
    airportColours.put("PHX", color(103, 71, 44));
    airportColours.put("LGA", color(236, 174, 164));
  }
    void setup() {
      buttons.clear();
      
      pg = createGraphics(530, 400);
      Table table = loadTable("flights100k.csv", "header");
    
      // Count flights per DEST airport
      HashMap<String, Integer> counts = new HashMap<String, Integer>();
    
      for (TableRow row : table.rows()) {
        if (row.getInt("CANCELLED") == 1) continue;
    
        String dest = row.getString("DEST");
        if (dest == null || dest.trim().equals("")) continue;
    
        counts.put(dest, counts.getOrDefault(dest, 0) + 1);
      }
    
      // Sort by count (high to low)
      ArrayList<String> keys = new ArrayList<String>(counts.keySet());
      keys.sort((a, b) -> counts.get(b) - counts.get(a));
    
      // Keep only the top 10
      int limit = min(10, keys.size());
      airports = new String[limit];
      values = new float[limit];
    
      for (int i = 0; i < limit; i++) {
        airports[i] = keys.get(i);
        values[i] = counts.get(airports[i]);
      }
      
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
        float x = 40 + i * barWidth;
        float bx = x + (barWidth - 5)/2 - 30;
        float by = pg.height - 25;
        float bw = 60;
        float bh = 20;
    
        buttons.add(new AirportButton(bx, by, bw, bh, airports[i]));
      }

    }
    
    void draw() {
      pg.beginDraw();
      pg.background(RY_BG);
      pg.stroke(0);
      
      // --- drawing the y-axis ---
      pg.stroke(0);
      pg.line(40, 10, 40, pg.height - 30);  // x1,y1,x2,y2
    
      // --- Y‑axis ticks + labels ---
      int ticks = 5;
      float maxVal = 0;
      for (float v : values) maxVal = max(maxVal, v);
    
      pg.textAlign(RIGHT, CENTER);
      pg.fill(0);
      for (int i = 0; i <= ticks; i++) {
        float tVal = (maxVal / ticks) * i;
        float y = map(tVal, 0, maxVal, pg.height - 30, 10);
        pg.line(35, y, 40, y);               // tick mark
        pg.text(int(tVal), 30, y);           // label
      }
    
      // --- Bars ---
      float barWidth = (pg.width - 50) / (float)values.length;
    
      for (int i = 0; i < values.length; i++) {
        if(airportColours.containsKey(airports[i]))  {
          pg.fill((int)airportColours.get(airports[i]));
        }else {
          pg.fill(0);
        }
        
        float h = map(values[i], 0, maxVal, 0, pg.height - 40);
        float x = 40 + i * barWidth;
        float y = pg.height - 30 - h;
    
        pg.rect(x, y, barWidth - 5, h);
    
        // airport labels
        pg.fill(0);
        pg.textAlign(CENTER, TOP);
        pg.text(airports[i], x + (barWidth - 5)/2, pg.height - 25);
        
      }
      pg.endDraw();
      image(pg, 0, 0);
      
      // --- Y-axis label (rotated) ---
        pushMatrix();
        translate(-15, pg.height/2);  // move to left side, halfway down
        rotate(-HALF_PI);            // rotate 90° counter‑clockwise
        textAlign(CENTER, CENTER);
        fill(0);
        text("Quantity of flights", 0, 0);
        popMatrix();
   
      
      fill(0);
      textAlign(CENTER, TOP);
      textSize(20);
      text("Bar Chart of Most Popular Destination Airports", pg.width/2, -50);
      
      textSize(14);
      textAlign(CENTER, BOTTOM);
      text("Most popular destination airports", pg.width/2, pg.height + 5);
    }
    String checkClick(float mx, float my) {
      float localX = mx - (width - 530)/2;
      float localY = my - (height - 250)/2;
      for (AirportButton b : buttons) {
        if (b.isInside(localX, localY)) { 
          // subtract translation offset (50,50)
          return b.code;
        }
      }
      return null;
    }
}
    // ===== DROPDOWN CLASS =====
class Dropdown {
  float x, y, w, h;
  String[] options;
  int selectedIndex = 0;
  boolean openDropDown = false;
  boolean hovering = false;

  Dropdown(float x, float y, float w, float h, String[] options) {
    this.x=x; this.y=y; this.w=w; this.h=h; this.options=options;
  }

  String selected() {
    return options[selectedIndex];
  }

  void draw() {
    // --- MAIN BOX HOVER CHECK ---
    hovering = (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h);

    // --- MAIN BOX ---
    noStroke();
    fill(hovering ? #3D5A80 : RY_BLUE);
    rect(x, y, w, h, 8);

    fill(255);
    textAlign(LEFT, CENTER);
    textSize(14);
    text(options[selectedIndex], x+10, y+h/2);

    textAlign(RIGHT, CENTER);
    text(openDropDown ? "▲" : "▼", x+w-8, y+h/2);

    // --- OPTIONS LIST ---
    if (openDropDown) {
      for (int i=0; i<options.length; i++) {
        float iy = y + h + i*h;

        boolean hov = (mouseX > x && mouseX < x+w && mouseY > iy && mouseY < iy+h);

        fill(i == selectedIndex ? #2B3F60 : #1C2E4A);
        rect(x, iy, w, h, (i == options.length-1) ? 8 : 0);
        if(i == selectedIndex)  {
          stroke(255,215,0);
          strokeWeight(2);
          noFill();
          rect(x, iy, w, h, ( i == options.length-1) ? 8 : 0);
          noStroke();
        }
          
        fill(255);
        textAlign(LEFT, CENTER);
        text(options[i], x+10, iy+h/2);

      }
    }
  }

  String mousePressed(int mx, int my) {
    if (openDropDown) {
      for (int i=0; i<options.length; i++) {
        float iy = y + h + i*h;
        if (mx>x && mx<x+w && my>iy && my<iy+h) {
          selectedIndex = i;
          openDropDown = false;
          return options[i];
        }
      }
      openDropDown = false;
      return null;
    } else {
      if (mx>x && mx<x+w && my>y && my<y+h) {
        openDropDown = true;
        return null;
      }
    }
    return null;
  }
}

class AirlineStats {
  int total = 0;
  int cancelled = 0;
  int delayed = 0;
}

HashMap<String, AirlineStats> computeAirlineStats() {
  HashMap<String, AirlineStats> stats = new HashMap<>();
  Table table = loadTable("flights100k.csv", "header");

  for (TableRow row : table.rows()) {
    String carrier = row.getString("MKT_CARRIER");
    if (carrier == null || carrier.trim().equals("")) continue;

    AirlineStats s = stats.getOrDefault(carrier, new AirlineStats());
    s.total++;

    if (row.getInt("CANCELLED") == 1) {
      s.cancelled++;
    }

    int dep = row.getInt("DEP_TIME");
    int crs = row.getInt("CRS_DEP_TIME");
    int depMin = (dep / 100) * 60 + (dep % 100);
    int crsMin = (crs / 100) * 60 + (crs % 100);
    int delay = depMin - crsMin;
    if (delay > 30) s.delayed++;

    stats.put(carrier, s);
  }
  return stats;
}

class AirlineRateChart {
  PGraphics pg;
  String[] airlines;
  float[] rates;
  String mode = "cancel";
  boolean showLegend = false;
  int btnX = 10, btnY = 310, btnW = 160, btnH = 28;
  float drawnAtX = 0;
  float drawnAtY = 0; 

  HashMap<String, Integer> airlineColours = new HashMap<String, Integer>();

  AirlineRateChart() {
    pg = createGraphics(530, 400);
    airlineColours.put("AA", color(78, 96, 129));
    airlineColours.put("DL", color(65, 74, 90));
    airlineColours.put("UA", color(51));
    airlineColours.put("WN", color(101, 110, 93));
    airlineColours.put("AS", color(151, 168, 135));
    airlineColours.put("B6", color(203, 208, 181));
    airlineColours.put("NK", color(255, 247, 227));
    airlineColours.put("F9", color(187, 159, 136));
    airlineColours.put("G4", color(153, 115, 90));
    airlineColours.put("HA", color(142, 89, 99));
    airlineColours.put("PHX", color(103, 71, 44));
    airlineColours.put("LGA", color(236, 174, 164));
  }

  void compute(HashMap<String, AirlineStats> stats) {
    ArrayList<String> keys = new ArrayList<>(stats.keySet());

    keys.sort((a, b) -> {
      AirlineStats sa = stats.get(a);
      AirlineStats sb = stats.get(b);
      float ra = (mode.equals("cancel")) ? (float)sa.cancelled/sa.total : (float)sa.delayed/sa.total;
      float rb = (mode.equals("cancel")) ? (float)sb.cancelled/sb.total : (float)sb.delayed/sb.total;
      return Float.compare(rb, ra);
    });

    int limit = min(10, keys.size());
    airlines = new String[limit];
    rates = new float[limit];

    for (int i = 0; i < limit; i++) {
      airlines[i] = keys.get(i);
      AirlineStats s = stats.get(airlines[i]);
      rates[i] = (mode.equals("cancel")) ? (float)s.cancelled/s.total : (float)s.delayed/s.total;
    }
  }

  void draw(float x, float y) {
    pg.beginDraw();
    pg.background(RY_BG);
    pg.stroke(0);
    
    pg.line(40, 10, 40, pg.height-30);
    
    float maxPercentage = 0;
    for(float r: rates) maxPercentage = max(maxPercentage, r * 100);
    float maxPercent = ceil(maxPercentage / 5) * 5;
    
    pg.textAlign(RIGHT, CENTER);
    pg.fill(0);
    pg.textSize(11);
    
    float percent = 5;
    
    for (int i = 0; i <= maxPercent; i += percent) {
      float ty = map(i, 0, maxPercent, pg.height - 30, 10);
      pg.line(35, ty, 40, ty);
      pg.text(i + "%", 33, ty);
    }
    
    
    float barWidth = (pg.width - 50) / (float)rates.length;

    for (int i = 0; i < rates.length; i++) {
      float h = map(rates[i] * 100, 0, maxPercent, 0, pg.height - 40);
      float bx = 40 + i * barWidth;
      float by = pg.height - 30 - h;

      if  (airlineColours.containsKey(airlines[i]))  {
        pg.fill((int)airlineColours.get(airlines[i]));
      } else{
        pg.fill(RY_BLUE);
      }
      pg.rect(bx, by, barWidth -5, h);
      
      pg.fill(0);
      pg.textAlign(CENTER, BOTTOM);
      pg.textSize(11);
      pg.text(nf(rates[i] * 100, 1, 1) + "%", bx + (barWidth - 5)/2, by-2);
      
      pg.fill(0);
      pg.textAlign(CENTER, TOP);
      pg.text(airlines[i], bx + (barWidth - 5)/2, pg.height - 25);
    }
     pg.fill(200);
    pg.noStroke();
    pg.rect(btnX, btnY, btnW, btnH, 5);
    pg.fill(0);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(12);
    pg.text(showLegend ? "Hide Airline Legend" : "Show Airline Legend",
            btnX + btnW/2, btnY + btnH/2);

    pg.endDraw();
    image(pg, x, y);
    
  }
    void mousePressed() {
    float mx = mouseX - drawnAtX;
    float my = mouseY - drawnAtY;
    if (mx > btnX && mx < btnX + btnW &&
        my > btnY && my < btnY + btnH) {
      showLegend = !showLegend;
    }
  }

  // ADD: draws the legend panel in screen coordinates (outside pg)
  void drawLegendPanel() {
    pushStyle();
    int rowH = 22;
    int boxW = 230;
    int boxH = 24 + airlines.length * rowH;

    // Right of the chart: translate is (300,200), pg width is 500, so 300+500+10 = 810
    float bx = drawnAtX + pg.width + 10;
    float by = drawnAtY;

    fill(255);
    stroke(180);
    strokeWeight(1);
    rect(bx, by, boxW, boxH, 8);

    noStroke();
    fill(40);
    textAlign(LEFT, TOP);
    textSize(13);
    text("Airline Legend", bx + 12, by + 6);

    textSize(12);
    for (int i = 0; i < airlines.length; i++) {
      float rowY = by + 24 + i * rowH;
      String code = airlines[i];

      // Use the actual colour from airlineColours map, same as the bars
      if (airlineColours.containsKey(code)) {
        fill((int) airlineColours.get(code));
      } else {
        fill(RY_BLUE);
      }
      noStroke();
      rect(bx + 10, rowY + 3, 14, 14, 3);

      fill(30);
      textAlign(LEFT, TOP);
      // Uses getAirlineName() from regionPieCharts.pde — already globally available
      text(code + "  =  " + getAirlineName(code), bx + 30, rowY + 3);
    }
    popStyle();
  }
}
