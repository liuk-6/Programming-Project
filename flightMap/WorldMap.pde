class WorldMap{
  PShape mapShape;

  // Use viewBox values
  float svgMinX = 111/10;
  float svgMinY = -25/10;
  float svgWidth = 93781/100;
  float svgHeight = 545;

  // Continental US bounds for lat/lon
  float minLon = -125;
  float maxLon = -66;
  float minLat = 24;
  float maxLat = 50;

  WorldMap(String filename) {
    mapShape = loadShape(filename);
  }
  void display(float x, float y, float w, float h) {

    float scale = min(w / svgWidth, h / svgHeight);

    float drawW = svgWidth * scale;
    float drawH = svgHeight * scale;

    float offsetX = x + (w - drawW) / 2;
    float offsetY = y + (h - drawH) / 2;

    shape(mapShape, offsetX, offsetY, drawW, drawH);
  }

  PVector geoToScreen(float lat, float lon, float x, float y, float w, float h) {

    float px = map(lon, minLon, maxLon, svgMinX, svgMinX + svgWidth);
    float py = map(lat, maxLat, minLat, svgMinY, svgMinY + svgHeight);

    float scale = min(w / svgWidth, h / svgHeight);

    float drawW = svgWidth * scale;
    float drawH = svgHeight * scale;

    float offsetX = x + (w - drawW) / 2;
    float offsetY = y + (h - drawH) / 2;

    return new PVector(
      offsetX + (px - svgMinX) * scale,
      offsetY + (py - svgMinY) * scale
      );
  }
}
