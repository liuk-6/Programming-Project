class Screen {

  UILayout layout = new UILayout();
  ArrayList<Button> buttons = new ArrayList<Button>();

  String title = "";

  void draw() {
    layout.beginPage(title);
    drawContent();

    for (Button b : buttons)
      b.display();
  }

  // ---------- OVERRIDDEN BY SCREENS ----------
  void drawContent() {}

  // ---------- EVENTS (IMPORTANT) ----------
  void mousePressed() {
    for (Button b : buttons) b.click();
  }

  void mouseMoved() {
    for (Button b : buttons) b.over(mouseX, mouseY);
  }

  void keyPressed(char k) {}

}
/////////////////////// MENU SCREEN //////////////////////////////////////
class HomeScreen extends Screen {

  int NAV_HEIGHT = 85;

  color bgTop = color(28, 45, 85);
  color bgBottom = color(12, 20, 45);

  HomeScreen() {

    int buttonW = 180;
    int buttonH = 38;
    int pad = 20;

    // navigation buttons
    buttons.add(new Button(width-420, pad,
      buttonW, buttonH, "QUERIES", "queries", 16, true));

    buttons.add(new Button(width-220, pad,
      buttonW, buttonH, "DASHBOARD", "dashboard", 16, true));
    
    buttons.add(new Button(width-620, pad,
      buttonW, buttonH, "My Flights", "myFlights", 16, true));

    buttons.add(new Button(pad, pad,
      100, buttonH, "EXIT", "exit", 16, true));
  }

  void drawContent() {
  drawHeroPanel();
  drawPlane();
}


  void drawHeroPanel() {

    float panelW = width * 0.55;
    float panelH = 180;

    float x = width/2 - panelW/2;
    float y = NAV_HEIGHT + 70;

    // shadow
    fill(0, 90);
    rect(x+8, y+8, panelW, panelH, 20);

    // glass panel
    fill(255, 25);
    rect(x, y, panelW, panelH, 20);

    // text
    textAlign(CENTER);

    fill(255);
    textSize(56);
    text("Flight Scanner", width/2, y + 70);

    
  }

  // PLANE IMAGE SECTION
  void drawPlane() {

    imageMode(CENTER);

    // soft glow behind image
    fill(255, 30);
    ellipse(width/2, height*0.65, width*0.7, height*0.5);

    image(
      planeHomeScreen,
      width/2,
      height*0.65,
      width*0.8,
      height*0.6
    );

    imageMode(CORNER);
  }

  // ======================================================
  void mousePressed() {

    for (Button b : buttons) {

      if (b.over(mouseX, mouseY)) {

        if (b.type.equals("queries")) goTo(queries);
        if (b.type.equals("dashboard")) goTo(dashboard);
        if (b.type.equals("myFlights")) goTo(flightsBooked);
        if (b.type.equals("exit")) exit();
      }
    }
  }
}
/////////////////////////////////FIRST OPTIONS SCREENS /////////////////////////////////

class QueriesScreen extends Screen {

  ArrayList<Flight> flights;

  int NAV_HEIGHT = 85;

  color bgTop = color(28,45,85);
  color bgBottom = color(12,20,45);

  QueriesScreen() {
    this.title = "Flight Queries";
    this.flights = flightsList;
    setupButtons();
  }

  void setupButtons() {

    int cardW = 260;
    int cardH = 120;
    int spacing = 50;

    float startX = width/2 - (3*cardW + 2*spacing)/2;
    float y = 260;

    // back (navbar style)
    buttons.add(new Button(
      20, 22, 120, 38,
      "BACK", "back", 16, true));

    // card buttons
    buttons.add(new Button(startX, y,
      cardW, cardH, "FLIGHT SEARCH", "flightQuery", 18, true));

    buttons.add(new Button(startX + cardW + spacing, y,
      cardW, cardH, "TRAFFIC SEARCH", "airlineQuery", 18, true));

    buttons.add(new Button(startX + 2*(cardW + spacing), y,
      cardW, cardH, "DATE SEARCH", "dateQuery", 18, true));
  }

