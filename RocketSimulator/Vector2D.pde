
//Class for storing 2 coupled values conveniently
class Vector2D {
  float x, y;
  
  float getAngle(Vector2D otherVector) {
    return acos((otherVector.x * x + otherVector.y * y) / (magnitude() * otherVector.magnitude()));
  }
  float magnitude() {
    return sqrt(x*x + y*y);
  }
  Vector2D getNormalized() {
    return new Vector2D(x/sqrt(x*x+y*y), y/sqrt(x*x+y*y));
  }
  Vector2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Vector2D() {
    this.x = 0;
    this.y = 0;
  }
}
