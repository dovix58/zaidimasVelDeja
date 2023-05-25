public class Sprite {

  PImage image;
  float centerX, centerY;
  float changeX, changeY;
  float w, h;
  float row;
  float col;

  


  Sprite(PImage image, float scale, float x, float y, float row, float col) {

    this.image = image;
    w = image.width * scale;
    h = image.height * scale;

    centerX = x;
    centerY = y;
    changeX = 0;
    changeY = 0;
    this.row = row;
    this.col = col;
  }
  
 
  public void display() {
    if (this.image != null) {
      image(image, centerX, centerY, w, h);
    }
  }
  void setNewValues(int x) {
    if (x == 1) {
      this.image = grass;
      this.h = image.height * 50.0/70;
      this.w = image.width * 50.0/70;
      
    } else if (x == 2) {

      this.image = dirt;
      this.h = image.height * 50.0/70;
      this.w = image.width * 50.0/70;
    } else if (x == 3) {

      this.image = box;
      this.h = image.height * 50.0/70;
      this.w = image.width * 50.0/70;
    } else if (x == 4) {

      this.image = gold;
      this.h = image.height * 50.0/70;
      this.w = image.width * 50.0/70;
    } else if (x == 5) {

      this.image = blob;
      this.h = image.height * 50/30.0;
      this.w = image.width * 50/30.0;
      
    } else if (x == 0) {

      this.image = null;
      
    }
  }
  public void update() {

    centerX += changeX;
    centerY += changeY;
  }

  void setLeft(float left) {
    centerX = left + w/2;
  }
  float getLeft() {
    return centerX - w/2;
  }
  void setRight(float right) {
    centerX = right - w/2;
  }
  float getRight() {
    return centerX + w/2;
  }
  void setTop(float top) {
    centerY = top + h/2;
  }
  float getTop() {
    return centerY - h/2;
  }
  void setBottom(float bottom) {
    centerY = bottom - h/2;
  }
  float getBottom() {

    return centerY + h/2;
  }
}
