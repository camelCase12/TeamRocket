void initVehicleAssembly() {
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

void vehicleAssemblyDriver() {
  assemblyWindow.render();
  bg.render();
  mouseHolder.render();
}