  void drawContent() {
  drawPageHeader();
  drawCardsBackground();
  drawInfoPanel();
}


  // ======================================================
  // PAGE HEADER
  void drawPageHeader() {

    textAlign(CENTER);

    fill(255);
    textSize(44);
    text("Flight Queries", width/2, NAV_HEIGHT + 70);

    fill(255,170);
    textSize(18);
    text("Choose how you want to explore flight data",
         width/2, NAV_HEIGHT + 100);
  }

  // ======================================================
  // CARD BACKGROUND LAYER (adds website depth)
  void drawCardsBackground() {

    float w = width*0.8;
    float h = 200;

    float x = width/2 - w/2;
    float y = 210;

    // shadow
    fill(0,80);
    rect(x+8,y+8,w,h,25);

    // glass panel
    fill(255,20);
    rect(x,y,w,h,25);
  }

  // ======================================================
  // INFO PANEL
  void drawInfoPanel() {

    float w = width * 0.6;
    float h = 170;
    float x = width/2 - w/2;
    float y = height - 230;

    // shadow
    fill(0,80);
    rect(x+6,y+6,w,h,20);

    // panel
    fill(255,25);
    rect(x,y,w,h,20);

    textAlign(CENTER);

    fill(255);
    textSize(22);
    text("SMART SEARCH FEATURES", width/2, y+40);

    fill(255,180);
    textSize(16);

    text("• Compare airline routes instantly", width/2, y+75);
    text("• Analyze traffic across regions", width/2, y+100);
    text("• Explore flights by travel date", width/2, y+125);
  }

  // ======================================================
  void mousePressed() {

    for (Button b : buttons) {

      if (b.over(mouseX, mouseY)) {

        if (b.type.equals("back")) goBack();
        if (b.type.equals("flightQuery")) goTo(flightsSearch);
        if (b.type.equals("airlineQuery")) goTo(flightsTraffic);
        if (b.type.equals("dateQuery")) goTo(flightsDate);
      }
    }
  }

  void keyPressed(char k) {}
}

// Card button class with hover animation
class CardButton extends Button {
  float hoverScale = 1.0;
  float targetScale = 1.0;

  CardButton(float x, float y, float w, float h, String label, String type) {
    super(x, y, w, h, label, type, 18, true);
  }

  void update() {
    if (over(mouseX, mouseY)) {
      targetScale = 1.05;
    } else {
      targetScale = 1.0;
    }
    hoverScale = lerp(hoverScale, targetScale, 0.1);
  }

  @Override
  void display() {
    pushMatrix();
    translate(x + w/2, y + h/2);
    scale(hoverScale);
    translate(-(x + w/2), -(y + h/2));

    // Shadow
    noStroke();
    fill(0, 50);
    rect(x+5, y+5, w, h, 20);

    // Card background
    fill(255);
    stroke(200);
    strokeWeight(1);
    rect(x, y, w, h, 20);

    // Icon
    fill(RY_BLUE);
    ellipse(x + 50, y + h/2, 60, 60);

    // Text
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(18);
    text(label, x + 100, y + h/2);

    popMatrix();
  }
}



class DashboardScreen extends Screen {

  DashboardScreen() {
    title = "Dashboard";
    int buttonW = 180;
    int buttonH = 50;
    int x = 60;
    int y = 252;
    textAlign(CENTER);
    buttons.add(new Button(x, y, buttonW, buttonH, "HOME", "home", 30, false));
    buttons.add(new Button(x, y + 80, buttonW, buttonH, "GRAPHS", "graphs", 30, false));
    buttons.add(new Button(x + 525, y + 150, buttonW + 410, buttonH + 220, "", "graphsPage", 30, false));
    textAlign(CORNER);
  }

  
  void drawContent(){
  drawSidebar();
  dashboardCards();
}
  
