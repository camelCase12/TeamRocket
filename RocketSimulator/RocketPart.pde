//RocketPart representing a building block for the rocket
class RocketPart {
  int type; // enum of RocketPartTypes
  float x, y;
  Vector2D[] points; // each rocket part is defined by a set of points that create a polygon.
                    // a second rendering pass will be used if additional graphics are needed.
                    
  void render(float scaleFactor, float drawX, float drawY) {
    if(type == RocketPartTypes.EMPTY) {
      return;
    }
    stroke(white);
    for(int i = 0; i < points.length-1; i++) {
      line(drawX + points[i].x*scaleFactor, drawY + points[i].y*scaleFactor, drawX + points[i+1].x*scaleFactor, drawY + points[i+1].y*scaleFactor);
    }
    int lastElement = points.length-1;
    line(drawX + points[lastElement].x*scaleFactor, drawY + points[lastElement].y*scaleFactor, drawX + points[0].x*scaleFactor, drawY + points[0].y*scaleFactor);
  }
                    
  void generatePoints() {
    int numPoints;
    switch(type) {
      case RocketPartTypes.EMPTY:
        break;
        
      case RocketPartTypes.BLOCK: // Defines 4 points for a square
        numPoints = 4;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0, 0);
        points[1] = new Vector2D(1, 0);
        points[2] = new Vector2D(1, 1);
        points[3] = new Vector2D(0, 1);
        break;
      case RocketPartTypes.THRUSTER: // Trapezoid for thruster
        numPoints = 4;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0, 0);
        points[1] = new Vector2D(1, 0);
        points[2] = new Vector2D(0.8, 1);
        points[3] = new Vector2D(0.2, 1);
        break;
      case RocketPartTypes.FUEL: // Slightly different shape for distinguishment
        numPoints = 6;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0, 0);
        points[1] = new Vector2D(1, 0);
        points[2] = new Vector2D(0.8, 0.5);
        points[3] = new Vector2D(1, 1);
        points[4] = new Vector2D(0, 1);
        points[5] = new Vector2D(0.2, 0.5);
        break;
      case RocketPartTypes.CREWCAPSULE: // Slightly different shape for distinguishment
        numPoints = 3;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0.5, 0);
        points[1] = new Vector2D(1, 1);
        points[2] = new Vector2D(0, 1);
        break;
    }
  }
  void setType(int type) {
    this.type = type;
    generatePoints();
  }
  
  RocketPart(int type) { // Creates a rocket part from RocketPartTypes below
    this.type = type;
    generatePoints();
  }
  RocketPart() {
    type = RocketPartTypes.EMPTY;
  }
}

class RocketPartTypes {
  final static int EMPTY = 0;
  final static int BLOCK = 1;
  final static int THRUSTER = 2;
  final static int FUEL = 3;
  final static int CREWCAPSULE = 4;
}
