
//make global variables
//make tetris blocks
final Block I=new Block(new int[][]{{0, 0}, {1, 0}, {2, 0}, {3, 0}}, new int[]{1, 0});
final Block L=new Block(new int[][]{{0, 0}, {1, 0}, {2, 0}, {2, 1}}, new int[]{1, 0});
final Block T=new Block(new int[][]{{0, 0}, {1, 0}, {2, 0}, {1, 1}}, new int[]{1, 0});
final Block O=new Block(new int[][]{{0, 0}, {1, 0}, {0, 1}, {1, 1}}, new int[]{1, 0});
final Block Z=new Block(new int[][]{{0, 0}, {1, 0}, {1, 1}, {2, 1}}, new int[]{1, 0});
final Block[]tetris_blocks=new Block[]{I, L, T, O, Z};

//initial state of blocks
Block[]blocks=new Block[100];
int current_block=-1;

//setup the game
//--------------------------------------------------------------------------------------------------------------------------------------------------
void setup() {
  size(400, 800);
  frameRate(60);

  blocks[0]=T.clone();
  current_block=0;

  thread("update");
}

//draw the game
//-------------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  clear();
  for (Block block : blocks) {
    if (block==null) {
      break;
    }
    block.draw();
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      blocks[current_block].rotateRight();
    } else if (keyCode == DOWN) {
      blocks[current_block].rotateLeft();
    } else if (keyCode == RIGHT) {
      blocks[current_block].goRight();
    } else if (keyCode == LEFT) {
      blocks[current_block].goLeft();
    } else {
      return;
    }

    redraw();
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------------
void update() {
  while (true) {
    for (Block block : blocks) {
      if (block==null) {
        break;
      }
      block.update();
    }
    delay(400);
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------
Block chooseBlock() {
  return tetris_blocks[int(random(tetris_blocks.length))].clone();
}

//------------------------------------------------------------------------------------------------------------------------------------------

class Block {

  public static final int BLOCK_WIDTH = 40;
  public static final int BLOCK_HEIGHT = 40;

  private int[][] positions;
  private int[] center;

  private final color c;

  //--------------------------------------------------------------------------------------------------------------------------------------------

  Block (int[][] positions, int[] center) {
    this(positions, center, color(255, 255, 0));
  }
  Block (int[][] positions, int[] center, color c) {
    this.positions = positions;
    this.center = center;

    this.c = c;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  Block clone() {
    int[][] positions =  new int[this.positions.length][];
    for (int i = 0; i < positions.length; i++) {
      positions[i] = this.positions[i].clone();
    }

    return new Block(positions, center.clone());
  }



  //---------------------------------------------------------------------------------------------------------------------------------------------
  void draw() {

    fill(c);
    for (int[] position : positions) {
      rect(position[0]*BLOCK_WIDTH, position[1]*BLOCK_HEIGHT, BLOCK_WIDTH, BLOCK_HEIGHT);
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------
  int bottom() {
    int max = 0;
    for (int[] position : positions) {
      if (position[1] > max) {
        max = position[1];
      }
    }

    return max;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  int right() {
    int max = 0;
    for (int[] position : positions) {
      if (position[0] > max) {
        max = position[0];
      }
    }

    return max;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  int left() {
    int min = 100;
    for (int[] position : positions) {
      if (position[0] < min) {
        min = position[0];
      }
    }

    return min;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
    if (bottom() < 19) {
      shift(0, 1);
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  void shift(int x, int y) {
    for (int[] position : positions) {
      position[0] += x;
      position[1] += y;
    }
    center[0] += x;
    center[1] += y;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  void goRight() {
    if (right() < 9) {
      shift(1, 0);
    }
  }

  void goLeft() {
    if (left() > 0) {
      shift(-1, 0);
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------

  void rotateRightDangerous() { // could go out of bounds
    for (int[] position : positions) {
      int dif_x = position[0] - center[0];
      int dif_y = position[1] - center[1];
      position[0] = center[0] + dif_y;
      position[1] = center[1] - dif_x;
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------

  void rotateLeftDangerous() { // could go out of bounds
    for (int[] position : positions) {
      int dif_x = position[0] - center[0];
      int dif_y = position[1] - center[1];
      position[0] = center[0] - dif_y;
      position[1] = center[1] + dif_x;
    }
  }
  
  void rotateRight() { // safe rotation
    Block temp = clone();
    temp.rotateRightDangerous();
    if(temp.left() >= 0 && temp.right() < 10 && temp.bottom() < 20) {
      rotateRightDangerous();
    }
  }
  
  void rotateLeft() { // safe rotation
    Block temp = clone();
    temp.rotateLeftDangerous();
    if(temp.left() >= 0 && temp.right() < 10 && temp.bottom() < 20) {
      rotateLeftDangerous();
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------
