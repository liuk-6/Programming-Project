class LocationManager {
  HashMap<String, PVector> locations = new HashMap<String, PVector>();

  void loadLocations(String filename) {
    String[] lines = loadStrings(filename);

    for (String line : lines) {
      String[] parts = split(line, ",");
      String name = parts[0];
      float lat = float(parts[1]);
      float lon = float(parts[2]);

      locations.put(name, new PVector(lat, lon));
    }
  }

  PVector getLocation(String name) {
    return locations.get(name);
  }
}
