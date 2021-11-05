Button[] b = new Button[2];
PImage img;

void setup() {
  background(0);
  size(750, 750);
  b[0] = new Button(280, 400, 200, 50, "Play Game");
  b[1] = new Button(280, 600, 200, 50, "Options");
  b[0].init();
  img = loadImage("output-onlinepngtools.png");
}

void init() {
 textAlign(CENTER); 
}

void draw() {
  background(0);
  
  image(img, 160, 50);
  
  for(int i = 0; i < b.length; i++) {
    if(b[i].isInBounds(mouseX, mouseY)) {
     b[i].hoverState = true; 
    }
    else {
     b[i].hoverState = false; 
    }
    
    b[i].render();
  }
}

void mousePressed() {
  for(int i = 0; i < b.length; i++) {
    if(b[i].isInBounds(mouseX, mouseY)) {
      println("Button " + i + " was clicked.");
      break;
    }
  }
}
