Table table;

class FlightsToArray
{
  ArrayList<Flight> flights = new ArrayList<Flight>();
}

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
  
  Flight(int row)
  {
    int rowIndex = row;
  }
  
  void setup()
  {
    table = loadTable("flights2k.csv");
  }
}
