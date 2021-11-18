void vehicleAssemblyDriver() {
  for(int i = 2; i < b.length; i++) {
    if(b[i].isInBounds(mouseX, mouseY)) {
      b[i].hoverState = true; 
    }
    else {
      b[i].hoverState = false; 
    }
    
    b[i].render();
  }
}
