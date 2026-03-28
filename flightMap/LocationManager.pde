class LocationManager {

  // Stores code → (lat, lon)
  HashMap<String, PVector> locations = new HashMap<String, PVector>();

  // Load locations from CSV file
  void loadLocations(String filename) {
    String[] lines = loadStrings(filename);

    if (lines == null) {
      println("Error: file not found -> " + filename);
      return;
    }

    for (String line : lines) {

      line = trim(line);
      if (line.length() == 0) continue;

      String[] parts = split(line, ",");

      // Ensure valid format
      if (parts.length < 3) continue;

      try {
        String code = trim(parts[0]).toUpperCase();
        float lat = float(trim(parts[1]));
        float lon = float(trim(parts[2]));

        locations.put(code, new PVector(lat, lon));

      } catch (Exception e) {
        println("Skipping bad line: " + line);
      }
    }
  }

  // Get coordinates for a location
  PVector getCoords(String code) {
    return locations.get(code);
  }

  // Check if location exists
  boolean hasLocation(String code) {
    return locations.containsKey(code);
  }
}
