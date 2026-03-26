class FlightCard {
  float x, y, w, h;
  Flight f;

  FlightCard(float x, float y, Flight f) {
    this.x = x;
    this.y = y;
    this.w = 900;
    this.h = 110;
    this.f = f;
  }

  void display() {
    // 1. Card Background
    fill(255);
    stroke(230);
    strokeWeight(1);
    rect(x, y, w, h, 8);

    // 2. Top Bar: Date & Flight Number
    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    text(formatDate(f.date) + "  |  " + f.carrier + " " + f.flightNumber, x + 30, y + 15);

    // 3. Departure Info (Left)
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(22);
    text(formatTime(f.scheduledDepartureTime), x + 30, y + 55);
    textSize(14);
    fill(100);
    text(f.origin, x + 30, y + 80);

    // 4. Journey Line
    stroke(200);
    float startX = x + 120;
    float endX = x + w - 350;
    float midX = (startX + endX)/2;
    line(startX, y + 65, endX, y + 65);
    fill(RY_BLUE);
    textSize(12);
    textAlign(CENTER);
    text("DIRECT", midX, y + 55);
    triangle(endX - 10, y + 60, endX, y + 65, endX - 10, y + 70);

    // 5. Arrival Info (Right)
    fill(0);
    textAlign(RIGHT, CENTER);
    textSize(22);
    text(formatTime(f.scheduledArrivalTime), x + w - 250, y + 55);
    textSize(14);
    fill(100);
    text(f.destination, x + w - 250, y + 80);

    // 6. Price/Action Area
    fill(RY_YELLOW);
    noStroke();
    rect(x + w - 180, y + 25, 150, 60, 5);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("SELECT", x + w - 105, y + 55);
    
    // Inside FlightCard.display()
    boolean isSelected = selectedFlights.contains(f);
    
    fill(isSelected ? color(0, 200, 0) : RY_YELLOW); // Green if selected, yellow otherwise
    noStroke();
    rect(x + w - 180, y + 25, 150, 60, 5);
    
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(isSelected ? "SELECTED" : "SELECT", x + w - 105, y + 55);
  }

  boolean clickSelect() {
    return mouseX > x + w - 180 && mouseX < x + w - 30 && mouseY > y + 25 && mouseY < y + 85;
  }
  void mousePressed() {
  // Check if any FlightCard's SELECT was clicked
  for (FlightCard fc : allFlightCards) { // assuming you store them in an ArrayList<FlightCard>
    if (fc.clickSelect()) {
      // Add flight to selectedFlights if not already added
      if (!selectedFlights.contains(fc.f)) {
        selectedFlights.add(fc.f);
        println("Flight selected: " + fc.f.carrier + " " + fc.f.flightNumber);
      }
    }
  }
 }
}
