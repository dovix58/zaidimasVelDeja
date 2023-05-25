class Coins extends Animation{
  
  
  
  Coins(PImage image, float scale, float x, float y, float row, float col){
  super(image, scale,x,y,row,col);
  
  
  standNeutral = new PImage[7];
  
  int value = 1;
  
  for (int i = 0; i < 7; i++){
    standNeutral[i] = loadImage("Coins/coin_0" + value + ".png");
    ++value;
    
  }
  
  currentImages = standNeutral;
  
  
  
  
  
  
  
  
  
  }
}
