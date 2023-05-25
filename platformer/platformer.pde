import controlP5.*;


final float moveSpeed = 5;
final float spriteScale = 50.0/70;
final int spriteSize = 50;
final float gravity = 0.6;
final float jumpSpeed = 14;

final float rightMargin = 400;
final float leftMargin = 60;
final float verticalMargin = 40;


final int neutralFacing= 0;
final int rightFacing = 1;
final int leftFacing = 2;

final float Width = spriteSize * 32;
final float Height = spriteSize * 16;
final float groundLevel = Height - spriteSize;

Table table;

int gridX, gridY;

import java.util.List;

boolean isGameOver;
boolean isLevelOver;
boolean isMenu = true;
boolean isEditor = false;
boolean isCont = false;

int numCoins;
int level = 1;

Player p;
PImage dirt, grass, box, gold, blob, pl, bg, spriteSheet;
ArrayList<Sprite> platforms;
ArrayList<Coins> coins;
ArrayList<Enemy> bad;

int currentX;
int currentY;
 
 ControlP5 cp5;
Textfield myTextfield;


float viewX = 0;
float viewY = 0;

int forChange;
PImage option;

Button startButton;
Button editor;
void setup() {
  
  
  

  size(800, 600);
  imageMode(CENTER);
  pl = loadImage("anim/standR.png");
  p = new Player(pl, 0.8);
  numCoins = 0;
  
  p.setBottom(groundLevel-100);
  p.centerX = 100;

  isLevelOver = false;
  isGameOver = false;
  isEditor = false;

  p.changeX = 0;
  p.changeY = 0;

  coins = new ArrayList<Coins>();
  bad = new ArrayList<Enemy>();
  platforms = new ArrayList<Sprite>();


  dirt = loadImage("tiles/dirt.png");
  grass = loadImage("tiles/grass.png");
  box = loadImage ("tiles/box.png");
  gold = loadImage ("Coins/coin_01.png");
  blob = loadImage("enemies/Walk1.png");
  bg = loadImage("tiles/bg.png");
  spriteSheet = loadImage("tiles/tiles.png");
  forChange = 1;
  option = loadImage("tiles/dirt.png");

  startButton = new Button((width-200)/2, (height-150)/2, 200, 100, "Start game", 0, 200, 200);
  editor = new Button((width-200)/2, (height-150), 200, 100, "Editor", 0, 200, 200);
  
  cp5 = new ControlP5(this);
   myTextfield = cp5.addTextfield("Input code")
                  .setPosition(p.centerX, p.centerY-250)
                  .setSize(200, 30);
   
 
                  

  switch(level) {

  case 1:
    createPlatforms("map/map1.csv");
    break;
  case 2:
    createPlatforms("map/map2.csv");
    break;
  case 3:
    createPlatforms("map/map3.csv");
  }
}
void draw() {
  background(255); 

  if (isMenu)
  {
    background(150);
    fill(0);
    textSize(70);
    text("Platformer Game \n by Dovydas Kavoliunas", width/2, 100);
    startButton.update();
    startButton.render();

    editor.update();
    editor.render();
    cp5.hide();



    if (startButton.isClicked())
    {
      isMenu = false;
    } else if (editor.isClicked()) {

      isEditor = true;
      isMenu = false;
    }
  } else if (isEditor) {
    

    
    background(255);
    fill(0);
    textSize(70);
    scale(0.50);


    image(grass, 35, 35);
    text("1", 35, 70);

    image(dirt, 110, 35);
    text("2", 110, 70);
    image(box, 185, 35);
    text("3", 185, 70);
    image(blob, 260, 35, 70, 60);
    text("4", 260, 70);
    image(gold, 335, 35);
    text("5", 335, 70);
    fill(255,0,0);
    rect(370,0,70,70);
    fill(0);
    text("X", 405, 70);
    

    textSize(27);
    text("Press the numbers coressponding to the block you want to select. X is for deleting tiles.", 1000, 70);

    translate(0, 400);


    editPlatformLists(platforms);
    editCoinLists(coins);
    editBadLists(bad);

    p.display();
    
    
   

  if (forChange != 0){
    image(option, mouseX*2, mouseY*2-400, 40, 40);
  }

  } else if (isCont){
    //scroll();
    //displayAll();
    
    
  }
  else {
    
    //myTextfield = cp5.addTextfield("Input code")
    //              .setPosition(p.centerX, p.centerY-250)
    //              .setSize(200, 30);
    
    scroll();
    displayAll();
    fill(255, 0, 0);
    textSize(32);
    text("Coin:" + numCoins, viewX + 50, viewY +50);
    text("Lives:" + p.lives, viewX + 50, viewY +100);
    currentX = (int)(p.centerX-100);
    currentY = (int)((p.centerY-850));
    cp5.setPosition(currentX,currentY);
    


    if (!isGameOver && !isLevelOver) {

      updateAll();
      collectCoins();
      checkDeath();
    }
  }
}

  


