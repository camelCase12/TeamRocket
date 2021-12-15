
//Reference to a rocketpart temporarily held in the mouse
class MouseHolder {
  RocketPart currentPart = new RocketPart();
  
  void render() {
    if(currentPart.type==RocketPartTypes.EMPTY) {
      return;
    }
    stroke(white);
    currentPart.render(30, mouseX, mouseY);
  }
}
