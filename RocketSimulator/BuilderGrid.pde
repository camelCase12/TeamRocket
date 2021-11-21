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
        rect(x + cellSizeX*i, y + cellSizeY*j, cellSizeX, cellSizeY);
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
    if(clickedSquareX < 0 || clickedSquareY < 0 || clickedSquareX > grid.length
        || clickedSquareY > grid[0].length) {
          return;
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
