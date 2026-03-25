class FlightManager {
  ArrayList<FlightLocation> allFlights = new ArrayList<FlightLocation>();
  ArrayList<FlightLocation> filteredFlights = new ArrayList<FlightLocation>();

  void loadFromTable(Table table, AirportManager airportManager) {
    allFlights.clear();

    for (int row = 0; row < table.getRowCount(); row++) {

      Flight raw = new Flight(row);

      String originCode = raw.origin.trim().toUpperCase();
      String destCode = raw.destination.trim().toUpperCase();

      PVector origin = airportManager.getCoords(originCode);
      PVector dest = airportManager.getCoords(destCode);

      int schedDep = raw.scheduledDepartureTime;
      int actualDep = raw.actualDepartureTime;
      boolean cancelled = raw.cancelled;

      String status;

      if (cancelled) {
        status = "CANCELLED";
      } else {
        int delay = timeToMinutes(actualDep) - timeToMinutes(schedDep);
        if (delay > 30) {
          status = "DELAYED";
        } else {
          status = "ON_TIME";
        }
      }
      if (origin != null && dest != null) {

        float oLat = origin.x;
        float oLon = origin.y;
        float dLat = dest.x;
        float dLon = dest.y;

        // ✅ Skip Alaska, Hawaii, etc.
        if (oLat < 24 || oLat > 50 || dLat < 24 || dLat > 50) {
          continue;
        }

        // ✅ ONLY create flight once
        FlightLocation f = new FlightLocation(
          originCode,
          destCode,
          oLat, oLon,
          dLat, dLon,
          str(raw.scheduledDepartureTime),
          str(raw.scheduledArrivalTime),
          raw.distance,
          raw.date,
          status
          );

        allFlights.add(f);
      } else {
        println("Missing airport:", originCode, destCode);
      }
    }

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


  int timeToMinutes(int t) {
    int hours = t / 100;
    int mins = t % 100;
    return hours * 60 + mins;
  }
}
