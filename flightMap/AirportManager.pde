class AirportManager {
  HashMap<String, PVector> airports = new HashMap<String, PVector>();

  void loadAirports(String filename) {
    String[] lines = loadStrings(filename);

    for (String line : lines) {
      String[] parts = split(line, ",");
      
      String code = parts[0].trim();
      float lat = float(parts[1]);
      float lon = float(parts[2]);

      airports.put(code, new PVector(lat, lon));
    }
  }

  PVector getCoords(String code) {
    return airports.get(code);
  }

  boolean hasAirport(String code) {
    return airports.containsKey(code);
  }  
}
