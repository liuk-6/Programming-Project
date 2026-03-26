class Button {
  float x, y, w, h;
  String label, type;
  int textSize;
  boolean hasShadow;

  Button(float x, float y, float w, float h, String label, String type, int textSize, boolean hasShadow) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.label = label; this.type = type; this.textSize = textSize; this.hasShadow = hasShadow;
  }

  void display() {
    boolean hovers = over(mouseX, mouseY);

    if (hasShadow) {
      noStroke();
      fill(0, 40);
      rect(x + 2, y + 4, w, h, 8);
    }

    if (type.equals("flightsOutput")) {
      noStroke();
      fill(hovers ? color(255, 215, 0) : RY_YELLOW);
      rect(x, y, w, h, 8);
      fill(RY_BLUE);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(label, x + w/2, y + h/2 - 3);
    } else if (type.equals("back") || type.equals("backQ")) {
      stroke(255, 180);
      strokeWeight(1);
      fill(hovers ? color(255,30) : color(0,0));
      rect(x, y, w, h, 5);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text("← " + label, x + w/2, y + h/2 - 2);
      } else if (type.equals("home")){
      noStroke();
      if(hovers){
        fill(RY_BLUE);
      } else {
         fill(240, 231, 213);
      }
      rect(x, y, w, h, 10);
      
      if(hovers)  {
        fill(255);
      } else {
        fill(0);
      }
      
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(label, x + w/2, y + h/2 - 2);
    } else {
      noStroke();
      fill(hovers ? #3D5A80 : RY_BLUE);
      rect(x, y, w, h, 10);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(label, x + w/2, y + h/2 - 2);
    }
  }

  boolean click() {
    return over(mouseX, mouseY);
  }

  boolean over(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

// ===== TEXT ENTRY BUTTON =====
class TextEntryButton extends Button {
  int maxlen, inputOrder;
  
  TextEntryButton(float x, float y, float w, float h, String label, String type, int maxChars, int textSize, boolean hasShadow, int inputOrder){
    super(x, y, w, h, label, type, textSize, hasShadow);
    this.inputOrder = inputOrder;
    this.maxlen = maxChars;
  }

  @Override
  void display() {
    QueriesFlights qf = null;
    if (currentScreenObject instanceof QueriesFlights) {
        qf = (QueriesFlights) currentScreenObject;
    }
    boolean isCurrent = (qf != null && qf.currentInput == this);

    stroke(RY_BLUE);
    strokeWeight(isCurrent ? 2 : 1);

    // Background
    if (isCurrent) fill(255);       // White when active
    else fill(255);                 // White when inactive (instead of RY_BLUE)
    rect(x, y, w, h, 5);

    // Text
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(textSize);

    String displayText = label;
    if (isCurrent && (frameCount / 25) % 2 == 0) displayText += "|";
    text(displayText, x + 10, y + h/2);
  }

  // Add a character to the text entry
  void addChar(char s) {
    if (s == BACKSPACE) {
      if (label.length() > 0) label = label.substring(0, label.length() - 1);
    } else if (s != CODED && s != ENTER && s != TAB && label.length() < maxlen) {
      label += s;
    }
  }
}
