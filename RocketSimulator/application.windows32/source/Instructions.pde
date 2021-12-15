void initInstructions() {
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

void instructionsDriver() {
  instructionsWindow.render();
}
