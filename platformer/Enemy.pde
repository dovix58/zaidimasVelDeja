class Enemy extends Animation{

float boundryLeft, boundryRight;
      Enemy(PImage image, float scale,float x,float y, float bLeft, float bRight, float row, float col){
      
      super(image, scale,x,y,row,col);
      moveLeft = new PImage[2];
      moveLeft[0] = loadImage("enemies/Walk1.png");
      moveLeft[1] = loadImage("enemies/Walk2.png");
      
      moveRight = new PImage[2];
      moveRight[0] = loadImage("enemies/Walk1R.png");
      moveRight[1] = loadImage("enemies/Walk2R.png");
      
      currentImages = moveRight;
      direction = rightFacing;
      boundryLeft = bLeft;
      boundryRight = bRight;
      changeX = 2;
      
      }
      void update(){
      
      super.update();  
      if (getLeft() <= boundryLeft){
        setLeft(boundryLeft);
        changeX *= -1;
      
      
      }
      else if (getRight() >= boundryRight){
      setRight(boundryRight);
        changeX *= -1;
      }
      
      
      }


}