  void drawSidebar(){
    fill(240, 231, 213);
    noStroke();
    rect(40, 40, 220, 640, 20);
    fill(255);
    ellipse(150, 120, 80, 80);
    image(logo, 110, 80, 90, 90);
    
    fill(0);
    textAlign(CENTER);
    textSize(18);
    text("FLIGHT SCANNER", 150, 180); 
  }
  void dashboardCards(){  
    
  fill(255);
  rect(300, 400, 270, 270, 20);

  fill(255);
  rect(300, 60, 880, 300, 20);
}
  
  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        if (b.type.equals("home")) {
          goTo(home);
        }
        if (b.type.equals("graphs") || b.type.equals("graphsPage")){
          goTo(graphDashboard);
       }
      }
    }
  }
}
//////////////////// SECOND SELECTION CLASSES AFTER CHOOSEN QUERIES SEARCH //////////////////////////////////////

class QueriesFlights extends Screen {
  TextEntryButton inputFrom, inputTo, inputStart, inputEnd;
  TextEntryButton currentInput;
  boolean roundTrip = true;   // default like airline apps
  Button roundTripBtn;
  Button oneWayBtn;
  PImage swapImg;
  float swapX, swapY, swapW, swapH;
  ArrayList<String> suggestions = new ArrayList<String>();// drop down suggestions
  
  
  QueriesFlights() {
    title = "Flight Search";
    int margin = 100;
    int spacing = 15;
    int buttonH = 45;
    int queryW = (width - (margin * 2) - (spacing * 3)) / 4; 

    // White card layout
    int cardX = 90;
    int cardY = height/3 - 90;
    int cardW = width - 140;
    int cardH = 280;

    int tripBtnY = cardY + 80;       // Trip buttons below title
    int inputY   = tripBtnY + 45;    // Inputs below trip buttons
    int labelOffset = 12;            // Labels above inputs

    // Trip type buttons
    roundTripBtn = new Button(cardX + 10, tripBtnY-20, 140, 30, "Round Trip", "roundTrip", 14, false);
    oneWayBtn    = new Button(cardX + 160, tripBtnY-20, 120, 30, "One Way", "oneWay", 14, false);
    
    buttons.add(roundTripBtn);
    buttons.add(oneWayBtn);

    // Inputs
    inputFrom  = new TextEntryButton(cardX, inputY, queryW, buttonH, "Origin", "enter", 25, 16, false, 1);
    inputTo    = new TextEntryButton(cardX + (queryW + spacing)+15, inputY, queryW, buttonH, "Destination", "enter", 25, 16, false, 2);
    inputStart = new TextEntryButton(cardX + (queryW + spacing) * 2+15, inputY, queryW, buttonH, "MM/DD/YYYY", "enter", 10, 16, false, 3);
    inputEnd   = new TextEntryButton(cardX + (queryW + spacing) * 3+15, inputY, queryW, buttonH, "MM/DD/YYYY", "enter", 10, 16, false, 4);
    
    buttons.add(inputFrom);
    buttons.add(inputTo);
    buttons.add(inputStart);

    // Swap arrow image
    swapImg = loadImage("SwapArrow.png");
    swapW = 40;
    swapH = 35;
    swapX = inputFrom.x + inputFrom.w + ((inputTo.x - (inputFrom.x + inputFrom.w))/2) - swapW/2;
    swapY = inputFrom.y + inputFrom.h/2 - swapH/2;

    // Search button
    buttons.add(new Button(cardX + cardW - 200 - 40, inputY + 75, 200, 50, "Search flights", "flightsOutput", 20, false));

    // Back button
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }
  void updateSuggestions(String input){
    suggestions.clear();
    if(input.length()<2)return;
    input= input.toLowerCase();
    for(Flight f:flightsList){
      String origin = f.origin.toLowerCase();
      String originCity = f.originCityName.toLowerCase();
      if(origin.contains(input) || originCity.contains(input)){
        String suggestion = f.origin + " - "+ f.originCityName;
        if(!suggestions.contains(suggestion)){
          suggestions.add(suggestion);
        }
        if(suggestions.size()>=5) break;
      }
    }
    
    
  }
  

