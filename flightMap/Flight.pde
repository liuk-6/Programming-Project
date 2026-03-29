class Flight{
  String date;
  String carrier;
  int    flightNumber;
  String origin;
  String originCityName;
  String destination;
  String destinationCityName;
  int    scheduledDepartureTime;
  int    actualDepartureTime;
  int    scheduledArrivalTime;
  int    actualArrivalTime;
  boolean cancelled;
  boolean diverted;
  int    distance;

  // Reads one CSV row by index using the global table
  Flight(int rowIndex) {
    TableRow row = table.getRow(rowIndex);

    date = row.getString("FL_DATE");
    carrier = row.getString("MKT_CARRIER");
    flightNumber = row.getInt("MKT_CARRIER_FL_NUM");
    origin = row.getString("ORIGIN");
    originCityName = row.getString("ORIGIN_CITY_NAME");
    destination  = row.getString("DEST");
    destinationCityName = row.getString("DEST_CITY_NAME");
    scheduledDepartureTime = row.getInt("CRS_DEP_TIME");
    actualDepartureTime = row.getInt("DEP_TIME");
    scheduledArrivalTime = row.getInt("CRS_ARR_TIME");
    actualArrivalTime = row.getInt("ARR_TIME");
    cancelled = (row.getInt("CANCELLED") == 1);
    diverted = (row.getInt("DIVERTED")  == 1);
    distance = row.getInt("DISTANCE");
  }
}
