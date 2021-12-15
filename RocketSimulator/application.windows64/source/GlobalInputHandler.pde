//Executes code based on the name of the button that was clicked.
//Events/delegates and lambda functions are both absent from processing--this is
//the current solution for allowing buttons to execute new code segments.
void globalButtonHandler(String buttonName) {
  
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

void globalKeyHandler() {
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

void globalReleaseHandler() {
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
