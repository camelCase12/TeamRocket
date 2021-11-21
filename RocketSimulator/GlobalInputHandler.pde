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
    case "optionsBackBtn":
      windowState = WindowState.MAIN_MENU;
      break;
    case "instructionsBtn":
      windowState = WindowState.INSTRUCTIONS;
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
      print("Turned the sound off!\n");
      } else {
      sound = true;
      print("Turned the sound on!\n");
      }
      break;
  }
}
