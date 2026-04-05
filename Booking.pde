class Booking {
  Flight flight;
  String passengerName;

  Booking(Flight flight, String passengerName) {
    this.flight = flight;
    this.passengerName = passengerName;
  }

  // Returns a simple string representation for display in BookingsScreen
  String info() {
    return flight.flightNumber + " | " + flight.origin + " → " + flight.destination +
           " | " + flight.date + " | " + passengerName;
  }
}
