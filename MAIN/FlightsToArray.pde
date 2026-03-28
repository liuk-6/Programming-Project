class Flight {
  String date;
  String carrier;
  int flightNumber;
  String origin;
  String originCityName;
  String destination;
  String destinationCityName;
  int scheduledDepartureTime; // in HHMM, e.g., 930
  int actualDepartureTime;
  int scheduledArrivalTime;
  int actualArrivalTime;
  boolean cancelled;
  boolean diverted;
  int distance;

  // Constructor from table row
  Flight(int rowIndex) {
    date = table.getRow(rowIndex).getString("FL_DATE").split(" ")[0];
    carrier = table.getRow(rowIndex).getString("MKT_CARRIER");
    flightNumber = table.getRow(rowIndex).getInt("MKT_CARRIER_FL_NUM");
    origin = table.getRow(rowIndex).getString("ORIGIN");
    originCityName = table.getRow(rowIndex).getString("ORIGIN_CITY_NAME");
    destination = table.getRow(rowIndex).getString("DEST");
    destinationCityName = table.getRow(rowIndex).getString("DEST_CITY_NAME");
    scheduledDepartureTime = table.getRow(rowIndex).getInt("CRS_DEP_TIME");
    actualDepartureTime = table.getRow(rowIndex).getInt("DEP_TIME");
    scheduledArrivalTime = table.getRow(rowIndex).getInt("CRS_ARR_TIME");
    actualArrivalTime = table.getRow(rowIndex).getInt("ARR_TIME");
    cancelled = table.getRow(rowIndex).getInt("CANCELLED") == 1;
    diverted = table.getRow(rowIndex).getInt("DIVERTED") == 1;
    distance = table.getRow(rowIndex).getInt("DISTANCE");
  }

  // Format HHMM int to "HH:mm" string
  String formatTime(int t) {
    int h = t / 100;
    int m = t % 100;
    return nf(h, 2) + ":" + nf(m, 2); // ensures two digits
  }

  // Get flight duration as "Xh Ym"
  String getDuration() {
    int depMin = (scheduledDepartureTime / 100) * 60 + (scheduledDepartureTime % 100);
    int arrMin = (scheduledArrivalTime / 100) * 60 + (scheduledArrivalTime % 100);

    int diff = arrMin - depMin;
    if (diff < 0) diff += 24 * 60; // overnight flights

    int hours = diff / 60;
    int minutes = diff % 60;

    return hours + "h " + minutes + "m";
  }
}
