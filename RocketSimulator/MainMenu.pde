void initMainMenu() {
  mainMenuWindow = new Window();
  mainMenuWindow.addImage("titlelogo.png", "title", 160, 50);
  mainMenuWindow.addButton(280, 400, 200, 50, "playGameBtn", "Play Game", 30);
  mainMenuWindow.addButton(280, 600, 200, 50, "optionsBtn", "Options", 30);
}

void mainMenuDriver() {
  mainMenuWindow.render();
}
/*
      image(img, 160, 50); //Displays title image
      for(int i = 0; i < 2; i++) { //Robert's Note: I modified this For loop to only display the main menu buttons
        if(b[i].isInBounds(mouseX, mouseY)) {
         b[i].hoverState = true; 
        }
        else {
         b[i].hoverState = false; 
        }
    
        b[i].render();
      }
      */
