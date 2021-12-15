
class Rocket {
  float x = width / 2;
  float y = height - 140;
  float velX, velY = 0;
  float accX, accY = 0;
  float mass = 20;
  float inertialMoment;
  float angularPosition; // may be unnecessary?
  float angularVelocity;
  float angularAcceleration;
  float gConstant = 0.0005;
  float fuelMaximum;
  float fuelAggregate;
  float fuelAmountConstant = 30;
  float fuelUsageConstant = 0.01;
  float thrustConstant = 0.4;
  boolean thrustState = false;
  boolean pitchLeft = false;
  boolean pitchRight = false;
  float rotationConstant = 0.01;
  LineSegment[] segments;
  LineSegment[] thrustVectors;
  RocketPart[] rocketParts;
  Vector2D[] starPositions = new Vector2D[90];
  Vector2D[] thrustParticles = new Vector2D[40];
  int scale = 30;
  
  void render() {
    stroke(white);
    for(int i = 0; i < segments.length; i++) {
      line(segments[i].startPos.x+width/2, segments[i].startPos.y+height-140, segments[i].endPos.x+width/2, segments[i].endPos.y+height-140);
    }
    if(debug) {
      //Draw stars
      for(int i = 0; i < starPositions.length; i++) {
        //Move the stars according to rocket movement
        starPositions[i].y += velY;
        starPositions[i].x += velX;
        
        //Cull and replace stars as they move off screen
        if(starPositions[i].y > height*2) {
          starPositions[i].x = random(width*3)-width;
          starPositions[i].y = -15;
        }
        else if(starPositions[i].y < -height) {
          starPositions[i].x = random(width*3)-width;
          starPositions[i].y = height+15;
        }
        else if(starPositions[i].x > width*2) {
          starPositions[i].x = -15;
          starPositions[i].y = random(height*3)-height;
        }
        else if(starPositions[i].x < -width) {
          starPositions[i].x = width+15;
          starPositions[i].y = random(height*3)-height;
        }
        
        //Draw star
        circle(starPositions[i].x, starPositions[i].y, 5);
      }
      
      
      //Draw center of mass
      stroke(255, 0, 0);
      fill(255, 0, 0);
      circle(x, y, 5);
      
      //Draw thrust vectors
      stroke(0, 255, 0);
      fill(0, 255, 0);
      for(int i = 0; i < thrustVectors.length; i++) {
        line(thrustVectors[i].startPos.x+width/2, thrustVectors[i].startPos.y+height-140, thrustVectors[i].endPos.x+width/2, thrustVectors[i].endPos.y+height-140);
      }
      
      //Draw fuel amount
      stroke(255);
      fill(0);
      rect(20, 20, width - 40, 20);
      fill(255);
      stroke(0);
      rect(21, 21, (max(fuelAggregate, 0) / fuelMaximum) * (width - 42), 18);
    }
  }
  
  //Rotates the rocket and its thrust vectors about the center of mass by angleRads
  void rotateRocket(float angleRads) {
    //Flip the polarity to ensure counterclockwise rotation for positive angles
    angleRads = -angleRads;
    
    //Rotate main segments
    for(int i = 0; i < segments.length; i++) {
      //Points to rotate -> are already in relation to center of mass
      Vector2D startPos = segments[i].startPos;
      Vector2D endPos = segments[i].endPos;
      
      //Calculate rotated points
      Vector2D newStartPos = new Vector2D(startPos.x * cos(angleRads) - startPos.y * sin(angleRads),
                                          startPos.x * sin(angleRads) + startPos.y * cos(angleRads));
      Vector2D newEndPos = new Vector2D(endPos.x * cos(angleRads) - endPos.y * sin(angleRads),
                                          endPos.x * sin(angleRads) + endPos.y * cos(angleRads));
      
      //Assign new rotated values
      segments[i].startPos = newStartPos;
      segments[i].endPos = newEndPos;
    }
    
    //Rotate thrust vectors
    for(int i = 0; i < thrustVectors.length; i++) {
      //Points to rotate -> are already in relation to center of mass
      Vector2D startPos = thrustVectors[i].startPos;
      Vector2D endPos = thrustVectors[i].endPos;
      
      //Calculate rotated points
      Vector2D newStartPos = new Vector2D(startPos.x * cos(angleRads) - startPos.y * sin(angleRads),
                                          startPos.x * sin(angleRads) + startPos.y * cos(angleRads));
      Vector2D newEndPos = new Vector2D(endPos.x * cos(angleRads) - endPos.y * sin(angleRads),
                                          endPos.x * sin(angleRads) + endPos.y * cos(angleRads));
      
      //Assign new rotated values
      thrustVectors[i].startPos = newStartPos;
      thrustVectors[i].endPos = newEndPos;
    }
  }
  
