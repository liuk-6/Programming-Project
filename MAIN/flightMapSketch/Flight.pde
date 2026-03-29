class Flight
{
  String date;
  String carrier;
  int flightNumber;
  String origin;
  String originCityName;
  String destination;
  String destinationCityName;
  int scheduledDepartureTime;
  int actualDepartureTime;
  int scheduledArrivalTime;
  int actualArrivalTime;
  boolean cancelled;
  boolean diverted;
  int distance;
  
  Flight(int rowIndex)
  {
    date = table.getRow(rowIndex).getString("FL_DATE");
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
    cancelled = (table.getRow(rowIndex).getInt("CANCELLED") == 1) ? true : false;
    diverted = (table.getRow(rowIndex).getInt("DIVERTED") == 1) ? true : false;
    distance = table.getRow(rowIndex).getInt("DISTANCE");
  }
}