void editPlatformLists(List<Sprite> sprites) {
  List<Sprite> willBeremoved = new ArrayList<Sprite>();
  for (Sprite spriteItem : sprites)
  {
    if (isInRect(spriteItem)) {
      switch (forChange) {
      case 0:
      case 1:
      case 2:
      case 3:
        //platform to platform
        spriteItem.setNewValues(forChange);
        break;
        //Platform to coins
      case 4:
        willBeremoved.add(spriteItem);
        Coins c = new Coins(gold, spriteScale, spriteItem.centerX, spriteItem.centerY, spriteItem.row, spriteItem.col);
        coins.add(c);
        break;
        //Platform to enemy
      case 5:
        willBeremoved.add(spriteItem);
        Enemy e = new Enemy(blob, 50/30.0, spriteItem.centerX, spriteItem.centerY, spriteItem.getLeft(), spriteItem.getLeft() + (4*spriteSize), spriteItem.row, spriteItem.col);
        bad.add(e);
        break;
      }
    } else {
      spriteItem.display();
      noFill();
      rect(spriteItem.centerX-spriteItem.w/2, spriteItem.centerY-spriteItem.h/2, spriteItem.w, spriteItem.h);
    }
  }
  platforms.removeAll(willBeremoved);
}


void controlEvent(ControlEvent event) {
  if (event.isAssignableFrom(Textfield.class)) {
    println("Text entered: " + event.getStringValue());
  }
}

void editCoinLists(List<Coins> coins) {
  List<Coins> willBeremoved = new ArrayList<Coins>();
  for (Coins coinItem : coins)
  {
    if (isInRect(coinItem)) {
      switch (forChange) {
      case 0:
      case 1:
      case 2:
      case 3:
        //to platform
        willBeremoved.add(coinItem);
        Sprite s = new Sprite(grass, spriteScale, coinItem.centerX, coinItem.centerY, coinItem.row, coinItem.col);
        platforms.add(s);
        break;
        // to coins
      case 4:
        coinItem.setNewValues(forChange);
        break;
        // to enemy
      case 5:
        willBeremoved.add(coinItem);
        Enemy e = new Enemy(blob, 50/30.0, coinItem.centerX, coinItem.centerY, coinItem.getLeft(), coinItem.getLeft() + (4*spriteSize), coinItem.row, coinItem.col);
        bad.add(e);
        break;
      }
    } else {
      coinItem.display();
      noFill();
      rect(coinItem.centerX-coinItem.w/2, coinItem.centerY-coinItem.h/2, coinItem.w, coinItem.h);
    }
  }
  coins.removeAll(willBeremoved);
}

void editBadLists(List<Enemy> enemys) {
  List<Enemy> willBeremoved = new ArrayList<Enemy>();
  for (Enemy enemyItem : enemys)
  {
    if (isInRect(enemyItem)) {
      switch (forChange) {
      case 0:
      case 1:
      case 2:
      case 3:
        //to platform
        willBeremoved.add(enemyItem);
        Sprite s = new Sprite(grass, spriteScale, enemyItem.centerX, enemyItem.centerY, enemyItem.row, enemyItem.col);
        platforms.add(s);
        break;
        // to coins
      case 4:
        willBeremoved.add(enemyItem);
        Coins c = new Coins(gold, spriteScale, enemyItem.centerX, enemyItem.centerY, enemyItem.row, enemyItem.col);
        coins.add(c);
        break;
        // to enemy
      case 5:
        enemyItem.setNewValues(forChange);
        break;
      }
    } else {
      enemyItem.display();
      noFill();
      rect(enemyItem.centerX-enemyItem.w/2, enemyItem.centerY-enemyItem.h/2, enemyItem.w, enemyItem.h);
    }
  }
  bad.removeAll(willBeremoved);
}



