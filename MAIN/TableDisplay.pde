// ===== TABLE DISPLAY =====  ---- // (Sebastian Aleman - 5/4 - function to draw table of 15 top routes in a region)
class TableDisplay {
  Table table;
  float x, y;
  float rowHeight = 50;
  float colWidth = 250;

  TableDisplay(Table t, float x, float y) {
    this.table = t;
    this.x = x; this.y = y;
  }

  void display() {
    float rowH = 60;
    float colW = (width - x*2) / table.getColumnCount();
    textAlign(CENTER, CENTER);
    textSize(18);

    // Header
    for (int c = 0; c < table.getColumnCount(); c++) {
      float px = x + c*colW;
      fill(200);
      rect(px, y, colW, rowH);
      fill(0);
      text(table.getColumnTitle(c), px + colW/2, y + rowH/2);
    }

    // Data rows with alternating colors
    for (int r = 0; r < table.getRowCount(); r++) {
      float py = y + (r+1)*rowH;
      for (int c = 0; c < table.getColumnCount(); c++) {
        float px = x + c*colW;
        fill(r % 2 == 0 ? 255 : 245);
        stroke(220);
        rect(px, py, colW, rowH);
        fill(50);
        text(table.getString(r, c), px + colW/2, py + rowH/2);
      }
    }
  }
}
