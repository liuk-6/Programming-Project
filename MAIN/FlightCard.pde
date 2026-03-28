class FlightCard {
  float x, y, w, h;
  Flight f;

  FlightCard(float x, float y, Flight f) {
    this.x = x;
    this.y = y;
    this.w = 900;
    this.h = 120; // slightly taller for modern feel
    this.f = f;
  }

  void display() {
    boolean hovering = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    boolean isSelected = selectedFlights.contains(f);

    // 1. Card background with hover effect
    pushStyle();
    fill(255);
    stroke(hovering ? 180 : 230);
    strokeWeight(hovering ? 2 : 1);
    rect(x, y, w, h, 10);
    popStyle();

    // 2. Top bar: date & flight number
    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    text(formatDate(f.date) + "  |  " + f.carrier + " " + f.flightNumber, x + 30, y + 10);

    // 3. Departure info (left)
    fill(0);
    textSize(26);
    textAlign(LEFT, CENTER);
    text(formatTime(f.scheduledDepartureTime), x + 30, y + 60);

    textSize(14);
    fill(100);
    text(f.origin, x + 30, y + 90);

    // 4. Journey line with duration
    float startX = x + 150;
    float endX = x + w - 350;
    float midX = (startX + endX)/2;

    stroke(200);
    strokeWeight(1);
    line(startX, y + 70, endX, y + 70);

    fill(RY_BLUE);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("DIRECT", midX, y + 60);

    fill(80);
    text(f.getDuration(), midX, y + 85);
    triangle(endX - 10, y + 65, endX, y + 70, endX - 10, y + 75);

    // 5. Arrival info (right)
    fill(0);
    textSize(26);
    textAlign(RIGHT, CENTER);
    text(formatTime(f.scheduledArrivalTime), x + w - 250, y + 60);

    textSize(14);
    fill(100);
    text(f.destination, x + w - 250, y + 90);

    // 6. SELECT button
    fill(isSelected ? color(0, 200, 0) : RY_YELLOW);
    noStroke();
    rect(x + w - 180, y + 30, 150, 60, 8);

    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(isSelected ? "SELECTED" : "SELECT", x + w - 105, y + 60);
  }

  // Check if SELECT button was clicked
  boolean clickSelect() {
    return mouseX > x + w - 180 && mouseX < x + w - 30 && mouseY > y + 30 && mouseY < y + 90;
  }

  // Handle clicks
  void mousePressed() {
    if (clickSelect()) {
      if (!selectedFlights.contains(f)) {
        selectedFlights.add(f);
        println("Flight selected: " + f.carrier + " " + f.flightNumber);
      } else {
        selectedFlights.remove(f);
        println("Flight deselected: " + f.carrier + " " + f.flightNumber);
      }
    }
  }
}
