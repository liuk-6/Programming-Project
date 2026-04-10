public class UserSelection {//-------------- Nicolas - 16/03/26 - 30/03/26 --- stores user selections
  String destination;
  String origin;
  String dateStart;
  String dateEnd;

  UserSelection(String origin, String destination, String dateStart, String dateEnd) {
    this.destination = destination;
    this.origin = origin;
    this.dateStart = dateStart;
    this.dateEnd = dateEnd;
  }
}
