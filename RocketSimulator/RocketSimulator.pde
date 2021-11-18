//Global/static variables--each window and the window state
Window mainMenuWindow;
Window assemblyWindow;
Window flightWindow;
Window optionsWindow;
int windowState;
BuilderGrid bg;

//Called upon program launch.
void setup() {
  //Set background color to black and size to 750px*750px
  background(0);
  size(750, 750);
  
  //Initialize each window
  initMainMenu();
  initVehicleAssembly();
  initVehicleFlight();
  initOptions();
  
  //Set the first windowState to MAIN_MENU
  windowState = WindowState.MAIN_MENU;
}

//Called each frame.
void draw() {
  //Clear the frame before drawing
  background(0);
  
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
  }
}