  void drawContent() {
    drawTripSelector();
    
    // White card container
    fill(255);
    noStroke();
    rect(70, height/3 - 90, width - 140, 280, 12);  // Taller card

    // Card title
    fill(RY_BLUE);
    textAlign(LEFT);
    textSize(22);
    text("Book your next trip", 100, height/3 - 65);

    // Labels
    fill(120);
    textSize(12);
    int labelOffset = 12;
    text("FLY FROM", inputFrom.x, inputFrom.y - labelOffset);
    text("FLY TO", inputTo.x, inputTo.y - labelOffset);
    text("DEPARTURE", inputStart.x, inputStart.y - labelOffset);
    drawSuggestions();
    if (roundTrip) text("RETURN", inputEnd.x, inputEnd.y - labelOffset);

    // Draw inputs
    inputFrom.display();
    inputTo.display();
    inputStart.display();
    if (roundTrip) inputEnd.display();

    // Swap arrow
    image(swapImg, swapX, swapY, swapW, swapH);

   // Draw buttons
    for (Button b : buttons) {
      if (b == inputEnd && !roundTrip) continue;  // Skip return date if one-way
      b.display();
    }

  }
  void drawSuggestions(){
  if(suggestions.size()==0||currentInput == null) return;
    float x = currentInput.x;
    float y = currentInput.y + currentInput.h;
    float w = currentInput.w;
    float h = 35;
    
    for(int i = 0; i<suggestions.size();i++){
      fill(255);
      stroke(200);
      rect(x, y + i*h, w, h);
      fill(0);
      textAlign(LEFT, CENTER);
      text(suggestions.get(i), x+10, y + i*h +h/2);
    }
  }