boolean isInRect(Sprite s) {
  if ( mousePressed && mouseButton == LEFT  && mouseX*2 > s.getLeft() && mouseX*2 <= s.getRight() && mouseY*2-400 < s.getBottom() && mouseY*2-400 >= s.getTop()) {
    return true;
  }
  return false;
}
void displayAll() {

  p.display();
  if (p.getRight() > 1600) {
    p.centerX = 1600- spriteSize/2;
  }
  if (p.getLeft() < 3) {
    p.centerX = 3+spriteSize/2 ;
  }

  for (Sprite s : platforms)
    s.display();

  for (Sprite c : coins) {
    c.display();
  }

  for (Sprite e : bad) {
    e.display();
  }

  if (isLevelOver && level != 4) {

    fill(0, 0, 255);

    text("You Win!", viewX + width/2 - 100, viewY + height/2);
    text("Press SPACE to continue to next level!", viewX + width/2 - 100, viewY + height/2+ 100);
  }

  if (level == 4 && isLevelOver) {


    text("Game Finished!", viewX + width/2 - 100, viewY + height/2+ 50);
    
  } else if (isGameOver && level != 4) {

    fill(0, 0, 255);
    text("GAME OVER!", viewX + width/2 - 100, viewY + height/2);
    text("You lose!", viewX + width/2 - 100, viewY + height/2+ 50);
    text("Press SPACE to Retry", viewX + width/2 - 100, viewY + height/2+ 100);
  }
}


void updateAll() {

  p.updateAnimation();
  resolvePlatformCollisions(p, platforms);
  for (Sprite c : coins) {
    ((Animation)c).updateAnimation();
  }

  for (Sprite e : bad) {
    e.update();
    ((Animation)e).updateAnimation();
  }
}

void scroll() {
 
  float rightBoundry = viewX + width - rightMargin;
  if (p.getRight()> rightBoundry && p.getRight() <= 1200) {
    viewX += p.getRight() - rightBoundry;
  }

  float leftBoundry = viewX+ leftMargin;
  if (p.getLeft() < leftBoundry && p.getLeft() > spriteSize+10) {
    viewX -= leftBoundry - p.getLeft();
  }
  float bottomBoundry = viewY + height - verticalMargin;
  if (p.getBottom() > bottomBoundry) {
    viewY += p.getBottom()- bottomBoundry;
  }

  float topBoundry = viewY + verticalMargin;
  if (p.getTop() < topBoundry) {
    viewY -= topBoundry - p.getTop();
  }


  translate(-viewX, -viewY);
 
  cp5.update();
  cp5.show();
  currentY += viewY;
  //cp5.setPosition((int)(currentX-viewX),(int)(currentY+viewY));
}

boolean isOnPlatform(Sprite s, ArrayList<Sprite> walls) {
  s.centerY += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.centerY -= 5;
  if (col_list.size() > 0) {
    return true;
  } else {
    return false;
  }
}

void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {

  s.changeY += gravity;

  s.centerY += s.changeY;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.changeY > 0) {
      s.setBottom(collided.getTop());
    } else if (s.changeY < 0) {
      s.setTop(collided.getBottom());
    }
    s.changeY = 0;
  }

  s.centerX += s.changeX;
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.changeX > 0) {
      s.setRight(collided.getLeft());
    } else if (s.changeX < 0) {
      s.setLeft(collided.getRight());
    }
  }
}

boolean checkCollision(Sprite s1, Sprite s2) {

  if (s2.image == null) {
    return false;
  }

  boolean noXOverLap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverLap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if (noXOverLap || noYOverLap) {
    return false;
  } else {
    return true;
  }
}