  void calculateLinearAcceleration() {
    //Clear acceleration values
    accY = 0;
    accX = 0;
    
    //Apply thrust
    if(thrustState) {
      for(int i = 0; i < thrustVectors.length; i++) {
        if(fuelAggregate > 0) {
          fuelAggregate -= fuelUsageConstant; // Reduce fuel to power the thruster
        }
        //Calculate thrust vector
        Vector2D thrustVector = new Vector2D(thrustVectors[i].endPos.x - thrustVectors[i].startPos.x,
                                             thrustVectors[i].endPos.y - thrustVectors[i].startPos.y);
        Vector2D normalizedThrust = thrustVector.getNormalized();
        
        //Apply thrust to linear acceleration
        accY += normalizedThrust.y*thrustConstant / mass;
        accX += normalizedThrust.x*thrustConstant / mass;
      }
    }
    
    //Apply gravity
    accY -= gConstant * mass;
  }
  
  void calculateAngularAcceleration() {
    //Clear acceleration value
    angularAcceleration = 0;
    
    //Apply thrust
    if(thrustState) {
      for(int i = 0; i < thrustVectors.length; i++) {
        if(fuelAggregate > 0) {
          fuelAggregate -= fuelUsageConstant; // Reduce fuel to power the thruster
        }
        else return;
        //Calculate thrust vector
        Vector2D thrustVector = new Vector2D(thrustVectors[i].endPos.x - thrustVectors[i].startPos.x,
                                             thrustVectors[i].endPos.y - thrustVectors[i].startPos.y);
        
        //Apply thrust to angular acceleration
        //torque = r * F * sin(theta)
        //aka torque = point of force application * force magnitude * sin(angle between point vector and force vector)
        Vector2D r = thrustVectors[i].startPos;
        float theta = thrustVector.getAngle(r);
        float torque = r.magnitude() * thrustConstant * sin(theta);
        
        //Check directionality of torque -> s = x1y2 - y1x2
        //S being positive or negative indicates directionality
        float s = r.x*thrustVector.y - r.y*thrustVector.x;
        
        //Add to acceleration for this tick
        if(s > 0) {
          angularAcceleration += torque/inertialMoment;
        } else {
          angularAcceleration -= torque/inertialMoment;
        }
      }
    }
  }
  
  //Changes the angles of thrusters if left/right keys are pressed
  void angleThrusters() {
    if(pitchLeft) {
      for(int i = 0; i < thrustVectors.length; i++) {
        //Get thrustVector zeroed to its start point
        Vector2D thrustVector = new Vector2D(thrustVectors[i].endPos.x - thrustVectors[i].startPos.x, thrustVectors[i].endPos.y - thrustVectors[i].startPos.y);
        
        //Rotate
        Vector2D newThrustVector = new Vector2D(thrustVector.x * cos(rotationConstant) - thrustVector.y * sin(rotationConstant),
                                                thrustVector.x * sin(rotationConstant) + thrustVector.y * cos(rotationConstant));
                      
        //Reassign
        thrustVectors[i].endPos.x = thrustVectors[i].startPos.x + newThrustVector.x;
        thrustVectors[i].endPos.y = thrustVectors[i].startPos.y + newThrustVector.y;
      }
    }
    if(pitchRight) {
      for(int i = 0; i < thrustVectors.length; i++) {
        //Get thrustVector zeroed to its start point
        Vector2D thrustVector = new Vector2D(thrustVectors[i].endPos.x - thrustVectors[i].startPos.x, thrustVectors[i].endPos.y - thrustVectors[i].startPos.y);
        
        //Rotate
        Vector2D newThrustVector = new Vector2D(thrustVector.x * cos(-rotationConstant) - thrustVector.y * sin(-rotationConstant),
                                                thrustVector.x * sin(-rotationConstant) + thrustVector.y * cos(-rotationConstant));
        
        //Reassign
        thrustVectors[i].endPos.x = thrustVectors[i].startPos.x + newThrustVector.x;
        thrustVectors[i].endPos.y = thrustVectors[i].startPos.y + newThrustVector.y;
      }
    }
  }
  
