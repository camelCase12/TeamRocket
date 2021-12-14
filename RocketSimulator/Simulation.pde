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
  text("x: "+rocket.x, 40, 200);
  text("y: "+rocket.y, 40, 250);
}
