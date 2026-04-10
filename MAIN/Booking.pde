class Booking { // Samuel Cumani, 04/04/2026, Returns a simple string representation for display in BookingsScreen
  Flight flight; 
  String passengerName;

  Booking(Flight flight, String passengerName) {
    this.flight = flight;
    this.passengerName = passengerName;
  }

   
  String info() {
    return flight.flightNumber + " | " + flight.origin + " → " + flight.destination +
           " | " + flight.date + " | " + passengerName;
  }
}
