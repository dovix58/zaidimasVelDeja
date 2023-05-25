class Animation extends Sprite {

  PImage[] currentImages;
  PImage[] standNeutral;
  PImage[] moveLeft;
  PImage[] moveRight;

  int direction;
  int index;
  int frame;

  Animation(PImage image, float scale, float x, float y, float row, float col) {
    super(image, scale,x,y,row,col);
    direction = neutralFacing;
    index = 0;
    frame = 0;
  }

  void updateAnimation() {

    frame++;
    if (frame % 5 == 0) {
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
    }
  }

  void selectDirection() {

    if (changeX > 0) {
      direction = rightFacing;
    } else if (changeX < 0) {
      direction = leftFacing;
    } else {
      direction = neutralFacing;
    }
  }
  void selectCurrentImages() {
 
    if (direction == rightFacing) {
      currentImages = moveRight;
    } else if (direction == leftFacing) {
      currentImages = moveLeft;
    } else {
      currentImages = standNeutral;
    }

   
  }
  void advanceToNextImage() {

    index++;
    if (index >= currentImages.length) {
      index = 0;
    }

    image = currentImages[index];
    
  }
}
