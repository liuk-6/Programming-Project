class Flight                                                            // Samuel Cumani, 22/03/2026, flight class to store each flight as an object with attributes for visualization 
{                                                                       // Revision: Nicolas Abrante, 27/03/2026, added functionality for further use 
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

  // Samuel Cumani, 22/03/2026, Constructor loads desired flight data (row x) from csv columns 
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

  // Nicolas Abrante, 27/03/2026, Format HHMM int to "HH:mm" string
  String formatTime(int t) {                                                         
    int h = t / 100;
    int m = t % 100;
    return nf(h, 2) + ":" + nf(m, 2); // ensures two digits
  }
  String info() {
    return date + " | " + carrier + " " + flightNumber +
           " : " + origin + " → " + destination +
           " | Dep: " + formatTime(scheduledDepartureTime) +
           " Arr: " + formatTime(scheduledArrivalTime);
  }

  // Nicolas Abrante, 27/03/2026, Get flight duration as "Xh Ym"
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