ArrayList<Sprite> checkCollisionList(Sprite s, List<? extends Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {

    if (checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


void createPlatforms(String filename) {

  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      println(lines[row]);

      if (values[col].equals("1")) {

        Sprite s = new Sprite(grass, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        platforms.add(s);
      } else if (values[col].equals("2")) {
        Sprite s = new Sprite(dirt, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        platforms.add(s);
      } else if (values[col].equals("3")) {
        Sprite s = new Sprite(box, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        platforms.add(s);
      } else if (values[col].equals("4")) {
        Coins c = new Coins(gold, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        coins.add(c);
      } else if (values[col].equals("5")) {
        float bLeft = col * spriteSize;
        float bRight = bLeft + 4 * spriteSize;
        Enemy e = new Enemy(blob, 50/30.0, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, bLeft, bRight, row, col);
        bad.add(e);
      } else if (values[col].equals("0")) {
        Sprite b = new Sprite(dirt, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        b.image = null;
        platforms.add(b);
       
      }
      else {
      Sprite b = new Sprite(dirt, spriteScale, spriteSize/2 + col * spriteSize, spriteSize/2 + row * spriteSize, row, col);
        b.image = null;
        platforms.add(b);
      
      }
    }
  }
}

void keyPressed() {
  if (key == 'd') {
    p.changeX = moveSpeed;
  } else if (key == 'a') {
    p.changeX = -moveSpeed;
  } else if (key == 'w' && isOnPlatform(p, platforms)) {
    p.changeY = -jumpSpeed;
  } else if (keyCode == UP) {
    p.changeY = -moveSpeed;
  } else if (keyCode == DOWN) {
    p.changeY = moveSpeed;
  } else if (isLevelOver && key == ' ') {
    setup();
  } else if (isEditor && key == '1') {

    forChange = 1;
    option = grass;
  } else if (isEditor && key == '2') {

    forChange = 2;
    option = dirt;
  } else if (isEditor && key == '3') {

    forChange = 3;
    option = box;
  } else if (isEditor && key == '4') {

    forChange = 4;
    option = gold;
  } else if (isEditor && key == '5') {

    forChange = 5;
    option = blob;
  } else if (isEditor && key == 'x') {

    forChange = 0;
  } else if (key == 'p') {
    isEditor = !isEditor;
    isCont = false;
  } else if (isEditor && key == 's') {
    //TODO save to file
    saveToNewFile();

    //order by corpdinpates and save to excel
  } else if (isGameOver && key == ' ') {
    setup();
  } else if (key == '.'){
    isCont = true;
  }
}

void saveToNewFile() {

  gridY = 16;
  gridX = 33;
  table = new Table();
  for (int i=0; i<gridY; ++i)table.addRow();
  for (int j=0; j<gridX; ++j)table.addColumn();




  for (int row=0; row<16; row++) {
    for (int col=0; col<33; col++) {
      //fileToFrite();
      //findSprintType(col, row); //0|1|2|3|4
      //0x0
      Sprite foundPlatform = findPlatformSpriteByCordinate(row, col);
      // 25*50 = 1250
      //CSV += "0|1|2|3";
      //ifImage == DIrt
      Sprite foundPCoin = findCoinSpriteByCordinate(row, col);
      //CSV += "4;";
      Sprite foundEnemy = findEnemySpriteByCordinate(row, col);
      //CSV += "5;";

      if (foundPCoin != null) {
        table.setInt(row, col, 4);
      }
      if (foundEnemy != null) {
        table.setInt(row, col, 5);
      }
      if (foundPlatform != null) {
        if (foundPlatform.image == null) {
          table.setInt(row, col, 0);
        } else if (foundPlatform.image == grass) {
          table.setInt(row, col, 1);
        } 
        else if (foundPlatform.image == dirt) {
          table.setInt(row, col, 2);
        }
        else if (foundPlatform.image == box) {
          table.setInt(row, col, 3);
        }
      }
    }
  }

  saveTable(table, "savedMaps/mapas.csv");
}


Sprite findPlatformSpriteByCordinate(int row, int col) {
  for (Sprite s : platforms) {
    if (s.row == row && s.col == col) {
      return s;
    }
  }
  return null;
}

Sprite findCoinSpriteByCordinate(int row, int col) {
  for (Sprite s : coins) {
    if (s.row == row && s.col == col) {
      return s;
    }
  }
  return null;
}
Sprite findEnemySpriteByCordinate(int row, int col) {
  for (Sprite s : bad) {
    if (s.row == row && s.col == col) {
      return s;
    }
  }
  return null;
}





void keyReleased()
{
  if (key == 'd') {
    p.changeX = 0;
  } else if (key == 'a') {
    p.changeX = 0;
  } else if (keyCode == UP) {
    p.changeY = 0;
  } else if (keyCode == DOWN) {
    p.changeY = 0;
  }
}

void collectCoins() {

  ArrayList<Sprite> coin_list = checkCollisionList(p, coins);
  if (coin_list.size() > 0) {
    for (Sprite coin : coin_list) {
      numCoins++;
      coins.remove(coin);
      Sprite s = new Sprite(dirt, spriteScale, coin.centerX, coin.centerY, coin.row, coin.col);
      s.image = null;
        platforms.add(s);
    }
  }

  if (coins.size() == 0) {
    isLevelOver = true;
    level++;
  }
}

void checkDeath() {


  ArrayList<Sprite> baddie_list = checkCollisionList(p, bad);

  boolean fallOffCliff = p.getBottom() > groundLevel;

  if (baddie_list.size() > 0 || fallOffCliff) {
    p.lives--;
    if (p.lives == 0) {
      isGameOver = true;
    } else {
      p.centerX = 100;
      p.setBottom(groundLevel);
    }
  }
}
