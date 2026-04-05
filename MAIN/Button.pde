class Button {
  float x, y, w, h;
  String label, type;
  int textSize;
  boolean hasShadow;
  float hoverScale;
  float targetScale;

  Button(float x, float y, float w, float h, String label, String type, int textSize, boolean hasShadow) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.label = label; this.type = type; this.textSize = textSize; this.hasShadow = hasShadow;
  }

  void display() {
    boolean hovers = over(mouseX, mouseY);
    
    if (hovers)  {
      targetScale = 1.04;
    } else {
      targetScale = 1.0;
    }
    
    hoverScale = lerp(hoverScale, targetScale, 0.5); // Lerp gives a smooth transition
  
    if (type.equals("graphsPage") || type.equals("pieChartsPage") || type.equals("flightMapPage")) {
      pushMatrix();
      translate(x + w/2, y + h/2);
      scale(hoverScale);
      translate(-(x + w/2), -(y + h/2));
      
      fill(hovers ? color(RY_BLUE) : 255);
      rect(x, y, w, h, 20);
      
      fill(hovers ? 255 : RY_BLUE);
      textAlign(LEFT, TOP);
      textSize(textSize);
      text(label, x + 15, y + 20);
      
      popMatrix();
      return;
    }
    
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
      
      } else if (type.equals("home") || type.equals("graphs") || type.equals("pieCharts") || type.equals("maps")){
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
      
    } else if (type.equals("dateOutput")) {
      noStroke();
      fill(hovers ? color(255, 215, 0) : RY_YELLOW); // yellow background
      rect(x, y, w, h, 8);
      fill(RY_BLUE);  // text color
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(label, x + w/2, y + h/2 - 3);
    }
    else {
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
  boolean hasError;
  int shakeTimer;
  float shakeOffset;
  
  TextEntryButton(float x, float y, float w, float h, String label, String type, int maxChars, int textSize, boolean hasShadow, int inputOrder){
    super(x, y, w, h, label, type, textSize, hasShadow);
    this.inputOrder = inputOrder;
    this.maxlen = maxChars;
    hasError = false;
    shakeTimer = 0;
    shakeOffset = 0;
  }
  
  void triggerError() {
    shakeTimer = 20; // frames (~0.3 sec)
  }

  
  
  void display() {
  
   boolean isCurrent = false;

  if (currentScreenObject instanceof QueriesDate) {
    QueriesDate qd = (QueriesDate) currentScreenObject;
    isCurrent = (qd.currentInput == this);
  }
    
     // ---------------- SHAKE ANIMATION ----------------
    if (shakeTimer > 0) {
      shakeOffset = sin(frameCount * 0.8) * 5;
      shakeTimer--;
    } else {
      shakeOffset = 0;
    }
  
  
    // -------------------------------------------------
    // BORDER LOGIC (NEW)
    // -------------------------------------------------
  
    if (isCurrent) {
      stroke(RY_BLUE);          // active input
      strokeWeight(2);
    }
    else if (hasError) {
      stroke(255, 60, 60);        // error highlight
      strokeWeight(3);
    }
    else {
      stroke(200);               // normal state
      strokeWeight(1);
    }
  
    // -------------------------------------------------
    // BACKGROUND
    // -------------------------------------------------
  
    if (hasError && !isCurrent)
      fill(255, 240, 240);   // light red tint
    else
      fill(255);
  
    rect(x + shakeOffset, y, w, h, 5);
  
    // -------------------------------------------------
    // TEXT
    // -------------------------------------------------
  
    fill(RY_BLUE);
    textAlign(LEFT, CENTER);
    textSize(textSize);
  
    String displayText = label;
  
    // blinking cursor
    if (isCurrent && (frameCount / 25) % 2 == 0)
      displayText += "|";
  
    text(displayText, x + 10 + shakeOffset, y + h/2);
  }

  // Add a character to the text entry
 void addChar(char s) {
  
    hasError = false; // ⭐ remove error when user edits
    shakeTimer = 0;
    
    if (s == BACKSPACE) {
      if (label.length() > 0)
        label = label.substring(0, label.length() - 1);
    }
    else if (s != CODED && s != ENTER && s != TAB && label.length() < maxlen) {
      label += s;
    }
  }
}
