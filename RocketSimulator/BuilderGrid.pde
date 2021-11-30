class BuilderGrid {
  RocketPart[][] grid;
  float x, y;
  float Width, Height;
  float cellSizeX, cellSizeY;
  
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
    else { // Place down item into the square
      grid[clickedSquareX][clickedSquareY].setType(mouseHolder.currentPart.type);
      mouseHolder.currentPart.setType(RocketPartTypes.EMPTY);
    }
    println("Clicked grid at: (x: " + clickedSquareX + ", y: " + clickedSquareY + ")");
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