  void mousePressed() {
  if (currentInput != null && suggestions.size() > 0) {
  float x = currentInput.x;
  float y = currentInput.y + currentInput.h;
  float h = 35;

  for (int i = 0; i < suggestions.size(); i++) {
    if (mouseX > x && mouseX < x + currentInput.w &&
        mouseY > y + i*h && mouseY < y + (i+1)*h) {
      
      String selected = suggestions.get(i);

      currentInput.label =selected.split(" - ")[0];

      suggestions.clear(); // hide dropdown
      return;
        }
      }
  }
    TextEntryButton[] allInputs = roundTrip 
      ? new TextEntryButton[]{inputFrom, inputTo, inputStart, inputEnd}
      : new TextEntryButton[]{inputFrom, inputTo, inputStart};
    
    currentInput = null;
    for (TextEntryButton b : allInputs) {
      if (b.over(mouseX, mouseY)) {
        currentInput = b;
        if (b.label.equals("MM/DD/YYYY") || b.label.equals("Origin") || b.label.equals("Destination")) {
          b.label = "";
        }
      }
    }

    for (Button b : buttons) {
      if (b == inputEnd && !roundTrip) continue;
      if (b.over(mouseX, mouseY)) {
          if(b.type.equals("back")) goBack();
          // Trip type buttons
          if (b.type.equals("roundTrip")) roundTrip = true;
          if (b.type.equals("oneWay")) roundTrip = false;
  
          // Search button
          if (b.type.equals("flightsOutput")) {
              selection.origin      = inputFrom.label;
              selection.destination = inputTo.label;
              selection.dateStart   = inputStart.label;
              selection.dateEnd     = roundTrip ? inputEnd.label : "";
  
              searchFlights(); // <- now actually searches!
          }
      }
}

    // Swap arrow click
    if (mouseX > swapX && mouseX < swapX + swapW &&
        mouseY > swapY && mouseY < swapY + swapH) {
      String temp = inputFrom.label;
      inputFrom.label = inputTo.label;
      inputTo.label = temp;
    }
  }
  void drawTripSelector() {
    textAlign(LEFT, CENTER);
    textSize(14);
    if (roundTrip) {
      fill(#A8D05F); 
      rect(roundTripBtn.x-5, roundTripBtn.y-5, roundTripBtn.w+10, roundTripBtn.h+10, 8);
    } else {
      fill(#A8D05F);
      rect(oneWayBtn.x-5, oneWayBtn.y-5, oneWayBtn.w+10, oneWayBtn.h+10, 8);
    }
  }

  void keyPressed(char k) {
    if (currentInput != null) currentInput.addChar(k);
    if(currentInput == inputFrom ||currentInput == inputTo){
      updateSuggestions(currentInput.label);
    }
  }
  // Inside your QueriesFlights class
  void searchFlights() {
    // Clear previous results
    results.clear();
  
    // Get user input from the text fields
    String originInput = inputFrom.label.trim().toLowerCase();
    String destInput   = inputTo.label.trim().toLowerCase();
    String dateInput   = inputStart.label.trim(); // exact format "MM/DD/YYYY"
  
    // Loop through all flights
    for (Flight f : flightsList) {
      boolean originMatch = f.origin.toLowerCase().equals(originInput) 
                         || f.originCityName.toLowerCase().contains(originInput);
  
      boolean destMatch   = f.destination.toLowerCase().equals(destInput)
                         || f.destinationCityName.toLowerCase().contains(destInput);
  
      boolean dateMatch   = f.date.equals(dateInput);
  
      if (originMatch && destMatch && dateMatch) {
        results.add(f);
      }
    }
  
    println("Flights found: " + results.size());
  
    // Switch to FlightsOutputScreen if flights were found
    if (results.size() > 0) {
      goTo(flightsOutput);
    } else {
      println("No flights found for this search!");
    }
  }
  
  // Helper function to map city name to IATA code
  String getIATACodeFromInput(String input) {
    input = input.trim().toLowerCase();
    for (Flight f : flightsList) {
      if (f.originCityName.toLowerCase().contains(input)) return f.origin;
      if (f.destinationCityName.toLowerCase().contains(input)) return f.destination;
    }
    return input; // fallback if already an IATA code
  }
}

class QueriesDate extends Screen {
  TextEntryButton inputButton;
  TextEntryButton inputButton2;
  TextEntryButton currentInput;
  
  // Button bounds for the manual Search button
  float btnX, btnY, btnW = 120, btnH = 40;

  QueriesDate() {
    title = "Date Search";
    int queryW = 240;
    int queryH = 50;
    
    int centerX = width/2;
    int yq = height/4 +100;
    
    int spacing = 40;
    
    int xq  = centerX - queryW - spacing/2;
    int xq2 = centerX + spacing/2;

    // Standard Back Button
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
    
    // The Search Button
    buttons.add(new Button(centerX - 100, yq + 90, 200, 50, "Search flights", "dateOutput", 20, false));    
    // Initialize Input Boxes
    inputButton = new TextEntryButton(xq, yq, queryW, queryH, "MM/DD/YYYY", "date1", 15, 20, false, 1);
    inputButton2 = new TextEntryButton(xq2, yq, queryW, queryH, "MM/DD/YYYY", "date2", 15, 20, false, 2);
    
    buttons.add(inputButton);
    buttons.add(inputButton2);
  }
  void drawCard(){
    fill(255);
    rect(150, 200, width-300, 250, 20);
  
  }


  void drawContent() {
    drawCard();
    // Card title
    fill(RY_BG);
    textAlign(LEFT);
    textSize(22);
    text("Book your next trip", 150, height/3 - 65);

    for (Button b : buttons) {
      b.display();
    }
    
    textSize(18);
    fill(0);
    textAlign(LEFT);
    text("From:", inputButton.x, inputButton.y - 10);
    text("To:", inputButton2.x, inputButton2.y - 10);
  }

  void keyPressed(char k) {
    if (currentInput != null) {
      currentInput.addChar(k);
    }
  }

  void mousePressed() {
    currentInput = null;

    // 1. Handle Input Focus
    if (inputButton.over(mouseX, mouseY)) {
      currentInput = inputButton;
      if(inputButton.label.equals("MM/DD/YYYY")) inputButton.label = "";
    }
    if (inputButton2.over(mouseX, mouseY)) {
      currentInput = inputButton2;
      if(inputButton2.label.equals("MM/DD/YYYY")) inputButton2.label = "";
    }

    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        println("Clicked: " + b.type);
        
        if (b.type.equals("back")) goBack();
        
        
        if (b.type.equals("dateOutput")) {
          selection.dateStart = inputButton.label;
          selection.dateEnd = inputButton2.label;
          
          searchFlightsDateRange(); 
          
          goTo(flightsOutput); 
        }
      }
    }
  }
}


