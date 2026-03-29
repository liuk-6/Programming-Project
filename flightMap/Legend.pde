
class Legend{

  void display() {
    float x = width - 220;
    float y = height -150;

    fill(0, 180);
    noStroke();
    rect(x, y, 200, 220, 10);

    textSize(14);
    fill(255);
    text("Flight Status", x + 20, y + 30);

    if (statusFilter.equals("ON_TIME")) strokeWeight(5);
    else strokeWeight(3);
    stroke(0, 200, 0);
    line(x + 20, y + 50, x + 60, y + 50);
    fill(255);
    text("On Time", x + 70, y + 55);

    if (statusFilter.equals("DELAYED")) strokeWeight(5);
    else strokeWeight(3);
    stroke(255, 165, 0);
    line(x + 20, y + 75, x + 60, y + 75);
    fill(255);
    text("Delayed", x + 70, y + 80);

    if (statusFilter.equals("CANCELLED")) strokeWeight(5);
    else strokeWeight(3);
    stroke(255, 0, 0);
    line(x + 20, y + 100, x + 60, y + 100);
    fill(255);
    text("Cancelled", x + 70, y + 105);

    stroke(0, 100, 255);
    line(x + 20, y + 125, x + 60, y + 125);
    fill(255);
    text("Selected", x + 70, y + 130);

    fill(255);
    textSize(13);
    text("Airports", x + 20, y + 150);

    fill(255, 0, 0);
    ellipse(x + 30, y + 170, 8, 8);
    fill(255);
    text("Selectable Airport", x + 45, y + 160);

    fill(0);
    ellipse(x + 30, y + 195, 6, 6);
    fill(255);
    text("Other Airport", x + 45, y + 170);
  }

  String checkClick(float mx, float my) {
    float x = width - 220;
    float y = height - 150;

    if (over(mx, my, x, y + 35, 200, 25)) return "ON_TIME";
    if (over(mx, my, x, y + 60, 200, 25)) return "DELAYED";
    if (over(mx, my, x, y + 85, 200, 25)) return "CANCELLED";
    if (over(mx, my, x, y + 110, 200, 25)) return "ALL";

    return null;
  }

  boolean over(float mx, float my, float x, float y, float w, float h) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}   
