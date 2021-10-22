
class Button {
  float x, y, Width, Height; // Capitalized because of width/height reserved
  String text;
  Boolean hoverState = false; // Determines how button should be drawn for stylization
  
  Boolean isInBounds(float inX, float inY) { // Returns whether a coordinate is in the bounds of the rectangle
    if(inX < x || inX > x+Width || inY < y || inY > y+Height) return false; // || on rejection is more efficient because generally only 1 button is clicked
    return true;
  }
  
  void render() { // Draw the button -> backcolor/border -> text
    //Draw backcolor, if hovered over
    stroke(255);
    fill(0);
    if(hoverState) fill(80); 
    rect(x, y, Width, Height);
    //Draw text
    fill(255);
    text(text, x + 5, y + 30);
  }
  
  Button(float x, float y, float Width, float Height, String text) {
    this.x = x; this.y = y; this.Width = Width; this.Height = Height;
    this.text = text;
  }
  
  Button() {}
}
