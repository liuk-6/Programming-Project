class InfoPanel{
  FlightLocation selected;

  void setFlight(FlightLocation f) {
    selected = f;
  }

  void display() {
    if (selected == null) return;

    fill(0, 180);
    rect(20, 65, 240, 165, 10);

    fill(255);
    textSize(14);

    text("From: " + selected.origin, 30, 85);
    text("To: " + selected.destination, 30, 105);
    text("Departure: " + selected.depTime, 30, 125);
    text("Arrival: " + selected.arrTime, 30, 145);
    text("Distance: " + selected.distance + " km", 30, 165);
  }
}
