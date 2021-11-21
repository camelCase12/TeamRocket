void initInstructions() {
  instructionsWindow = new Window();
  instructionsWindow.addLabel(25, 50, 100, 500, "backgroundLbl", "Click \"Play Game\" to begin. In the play window, click inside\n"
                                                               + "of a box on the grid to select a part and build your rocket.\n"
                                                               + "Click \"Erase\" to clear the field and start over.\n\n"
                                                               + "Structure Block: \n"
                                                               + "Fuel Block: \n"
                                                               + "Thruster Block: \n"
                                                               + "Fuel Block: \n\n"
                                                               + "Once your rocket is complete, click \"Fly Rocket!\" to launch!\n"
                                                               + "While in the air, use the Left and Right arrow keys to move the\n"
                                                               + "rocket. Stay on course, and good luck!", 20);
  instructionsWindow.addButton(280, 650, 200, 50, "optionsBackBtn", "Back to Main Menu", 20);
}

void instructionsDriver() {
  instructionsWindow.render();
}
