
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
    
    //Shadow
    if(hasShadow){
      noStroke();
      fill(0, 80);
      rect(x+3, y+7, w, h, 10);
    }
    
    boolean hovers = over(mouseX, mouseY);
      if(type.equals("queries")){
        if(hovers) fill(119, 139, 150);
        else fill(61, 63, 74);
      }
       else if(type.equals("graphs")){
         if(hovers) fill(142, 163, 157);
           else fill(61, 63, 74);
       }
       else if(type.equals("exit") || type.equals("back")){
         if(hovers) fill(180);
           else fill(70);
       }
       else{
         if(hovers) fill(209, 207, 201);
            else fill(61, 63, 74);
    }    
    
    stroke(255);
    rect(x, y, w, h, 8);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(textSize);
    text(label, x + w/2, y + h/2);
  }
  
  void click() {
    if (over(mouseX, mouseY)) {
      println("Clicked "+type);
      // Decide what to do based on the button type
      if (type.equals("queries")) currentScreen = queries;
      if (type.equals("flights")) {
        searchFlight();
        currentScreen = flights;
      }
      if (type.equals("graphs"))currentScreen =graphs;
      if (type.equals("back")) currentScreen =home;
      if (type.equals("exit")) currentScreen = exit;
    }

  }
  
  boolean over(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
class TextEntryButton extends Button{
  int maxlen;
  
  TextEntryButton(float x, float y, float w, float h, String label, String type, int maxChars, int textSize, boolean hasShadow){
    super(x,y,w,h,label,type,textSize, hasShadow);
    this.maxlen = maxChars;
    
  }
  
  void addChar(char s){
    if(s==BACKSPACE){
      if(!label.equals("")){
        label = label.substring(0,label.length()-1);
      }
    }
    else if (label.length()<maxlen){
      label = label +str(s);
    }
  
  }
}
