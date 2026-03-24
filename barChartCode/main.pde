BarChart destChart;
OriginBarChart originChart;
PieChart pieChart;
Screen screen1, screen2;
Screen currentScreen;

float percentOnTime;
float percentDelayed;
float percentCancelled;
String activeFact = "";

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
  
  screen1 = new Screen(color(150, 200, 255));
  screen2 = new Screen(color(255, 200, 150));

  // Screen 1 widgets
  screen1.addWidget(new Widget(20, 20, 120, 40, "Next"));

  // Screen 2 widgets
  screen2.addWidget(new Widget(20, 20, 120, 40, "Back"));

  currentScreen = screen1;
}

void draw() {
  background(255,255,255);
  currentScreen.draw();
  
  if (currentScreen == screen1){
    // --- Draw Destination Bar Chart ---
    pushMatrix();
    translate(30, 200);     // top-left
    destChart.draw();
    popMatrix();
  
    // --- Draw Origin Bar Chart ---
    pushMatrix();
    translate(630, 200);    // bottom-left
    originChart.draw();
    popMatrix();
  }
  
  if (currentScreen == screen2){
    // --- Draw Pie Chart ---
    pushMatrix();
    translate(width/2, height/2);   // right side
    pieChart.draw();
    popMatrix();
  }
  // --- Titles for clarity ---
  fill(0);
  textSize(20);
  text("Flight Data Visualisation Dashboard", width/2, 30);
  if (activeFact != "") {
      drawInfoBox(activeFact);
    }
}
void mousePressed(){
  if (currentScreen == screen1) {
    String airport = destChart.checkClick(mouseX, mouseY);
    if (airport != null) {
      showAirportFacts(airport);
      return; // stop here so widget logic doesn't override
    }
  }

  Widget w = currentScreen.getEvent(mouseX, mouseY);

  if (w == null) return;

  if (w.label.equals("Next")) {
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
    activeFact = "LAX — Los Angeles International Airport.\nOne of the busiest airports in the world.";
  } else if (code.equals("JFK")) {
    activeFact = "JFK — Major international hub in New York.";
  } else if (code.equals("SEA")) {
    activeFact = "SEA — Seattle-Tacoma International Airport.";
  } else {
    activeFact = code + " — No facts available yet.";
  }
}

void mouseMoved(){
  currentScreen.updateHover(mouseX, mouseY);
}
void drawInfoBox(String msg) {
  int boxW = 300;
  int boxH = 120;
  int x = 20;
  int y = height - boxH - 20;

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
