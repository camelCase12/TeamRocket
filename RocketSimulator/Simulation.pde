void initVehicleFlight() {
  flightWindow = new Window();
  flightWindow.addButton(520, 60, 200, 50, "exitFlightBtn", "Exit Flight", 30);
}

void vehicleFlightDriver() {
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
  text("Height: "+int(max(height-140-rocket.y, 0))+" meters", 40, 300);
  
  text("Reached milestone: " + getCurrentMilestone(int(max(height-140-rocket.y, 0))), 40, 350);
  text("Next milestone: " + getNextMilestone(int(max(height-140-rocket.y, 0))), 40, 400);
}
