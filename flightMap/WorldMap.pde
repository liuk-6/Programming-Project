class WorldMap {
  PShape mapShape;

  // SVG viewBox origin and size (from the usa.svg file)
  float svgMinX  =  11.1;
  float svgMinY  =  -2.5;
  float svgWidth = 937.81;
  float svgHeight = 545.0;

  // Geographic bounds of the continental US
  float minLon = -125, maxLon = -66;
  float minLat =   24, maxLat =  50;

  WorldMap(String filename) {
    mapShape = loadShape(filename);
  }

  // Draw the SVG scaled and centred inside the content area
  void display(float x, float y, float w, float h) {
    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;
    shape(mapShape, offsetX, offsetY, svgWidth * scale, svgHeight * scale);
  }

  // Convert geographic (lat, lon) to screen (px, py)
  PVector geoToScreen(float lat, float lon,
                      float x, float y, float w, float h) {
    // Map lon → SVG x, lat → SVG y (note: lat is flipped)
    float px = map(lon, minLon, maxLon, svgMinX, svgMinX + svgWidth);
    float py = map(lat, maxLat, minLat, svgMinY, svgMinY + svgHeight);

    float scale   = min(w / svgWidth, h / svgHeight);
    float offsetX = x + (w - svgWidth  * scale) / 2;
    float offsetY = y + (h - svgHeight * scale) / 2;

    return new PVector(
      offsetX + (px - svgMinX) * scale,
      offsetY + (py - svgMinY) * scale
    );
  }
}