class TrafficScreen extends Screen {

  ArrayList<Route> east;
  ArrayList<Route> central;
  ArrayList<Route> west;
  RegionPieChart eastPie;
  RegionPieChart westPie;
  RegionPieChart centralPie;

  String currentZone = "East";  // "East", "Central", "West"

  Button backBtn;
  Button eastBtn, centralBtn, westBtn;

  TrafficScreen(ArrayList<Route> east,
                ArrayList<Route> central,
                ArrayList<Route> west) {
    title = "Traffic Analytics";
    this.east = east;
    this.central = central;
    this.west = west;
    eastPie = new RegionPieChart(eastCoastAirports);
    centralPie = new RegionPieChart(centralAirports);
    westPie = new RegionPieChart(westCoastAirports);

    // Back button
    backBtn = new Button(30, 22, 80, 30, "BACK", "back", 15, false);
    buttons.add(backBtn);

    // Zone selection buttons
    int buttonW = width/3-30; 
    int buttonH = 30;
    int spacing = 10;
    int y = 75;
    int xStart = width/2 - buttonW*3/2 - spacing;
    eastBtn    = new Button(xStart, y, buttonW, buttonH, "EAST-COAST", "east", 16, false);
    centralBtn = new Button(xStart + buttonW + spacing, y, buttonW, buttonH, "CENTRAL", "central", 16, false);
    westBtn    = new Button(xStart + (buttonW + spacing)*2, y, buttonW, buttonH, "WEST-COAST", "west", 16, false);

    buttons.add(eastBtn);
    buttons.add(centralBtn);
    buttons.add(westBtn);
  }


  void draw() {
    ui.drawNavbar(title);
    // Draw zone buttons with highlight for selected zone
    for (Button b : buttons) {
      if (b == eastBtn && currentZone.equals("East")) highlightButton(b);
      else if (b == centralBtn && currentZone.equals("Central")) highlightButton(b);
      else if (b == westBtn && currentZone.equals("West")) highlightButton(b);
      else b.display();  // normal button display
    }

    // Draw the routes panel for current zone
    ArrayList<Route> currentList;
    String zoneTitle;
    if (currentZone.equals("East")) {
      currentList = east;
      zoneTitle = "EAST COAST";
    } else if (currentZone.equals("Central")) {
      currentList = central;
      zoneTitle = "CENTRAL";
    } else {
      currentList = west;
      zoneTitle = "WEST COAST";
    }

    drawRoutesPanel(zoneTitle, currentList);
    if (currentZone.equals("East")) {
      eastPie.draw(width - 420, 150);
    }
    else if (currentZone.equals("Central")) {
      centralPie.draw(width - 420, 150);
    }
    else if (currentZone.equals("West")) {
      westPie.draw(width - 420, 150);
    }
  }

  void highlightButton(Button b) {
    // Draw a highlight background
    fill(255, 215, 0);  // golden highlight
    rect(b.x - 5, b.y - 5, b.w + 10, b.h + 10, 8);

    // Draw the button text on top
    b.display();
  }

  void drawRoutesPanel(String title, ArrayList<Route> routes) {
    float panelWidth = width -50;
    float panelHeight = 560;
    float x = width/2;
    float yStart = 120;

    // Panel background
    fill(RY_BG);
    rectMode(CENTER);
    rect(x, yStart + panelHeight/2, panelWidth, panelHeight, 20);
    rectMode(CORNER);

    // Panel title
    fill(0);
    textAlign(CENTER);
    textSize(40);
    text(title, x, yStart+60 - 20);

    // List routes
    fill(0);
    textAlign(LEFT);
    textSize(24);
    float padding = 30;
    float y = yStart+100;
    int rank = 1;

    for (Route r : routes) {
      text(rank + ". " + r.origin + " -> " + r.destination + " (" + r.passengers + ")", x - panelWidth/2 + padding, y);
      y += 22;
      rank++;
      if (y > yStart + panelHeight - 20) break;
    }
  }

