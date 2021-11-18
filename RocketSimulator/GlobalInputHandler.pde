
//Executes code based on the name of the button that was clicked.
//Events/delegates and lambda functions are both absent from processing--this is
//the current solution for allowing buttons to execute new code segments.
void globalButtonHandler(String buttonName) {
  switch(buttonName) {
    case "playGameBtn":
      windowState = WindowState.VEHICLE_ASSEMBLY;
      break;
    case "mainMenuBtn":
      windowState = WindowState.MAIN_MENU;
      break;
    case "optionsBtn":
      windowState = WindowState.OPTIONS;
      break;
    case "optionsBtn1":
      windowState = WindowState.MAIN_MENU;
      break;
  }
}
