class Button {
  float x, y, w, h;
  String label;
  
  String type;
  
  Button(float x, float y, float w, float h, String label, String type) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.type = type;
  }
  
  void display() {
    if (over(mouseX, mouseY)) 
    {
      fill(100, 140, 255);
    } 
    else 
    {
      fill(70);
    }    
    
    stroke(255);
    rect(x, y, w, h, 8);
    fill(255);
    textAlign(CENTER, CENTER);
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
      if (type.equals("data"))currentScreen =data;
      if (type.equals("back")) currentScreen =home;
      if (type.equals("exit")) currentScreen = exit;
      if (type.equals("backQ")) currentScreen = queries;
    }

  }
  
  boolean over(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}
class TextEntryButton extends Button{
  int maxlen;
  
  TextEntryButton(float x, float y, float w, float h, String label, String type, int maxChars){
    super(x,y,w,h,label,type);
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
