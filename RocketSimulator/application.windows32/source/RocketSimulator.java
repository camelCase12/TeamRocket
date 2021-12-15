import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RocketSimulator extends PApplet {



//Global/static variables--each window and the window state
Window mainMenuWindow;
Window assemblyWindow;
Window flightWindow;
Window optionsWindow;
Window instructionsWindow;
MouseHolder mouseHolder;
int windowState;
BuilderGrid bg;
Rocket rocket;

//Options menu variables
boolean sound = true;
boolean debug = false;
int black = 0;
int white = 255;
int gray = 0;

//Sound variables
SoundFile boop;
SoundFile menu;
SoundFile thrust;
SoundFile ambience;

//Rocket pngs
PImage fuelImage;
PImage crewImage;
PImage thrustImage;
PImage structureImage;

//Called upon program launch.
public void setup() {
  //Set background color to black and size to 750px*750px
  background(gray);
  
  
  //Initialize each window
  initMainMenu();
  initVehicleAssembly();
  initVehicleFlight();
  initOptions();
  initInstructions();
  
  //Initialize sounds
  boop = new SoundFile(this, "boopclipped.mp3");
  menu = new SoundFile(this, "MainMenuClip.wav");
  thrust = new SoundFile(this, "newRocketSound.wav");
  ambience = new SoundFile(this, "ambience.wav");
  
  //Initialize images
  fuelImage = loadImage("FuelBlock.png");
  crewImage = loadImage("CrewBlockDark.png");
  thrustImage = loadImage("ThrusterBlock.png");
  structureImage = loadImage("StructureBlock.png");
  
  //Initialize milestones
  initMilestones();
  
  //Test initialize mouseHolder
  mouseHolder = new MouseHolder();
  
  //Set the first windowState to MAIN_MENU
  windowState = WindowState.MAIN_MENU;
}

//Called each frame.
public void draw() {
  //Clear the frame before drawing
  background(gray);
  
  //Based on the current windowState, pick a driver to run
  switch(windowState) {
    case WindowState.MAIN_MENU:
      mainMenuDriver();
      break;
    case WindowState.VEHICLE_ASSEMBLY:
      vehicleAssemblyDriver();
      break;
    case WindowState.VEHICLE_FLIGHT:
      vehicleFlightDriver();
      break;
    case WindowState.OPTIONS:
      optionsDriver();
      break;
    case WindowState.INSTRUCTIONS:
      instructionsDriver();
      break;
  }
}

//Called when mouse is pressed.
public void mousePressed() {
  //Based on the current windowState, pick a mouse handler to run
  switch(windowState) {
    case WindowState.MAIN_MENU:
      mainMenuWindow.handleMouseClick();
      break;
    case WindowState.VEHICLE_ASSEMBLY:
      assemblyWindow.handleMouseClick();
      bg.handleMouseClick();
      break;
    case WindowState.VEHICLE_FLIGHT:
      flightWindow.handleMouseClick();
      break;
    case WindowState.OPTIONS:
      optionsWindow.handleMouseClick();
      break;
    case WindowState.INSTRUCTIONS:
      instructionsWindow.handleMouseClick();
      break;
  }
}

//Called when key is pressed.
public void keyPressed() {
  if(windowState==WindowState.VEHICLE_FLIGHT) {
    globalKeyHandler();
  }
}

public void keyReleased() {
  if(windowState==WindowState.VEHICLE_FLIGHT) {
    globalReleaseHandler();
  }
}
class BuilderGrid {
  RocketPart[][] grid;
  float x, y;
  float Width, Height;
  float cellSizeX, cellSizeY;
  String errorText = "";
  
  public void render() {
    stroke(white);
    fill(black);
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        //Draw the cell itself
        rect(x + cellSizeX*i, y + cellSizeY*j, cellSizeX, cellSizeY);
        
        //Draw the part in the cell
        float scaleDown = 0.9f;
        grid[i][j].render(scaleDown*cellSizeX, x + cellSizeX*i + cellSizeX*(1-scaleDown)/2, y + cellSizeY*j + cellSizeY*(1-scaleDown)/2);
      }
    }
    
    //Draw errorText
    stroke(255, 0, 0);
    fill(255, 0, 0);
    textAlign(CENTER);
    text(errorText, width/2, height - 250);
  }
  
  public void handleMouseClick() {
    //Adjust mouse to grid's coordinates
    float gridNormalizedMouseX = mouseX - x;
    float gridNormalizedMouseY = mouseY - y;
    //Calculate the square that the mouse would land in
    int clickedSquareX = (int)(gridNormalizedMouseX / cellSizeX);
    int clickedSquareY = (int)(gridNormalizedMouseY / cellSizeY);
    if(clickedSquareX < 0 || clickedSquareY < 0 || clickedSquareX >= grid.length
        || clickedSquareY >= grid[0].length) {
          return;
    }
    //Place whatever is in the mouseHolder into the square, or pick up the square if the mouseHolder is empty
    if(mouseHolder.currentPart.type == RocketPartTypes.EMPTY) { // Pick up what is in the square
      mouseHolder.currentPart.setType(grid[clickedSquareX][clickedSquareY].type);
      grid[clickedSquareX][clickedSquareY].setType(RocketPartTypes.EMPTY);
    }
    else if (grid[clickedSquareX][clickedSquareY].type == RocketPartTypes.EMPTY) { // Place down item into the square
      grid[clickedSquareX][clickedSquareY].setType(mouseHolder.currentPart.type);
      mouseHolder.currentPart.setType(RocketPartTypes.EMPTY);
    }
    else { // Swap items
      int tempType = grid[clickedSquareX][clickedSquareY].type;
      grid[clickedSquareX][clickedSquareY].setType(mouseHolder.currentPart.type);
      mouseHolder.currentPart.setType(tempType);
    }
    println("Clicked grid at: (x: " + clickedSquareX + ", y: " + clickedSquareY + ")");
  }
  
  public boolean verifyGrid() {
    //Verify that rocket contains necessary parts
    boolean hasCrewCapsule = false;
    boolean hasFuelTank = false;
    boolean hasThruster = false;
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        if(grid[i][j].type == RocketPartTypes.CREWCAPSULE) {
          if(j == grid[0].length-1) {
            errorText = "You need a structure block below the crew capsule.";
            return false;
          }
          if(grid[i][j+1].type != RocketPartTypes.BLOCK) {
            errorText = "You need a structure block below the crew capsule.";
            return false;
          }
          hasCrewCapsule = true;
        }
        if(grid[i][j].type == RocketPartTypes.FUEL) {
          hasFuelTank = true;
        }
        if(grid[i][j].type == RocketPartTypes.THRUSTER) {
          if(j == 0) {
            errorText = "You need a block above the thruster block.";
            return false;
          }
          if(grid[i][j-1].type == RocketPartTypes.EMPTY) {
            errorText = "You need a block above the thruster block.";
            return false;
          }
          hasThruster = true;
        }
      }
    }
    //Print necessary part missing error messages
    if(!hasCrewCapsule) {
      errorText = "Please add a crew capsule!";
      return false;
    }
    if(!hasFuelTank) {
      errorText = "Please add a fuel tank!";
      return false;
    }
    if(!hasThruster) {
      errorText = "Please add a thruster!";
      return false;
    }
    
    //Check to make sure rocket is contiguous
    int partCount = 0;
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        if(grid[i][j].type != RocketPartTypes.EMPTY) {
          partCount++;
        }
      }
    }
    
    return true;
  }
  
  BuilderGrid(int gridSizeX, int gridSizeY, float x, float y, float Width, float Height) {
    grid = new RocketPart[gridSizeX][gridSizeY];
    for(int i = 0; i < gridSizeX; i++) {
      for(int j = 0; j < gridSizeY; j++) {
        grid[i][j] = new RocketPart();
      }
    }
    this.cellSizeX = Width / gridSizeX;
    this.cellSizeY = Height / gridSizeY;
    this.x = x;
    this.y = y;
  }
}
class Button {
  float x, y, Width, Height; // Capitalized because of width/height reserved
  String text;
  String name;
  Boolean hoverState = false; // Determines how button should be drawn for stylization
  int textSize;
  
