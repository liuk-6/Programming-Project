BarChart destChart;
OriginBarChart originChart;
PieChart pieChart;
graphScreen screen1, screen2;
graphScreen currentScreen;

float percentOnTime;
float percentDelayed;
float percentCancelled;
String activeFact = "";
boolean showDestinationChart = true; // default view

void setup() {
  size(1200, 700);   // enough room for 3 charts

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

  // Screen 1 widgets
  screen1.addWidget(new Widget(20, 20, 140, 40, "Destination"));
  screen1.addWidget(new Widget(170, 20, 140, 40, "Origin"));
  screen1.addWidget(new Widget(320, 20, 120, 40, "Next"));
  
  // Screen 2 widgets
  screen2.addWidget(new Widget(20, 20, 120, 40, "Back"));

  currentScreen = screen1;
}

void draw() {
  background(255);

  // Draw screen background + widgets
  currentScreen.draw();

  // Draw charts
  if (currentScreen == screen1) {
    pushMatrix();
    translate(300, 200);
  
    if (showDestinationChart) {
      destChart.draw();
    } else {
      originChart.draw();
    }
  
    popMatrix();
  }
  if (currentScreen == screen2) {
    pushMatrix();
    translate(200, 300);
    pieChart.draw();
    popMatrix();
  }

  // Draw title
  fill(0);
  textSize(20);
  text("Flight Data Visualisation Dashboard", width/2, 30);

  // Draw airport fact box
  if (activeFact != "") {
    drawInfoBox(activeFact);
  }

  // ⭐ DRAW THE TOP-AIRPORT BOX LAST ⭐
  if (currentScreen == screen2 && pieChart.isShowingTop()) {
    drawTopAirportBox();
  }
}
void mousePressed() {
    
  if (currentScreen == screen1) {
  
    // Destination chart buttons
    String airport = destChart.checkClick(mouseX, mouseY);
    if (airport != null) {
      showAirportFacts(airport);
      return;
    }
  
    // Origin chart buttons
    airport = originChart.checkClick(mouseX, mouseY);
    if (airport != null) {
      showAirportFacts(airport);
      return;
    }
  }
  if (currentScreen == screen2) {
    pieChart.mousePressed();
  }


  Widget w = currentScreen.getEvent(mouseX, mouseY);

  if (w == null) return;

  if (w.label.equals("Destination")) {
    showDestinationChart = true;
  }
  else if (w.label.equals("Origin")) {
    showDestinationChart = false;
  }
  else if (w.label.equals("Next")) {
    currentScreen = screen2;
    activeFact = "";
  }
  else if (w.label.equals("Back")) {
    currentScreen = screen1;
    activeFact = "";
  }
}
void showAirportFacts(String code) {
  if (code.equals("LAX")) {
    activeFact = "LAX — \nLos Angeles International Airport. \n The eighth-busiest airport in the world serving over 75 million guests in 2023 \n It has an official song.";
  } else if (code.equals("JFK")) {
    activeFact = "JFK — \n John F Kennedy International Airport \n There is a pet-only terminal.";
  } else if (code.equals("SEA")) {
    activeFact = "SEA — \n Seattle-Tacoma International Airport. \n SEA Airports parking garage is the second largest parking lot (under one roof) in the world.";
  } else if (code.equals("HON")) {
    activeFact = "HON — \n Honolulu International Airport. \n The largest airport in Hawaii.";
  } else if (code.equals("LGA")) {
    activeFact = "LGA — \n LaGuardia Airport. \n The airport lies partly on reclaimed land, created using landfill .";
  } else if (code.equals("PHX")) {
    activeFact = "PHX — \n Phoenix Sky Harbor International Airport. \n It is Arizona's largest and busiest airport. .";
  }else if (code.equals("MCO")) {
    activeFact = "MCO — \n Orlando International Airport. \n Has over $41 billion in economic impact.";
  } else if (code.equals("ATL")) {
    activeFact = "ATL —  Hartsfield-Jackson Atlanta International Airport. \n Since 1998, Hartsfield-Jackson has been the busiest airport in the world for 23 out of 24 years.";
  }else if (code.equals("DFW")) {
    activeFact = "DFW — \n Dallas/Fort Worth International Airport. \n it serves 269 destinations (196 domestic and 73 international).";
  }else if (code.equals("CLT")) {
    activeFact = "CLT — \n Charlotte Douglas International Airport. \n Contributes about 5% of North Carolinas GDP.";
  }else if (code.equals("DEN")) {
    activeFact = "DEN — \n Denver International Airport . \n legend is that there are miles of underground tunnels and layer upon layer of secret buildings and bunkers beneath the airport.";
  } else if (code.equals("ORD")) {
    activeFact = "ORD — \n Chicago Ohare International Airport. \n  Built in February of 1944.";
  } else {
    activeFact = code + " — No facts available yet.";
  }
}

void mouseMoved() {
  currentScreen.updateHover(mouseX, mouseY);
}
void drawInfoBox(String msg) {
  int boxW = 300;
  int boxH = 120;
  int x = 50;
  int y = height - boxH -150;

  // background rectangle
  fill(255);
  stroke(0);
  strokeWeight(2);
  rect(x, y, boxW, boxH, 12);

  // text
  fill(0);
  textSize(14);
  textAlign(LEFT, TOP);
  text(msg, x + 15, y + 15, boxW - 30, boxH - 30);
}
void drawTopAirportBox() {
  pushStyle(); 
  pushMatrix();
  String[] lines = pieChart.getTopAirportInfo();

  int boxW = 260;
  int boxH = 120;
  int x = width - boxW - 40;   // right side of screen
  int y = 120;                 // adjust as needed

  // Background
  fill(255);
  stroke(0);
  strokeWeight(2);
  rect(x, y, boxW, boxH, 12);

  // Text
  fill(0);
  textAlign(LEFT, TOP);
  textSize(14);

  for (int i = 0; i < lines.length; i++) {
    text(lines[i], x + 15, y + 15 + i * 25);
  }
   popMatrix();
   popStyle();
}
