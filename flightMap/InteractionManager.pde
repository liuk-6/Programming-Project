class InteractionManager {

  FlightLocation checkClick(ArrayList<FlightLocation> flights, float mx, float my, WorldMap map) {
    for (FlightLocation f : flights) {
      if (f.isClicked(mx, my, map)) {
        return f;
      }
    }
    return null;
  }
}
