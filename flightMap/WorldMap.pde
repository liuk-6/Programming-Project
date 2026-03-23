class WorldMap {
  PShape mapShape;

  // Use viewBox values
  float svgMinX = 11.1;
  float svgMinY = -2.5;
  float svgWidth = 937.81;
  float svgHeight = 545;

  // Continental US bounds for lat/lon
  float minLon = -125;
  float maxLon = -66;
  float minLat = 24;
  float maxLat = 50;

  WorldMap(String filename) {
    mapShape = loadShape(filename);
  }

  void display() {
    float scale = min(width / svgWidth, height / svgHeight);

    float drawW = svgWidth * scale;
    float drawH = svgHeight * scale;

    float offsetX = (width - drawW) / 2;
    float offsetY = (height - drawH) / 2;

    shape(mapShape, offsetX, offsetY, drawW, drawH);
  }

  PVector geoToScreen(float lat, float lon) {
    // Map lon/lat to SVG coordinates
    float x = map(lon, minLon, maxLon, svgMinX, svgMinX + svgWidth);
    float y = map(lat, maxLat, minLat, svgMinY, svgMinY + svgHeight);

    // Scale to screen
    float scale = min(width / svgWidth, height / svgHeight);
    float drawW = svgWidth * scale;
    float drawH = svgHeight * scale;

    float offsetX = (width - drawW) / 2;
    float offsetY = (height - drawH) / 2;

    return new PVector(
      offsetX + (x - svgMinX) * scale,
      offsetY + (y - svgMinY) * scale
    );
  }
}
