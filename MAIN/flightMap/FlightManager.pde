class FlightManager {
  ArrayList<FlightLocation> allFlights      = new ArrayList<FlightLocation>();
  ArrayList<FlightLocation> filteredFlights = new ArrayList<FlightLocation>();

  // Only flights involving these airports are shown
  HashSet<String> allowedAirports = new HashSet<String>();

  // How many minutes late counts as a delay
  final int DELAY_THRESHOLD = 30;

  void loadFromTable(Table table, LocationManager loc) {
    allFlights.clear();

    // Define the airports we want to show
    String[] airports = { "DFW","ATL","CLT","ORD","DEN",
                          "LAX","PHX","SEA","LGA","MCO" };
    for (String a : airports) allowedAirports.add(a);

    for (int row = 0; row < table.getRowCount(); row++) {
      Flight raw = new Flight(row);

      String originCode = raw.origin.trim().toUpperCase();
      String destCode   = raw.destination.trim().toUpperCase();

      // Skip if either airport has no coordinates
      PVector origin = loc.getCoords(originCode);
      PVector dest   = loc.getCoords(destCode);
      if (origin == null || dest == null) {
        println("Missing coords for:", originCode, destCode);
        continue;
      }

      // Restrict to continental US latitude band
      float oLat = origin.x, oLon = origin.y;
      float dLat = dest.x,   dLon = dest.y;
      if (oLat < 24 || oLat > 50 || dLat < 24 || dLat > 50) continue;

      // Compute status
      String status;
      if (raw.cancelled) {
        status = "CANCELLED";
      } else {
        int delay = timeToMinutes(raw.actualDepartureTime)
                  - timeToMinutes(raw.scheduledDepartureTime);
        status = (delay > DELAY_THRESHOLD) ? "DELAYED" : "ON_TIME";
      }

      allFlights.add(new FlightLocation(
        originCode, destCode,
        oLat, oLon, dLat, dLon,
        str(raw.scheduledDepartureTime),
        str(raw.scheduledArrivalTime),
        raw.distance, raw.date, status
      ));
    }

    // Start with all flights visible
    filteredFlights = new ArrayList<FlightLocation>(allFlights);
  }

  // Optional: filter to a single date
  void filterByDate(String date) {
    filteredFlights.clear();
    for (FlightLocation f : allFlights) {
      if (f.date.equals(date)) filteredFlights.add(f);
    }
  }

  ArrayList<FlightLocation> getFlights() {
    return filteredFlights;
  }

  // Converts a time integer like 1435 → minutes (14*60 + 35 = 875)
  int timeToMinutes(int t) {
    return (t / 100) * 60 + (t % 100);
  }
}
