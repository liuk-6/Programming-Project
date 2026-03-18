class InfoPanel{
  FlightLocation selected;

  void setFlight(FlightLocation f) {
    selected = f;
  }

  void display() {
    if (selected == null) return;

    fill(0, 180);
    rect(20, 20, 300, 140, 10);

    fill(255);
    textSize(14);

    text("From: " + selected.origin, 30, 50);
    text("To: " + selected.destination, 30, 70);
    text("Departure: " + selected.depTime, 30, 90);
    text("Arrival: " + selected.arrTime, 30, 110);
    text("Distance: " + selected.distance + " km", 30, 130);
  }
}
