class Button {
  float x, y, w, h;
  String label;
  String type;
  int textSize;
  boolean hasShadow;

  Button(float x, float y, float w, float h, String label, String type, int textSize, boolean hasShadow) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.type = type;
    this.textSize = textSize;
    this.hasShadow = hasShadow;
  }

  void display() {
    boolean hovers = over(mouseX, mouseY);

    // 1. DRAW SHADOW (If applicable)
    if (hasShadow) {
      noStroke();
      fill(0, 40); // Subtle modern shadow
      rect(x + 2, y + 4, w, h, 8);
    }

    // 2. DEFINE BUTTON STYLE BY TYPE
    if (type.equals("flightsOutput")) {
      // PRIMARY ACTION: Ryanair Yellow/Gold
      noStroke();
      fill(hovers ? #FFD700 : #F4CA35); // Brighter gold on hover
      rect(x, y, w, h, 8);
      
      // Professional Navy Blue Text
      fill(#2B4779); 
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text("Search Flights", x + w/2, y + h/2 - 3);

    } else if (type.equals("back") || type.equals("backQ")) {
      // HEADER/NAV BUTTON: Transparent with White Outline
      stroke(255, 180);
      strokeWeight(1);
      fill(hovers ? color(255, 30) : color(0, 0)); 
      rect(x, y, w, h, 5);
      
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text("← " + label, x + w/2, y + h/2 - 2);

    } else if (type.equals("queries") || type.equals("dashboard")) {
      // MAIN MENU BUTTONS: Dark Navy with White Text
      noStroke();
      fill(hovers ? #3D5A80 : #2B4779);
      rect(x, y, w, h, 10);
      
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(textSize);
      text(label, x + w/2, y + h/2 - 2);

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
      
    }else {
      // DEFAULT BUTTON STYLE
      stroke(200);
      fill(hovers ? 240 : 255);
      rect(x, y, w, h, 5);
      
      fill(50);
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

class TextEntryButton extends Button {
  int maxlen;
  int inputOrder;
  
  TextEntryButton(float x, float y, float w, float h, String label, String type, int maxChars, int textSize, boolean hasShadow, int inputOrder){
    super(x, y, w, h, label, type, textSize, hasShadow);
    this.inputOrder = inputOrder;
    this.maxlen = maxChars;
  }
  
  @Override
  void display() {
    stroke(RY_BLUE);
    strokeWeight(1);
    fill(245); // Light grey input box
    
    // Highlight if active
    if (currentScreenObject instanceof QueriesFlights && ((QueriesFlights)currentScreenObject).currentInput == this) {
      strokeWeight(2);
      fill(255); 
    }
    
    rect(x, y, w, h, 5);
    
    fill(RY_BLUE); // Dark text so it's visible!
    textAlign(LEFT, CENTER);
    textSize(textSize);
    
    String visual = label;
    if (currentScreenObject instanceof QueriesFlights && ((QueriesFlights)currentScreenObject).currentInput == this) {
       if ((frameCount / 25) % 2 == 0) visual += "|";
    }
    
    text(visual, x + 10, y + h/2 - 3);
  }
  
  void addChar(char s) {
    if (s == BACKSPACE) {
      if (label.length() > 0) label = label.substring(0, label.length() - 1);
    } else if (s != CODED && s != ENTER && s != TAB && label.length() < maxlen) {
      label += s;
    }
  }
}
