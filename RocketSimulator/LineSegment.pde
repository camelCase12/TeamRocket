
class LineSegment {
  Vector2D startPos;
  Vector2D endPos;
  
  Vector2D getCenter() {
    return new Vector2D((endPos.x + startPos.x)/2, (endPos.y + startPos.y)/2);
  }
  
  //Constructor with two points in float form
  LineSegment(float x1, float y1, float x2, float y2) {
    startPos = new Vector2D(x1, y1);
    endPos = new Vector2D(x2, y2);
  }
}
