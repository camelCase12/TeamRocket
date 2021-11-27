//Global/static variables--each window and the window state
Window mainMenuWindow;
Window assemblyWindow;
Window flightWindow;
Window optionsWindow;
Window instructionsWindow;
MouseHolder mouseHolder;
int windowState;
BuilderGrid bg;

//Options menu variables
boolean sound = true;
int black = 0;
int white = 255;
int gray = 0;

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
  
  //Test initialize mouseHolder
  mouseHolder = new MouseHolder();
  mouseHolder.currentPart.setType(RocketPartTypes.BLOCK);
  
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
