class LocationManager {
  // Maps airport code → PVector(lat, lon)
  HashMap<String, PVector> locations = new HashMap<String, PVector>();

  // Expects CSV lines in the format: CODE,lat,lon
  void loadLocations(String filename) {
    String[] lines = loadStrings(filename);
    if (lines == null) {
      println("LocationManager: file not found ->", filename);
      return;
    }

    for (String line : lines) {
      line = trim(line);
      if (line.length() == 0) continue;

      String[] parts = split(line, ",");
      if (parts.length < 3) continue;

      try {
        String code = trim(parts[0]).toUpperCase();
        float  lat  = Float.valueOf(trim(parts[1]));
        float  lon  = Float.valueOf(trim(parts[2]));
        locations.put(code, new PVector(lat, lon));
      } catch (Exception e) {
        println("LocationManager: skipping bad line:", line);
      }
    }
  }

  PVector getCoords(String code)    { return locations.get(code); }
  boolean hasLocation(String code)  { return locations.containsKey(code); }
}