  void mousePressed() {
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY)) {
        // Back button
        if (b.type.equals("back")) goBack();

        // Zone selection buttons
        if (b.type.equals("east")) currentZone = "East";
        if (b.type.equals("central")) currentZone = "Central";
        if (b.type.equals("west")) currentZone = "West";
      }
    }
  }
}
////////////////////////OUTPUT RESULTS OF QUERIES CHOOSEN //////////////////////////////////////
class FlightsOutputScreen extends Screen {

  float scrollY = 0;        // current scroll offset
  float scrollSpeed = 40;   // how much the list scrolls per mouse wheel tick
  float cardHeight = 110;   // height of each flight card
  float topMargin = 110;    // space from top before first card

  FlightsOutputScreen() {
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }

  void draw() {
    background(RY_BG); 
    fill(RY_BLUE);
    noStroke();
    rect(0, 0, width, 80); // header

    // Header Content
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    String route = selection.origin.toUpperCase() + " → " + selection.destination.toUpperCase();
    text(route, width/2, 35);

    textSize(14);
    fill(255, 200);
    text(results.size() + " flights found • " + selection.dateStart + " - " + selection.dateEnd, width/2, 60);

    // --- Draw the flights with scrolling ---
    pushMatrix();
    translate(0, scrollY); // move the origin by scroll offset
    if (results.size() > 0) {
      for (int i = 0; i < results.size(); i++) {
        drawFlightCard(width/2 - 450, topMargin + i * cardHeight, results.get(i));
      }
    } else {
      drawEmptyState();
    }
    popMatrix();

    for (Button b : buttons) b.display();
  }

  void drawFlightCard(float x, float y, Flight f) {
    float w = 900;
    float h = 100;

    fill(255);
    stroke(220);
    strokeWeight(1);
    rect(x, y, w, h, 8);

    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    text(f.date + " | Flight: " + f.carrier + " " + f.flightNumber, x + 20, y + 10);

    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(18);
    text(f.origin + " → " + f.destination, x + 20, y + 50);

    textSize(14);
    fill(120);
    text("Departure: " + formatTime(f.scheduledDepartureTime), x + 20, y + 75);
    text("Arrival: " + formatTime(f.scheduledArrivalTime), x + w - 200, y + 75);

    // SELECT button
    boolean isAlreadyBooked = bookedFlights.contains(f);

    if (isAlreadyBooked) 
    {
      fill(180); // Gray color
      noStroke();
      rect(x + w - 120, y + 25, 100, 50, 6);
      
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text("SELECTED", x + w - 70, y + 50);
     } 
     else 
     {
      fill(RY_GOLD);
      noStroke();
      rect(x + w - 120, y + 25, 100, 50, 6);
      
      fill(RY_BLUE);
      textAlign(CENTER, CENTER);
      textSize(16);
      text("SELECT", x + w - 70, y + 50);
    }
  }

  void drawEmptyState() {
    fill(150);
    textAlign(CENTER);
    textSize(20);
    text("No flights found for this route or date.", width/2, height/2);
  }

  void mousePressed() {
    // 1. Check BACK button
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) {
        goBack();
        return; 
      }
    }
  
    // 2. Check SELECT buttons for each flight
    for (int i = 0; i < results.size(); i++) {
      float cardX = width/2 - 450;
      float cardY = topMargin + i * cardHeight + scrollY; 
      float cardW = 900;
      float cardH = 100;
  
      float selectX = cardX + cardW - 120;
      float selectY = cardY + 25;
      float selectW = 100;
      float selectH = 50;
  
      if (mouseX > selectX && mouseX < selectX + selectW &&
          mouseY > selectY && mouseY < selectY + selectH) 
      {
        Flight selected = results.get(i);
        
        // This line ensures the code inside ONLY runs if the flight isn't there yet
        if (!bookedFlights.contains(selected)) {
          bookedFlights.add(selected);
          println("Flight added!");
        } else {
          println("Already in your list!");
        }
      }
    }
  }

  // SCROLLING with mouse wheel
  
  void scrollFlights(float e) {
  scrollY += -e * scrollSpeed;

  // Limit scrolling so content doesn't go too far
  float minScroll = min(0, height - (topMargin + results.size() * cardHeight));
  scrollY = constrain(scrollY, minScroll, 0);
  }
}

