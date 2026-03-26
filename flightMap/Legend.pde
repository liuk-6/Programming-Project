class Legend {

  void display() {
    float x = width - 220;
    float y = height -150;

    // background box
    fill(0, 180);
    noStroke();
    rect(x, y, 200, 140, 10);

    textSize(14);
    fill(255);
    text("Flight Status", x + 20, y + 30);

    //ON TIME
    // 🟢 ON TIME
    if (statusFilter.equals("ON_TIME")) {
      strokeWeight(5); // highlight
    } else {
      strokeWeight(3);
    }
    stroke(0, 200, 0);
    line(x + 20, y + 50, x + 60, y + 50);
    fill(255);
    text("On Time", x + 70, y + 55);

    //DELAYED
    if (statusFilter.equals("DELAYED")) {
      strokeWeight(5); // highlight
    } else {
      strokeWeight(3);
    }
    stroke(255, 165, 0);
    line(x + 20, y + 75, x + 60, y + 75);
    fill(255);
    text("Delayed", x + 70, y + 80);

    //CANCELLED
    if (statusFilter.equals("CANCELLED")) {
      strokeWeight(5); // highlight
    } else {
      strokeWeight(3);
    }
    stroke(255, 0, 0);
    line(x + 20, y + 100, x + 60, y + 100);
    fill(255);
    text("Cancelled", x + 70, y + 105);

    //ELECTED
    stroke(0, 100, 255);
    line(x + 20, y + 125, x + 60, y + 125);
    fill(255);
    text("Selected", x + 70, y + 130);
  }


  String checkClick(float mx, float my) {

    float x = width - 220;
    float y = height - 150;

    if (over(mx, my, x + 10, y + 25, 180, 25)) return "ON_TIME";
    if (over(mx, my, x + 10, y + 55, 180, 25)) return "DELAYED";
    if (over(mx, my, x + 10, y + 85, 180, 25)) return "CANCELLED";
    if (over(mx, my, x + 10, y + 115, 180, 25)) return "ALL";

    return null;
  }

  void drawItem(float x, float y, String value, String label, int c) {

    // Highlight if active
    if (statusFilter.equals(value)) {
      fill(255, 255, 255, 60);
      rect(x + 10, y - 15, 180, 25, 5);
    }

    stroke(c);
    strokeWeight(3);
    line(x + 20, y, x + 60, y);

    fill(255);
    text(label, x + 70, y + 5);
  }
  boolean over(float mx, float my, float x, float y, float w, float h) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
