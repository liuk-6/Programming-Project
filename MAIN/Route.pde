class Route {
  String origin;
  String destination;
  int passengers;
  int cancelled;
  int delayed;
  int onTime;
  float cancelRate;
  float delayRate;
  float onTimeRate;

  Route(String origin, String destination, int passengers) {
    this.origin      = origin;
    this.destination = destination;
    this.passengers  = passengers;
    this.cancelled   = 0;
    this.delayed     = 0;
    this.onTime      = 0;
    this.cancelRate  = 0;
    this.delayRate   = 0;
    this.onTimeRate  = 0;
  }
}