class Bookings extends Screen {
  float scrollY = 0;
  float scrollSpeed = 40;
  float cardHeight = 80; // Slimmer cards for the list
  float listX = 50;      // Positioned on the left
  
  Flight selectedForPass = null; // The flight currently being viewed as a boarding pass

  Bookings() {
    buttons.add(new Button(30, 22, 80, 30, "BACK", "back", 15, false));
  }

  void draw() {
    background(RY_BG);
    
    // --- HEADER ---
    fill(RY_BLUE);
    rect(0, 0, width, 80);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("MY BOOKED FLIGHTS", width/2, 40);

    // left side - flight list
    pushMatrix();
    translate(0, scrollY);
    for (int i = 0; i < bookedFlights.size(); i++) {
      drawFlightTab(listX, 120 + i * (cardHeight + 10), bookedFlights.get(i));
    }
    popMatrix();

    // Right side - boarding pass
    if (selectedForPass != null) {
      drawBoardingPass(width / 2 + 50, 120, selectedForPass);
    } else {
      fill(150);
      textAlign(CENTER);
      text("Select a flight to view boarding pass", width * 0.75, height / 2);
    }

    for (Button b : buttons) b.display();
  }

  // Slimmer card showing only Origin -> Destination
  void drawFlightTab(float x, float y, Flight f) {
    boolean isSelected = (f == selectedForPass);
    
    fill(isSelected ? RY_GOLD : 255);
    stroke(RY_BLUE);
    strokeWeight(isSelected ? 2 : 1);
    rect(x, y, width/3, cardHeight, 10);
    
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(18);
    text(f.origin + "  →  " + f.destination, x + 20, y + cardHeight/2);
    
    text(">", x + width/3 - 30, y + cardHeight/2);
  }

  void drawBoardingPass(float x, float y, Flight f) {
    float w = 400;
    float h = 500;
    
    // Pass Background
    fill(255);
    stroke(200);
    rect(x, y, w, h, 15);
    
    // Top Blue Bar
    fill(RY_BLUE);
    rect(x, y, w, 60, 15, 15, 0, 0);
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text("BOARDING PASS", x + w/2, y + 35);
    
    // Pass Details
    fill(50);
    textAlign(LEFT);
    textSize(14);
    float textY = y + 100;
    
    detailRow(x + 30, textY, "PASSENGER", "VALUED CUSTOMER");
    detailRow(x + 30, textY + 60, "FLIGHT", f.carrier + " " + f.flightNumber);
    detailRow(x + 30, textY + 120, "DATE", f.date);
    detailRow(x + 30, textY + 180, "FROM", f.originCityName + " (" + f.origin + ")");
    detailRow(x + 30, textY + 240, "TO", f.destinationCityName + " (" + f.destination + ")");
    detailRow(x + 30, textY + 300, "DEPARTS", formatTime(f.scheduledDepartureTime));
    
    // Barcode
    fill(0);
    for(int i=0; i<w-60; i+=4) {
      rect(x + 30 + i, y + h - 60, random(1, 3), 40);
    }
  }

  void detailRow(float x, float y, String label, String value) {
    fill(150);
    textSize(12);
    text(label, x, y);
    fill(RY_BLUE);
    textSize(18);
    text(value, x, y + 25);
  }

  void mousePressed() {
    // Back Button
    for (Button b : buttons) {
      if (b.over(mouseX, mouseY) && b.type.equals("back")) {
        goBack();
        return;
      }
    }

    // List selection logic
    for (int i = 0; i < bookedFlights.size(); i++) {
      float cardY = 120 + i * (cardHeight + 10) + scrollY;
      if (mouseX > listX && mouseX < listX + width/3 &&
          mouseY > cardY && mouseY < cardY + cardHeight) {
        selectedForPass = bookedFlights.get(i);
      }
    }
  }
}
