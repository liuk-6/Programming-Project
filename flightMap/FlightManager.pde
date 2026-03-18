class FlightManager {
  ArrayList<FlightLocation> allFlights = new ArrayList<FlightLocation>();
  ArrayList<FlightLocation> filteredFlights = new ArrayList<FlightLocation>();

  void loadFromTable(Table table, AirportManager airportManager) {
    allFlights.clear();

    for (int row = 0; row < table.getRowCount(); row++) {

      // Step 1: get raw flight from your friend's class
      Flight raw = new Flight(row);

      String originCode = raw.origin.trim().toUpperCase();
      String destCode = raw.destination.trim().toUpperCase();

      // Step 2: get coordinates
      PVector origin = airportManager.getCoords(originCode);
      PVector dest = airportManager.getCoords(destCode);

      // Step 3: only create flight if both airports exist
      if (origin != null && dest != null) {

        FlightLocation f = new FlightLocation(
          originCode,
          destCode,
          origin.x, origin.y,
          dest.x, dest.y,
          str(raw.scheduledDepartureTime),
          str(raw.scheduledArrivalTime),
          raw.distance,
          raw.date
          );

        allFlights.add(f);
      } else {
        println("Missing airport:", originCode, destCode);
      }
    }

    // default: show all flights
    filteredFlights = new ArrayList<FlightLocation>(allFlights);
  }

  void filterByDate(String date) {
    filteredFlights.clear();
    for (FlightLocation f : allFlights) {
      if (f.date.equals(date)) {
        filteredFlights.add(f);
      }
    }
  }

  ArrayList<FlightLocation> getFlights() {
    return filteredFlights;
  }
}
