class FlightCard {
  float x, y, w, h;
  Flight f;

  FlightCard(float x, float y, Flight f) {
    this.x = x;
    this.y = y;
    this.w = 900; 
    this.h = 110; // Slightly taller to fit the date
    this.f = f;
  }

  void display() {
    // 1. Card Background
    fill(255);
    stroke(230); 
    strokeWeight(1);
    rect(x, y, w, h, 8); 
    
    // 2. NEW: Top Bar (Date & Flight Number)
    fill(RY_BLUE);
    textAlign(LEFT, TOP);
    textSize(12);
    // Shows the Date and Carrier/Number (e.g., "01/02/2022 | WN 103")
    text(f.date + "  |  " + f.carrier + " " + f.flightNumber, x + 30, y + 15);

    // 3. Departure Info (Left)
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(22);
    text(formatTime(f.scheduledDepartureTime), x + 30, y + 55); // Adjusted Y
    textSize(14);
    fill(100);
    text(f.origin, x + 30, y + 80);

    // 4. The Journey Line (Middle)
    stroke(200);
    line(x + 120, y + 65, x + w - 350, y + 65);
    fill(RY_BLUE);
    textSize(12);
    textAlign(CENTER);
    text("DIRECT", (x + 120 + x + w - 350)/2, y + 55);
    triangle(x + w - 360, y + 60, x + w - 350, y + 65, x + w - 360, y + 70);

    // 5. Arrival Info (Right)
    fill(0);
    textAlign(RIGHT, CENTER);
    textSize(22);
    text(formatTime(f.scheduledArrivalTime), x + w - 250, y + 55);
    textSize(14);
    fill(100);
    text(f.destination, x + w - 250, y + 80);

    // 6. Price/Action Area (Ryanair Yellow)
    fill(#F4CA35);
    noStroke();
    rect(x + w - 180, y + 25, 150, 60, 5);
    fill(RY_BLUE);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("SELECT", x + w - 105, y + 55); 
  }
}
