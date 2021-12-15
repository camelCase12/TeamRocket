class Button {
  float x, y, Width, Height; // Capitalized because of width/height reserved
  String text;
  String name;
  Boolean hoverState = false; // Determines how button should be drawn for stylization
  int textSize;
  
  Boolean isInBounds(float inX, float inY) { // Returns whether a coordinate is in the bounds of the rectangle
    if(inX < x || inX > x+Width || inY < y || inY > y+Height) return false; // || on rejection is more efficient because generally only 1 button is clicked
    return true;
  }
  
  void render() { // Draw the button -> backcolor/border -> text
    textAlign(CENTER);
    textSize(textSize);
    //Draw backcolor, if hovered over
    stroke(white);
    fill(black);
    if(hoverState) fill(80); 
    rect(x, y, Width, Height);
    //Draw text
    fill(white);
    text(text, x + Width/2, y + 35);
  }
  
  Button(float x, float y, float Width, float Height, String name, String text, int textSize) {
    this.x = x; this.y = y; this.Width = Width; this.Height = Height;
    this.text = text;
    this.textSize = textSize;
    this.name = name;
  }
  
  Button() {}
}
