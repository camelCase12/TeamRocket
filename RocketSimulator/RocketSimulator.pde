Button[] b = new Button[3];
PImage img;
String menu;

void setup() {
  background(0);
  size(750, 750);
  b[0] = new Button(280, 400, 200, 50, "Play Game");
  b[1] = new Button(280, 600, 200, 50, "Options");
  b[0].init();
  img = loadImage("titlelogo.png");
  menu = "Main Menu";
  
  b[2] = new Button(280, 450, 200, 50, "Main Menu");  //A placeholder button for the sandbox
}

void init() {
 textAlign(CENTER);
}

void draw() {
  background(0);
  
  switch(menu) {
    case "Main Menu":
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
      break;
    case "Vehicle Assembly":
      vehicleAssemblyDriver();
      break;
  }
}

void mousePressed() {
  for(int i = 0; i < b.length; i++) {
    if(b[i].isInBounds(mouseX, mouseY)) {
      println("Button " + i + " was clicked.");
      switch (i) {
        case 0:
          menu = "Vehicle Assembly";
          break;
        case 1:
          break;
        case 2:
          menu = "Main Menu";
      }
      break;
    }
  }
}
