//setup the game
//------------------------------------------------------------------
void setup() {
  
  size(500, 500);
}





//draw the game
//---------------------------------------------------------------------
void draw() {
  fill(0,0,0);
  circle(100,100, 200);
  
}







class Block {
  int[][] positions;
  int[] center;
  Block (int[][] positions, int[] center) {
    this.positions = positions;
    this.center = center;
  }
  
  Block clone() {
     int[][] positions =  new int[this.positions.length][];
     for(int[] position : this.positions) {
       
  }
}
