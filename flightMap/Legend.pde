class Legend {

  void display() {
    float x = width - 220;
    float y = 20;

    // background box
    fill(0, 180);
    noStroke();
    rect(x, y, 200, 140, 10);

    textSize(14);
    fill(255);
    text("Flight Status", x + 20, y + 30);

    // 🟢 ON TIME
    stroke(0, 200, 0);
    strokeWeight(3);
    line(x + 20, y + 50, x + 60, y + 50);
    fill(255);
    text("On Time", x + 70, y + 55);

    // 🟠 DELAYED
    stroke(255, 165, 0);
    line(x + 20, y + 75, x + 60, y + 75);
    fill(255);
    text("Delayed", x + 70, y + 80);

    // 🔴 CANCELLED
    stroke(255, 0, 0);
    line(x + 20, y + 100, x + 60, y + 100);
    fill(255);
    text("Cancelled", x + 70, y + 105);

    // 🔵 SELECTED
    stroke(0, 100, 255);
    line(x + 20, y + 125, x + 60, y + 125);
    fill(255);
    text("Selected", x + 70, y + 130);
  }
}
