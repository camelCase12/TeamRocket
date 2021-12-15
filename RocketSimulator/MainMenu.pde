void initMainMenu() {
  mainMenuWindow = new Window();
  mainMenuWindow.addImage("titlelogo.png", "title", 160, 50);
  mainMenuWindow.addButton(280, 400, 200, 50, "playGameBtn", "Play Game", 30);
  mainMenuWindow.addButton(280, 500, 200, 50, "instructionsBtn", "Instructions", 30);
  mainMenuWindow.addButton(280, 600, 200, 50, "optionsBtn", "Options", 30);
}

void mainMenuDriver() {
  mainMenuWindow.render();
  if(sound && !menu.isPlaying()) {
    menu.play();
  }
}
