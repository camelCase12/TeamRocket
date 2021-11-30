
class Rocket {
  float x, y;
  LineSegment[] segments;
  RocketPart[] rocketParts;
  int scale = 30;
  
  void render() {
    stroke(white);
    for(int i = 0; i < segments.length; i++) {
      line(segments[i].startPos.x+x, segments[i].startPos.y+y, segments[i].endPos.x+x, segments[i].endPos.y+y);
    }
    if(debug) {
      stroke(255, 0, 0);
      fill(255, 0, 0);
      circle(x, y, 5);
    }
  }
  
  void zeroToCenterOfMass() {
    for(int i = 0; i < segments.length; i++) {
      segments[i].startPos.x -= x;
      segments[i].startPos.y -= y;
      segments[i].endPos.x -= x;
      segments[i].endPos.y -= y;
    }
  }
  
  void calculateCenterOfMass() {
    float xAggregate = 0;
    float yAggregate = 0;
    for(int i = 0; i < segments.length; i++) {
      Vector2D center = segments[i].getCenter();
      xAggregate += center.x;
      yAggregate += center.y;
    }
    x = xAggregate/segments.length;
    y = yAggregate/segments.length;
  }
  
  void calculateSegments() {
    //Calculate size of segments array
    int segmentsSize = 0;
    for(int i = 0; i < rocketParts.length; i++) {
      segmentsSize += rocketParts[i].points.length;
    }
    //Populate segments array
    segments = new LineSegment[segmentsSize];
    int counter = 0;
    for(int i = 0; i < rocketParts.length; i++) {
      float xOffset = rocketParts[i].x;
      float yOffset = rocketParts[i].y;
      for(int j = 0; j < rocketParts[i].points.length-1; j++) {
        Vector2D currentPoint = rocketParts[i].points[j];
        Vector2D nextPoint = rocketParts[i].points[j+1];
        segments[counter] = new LineSegment((currentPoint.x+xOffset)*scale, (currentPoint.y+yOffset)*scale, (nextPoint.x+xOffset)*scale, (nextPoint.y+yOffset)*scale);
        counter++;
      }
      Vector2D lastPoint = rocketParts[i].points[rocketParts[i].points.length-1];
      Vector2D firstPoint = rocketParts[i].points[0];
      segments[counter] = new LineSegment((lastPoint.x+xOffset)*scale, (lastPoint.y+yOffset)*scale, (firstPoint.x+xOffset)*scale, (firstPoint.y+yOffset)*scale);
      counter++;
    }
  }
  
  void convertGridToParts(BuilderGrid builderGrid) {
    //Calculate size of rocketParts array
    int rocketPartSize = 0;
    for(int i = 0; i < builderGrid.grid.length; i++) {
      for(int j = 0; j < builderGrid.grid[0].length; j++) {
        if(builderGrid.grid[i][j].type != RocketPartTypes.EMPTY) {
          rocketPartSize++;
        }
      }
    }
    //Populate rocketParts array
    rocketParts = new RocketPart[rocketPartSize];
    int counter = 0;
    for(int i = 0; i < builderGrid.grid.length; i++) {
      for(int j = 0; j < builderGrid.grid[0].length; j++) {
        if(builderGrid.grid[i][j].type != RocketPartTypes.EMPTY) {
          rocketParts[counter] = builderGrid.grid[i][j];
          //Set the relevant x/y positions of each rocket part in relation to the top left of the grid
          rocketParts[counter].x = i;
          rocketParts[counter].y = j;
          counter++;
        }
      }
    }
  }
  
  Rocket(BuilderGrid builderGrid) {
    //Get the full list of rocket parts from the grid
    convertGridToParts(builderGrid);
    
    //Calculate the simpler segment form for physics and rendering
    calculateSegments();
    
    //Calculate the center of mass as a position indicator
    calculateCenterOfMass();
    
    //Zero out the rocket to its x/y position
    zeroToCenterOfMass();
  }
}
