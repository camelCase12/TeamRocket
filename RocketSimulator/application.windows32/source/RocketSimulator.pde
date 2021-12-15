import processing.sound.*;

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
void setup() {
  //Set background color to black and size to 750px*750px
  background(gray);
  size(750, 750);
  
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
void draw() {
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
void mousePressed() {
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
void keyPressed() {
  if(windowState==WindowState.VEHICLE_FLIGHT) {
    globalKeyHandler();
  }
}

void keyReleased() {
  if(windowState==WindowState.VEHICLE_FLIGHT) {
    globalReleaseHandler();
  }
}
