class Player extends Animation {

  int lives;
  int num = 1;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;

  Player(PImage img, float scale) {

    super(img, scale,0,0,0,0);
    lives = 3;
    direction = rightFacing;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("anim/standL.png");

      standRight= new PImage[2];
    standRight[0] = loadImage("anim/standR.png");
     standRight[1] = loadImage("anim/standR.png");

      jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("anim/jumpL.png");

      jumpRight = new PImage[1];
    jumpRight[0] = loadImage("anim/jumpR.png");

      moveLeft = new PImage[9];
    for (int i = 0; i < 9; ++i) {
      moveLeft[i] = loadImage("anim/walkL/p1_walk" + num +".png");
      ++num;
    }
    num = 1;
    moveRight = new PImage[9];
      for (int i = 0; i < 9; ++i) {
      moveRight[i] = loadImage("anim/walkR/p1_walk" + num +".png");
      ++num;
    }
    currentImages = standRight;
  }



  @Override
    void updateAnimation() {
   
      onPlatform = isOnPlatform(this, platforms);
    
    inPlace = changeX == 0 && changeY == 0;
    
    super.updateAnimation();
    
  }
  @Override
    void selectDirection() {
    if (changeX > 0) {
      direction = rightFacing;
    } else if (changeX < 0)  {
      direction = leftFacing;
  }
    
    }
    

  @Override
    void selectCurrentImages() {
    if (direction == rightFacing) {
      if (inPlace) {
        currentImages = standRight;
      } else if (!onPlatform) {
        currentImages = jumpRight;
      } else {
        currentImages = moveRight;
      }
    }
    else if (direction == leftFacing) {
      if (inPlace) {
        currentImages = standLeft;
      } else if (!onPlatform) {
        currentImages = jumpLeft;
      } else {
        currentImages = moveLeft;
      }
    }
    
    
    
   
    
    
    
    
  }
}