  void update() {
    
    //Angle the thrusters according to input
    angleThrusters();
    
    //Calculate basic physics
    calculateLinearAcceleration();
    calculateAngularAcceleration();
    angularVelocity += angularAcceleration;
    rotateRocket(angularVelocity);
    velX += accX;
    velY += accY;
    if(y > height - 140 && velY < 0) {
      velY = 0;
      y = height - 140;
    }
    x -= velX;
    y -= velY; // This is very important->velocity is reversed in the y direction for rendering
  }
  
  void zeroToCenterOfMass() {
    for(int i = 0; i < segments.length; i++) {
      //Adjust all segments
      segments[i].startPos.x -= x;
      segments[i].startPos.y -= y;
      segments[i].endPos.x -= x;
      segments[i].endPos.y -= y;
    }
    for(int i = 0; i < thrustVectors.length; i++) {
      //Adjust thrust vectors
      thrustVectors[i].startPos.x -= x;
      thrustVectors[i].startPos.y -= y;
      thrustVectors[i].endPos.x -= x;
      thrustVectors[i].endPos.y -= y;
    }
    
    //Reset x and y values
    x = width / 2;
    y = height - 140;
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
  
  void calculateInertialMoment() {
    float inertialAggregate = 0;
    for(int i = 0; i < segments.length; i++) {
      //Get center of segment
      Vector2D center = segments[i].getCenter();
      float centerDistance = center.magnitude();
      
      Vector2D segment = new Vector2D(segments[i].endPos.x - segments[i].startPos.x, segments[i].endPos.y - segments[i].startPos.y);
      float segmentMass = segment.magnitude();
      
      //Formula for inertial moment of a point mass -> I = mr^2
      inertialAggregate += segmentMass*centerDistance*centerDistance;
    }
    inertialMoment = inertialAggregate;
  }
  
  void calculateSegments() {
    //Calculate size of segments array
    int segmentsSize = 0;
    int thrusterCount = 0;
    for(int i = 0; i < rocketParts.length; i++) {
      segmentsSize += rocketParts[i].points.length;
      if(rocketParts[i].type == RocketPartTypes.THRUSTER) thrusterCount++;
    }
    //Populate segments array
    segments = new LineSegment[segmentsSize];
    
    //Populate thruster array
    thrustVectors = new LineSegment[thrusterCount];
    int counter = 0;
    int thrustCounter = 0;
    for(int i = 0; i < rocketParts.length; i++) {
      float xOffset = rocketParts[i].x;
      float yOffset = rocketParts[i].y;
      
      //Calculate potential thruster positions
      if(rocketParts[i].type == RocketPartTypes.THRUSTER) {
        Vector2D endPoint1 = rocketParts[i].points[2];
        Vector2D endPoint2 = rocketParts[i].points[3];
        Vector2D midpoint = new Vector2D((endPoint1.x + endPoint2.x)/2, (endPoint1.y + endPoint2.y)/2);
        thrustVectors[thrustCounter] = new LineSegment((midpoint.x+xOffset)*scale, (midpoint.y+yOffset)*scale, (midpoint.x+xOffset)*scale, (midpoint.y+yOffset+1)*scale);
        thrustCounter++;
      }
      //Calculate segment positions from each point in the part
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
        if(builderGrid.grid[i][j].type == RocketPartTypes.FUEL) {
          fuelMaximum+=fuelAmountConstant;
          fuelAggregate+=fuelAmountConstant;
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
    
    //Calculate the inertial moment of the rocket
    calculateInertialMoment();
    
    //Initialize stars
    for(int i = 0; i < starPositions.length; i++) {
      starPositions[i] = new Vector2D(random(width*3)-width, random(height*3)-height);
    }
  }
}
