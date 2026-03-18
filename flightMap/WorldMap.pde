class WorldMap {
  PImage mapImg;

  WorldMap(String filename) {
    mapImg = loadImage(filename);
  }

  void display() {
    image(mapImg, 0, 0, width, height);
  }

  PVector geoToScreen(float lat, float lon) {

    // USA bounds (approx)
    float minLon = -173;
    float maxLon = -66;
    float minLat = 17;
    float maxLat = 71;

    float x = map(lon, minLon, maxLon, 0, width);
    float y = map(lat, maxLat, minLat, 0, height);

    return new PVector(x, y);
  }
}
