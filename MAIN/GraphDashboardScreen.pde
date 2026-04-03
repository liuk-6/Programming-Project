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
  
  boolean showDestinationChart = true; // default view
  PImage currentAirportImg;
  float ImgX;
  float ImgY;
  float w;
  float h;

  Dropdown barDropdown;
  
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
    screen1.addWidget(new Widget(1050, 620, 120, 40, "Pie Charts"));
 
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  
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
    
    if(currentScreen == screen1) barDropdown.draw();
  
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
        cancelRateChart.draw(0, 0);
      } else if (activeBarView.equals("% Delayed")) {
        delayRateChart.draw(0, 0);
      }
    
      popMatrix();
    }
    if (currentScreen == screen2) {
      airlinePie.draw(650, 150);
     if (currentScreen == screen2) {
      pushMatrix();
      translate(150, 300);
      pieChart.draw();
      popMatrix();
     }
    }
  
    // Draw title
    fill(255);
    textSize(30);
    text("Flight Data Visualisation Dashboard", width/2, 60);
  
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
    }
    if (currentScreen == screen2) {
      pieChart.mousePressed();
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
    int x = 500;   // right side of screen
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
      
      pg.fill(0);
      pg.text("Percentage of On Time flights", pg.width/2 , 10); 
    
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
      int mx = mouseX - 200;
      int my = mouseY - 300;
    
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

    pg.endDraw();
    image(pg, x, y);
    pushMatrix();
    translate(-15, pg.height/2);
    rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Rate (%)", 0, 0);
    popMatrix();
  
    // Title
    fill(0);
    textAlign(CENTER, TOP);
    textSize(20);
    text((mode.equals("cancel") ? "Cancellation" : "Delay") + " Rate by Airline", pg.width/2, -50);
  
    textSize(14);
    textAlign(CENTER, BOTTOM);
    text("Airlines", pg.width/2, pg.height + 25);
  }
}
