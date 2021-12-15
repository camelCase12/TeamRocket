//Wrapper class for PImage to work with them in a window
class Image {
  PImage img;
  String name;
  float x, y;
  
  //Draw image with x and y cached
  void render() {
    image(img, x, y);
  }
  
  Image(PImage img, String name, float x, float y) {
    this.img = img;
    this.name = name;
    this.x = x; this.y = y;
  }
}
