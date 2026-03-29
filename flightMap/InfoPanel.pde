class InfoPanel {
  // The flight currently shown in the panel (null = hidden)
  private FlightLocation currentFlight;

  void setFlight(FlightLocation f) {
    currentFlight = f;
  }

  // Safe getter — used in main draw() to avoid direct field access
  FlightLocation getFlight() {
    return currentFlight;
  }

  void display() {
    if (currentFlight == null) return;

    // Semi-transparent dark background box
    fill(0, 180);
    noStroke();
    rect(20, 65, 240, 170, 10);

    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    text("From:      " + currentFlight.origin,      30, 80);
    text("To:        " + currentFlight.destination,  30, 100);
    text("Departure: " + currentFlight.depTime,      30, 120);
    text("Arrival:   " + currentFlight.arrTime,      30, 140);
    text("Distance:  " + currentFlight.distance + " mi", 30, 160);
    text("Status:    " + currentFlight.status,       30, 180);
  }
}
