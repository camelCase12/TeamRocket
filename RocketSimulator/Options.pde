void initOptions() {
  optionsWindow = new Window();
  optionsWindow.addButton(350, 300, 200, 50, "optionsBtn1", "Options Button", 30);
}

void optionsDriver() {
  optionsWindow.render();
}
