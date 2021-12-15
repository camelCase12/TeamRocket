
//Class for storing 2 coupled values conveniently
class Vector2D {
  float x, y;
  
  float getAngle(Vector2D otherVector) {
    Vector2D thisNormalized = this.getNormalized();
    Vector2D otherNormalized = otherVector.getNormalized();
    float angle = acos(constrain((otherNormalized.x * thisNormalized.x + otherNormalized.y * thisNormalized.y) / (thisNormalized.magnitude() * otherNormalized.magnitude()), -1, 1));
    if(Float.isNaN(angle)) {
      println("get angle nanned");
      exit();
    }
    return angle;
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
