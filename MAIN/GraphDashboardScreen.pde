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
  int airportHoveredSlice = -1;
  
  // Results from airport search
  int airportOnTime = 0;
  int airportDelayed = 0;
  int airportCancelled = 0;
  int airportTotal = 0;
  
  // Text input box bounds (screen coords, set once)
  float searchBoxX, searchBoxY, searchBoxW = 200, searchBoxH = 38;
  // Search button bounds
  float searchBtnX, searchBtnY, searchBtnW = 100, searchBtnH = 38;
  
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
      drawBarTabs();
    } else if (currentScreen == screen2) {
      drawPieTabs();
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
  
  
    // Draw airport fact box
    if (activeFact != "" && currentScreen == screen1) {
      drawInfoBox(activeFact);
    }
  
    // DRAW THE TOP-AIRPORT BOX LAST
    if (currentScreen == screen2 && pieChart.isShowingTop()) {
      drawTopAirportBox();
    }
    for(Button b : buttons) b.display();
    
     // Draw dropdown on top of everything else
    // Draw dropdown on top of everything else
    if (currentScreen == screen1) {
      drawBarTabs();
    } else if (currentScreen == screen2) {
      drawPieTabs();
    }

    // Draw airport suggestions last so they appear over all charts and panels
    if (currentScreen == screen2 && activePieView.equals("Search Airport") &&
        airportInputActive && airportSuggestions.size() > 0) {
      float sugH = 30;
      for (int i = 0; i < airportSuggestions.size(); i++) {
        float sy = searchBoxY + searchBoxH + i * sugH;
        boolean sugHov = (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
                          mouseY > sy && mouseY < sy + sugH);

        noStroke();
        fill(sugHov ? color(220, 230, 255) : 255);
        rect(searchBoxX, sy, searchBoxW, sugH);

        stroke(200);
        strokeWeight(1);
        line(searchBoxX, sy + sugH, searchBoxX + searchBoxW, sy + sugH);

        fill(RY_BLUE);
        textAlign(LEFT, CENTER);
        textSize(13);
        noStroke();
        text(airportSuggestions.get(i), searchBoxX + 8, sy + sugH/2);
      }
      // Outer border around the whole list
      stroke(RY_BLUE);
      strokeWeight(1);
      noFill();
      rect(searchBoxX, searchBoxY + searchBoxH,
           searchBoxW, airportSuggestions.size() * sugH, 0, 0, 4, 4);
      noStroke();
    }
  }
  
    void highlightButton(Button b)  {
      fill(255,215,0);
      rect(b.x - 5, b.y - 5, b.w + 10, b.h + 10, 8);
      b.display();
    
     // Draw dropdown on top of everything else
  }
  void drawPieTabs() {
    String[] tabs = {"Overall Flights", "By Airline", "Search Airport"};
    int tabCount = tabs.length;
    float tabW = 280;
    float tabH = 40;
    float gap = 8;
    float totalW = tabCount * tabW + (tabCount - 1) * gap;
    float startX = width/2 - totalW/2;
    float tabY = 75;

    for (int i = 0; i < tabCount; i++) {
      float tx = startX + i * (tabW + gap);
      boolean isActive = activePieView.equals(tabs[i]);
      boolean isHovered = (mouseX > tx && mouseX < tx + tabW &&
                           mouseY > tabY && mouseY < tabY + tabH);

      // Shadow
      noStroke();
      fill(0, 40);
      rect(tx + 2, tabY + 3, tabW, tabH, 10);

      // Button body
      noStroke();
      fill(isActive ? color(30, 50, 90) : (isHovered ? color(61, 90, 128) : RY_BLUE));
      rect(tx, tabY, tabW, tabH, 10);

      // Gold outline when active — matches the style in your screenshot
      if (isActive) {
        noFill();
        stroke(RY_GOLD);
        strokeWeight(2.5);
        rect(tx, tabY, tabW, tabH, 10);
        noStroke();
      }

      // Label
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(tabs[i].toUpperCase(), tx + tabW/2, tabY + tabH/2);
    }
  }
  void drawBarTabs() {
    String[] tabs = {"Destination", "Origin", "% Cancelled", "% Delayed"};
    int tabCount = tabs.length;
    float tabW = 210;
    float tabH = 40;
    float gap = 8;
    float totalW = tabCount * tabW + (tabCount - 1) * gap;
    float startX = width/2 - totalW/2;
    float tabY = 75;

    for (int i = 0; i < tabCount; i++) {
      float tx = startX + i * (tabW + gap);
      boolean isActive = activeBarView.equals(tabs[i]);
      boolean isHovered = (mouseX > tx && mouseX < tx + tabW &&
                           mouseY > tabY && mouseY < tabY + tabH);

      // Shadow
      noStroke();
      fill(0, 40);
      rect(tx + 2, tabY + 3, tabW, tabH, 10);

      // Button body
      noStroke();
      fill(isActive ? color(30, 50, 90) : (isHovered ? color(61, 90, 128) : RY_BLUE));
      rect(tx, tabY, tabW, tabH, 10);

      // Gold outline when active
      if (isActive) {
        noFill();
        stroke(RY_GOLD);
        strokeWeight(2.5);
        rect(tx, tabY, tabW, tabH, 10);
        noStroke();
      }

      // Label
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(tabs[i].toUpperCase(), tx + tabW/2, tabY + tabH/2);
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
    
      String[] tabs = {"Destination", "Origin", "% Cancelled", "% Delayed"};
      int tabCount = tabs.length;
      float tabW = 210;
      float tabH = 40;
      float gap = 8;
      float totalW = tabCount * tabW + (tabCount - 1) * gap;
      float startX = width/2 - totalW/2;
      float tabY = 75;

      for (int i = 0; i < tabCount; i++) {
        float tx = startX + i * (tabW + gap);
        if (mouseX > tx && mouseX < tx + tabW &&
            mouseY > tabY && mouseY < tabY + tabH) {
          activeBarView = tabs[i];
          activeFact = "";
          return;
        }
      }
      
      // Destination chart buttons
      if(activeBarView.equals("Destination"))  {
      String airport = destChart.checkClick(mouseX, mouseY);
        if (airport != null) {
          showAirportFacts(airport);
          return;
        }
      }
    
      // Origin chart buttons
     else if (activeBarView.equals("Origin"))  {
      String airport = originChart.checkClick(mouseX, mouseY);
        if (airport != null) {
          showAirportFacts(airport);
          return;
        }
      }
      else if (activeBarView.equals("% Cancelled")) {
        cancelRateChart.mousePressed();
      }
      else if (activeBarView.equals("% Delayed")) {
        delayRateChart.mousePressed();
      }
    }
   if (currentScreen == screen2) {
      String[] tabs = {"Overall Flights", "By Airline", "Search Airport"};
      int tabCount = tabs.length;
      float tabW = 280;
      float tabH = 40;
      float gap = 8;
      float totalW = tabCount * tabW + (tabCount - 1) * gap;
      float startX = width/2 - totalW/2;
      float tabY = 75;

      for (int i = 0; i < tabCount; i++) {
        float tx = startX + i * (tabW + gap);
        if (mouseX > tx && mouseX < tx + tabW &&
            mouseY > tabY && mouseY < tabY + tabH) {
          activePieView = tabs[i];
          if (!tabs[i].equals("Search Airport")) {
            airportInputActive = false;
            airportSuggestions.clear();
          }
          return;
        }
      }
    }
     if (currentScreen == screen2) {
      if (activePieView.equals("Overall Flights")) {
        pieChart.mousePressed();
      }else if (activePieView.equals("By Airline")) {
        airlinePie.mousePressed(width/2 - 450/2, height/2 - 350/2 + 20);
      } else if (activePieView.equals("Search Airport")) {
          // Click inside input box
          if (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
              mouseY > searchBoxY && mouseY < searchBoxY + searchBoxH) {
          
              airportInputActive = true;
          
              if (airportSearchInput.equals("e.g. ATL")) {
                airportSearchInput = "";
            }
        
          // ✅ suggestion clicks MUST be inside this block
          } else if (airportSuggestions.size() > 0 && airportInputActive) {
        
            float sugH = 30;
            boolean clickedSuggestion = false;
        
            for (int i = 0; i < airportSuggestions.size(); i++) {
              float sy = searchBoxY + searchBoxH + i * sugH;
        
              if (mouseX > searchBoxX && mouseX < searchBoxX + searchBoxW &&
                  mouseY > sy && mouseY < sy + sugH) {
        
                String[] parts = airportSuggestions.get(i).split(" - ");
                if (parts.length > 0) {
                  String picked = parts[0].trim();
                  airportSearchInput = picked;
                }
        
                airportSuggestions.clear();
                airportInputActive = false;
                runAirportSearch();
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
        
          // Search button
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
      activeFact = "LAX - \nLos Angeles International Airport. \n\nThe eighth-busiest airport in the world serving over 75 million guests in 2023 \n\n It has an official song.";
      currentAirportImg = loadImage("LAX.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 45;
      
    } else if (code.equals("JFK")) {
      activeFact = "JFK - \nJohn F Kennedy International Airport \n\nThere is a pet-only terminal.";
      currentAirportImg = loadImage("JFK.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
      
    } else if (code.equals("SEA")) {
      activeFact = "SEA - \nSeattle-Tacoma International Airport. \n\nSEA Airports parking garage is the second largest parking lot (under one roof) in the world.";
      currentAirportImg = loadImage("SEA.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 40;
      
    } else if (code.equals("HON")) {
      activeFact = "HON - \nHonolulu International Airport. \n\nThe largest airport in Hawaii.";
      currentAirportImg = loadImage("HON.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
  
    } else if (code.equals("LGA")) {
      activeFact = "LGA - \n LaGuardia Airport.\n\nThe airport lies partly on reclaimed land, created using landfill .";
      currentAirportImg = loadImage("LGA.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 40;
    
    } else if (code.equals("PHX")) {
      activeFact = "PHX - \nPhoenix Sky Harbor International Airport. \n \n Arizona's largest and busiest airport.";
      currentAirportImg = loadImage("PHX.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    }else if (code.equals("MCO")) {
      activeFact = "MCO - \nOrlando International Airport. \n \nHas over $41 billion in economic impact.";
      currentAirportImg = loadImage("MCO.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 80;
      h = 60;
    
    } else if (code.equals("ATL")) {
      activeFact = "ATL -  \nHartsfield-Jackson Atlanta International Airport. \n\nSince 1998, Hartsfield-Jackson has been the busiest airport in the world for 23 out of 24 years.";
      currentAirportImg = loadImage("ATL.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    }else if (code.equals("DFW")) {
      activeFact = "DFW - \nDallas/Fort Worth International Airport. \n\nIt serves 269 destinations (196 domestic and 73 international).";
      currentAirportImg = loadImage("Dallas.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 60;
      h = 60;
    
    }else if (code.equals("CLT")) {
      activeFact = "CLT - \nCharlotte Douglas International Airport. \n\nContributes about 5% of North Carolinas GDP.";
      currentAirportImg = loadImage("CLT.png");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
    
    }else if (code.equals("DEN")) {
      activeFact = "DEN - \nDenver International Airport . \n \nLegend is that there are miles of underground tunnels and layer upon layer of secret buildings and bunkers beneath the airport.";
      currentAirportImg = loadImage("DEN.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 40;
    
    } else if (code.equals("ORD")) {
      activeFact = "ORD - \nChicago Ohare International Airport. \n\nBuilt in February of 1944.";
      currentAirportImg = loadImage("ORD.jpg");
      ImgX = 950;
      ImgY = height - 460;
      w = 70;
      h = 50;
    
    } else {
      activeFact = code + " - No facts available yet.";
    }
  }

  void drawInfoBox(String msg) {
    int boxW = 250;
    int x = 700;
    int y = height - 460;
    int padding = 20;
    int innerW = boxW - padding*2;
    
    textSize(14);
    float textH = textAscent() + textDescent();
    
    String[] paragraphs = msg.split("\n");
    int lines = 0;
    for(String p: paragraphs)  {
      if(p.trim().length() ==0)  {
        lines++;
        continue;
      }
      float lineW = 0;
      String[] words = p.split(" ");
      int pLines = 1;
      for (String word : words)  {
        if(word.length() ==0)continue;
      float ww = textWidth(word + " ");
      if (lineW + ww > innerW) { pLines++; lineW = ww;  }
      else lineW += ww;
    }
    lines += pLines;
    }
   
    int boxH = (int)(lines * textH) + padding * 2 + 15;
  
    // background rectangle
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(x, y, boxW, boxH, 12);
  
    // text
    fill(0);
    textSize(14);
    textAlign(LEFT, TOP);
    text(msg, x + padding, y + padding, innerW, boxH);
    
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
void drawAirportSearchView() {
    pushStyle();

    
    // ---- text input box ----
    stroke(RY_BLUE);
    strokeWeight(airportInputActive ? 2 : 1);
    fill(255);
    rect(searchBoxX, searchBoxY, searchBoxW, searchBoxH, 5);
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(16);
    String displayText = airportSearchInput.length() == 0 ? "e.g. ATL" : airportSearchInput;
    if (airportInputActive && (frameCount / 25) % 2 == 0) displayText += "|";
    noStroke();
    text(displayText, searchBoxX + 10, searchBoxY + searchBoxH / 2);

    // ---- search button ----
    boolean btnHovered = (mouseX > searchBtnX && mouseX < searchBtnX + searchBtnW &&
                          mouseY > searchBtnY && mouseY < searchBtnY + searchBtnH);
    noStroke();
    fill(btnHovered ? color(255, 215, 0) : RY_YELLOW);
    rect(searchBtnX, searchBtnY, searchBtnW, searchBtnH, 8);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Search", searchBtnX + searchBtnW / 2, searchBtnY + searchBtnH / 2);

    // ---- error message ----
    if (!airportSearchError.equals("")) {
      fill(color(180, 50, 50));
      textAlign(CENTER, TOP);
      textSize(14);
      text(airportSearchError, width/2, searchBoxY + searchBoxH + 15);
    }

    // ---- interactive pie chart ----
    if (airportSearchHasResult) {
      float[] vals = { airportOnTime, airportDelayed, airportCancelled };
      float total  = airportOnTime + airportDelayed + airportCancelled;

      float cx     = width / 2;
      float cy     = 430;
      float pieR   = 150;
      float expandDist = 16;

      // Determine hovered slice
      float dx   = mouseX - cx;
      float dy   = mouseY - cy;
      float dist = sqrt(dx * dx + dy * dy);
      airportHoveredSlice = -1;
      if (dist <= pieR + 25 && dist >= 5) {
        float ang = atan2(dy, dx) + HALF_PI;
        if (ang < 0)       ang += TWO_PI;
        if (ang > TWO_PI)  ang -= TWO_PI;
        float cumul = 0;
        for (int i = 0; i < vals.length; i++) {
          cumul += TWO_PI * (vals[i] / total);
          if (ang <= cumul) { airportHoveredSlice = i; break; }
        }
      }

      // Draw slices
      float start = -HALF_PI;
      String[] labels = { "On Time", "Delayed > 30min", "Cancelled" };
      for (int i = 0; i < vals.length; i++) {
        float angle    = TWO_PI * (vals[i] / total);
        boolean hov    = (airportHoveredSlice == i);
        float midAngle = start + angle / 2;
        float ox = hov ? cos(midAngle) * expandDist : 0;
        float oy = hov ? sin(midAngle) * expandDist : 0;

        fill(airportColours[i]);
        noStroke();
        arc(cx + ox, cy + oy, pieR * 2, pieR * 2, start, start + angle, PIE);

        if (angle > 0.2) {
          float lx = cx + ox + cos(midAngle) * pieR * 0.65;
          float ly = cy + oy + sin(midAngle) * pieR * 0.65;
          fill(0, 180);
          textAlign(CENTER, CENTER);
          textSize(hov ? 15 : 13);
          text(nf((vals[i] / total) * 100, 1, 1) + "%", lx, ly);
        }
        start += angle;
      }

      // Donut hole
      fill(RY_BG);
      noStroke();
      ellipse(cx, cy, pieR * 0.65, pieR * 0.65);

      // Centre label
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(11);
      text("total", cx, cy + 9);
      textSize(18);
      text(str(airportTotal), cx, cy - 7);

      // Hover tooltip
      if (airportHoveredSlice >= 0) {
        float pct = (vals[airportHoveredSlice] / total) * 100;
        String tip = labels[airportHoveredSlice] + "\n" +
                     int(vals[airportHoveredSlice]) + " flights (" +
                     nf(pct, 1, 1) + "%)";
        float tx = mouseX + 14;
        float ty = mouseY - 10;
        float tw = 195, th = 48;
        if (tx + tw > width - 10) tx = mouseX - tw - 14;
        fill(255); stroke(RY_BLUE); strokeWeight(1);
        rect(tx, ty, tw, th, 7);
        noStroke();
        fill(RY_BLUE);
        textAlign(LEFT, TOP);
        textSize(12);
        text(tip, tx + 9, ty + 7, tw - 18, th - 14);
      }

      // Legend to the right of pie
      float lx = cx + pieR + 30;
      float ly = cy - 35;
      for (int i = 0; i < labels.length; i++) {
        fill(airportColours[i]); noStroke();
        rect(lx, ly + i * 28, 14, 14, 3);
        fill(0);
        textAlign(LEFT, CENTER);
        textSize(13);
        text(labels[i], lx + 22, ly + i * 28 + 7);
      }

      // Title above pie
      fill(0);
      textAlign(CENTER, BOTTOM);
      textSize(18);
      text("Flight status for: " + airportSearchCode, cx, cy - pieR - 20);
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
void runAirportSearch() {
    String code = airportSearchInput.trim().toUpperCase();
    if (code.equals("") || code.equals("E.G. ATL")) {
      airportSearchError = "Please enter an airport code.";
      airportSearchHasResult = false;
      return;
    }

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

      if (row.getInt("CANCELLED") == 1) { airportCancelled++; continue; }

      String depStr = row.getString("DEP_TIME");
      String crsStr = row.getString("CRS_DEP_TIME");
      if (depStr == null || depStr.equals("") || crsStr == null || crsStr.equals("")) {
        airportCancelled++; continue;
      }

      int dep = row.getInt("DEP_TIME");
      int crs = row.getInt("CRS_DEP_TIME");
      int depMin = (dep / 100) * 60 + (dep % 100);
      int crsMin = (crs / 100) * 60 + (crs % 100);

      if (depMin - crsMin > 30) airportDelayed++;
      else airportOnTime++;
    }

    if (airportTotal == 0) {
      airportSearchError = "No flights found for: " + code +
                           ". Try a code like ATL, LAX or ORD.";
      return;
    }

    airportSearchCode = code;
    airportSearchHasResult = true;
    // No PGraphics render needed — pie draws live each frame
  }
    void goToPieCharts() {
    currentScreen = screen2;
  }
  
  void onEnter() {
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
  int btnX = 360, btnY = 0, btnW = 160, btnH = 28;
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
    pg.line(40, 10, 40, pg.height - 30);

    float maxPercentage = 0;
    for (float r : rates) maxPercentage = max(maxPercentage, r * 100);
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
      if (airlineColours.containsKey(airlines[i])) {
        pg.fill((int)airlineColours.get(airlines[i]));
      } else {
        pg.fill(RY_BLUE);
      }
      pg.rect(bx, by, barWidth - 5, h);
      pg.fill(0);
      pg.textAlign(CENTER, BOTTOM);
      pg.textSize(11);
      pg.text(nf(rates[i] * 100, 1, 1) + "%", bx + (barWidth - 5)/2, by - 2);
      pg.fill(0);
      pg.textAlign(CENTER, TOP);
      pg.text(airlines[i], bx + (barWidth - 5)/2, pg.height - 25);
    }

    pg.fill(200);
    pg.noStroke();
    pg.rect(btnX , btnY, btnW, btnH, 5);
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

  void drawLegendPanel() {
    pushStyle();
    int rowH = 22;
    int boxW = 230;
    int boxH = 24 + airlines.length * rowH;
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
      if (airlineColours.containsKey(code)) {
        fill((int) airlineColours.get(code));
      } else {
        fill(RY_BLUE);
      }
      noStroke();
      rect(bx + 10, rowY + 3, 14, 14, 3);
      fill(30);
      textAlign(LEFT, TOP);
      text(code + "  =  " + getAirlineName(code), bx + 30, rowY + 3);
    }
    popStyle();
  }
}
