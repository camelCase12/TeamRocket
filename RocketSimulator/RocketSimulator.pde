Button[] b = new Button[2];

void setup() {
  background(0);
  size(750, 750);
  b[0] = new Button(50, 50, 200, 50, "Button 1");
  b[1] = new Button(50, 200, 200, 50, "Button 2");
}

void draw() {
  background(0);
  
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