  public Boolean isInBounds(float inX, float inY) { // Returns whether a coordinate is in the bounds of the rectangle
    if(inX < x || inX > x+Width || inY < y || inY > y+Height) return false; // || on rejection is more efficient because generally only 1 button is clicked
    return true;
  }
  
  public void render() { // Draw the button -> backcolor/border -> text
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
//Executes code based on the name of the button that was clicked.
//Events/delegates and lambda functions are both absent from processing--this is
//the current solution for allowing buttons to execute new code segments.
public void globalButtonHandler(String buttonName) {
  
  //Play boop sound if sound is on
  if(sound) {
    boop.play();
  }
  
  switch(buttonName) {
    case "playGameBtn":
      if(menu.isPlaying()) {
        menu.stop();
      }
      windowState = WindowState.VEHICLE_ASSEMBLY;
      break;
    case "mainMenuBtn":
      windowState = WindowState.MAIN_MENU;
      break;
    case "flightBtn":
      if(bg.verifyGrid()) {
        rocket = new Rocket(bg);
        windowState = WindowState.VEHICLE_FLIGHT;
        flightWindow.addLabel(30, height/2+50, 50, 50, "instructionLbl", "Tap space to toggle thrust, Use Left/Right arrows to angle thrust.", 20);
      }
      break;
    case "optionsBtn":
      windowState = WindowState.OPTIONS;
      break;
    case "optionsBackBtn":
      windowState = WindowState.MAIN_MENU;
      break;
    case "instructionsBtn":
      windowState = WindowState.INSTRUCTIONS;
      break;
    case "exitFlightBtn":
      windowState = WindowState.VEHICLE_ASSEMBLY;
      if(thrust.isPlaying()) {
        thrust.stop();
      }
      break;
      
    //Options menu cases
    case "backgroundBtn":
      if (white == 255) {
        white = black; 
        black = 255;
        gray = 200;
      } else {
        black = white;
        white = 255;
        gray = 0;
      }
      break;
    case "soundBtn":
      if (sound == true) {
      sound = false;
      boop.stop();
      menu.stop();
      thrust.stop();
      print("Turned the sound off!\n");
      } else {
      sound = true;
      print("Turned the sound on!\n");
      }
      break;
    
    //Block choice cases
    case "eraseBtn":
      mouseHolder.currentPart.setType(RocketPartTypes.EMPTY);
      break;
    case "structureBtn":
      mouseHolder.currentPart.setType(RocketPartTypes.BLOCK);
      break;
    case "thrusterBtn":
      mouseHolder.currentPart.setType(RocketPartTypes.THRUSTER);
      break;
    case "fuelBtn":
      mouseHolder.currentPart.setType(RocketPartTypes.FUEL);
      break;
    case "crewBtn":
      mouseHolder.currentPart.setType(RocketPartTypes.CREWCAPSULE);
      break;
  }
}

public void globalKeyHandler() {
  if(key == CODED) {
    switch(keyCode) {
      case LEFT:
        rocket.pitchLeft = true;
        break;
      case RIGHT:
        rocket.pitchRight = true;
        break;
    }
  }
  else if (key == ' ') {
    //Change thrust on and off when space is pressed
    if(!rocket.thrustState && rocket.fuelAggregate > 0) {
      thrust.play();
    }
    else if (thrust.isPlaying()) {
      thrust.stop();
    }
    rocket.thrustState = !rocket.thrustState;
    flightWindow.removeLabel("instructionLbl");
  }
}

public void globalReleaseHandler() {
  if(key == CODED) {
    switch(keyCode) {
      case LEFT:
        rocket.pitchLeft = false;
        break;
      case RIGHT:
        rocket.pitchRight = false;
        break;
    }
  }
}
//Wrapper class for PImage to work with them in a window
class Image {
  PImage img;
  String name;
  float x, y;
  
  //Draw image with x and y cached
  public void render() {
    image(img, x, y);
  }
  
  Image(PImage img, String name, float x, float y) {
    this.img = img;
    this.name = name;
    this.x = x; this.y = y;
  }
}
public void initInstructions() {
  instructionsWindow = new Window();
  instructionsWindow.addLabel(25, 50, 100, 500, "backgroundLbl", "Click \"Play Game\" to begin. In the play window, click inside\n"
                                                               + "of a box on the grid to select a part and build your rocket.\n"
                                                               + "Click \"Trash\" to remove your held part.\n\n"
                                                               + "Structure Block: Basic block--provides structure for rocket\n"
                                                               + "Fuel Block: Stores fuel for your rocket to use\n"
                                                               + "Thruster Block: Burns fuel to produce thrust\n"
                                                               + "Once your rocket is complete, click \"Fly Rocket!\" to launch!\n"
                                                               + "Tap the spacebar to toggle your thrusters on and off.\n"
                                                               + "While in the air, use the Left and Right arrow keys to move the\n"
                                                               + "rocket. Stay on course, and good luck!", 20);
  instructionsWindow.addButton(280, 650, 200, 50, "optionsBackBtn", "Back to Main Menu", 20);
}

public void instructionsDriver() {
  instructionsWindow.render();
}
class Label {
  float x, y, Width, Height; // Capitalized because of width/height reserved
  String text;
  String name;
  int textSize;
  
  //Render the label by drawing text left-justified at the given point
  public void render() {
    textAlign(LEFT);
    textSize(textSize);
    //Draw backcolor, if hovered over
    stroke(white);
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

class LineSegment {
  Vector2D startPos;
  Vector2D endPos;
  
  public Vector2D getCenter() {
    return new Vector2D((endPos.x + startPos.x)/2, (endPos.y + startPos.y)/2);
  }
  
  //Constructor with two points in float form
  LineSegment(float x1, float y1, float x2, float y2) {
    startPos = new Vector2D(x1, y1);
    endPos = new Vector2D(x2, y2);
  }
}
public void initMainMenu() {
  mainMenuWindow = new Window();
  mainMenuWindow.addImage("titlelogo.png", "title", 160, 50);
  mainMenuWindow.addButton(280, 400, 200, 50, "playGameBtn", "Play Game", 30);
  mainMenuWindow.addButton(280, 500, 200, 50, "instructionsBtn", "Instructions", 30);
  mainMenuWindow.addButton(280, 600, 200, 50, "optionsBtn", "Options", 30);
}

public void mainMenuDriver() {
  mainMenuWindow.render();
  if(sound && !menu.isPlaying()) {
    menu.play();
  }
}
static ArrayList<Integer> milestoneHeights = new ArrayList<Integer>();
static ArrayList<String> milestones = new ArrayList<String>();

public static void initMilestones() {
  milestoneHeights.add(0);
  milestones.add("Sea Level");
  milestoneHeights.add(828);
  milestones.add("Burj Khalifa");
  milestoneHeights.add(8849);
  milestones.add("Mt Everest");
  milestoneHeights.add(10000);
  milestones.add("Troposphere");
  milestoneHeights.add(18000);
  milestones.add("Stratosphere");
  milestoneHeights.add(48000);
  milestones.add("Ionosphere");
  milestoneHeights.add(70000);
  milestones.add("Karman Line (space!)");
  milestoneHeights.add(408773);
  milestones.add("International Space Station");
  milestoneHeights.add(384472282);
  milestones.add("The Moon");
}


public static String getCurrentMilestone(int meters) {
  String milestone = "";
  int milestoneHeight = 0;
  for(int i = 0; i < milestoneHeights.size(); i++) {
    if(meters >= milestoneHeights.get(i)) {
      milestone = milestones.get(i);
      milestoneHeight = milestoneHeights.get(i);
    }
    else {
      return milestone + ", " + milestoneHeight + " m";
    }
  }
  return "";
}

public static String getNextMilestone(int meters) {
  for(int i = 0; i < milestoneHeights.size(); i++) {
    if(meters < milestoneHeights.get(i)) {
      return milestones.get(i) + ", " + milestoneHeights.get(i) + " m";
    }
  }
  return "";
}

//Reference to a rocketpart temporarily held in the mouse
class MouseHolder {
  RocketPart currentPart = new RocketPart();
  
  public void render() {
    if(currentPart.type==RocketPartTypes.EMPTY) {
      return;
    }
    stroke(white);
    currentPart.render(30, mouseX, mouseY);
  }
}
public void initOptions() {
  optionsWindow = new Window();
  optionsWindow.addButton(280, 650, 200, 50, "optionsBackBtn", "Back to Main Menu", 20);
  optionsWindow.addLabel(50, 200, 100, 50, "backgroundLbl", "Change background color:", 30);
  optionsWindow.addButton(500, 200, 200, 50, "backgroundBtn", "Background Color", 20);
  optionsWindow.addLabel(230, 300, 100, 50, "soundLbl", "Sound Effects:", 30);
  optionsWindow.addButton(500, 300, 200, 50, "soundBtn", "On/Off", 30);
}

public void optionsDriver() {
  optionsWindow.render();
}

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
  float gConstant = 0.0005f;
  float fuelMaximum;
  float fuelAggregate;
  float fuelAmountConstant = 30;
  float fuelUsageConstant = 0.01f;
  float thrustConstant = 0.4f;
  float maxThrusterAngle = 0.8f;
  boolean thrustState = false;
  boolean pitchLeft = false;
  boolean pitchRight = false;
  float rotationConstant = 0.01f;
  float rocketAngle = 0;
  LineSegment[] segments;
  LineSegment[] thrustVectors;
  float thrusterAngle = 0;
  RocketPart[] rocketParts;
  Vector2D[] starPositions = new Vector2D[90];
  Vector2D[] thrustParticles = new Vector2D[40];
  Vector2D[] thrustDirections = new Vector2D[40];
  int frameState = 0; // Only add a thrust particle every 4 frames
  int thrustIndex = 0;
  int scale = 30;
  
  public void render() {
    //Draw segments
    /*stroke(white);
    for(int i = 0; i < segments.length; i++) {
      line(segments[i].startPos.x+width/2, segments[i].startPos.y+height-140, segments[i].endPos.x+width/2, segments[i].endPos.y+height-140);
    }*/
    
    //Draw rocket part positions
    
    for(int i = 0; i < rocketParts.length; i++) {
      pushMatrix();
      translate(width/2+rocketParts[i].x, height-140+rocketParts[i].y);
      rotate(rocketAngle);
      switch(rocketParts[i].type) {
        case RocketPartTypes.FUEL:
          image(fuelImage, 0, 0);
          break;
        case RocketPartTypes.CREWCAPSULE:
          image(crewImage, 0, 0);
          break;
        case RocketPartTypes.THRUSTER:
          image(thrustImage, 0, 0);
          break;
        case RocketPartTypes.BLOCK:
          image(structureImage, 0, 0);
          break;
      }
      popMatrix();
       // circle(rocketParts[i].x+width/2, rocketParts[i].y+height-140, 8);
    }
    
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
      
      //Draw fuel amount
      stroke(255);
      fill(0);
      rect(20, 20, width - 40, 20);
      fill(255);
      stroke(0);
      rect(21, 21, (max(fuelAggregate, 0) / fuelMaximum) * (width - 42), 18);
      
    if(debug) {
      
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
      
      
    }
  }
  
  //Rotates the rocket and its thrust vectors about the center of mass by angleRads
  public void rotateRocket(float angleRads) {
    //Update rocket angle
    rocketAngle -= angleRads;
    if(rocketAngle > PI*2) {
      rocketAngle -= PI*2;
    }
    else if (rocketAngle < -PI*2) {
      rocketAngle += PI*2;
    }
    
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
    
    //Rotate rocket parts
    for(int i = 0; i < rocketParts.length; i++) {
      //Points to rotate -> are already in relation to center of mass
      Vector2D rocketPartPosition = new Vector2D(rocketParts[i].x, rocketParts[i].y);
      
      //Calculate rotated points
      Vector2D newRocketPartPosition = new Vector2D(rocketPartPosition.x * cos(angleRads) - rocketPartPosition.y * sin(angleRads),
                                          rocketPartPosition.x * sin(angleRads) + rocketPartPosition.y * cos(angleRads));
      
      //Assign new rotated values
      rocketParts[i].x = newRocketPartPosition.x;
      rocketParts[i].y = newRocketPartPosition.y;
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
  
  public void calculateLinearAcceleration() {
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
  
  public void calculateAngularAcceleration() {
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
  public void angleThrusters() {
    if(pitchLeft && thrusterAngle < maxThrusterAngle) {
      for(int i = 0; i < thrustVectors.length; i++) {
        //Update thruster angle
        thrusterAngle += rotationConstant;
        
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
    if(pitchRight && thrusterAngle > -maxThrusterAngle) {
      for(int i = 0; i < thrustVectors.length; i++) {
        //Update thruster angle
        thrusterAngle -= rotationConstant;
        
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
  
  public void handleThrust() {
    //Iterate through thrust vectors and spawn particles if thrustState is on
    frameState++;
    if(thrustState && frameState >= 3 && fuelAggregate > 0) {
      frameState = 0;
      for(int i = 0; i < thrustVectors.length; i++) {
        thrustParticles[thrustIndex] = new Vector2D(thrustVectors[i].startPos.x, thrustVectors[i].startPos.y);
      
        float randomAngleDeviation = random(1) - 0.5f;
        Vector2D thrustVector = new Vector2D(thrustVectors[i].endPos.x - thrustVectors[i].startPos.x, thrustVectors[i].endPos.y - thrustVectors[i].startPos.y);
      
        Vector2D newThrustVector = new Vector2D(thrustVector.x * cos(-randomAngleDeviation) - thrustVector.y * sin(-randomAngleDeviation),
                                                thrustVector.x * sin(-randomAngleDeviation) + thrustVector.y * cos(-randomAngleDeviation));
                                                
        thrustDirections[thrustIndex] = newThrustVector.getNormalized(); // Normalize for slow movement
      
        thrustIndex++;
        if(thrustIndex >= thrustParticles.length) {
          thrustIndex = 0;
        }
      }
    }
    
    for(int i = 0; i < thrustParticles.length; i++) {
      //Update particle position
      thrustParticles[i].x += thrustDirections[i].x;
      thrustParticles[i].y += thrustDirections[i].y;
      
      //Draw
      stroke(white);
      fill(white);
      rect(thrustParticles[i].x + width / 2, thrustParticles[i].y + height - 140, 5, 5);
    }
  }
  
  public void update() {
    
    //Angle the thrusters according to input
    angleThrusters();
    
    //Animate thrust from rocket
    handleThrust();
    
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
    
    //Play ambience sound if needed
    if(fuelAggregate <= 0 && thrust.isPlaying()) {
      thrust.stop();
    }
    if(fuelAggregate <= 0 && !ambience.isPlaying()) {
      ambience.play();
    }
  }
  
  public void zeroToCenterOfMass() {
    for(int i = 0; i < segments.length; i++) {
      //Adjust all segments
      segments[i].startPos.x -= x;
      segments[i].startPos.y -= y;
      segments[i].endPos.x -= x;
      segments[i].endPos.y -= y;
    }
    for(int i = 0; i < rocketParts.length; i++) {
      //Adjust all rocket parts
      rocketParts[i].x -= x;
      rocketParts[i].y -= y;
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
  
  public void calculateCenterOfMass() {
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
  
  public void calculateInertialMoment() {
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
  
  public void calculateSegments() {
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
      
      //Scale rocket part size
      rocketParts[i].x *= scale;
      rocketParts[i].y *= scale;
    }
  }
  
  public void convertGridToParts(BuilderGrid builderGrid) {
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
    
    //Initialize thrust particles
    for(int i = 0; i < thrustParticles.length; i++) {
      thrustParticles[i] = new Vector2D(-40, -40);
      thrustDirections[i] = new Vector2D(0, 0);
    }
  }
}
//RocketPart representing a building block for the rocket
class RocketPart {
  int type; // enum of RocketPartTypes
  float x, y;
  Vector2D[] points; // each rocket part is defined by a set of points that create a polygon.
                    // a second rendering pass will be used if additional graphics are needed.
                    
  public void render(float scaleFactor, float drawX, float drawY) {
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
                    
  public void generatePoints() {
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
        points[2] = new Vector2D(0.8f, 1);
        points[3] = new Vector2D(0.2f, 1);
        break;
      case RocketPartTypes.FUEL: // Slightly different shape for distinguishment
        numPoints = 6;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0, 0);
        points[1] = new Vector2D(1, 0);
        points[2] = new Vector2D(0.8f, 0.5f);
        points[3] = new Vector2D(1, 1);
        points[4] = new Vector2D(0, 1);
        points[5] = new Vector2D(0.2f, 0.5f);
        break;
      case RocketPartTypes.CREWCAPSULE: // Slightly different shape for distinguishment
        numPoints = 3;
        points = new Vector2D[numPoints];
        points[0] = new Vector2D(0.5f, 0);
        points[1] = new Vector2D(1, 1);
        points[2] = new Vector2D(0, 1);
        break;
    }
  }
  public void setType(int type) {
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
public void initVehicleAssembly() {
  assemblyWindow = new Window();
  assemblyWindow.addButton(520, 30, 200, 50, "mainMenuBtn", "Main Menu", 30);
  assemblyWindow.addButton(520, 110, 200, 50, "flightBtn", "Fly Rocket!", 30);
  assemblyWindow.addButton(30, 650, 150, 50, "eraseBtn", "Trash", 30);
  assemblyWindow.addButton(210, 650, 150, 50, "structureBtn", "Structure Block", 18);
  assemblyWindow.addButton(390, 650, 150, 50, "thrusterBtn", "Thuster Block", 18);
  assemblyWindow.addButton(570, 650, 150, 50, "fuelBtn", "Fuel Block", 18);
  assemblyWindow.addButton(570, 550, 150, 50, "crewBtn", "Crew Block", 18);
  bg = new BuilderGrid(7, 7, 30, 30, 400, 400);
}

public void vehicleAssemblyDriver() {
  assemblyWindow.render();
  bg.render();
  mouseHolder.render();
}
public void initVehicleFlight() {
  flightWindow = new Window();
  flightWindow.addButton(520, 60, 200, 50, "exitFlightBtn", "Exit Flight", 30);
}

public void vehicleFlightDriver() {
  flightWindow.render();
  //rocket.x = mouseX;
  //rocket.y = mouseY;
  rocket.update();
  rocket.render();
  textAlign(LEFT);
  if(debug) {
    text("x: "+rocket.x, 40, 200);
    text("y: "+rocket.y, 40, 250);
  }
  
  textSize(20);
  text("Height: "+PApplet.parseInt(max(height-140-rocket.y, 0))+" meters", 40, 300);
  
  text("Reached milestone: " + getCurrentMilestone(PApplet.parseInt(max(height-140-rocket.y, 0))), 40, 350);
  text("Next milestone: " + getNextMilestone(PApplet.parseInt(max(height-140-rocket.y, 0))), 40, 400);
}

//Class for storing 2 coupled values conveniently
class Vector2D {
  float x, y;
  
  public float getAngle(Vector2D otherVector) {
    Vector2D thisNormalized = this.getNormalized();
    Vector2D otherNormalized = otherVector.getNormalized();
    float angle = acos(constrain((otherNormalized.x * thisNormalized.x + otherNormalized.y * thisNormalized.y) / (thisNormalized.magnitude() * otherNormalized.magnitude()), -1, 1));
    if(Float.isNaN(angle)) {
      println("get angle nanned");
      exit();
    }
    return angle;
  }
  public float magnitude() {
    return sqrt(x*x + y*y);
  }
  public Vector2D getNormalized() {
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
//Defines an environment of gui controls--so that we can switch between environments
class Window {
  ArrayList<Button> buttons;
  ArrayList<Label> labels;
  ArrayList<Image> images;
  
  //Add a button through button constructor
  public void addButton(float x, float y, float Width, float Height, String name, String text, int textSize) {
      buttons.add(new Button(x, y, Width, Height, name, text, textSize));
  }
  //Remove a button by checking against text
  public void removeButton(String name) {
      for(int i = 0; i < buttons.size(); i++) {
        if(buttons.get(i).name==name) {
          buttons.remove(i);
          return;
        }
      }
  }
  //Add a label through label constructor
  public void addLabel(float x, float y, float Width, float Height, String name, String text, int textSize) {
    labels.add(new Label(x, y, Width, Height, name, text, textSize));
  }
  //Remove a label by checking against text
  public void removeLabel(String name) {
      for(int i = 0; i < labels.size(); i++) {
        if(labels.get(i).name==name) {
          labels.remove(i);
          return;
        }
      }
  }
  //Add an image through imgSource
  public void addImage(String imgSource, String name, int x, int y) {
     PImage img = new PImage();
     img = loadImage(imgSource);
     images.add(new Image(img, name, x, y)); 
  }
  //Calculates the hover state of each button
  public void handleMouseHover() {
    for(int i = 0; i < buttons.size(); i++) {
      if(buttons.get(i).isInBounds(mouseX, mouseY)) {
        buttons.get(i).hoverState = true; 
      }
      else {
        buttons.get(i).hoverState = false; 
      }
    }
  }
  //Handles a mouse click passed by the mousePressed main event handler
  public void handleMouseClick() {
    for(int i = 0; i < buttons.size(); i++) {
      if(buttons.get(i).isInBounds(mouseX, mouseY)) {
        println("Button " + buttons.get(i).name + " was clicked.");
        globalButtonHandler(buttons.get(i).name);
      }
    }
  }
  //Render all window components
  public void render() {
    handleMouseHover(); //Should always check hover states before rendering
     for(int i = 0; i < buttons.size(); i++) {
       buttons.get(i).render();
     }
     for(int i = 0; i < labels.size(); i++) {
       labels.get(i).render();
     }
     for(int i = 0; i < images.size(); i++) {
       images.get(i).render();
     }
  }
  
  Window() {
    buttons = new ArrayList<Button>();
    labels = new ArrayList<Label>();
    images = new ArrayList<Image>();
  }
}
//Pseudo-enum simulated through constant static integers
class WindowState {
  final static int MAIN_MENU = 0;
  final static int VEHICLE_ASSEMBLY = 1;
  final static int VEHICLE_FLIGHT = 2;
  final static int OPTIONS = 3;
  final static int INSTRUCTIONS = 4;
}
  public void settings() {  size(750, 750); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RocketSimulator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
