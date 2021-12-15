class BuilderGrid {
  RocketPart[][] grid;
  float x, y;
  float Width, Height;
  float cellSizeX, cellSizeY;
  String errorText = "";
  
  void render() {
    stroke(white);
    fill(black);
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        //Draw the cell itself
        rect(x + cellSizeX*i, y + cellSizeY*j, cellSizeX, cellSizeY);
        
        //Draw the part in the cell
        float scaleDown = 0.9;
        grid[i][j].render(scaleDown*cellSizeX, x + cellSizeX*i + cellSizeX*(1-scaleDown)/2, y + cellSizeY*j + cellSizeY*(1-scaleDown)/2);
      }
    }
    
    //Draw errorText
    stroke(255, 0, 0);
    fill(255, 0, 0);
    textAlign(CENTER);
    text(errorText, width/2, height - 250);
  }
  
  void handleMouseClick() {
    //Adjust mouse to grid's coordinates
    float gridNormalizedMouseX = mouseX - x;
    float gridNormalizedMouseY = mouseY - y;
    //Calculate the square that the mouse would land in
    int clickedSquareX = (int)(gridNormalizedMouseX / cellSizeX);
    int clickedSquareY = (int)(gridNormalizedMouseY / cellSizeY);
    if(clickedSquareX < 0 || clickedSquareY < 0 || clickedSquareX >= grid.length
        || clickedSquareY >= grid[0].length) {
          return;
    }
    //Place whatever is in the mouseHolder into the square, or pick up the square if the mouseHolder is empty
    if(mouseHolder.currentPart.type == RocketPartTypes.EMPTY) { // Pick up what is in the square
      mouseHolder.currentPart.setType(grid[clickedSquareX][clickedSquareY].type);
      grid[clickedSquareX][clickedSquareY].setType(RocketPartTypes.EMPTY);
    }
    else if (grid[clickedSquareX][clickedSquareY].type == RocketPartTypes.EMPTY) { // Place down item into the square
      grid[clickedSquareX][clickedSquareY].setType(mouseHolder.currentPart.type);
      mouseHolder.currentPart.setType(RocketPartTypes.EMPTY);
    }
    else { // Swap items
      int tempType = grid[clickedSquareX][clickedSquareY].type;
      grid[clickedSquareX][clickedSquareY].setType(mouseHolder.currentPart.type);
      mouseHolder.currentPart.setType(tempType);
    }
    println("Clicked grid at: (x: " + clickedSquareX + ", y: " + clickedSquareY + ")");
  }
  
  boolean verifyGrid() {
    //Verify that rocket contains necessary parts
    boolean hasCrewCapsule = false;
    boolean hasFuelTank = false;
    boolean hasThruster = false;
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        if(grid[i][j].type == RocketPartTypes.CREWCAPSULE) {
          if(j == grid[0].length-1) {
            errorText = "You need a structure block below the crew capsule.";
            return false;
          }
          if(grid[i][j+1].type != RocketPartTypes.BLOCK) {
            errorText = "You need a structure block below the crew capsule.";
            return false;
          }
          hasCrewCapsule = true;
        }
        if(grid[i][j].type == RocketPartTypes.FUEL) {
          hasFuelTank = true;
        }
        if(grid[i][j].type == RocketPartTypes.THRUSTER) {
          if(j == 0) {
            errorText = "You need a block above the thruster block.";
            return false;
          }
          if(grid[i][j-1].type == RocketPartTypes.EMPTY) {
            errorText = "You need a block above the thruster block.";
            return false;
          }
          hasThruster = true;
        }
      }
    }
    //Print necessary part missing error messages
    if(!hasCrewCapsule) {
      errorText = "Please add a crew capsule!";
      return false;
    }
    if(!hasFuelTank) {
      errorText = "Please add a fuel tank!";
      return false;
    }
    if(!hasThruster) {
      errorText = "Please add a thruster!";
      return false;
    }
    
    //Check to make sure rocket is contiguous
    int partCount = 0;
    for(int i = 0; i < grid.length; i++) {
      for(int j = 0; j < grid[0].length; j++) {
        if(grid[i][j].type != RocketPartTypes.EMPTY) {
          partCount++;
        }
      }
    }
    
    return true;
  }
  
  BuilderGrid(int gridSizeX, int gridSizeY, float x, float y, float Width, float Height) {
    grid = new RocketPart[gridSizeX][gridSizeY];
    for(int i = 0; i < gridSizeX; i++) {
      for(int j = 0; j < gridSizeY; j++) {
        grid[i][j] = new RocketPart();
      }
    }
    this.cellSizeX = Width / gridSizeX;
    this.cellSizeY = Height / gridSizeY;
    this.x = x;
    this.y = y;
  }
}
