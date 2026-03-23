class TableDisplay {
  Table table;
  float x, y, w, h;
  float rowHeight = 50;
  float colWidth = 250;

  TableDisplay(Table t, float x, float y) {
    this.table = t;
    this.x = x;
    this.y = y;
  }
//|----|-------------1200------------|----|
  void display() {
    float rowHeight = 60;
    float colWidth = 220;
    
    // Set global text alignment for the table
    textAlign(CENTER, CENTER); // This centers horizontally and vertically
    textSize(18);
  
    // 1. DRAW HEADER ROW
    for (int c = 0; c < table.getColumnCount(); c++) {
      float px = x + (c * colWidth);
      
      // Header Box
      fill(200);
      rect(px, y, colWidth, rowHeight);
      
      // Header Text
      fill(0);
      // Center point = start of cell + half the width
      text(table.getColumnTitle(c), px + (colWidth / 2), y + (rowHeight / 2));
    }
  
    // 2. DRAW DATA ROWS
    for (int r = 0; r < table.getRowCount(); r++) {
      float py = y + ((r + 1) * rowHeight);
      
      for (int c = 0; c < table.getColumnCount(); c++) {
        float px = x + (c * colWidth);
        
        // Cell border
        fill(255);
        stroke(220);
        rect(px, py, colWidth, rowHeight);
        
        // Cell text centered
        fill(50);
        // Center point = start of cell + half the width/height
        text(table.getString(r, c), px + (colWidth / 2), py + (rowHeight / 2));
      }
    }
  }
  



}
