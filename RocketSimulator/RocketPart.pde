//RocketPart representing a building block for the rocket
class RocketPart {
  int type; // enum of RocketPartTypes
  
  RocketPart() {
    type = RocketPartTypes.EMPTY;
  }
}

class RocketPartTypes {
  final static int EMPTY = 0;
  final static int BLOCK = 1;
}
