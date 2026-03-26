class Route {
  String origin;
  String destination;
  int passengers; // optional: number of passengers or traffic count

  Route(String origin, String destination, int passengers) {
    this.origin = origin;
    this.destination = destination;
    this.passengers = passengers;
  }
}
