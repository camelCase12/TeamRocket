void initOptions() {
  optionsWindow = new Window();
  optionsWindow.addButton(280, 650, 200, 50, "optionsBackBtn", "Back to Main Menu", 20);
  optionsWindow.addLabel(50, 200, 100, 50, "backgroundLbl", "Change background color:", 30);
  optionsWindow.addButton(500, 200, 200, 50, "backgroundBtn", "Background Color", 20);
  optionsWindow.addLabel(230, 300, 100, 50, "soundLbl", "Sound Effects:", 30);
  optionsWindow.addButton(500, 300, 200, 50, "soundBtn", "On/Off", 30);
}

void optionsDriver() {
  optionsWindow.render();
}
