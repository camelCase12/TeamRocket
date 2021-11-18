class Label {
  float x, y, Width, Height; // Capitalized because of width/height reserved
  String text;
  String name;
  int textSize;
  
  //Render the label by drawing text left-justified at the given point
  void render() {
    textAlign(LEFT);
    textSize(textSize);
    //Draw backcolor, if hovered over
    stroke(255);
    text(text, x + Width/2, y + 35);
  }
  
  Label(float x, float y, float Width, float Height, String text) {
    this.x = x; this.y = y; this.Width = Width; this.Height = Height;
    this.text = text;
  }
  Label(float x, float y, float Width, float Height, String name, String text, int textSize) {
    this.x = x; this.y = y; this.Width = Width; this.Height = Height;
    this.text = text;
    this.textSize = textSize;
    this.name = name;
  }
  
  Label() {}
}
