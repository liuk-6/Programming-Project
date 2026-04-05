class AirportButton {
  float x, y, w, h;
  String code;

  AirportButton(float x, float y, float w, float h, String code) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.code = code;
  }

  boolean isInside(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}
