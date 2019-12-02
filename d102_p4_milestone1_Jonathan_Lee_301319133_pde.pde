import controlP5.*;
import ddf.minim.*;

ControlP5 controlp5;
Minim minim;

public Character player;
public Enemy en;
public timeController timeControl;
public Background Background;

public boolean isReverse = false;

AudioPlayer song;

public  ArrayList <PVector> playPositions;
ArrayList<Block> blocks = new ArrayList<Block>();
ArrayList<Block> blocks2 = new ArrayList<Block>();
ArrayList<Block> blocks3 = new ArrayList<Block>();
ArrayList<Enemy> enemys = new ArrayList<Enemy>();
ArrayList<Background> backgrounds = new ArrayList<Background>();

float imgWidth= 480;
float imgHeight = 270;
int repeatX;
int repeatY;
int repeatX2;
int repeatY2;
int gameState = -1;
Button play;
int countEnemy = 12;
int state = 0;

PImage EnemyImage;
PImage [] standing = new PImage[2];
PImage [] walking = new PImage[4];

void setup() {
  frameRate(30);
  size(1000, 600);
  stroke(200);
  strokeWeight(2);
  fill(63);

  //player = new Character(new PVector(width/4, height/4));
  player = new Character(new PVector(20, height-16));
  player.jumping = true;

  //instantiate the enemy array
  EnemyImage = loadImage("character.png");
  for (int i=0; i < countEnemy; i++) {
    en = new Enemy (EnemyImage, new PVector(20, height), new PVector(2, 3));
    respawnEnemy();
  }
  //instantiate time controller
  timeControl = new timeController(new PVector());

  //instantiate level controller
  levelone();
  leveltwo();
  levelthree();

  //instantiate replay button
  controlp5 = new ControlP5(this);
  play = controlp5.addButton("Start Game", 0, width/2-95, height-200, 150, 50);
  play.setColorLabel(color(0));
  play.setColorBackground(color(0, 250, 250));

  //instantiate background controller
  repeatX =6;
  repeatY =4;
  backgrounds.add(new Background("bluesky.jpg", repeatX, repeatY, .25));
  repeatX2 =6;
  repeatY2 =0;
  backgrounds.add(new Background("clouds.jpg", repeatX2, repeatY2, .1));
  
  minim = new Minim(this);
  song = minim.loadFile("piratedance.mp3");
  song.loop();
}

void draw() {
  reset();
  levelreset();
  switch (gameState) {
  case -1:
    startScreen("Wecome to Worse gaem");
    break;
  case 0:
    levelone();
    gameplay();
    break;
  case 1:
    leveltwo();
    gameplay2();
    break;
  case 2:
    levelthree();
    gameplay3();
    break;
  case 3: 
    GameOver("Game Over!!");
  }
}
////////////////////////////////////// VOID GAME PLAY LEVEL 1 ////////////////////////////////////////////////////////////////////////
void gameplay() {
  controlp5.getController("Start Game").hide();
  background(255);
  //layer.detectFloor();

  if (up && !player.jumping) {
    player.jump(upForce);
  }
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);

 for (int i =0; i< backgrounds.size(); i++) {
    backgrounds.get(i).drawMe(new PVector(-player.pos.x, -player.pos.y));
  }

  timeControl.FixedUpdate();
  timeControl.update();  


  // check for collision with block and player
  if (player.block != null) {
    if (!player.block.isOn(player)) {
      player.jumping = true;
    }
  }
  //check for interaction between player --- if no interaction player falls
  if (player.jumping) {
    player.move(gravForce);
    if (player.vel.y > 0) {
      for (int i = 0; i < blocks.size(); i++) {
        Block b = blocks.get(i);
        if (b.bump(player)) {
          if (player.vel.y > 0) {
            player.landOn(b);
          } else {
            player.fall();
          }
        }
      }
    }
  }

  if (player.pos.x > width || player.pos.x <0) player.pos.x = 20;  //if player is going off screen make it start from the begining to keep scrolling

  for (int i = 0; i < blocks.size(); i++)
    //blocks.get(i).drawMe();
    blocks.get(i).drawMe(player);
  player.update();
  player.drawMe();


  // enemy interaction
  //if enemy on block is not null, then if enemy is not on block, then they are jumping
  if (en.block != null) {
    if (!en.block.eisOn(en)) {
      en.jumping = true;
    }
  }    
  // enemy move with gravity force, if enemy y velosity is greater than 0, for 
  en.move(gravForce);
  if (en.vel.y > 0) {
    for (int i = 0; i < blocks.size(); i++) {
      Block b = blocks.get(i);
      if (b.ebump(en)) {
        if (en.vel.y > 0) {
          en.elandOn(b);
        }
      }
    }
  }

  // for each enemy in the array update the draw me and apply the fall function to them
  for (int i=0; i<enemys.size(); i++) {
    Enemy en = enemys.get(i);
    //enemies move up?
    //enemies dissapear
    //println(en.pos.y);
    en.update();
    if (en.collision(player)) {
      player.hit();
      enemys.remove(en);
      if (enemys.size()<12)respawnEnemy();
    }
  }
}

////////////////////////////////////// VOID GAME PLAY LEVEL 2 ////////////////////////////////////////////////////////////////////////
void gameplay2() {
  background(255, 0, 0);
  //layer.detectFloor();

  if (up && !player.jumping) {
    player.jump(upForce);
  }
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);

  timeControl.FixedUpdate();
  timeControl.update();  
  player.update();

  if (player.block != null) {
    if (!player.block.isOn(player)) {
      player.jumping = true;
    }
  }
  //work out why character is not falling
  //guess is initial position is not zero, so player is applying internal vel that is not zero
  //if (player.block == null) {
  //  player.fall();
  //}

  //need to resolve player teleportation when jumping position check
  if (player.jumping) {
    player.move(gravForce);
    if (player.vel.y > 0) {
      for (int i = 0; i < blocks2.size(); i++) {
        Block b = blocks2.get(i);
        if (b.bump(player)) {
          if (player.vel.y > 0) {
            player.landOn(b);
          } else {
            player.fall();
          }
        }
      }
    }
  }

  if (player.pos.x > width) player.pos.x = 20;  //if player is going off screen make it start from the begining to keep scrolling

  for (int i = 0; i < blocks2.size(); i++)
    //blocks.get(i).drawMe();
    blocks2.get(i).drawMe(player);
  player.drawMe();


  en.move(gravForce);
  if (en.vel.y > 0) {
    for (int i = 0; i < blocks.size(); i++) {
      Block b = blocks.get(i);
      if (b.ebump(en)) {
        if (en.vel.y > 0) {
          en.elandOn(b);
        }
      }
    }
  }

  // for each enemy in the array update the draw me and apply the fall function to them
  for (int i=0; i<enemys.size(); i++) {
    Enemy en = enemys.get(i);
    //enemies move up?
    //enemies dissapear
    //println(en.pos.y);
    en.update();
    if (en.collision(player)) {
      player.hit();
      enemys.remove(en);
      if (enemys.size()<12)respawnEnemy();
    }
  }
}



void gameplay3() {
  background(0, 255, 0);
  //layer.detectFloor();

  if (up && !player.jumping) {
    player.jump(upForce);
  }
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);

  timeControl.FixedUpdate();
  timeControl.update();  
  player.update();

  if (player.block != null) {
    if (!player.block.isOn(player)) {
      player.jumping = true;
    }
  }
  //work out why character is not falling
  //guess is initial position is not zero, so player is applying internal vel that is not zero
  //if (player.block == null) {
  //  player.fall();
  //}

  //need to resolve player teleportation when jumping position check
  if (player.jumping) {
    player.move(gravForce);
    if (player.vel.y > 0) {
      for (int i = 0; i < blocks3.size(); i++) {
        Block b = blocks3.get(i);
        if (b.bump(player)) {
          if (player.vel.y > 0) {
            player.landOn(b);
          } else {
            player.fall();
          }
        }
      }
    }
  }

  if (player.pos.x > width) player.pos.x = 20;  //if player is going off screen make it start from the begining to keep scrolling

  for (int i = 0; i < blocks3.size(); i++)
    //blocks.get(i).drawMe();
    blocks3.get(i).drawMe(player);
  player.drawMe();


  en.move(gravForce);
  if (en.vel.y > 0) {
    for (int i = 0; i < blocks.size(); i++) {
      Block b = blocks.get(i);
      if (b.ebump(en)) {
        if (en.vel.y > 0) {
          en.elandOn(b);
        }
      }
    }
  }

  // for each enemy in the array update the draw me and apply the fall function to them
  for (int i=0; i<enemys.size(); i++) {
    Enemy en = enemys.get(i);
    //enemies move up?
    //enemies dissapear
    //println(en.pos.y);
    en.update();
    if (en.collision(player)) {
      player.hit();
      enemys.remove(en);
      if (enemys.size()<12)respawnEnemy();
    }
  }
}

void respawnEnemy() {
  //enemy(img, pvector, pvector);
  Enemy en = new Enemy(EnemyImage, new PVector(random(EnemyImage.width, width-EnemyImage.width), random(EnemyImage.height, height/3)), new PVector(random(2, 3), random(0, 0)));
  enemys.add(en);
}

void GameOver(String str) {
  //controlp5.getController("Start Game").show();
  background(255, 0, 0);
  fill(255);
  text(str, width/2, height/2);
  textAlign(CENTER);
}

void levelone() {
  blocks.add(new Block(new PVector(width/2, height - 20), new PVector(width, 40)));
  blocks.add(new Block(new PVector(200, height - 120), new PVector(200, 40)));
  blocks.add(new Block(new PVector(400, height - 240), new PVector(200, 40)));
  blocks.add(new Block(new PVector(700, height - 360), new PVector(200, 40)));

  blocks.add(new Block(new PVector(width/2+500, height - 240), new PVector(200, 40)));
  blocks.add(new Block(new PVector(width/2+800, height - 120), new PVector(200, 40)));
  blocks.add(new Block(new PVector(width+width/2-2, height - 20), new PVector(width, 40)));

  blocks.add(new Block(new PVector(width/2+900, height - 240), new PVector(200, 40)));
  blocks.add(new Block(new PVector(width/2+100, height - 120), new PVector(200, 40)));
  blocks.add(new Block(new PVector(width+width/16, height - 20), new PVector(width, 40)));
}

void leveltwo() {
  blocks2.add(new Block(new PVector(width/2, height - 20), new PVector(width, 40)));
  blocks2.add(new Block(new PVector(width/2+500, height - 240), new PVector(200, 40)));
  blocks2.add(new Block(new PVector(width/2+800, height - 120), new PVector(200, 40)));
  blocks2.add(new Block(new PVector(width+width/2-2, height - 20), new PVector(width, 40)));
}

void levelthree() {
  blocks3.add(new Block(new PVector(width/2, height - 20), new PVector(width, 40)));
  blocks3.add(new Block(new PVector(width/2+500, height - 240), new PVector(200, 40)));
  blocks3.add(new Block(new PVector(width/2+800, height - 120), new PVector(200, 40)));
  blocks3.add(new Block(new PVector(width+width/2-2, height - 20), new PVector(width, 40)));
}

void startScreen(String str) {
  controlp5.getController("Start Game").show();
  textAlign(CENTER);
  background(255, 0, 0);
  fill(255);
  text(str, width/2, height/2);
}

void reset() {
  if (key == 'm'|| key == 'M') {
    gameState=0;
    player.pos.x =20;
    player.pos.y = 100;
    isReverse = false;
    timeControl.reverseCounter = -1;
    timeControl.playPositions.clear();
  }
}

void levelreset() {
  if (key == 'y' ||key == 'Y') {
    player.pos.x=20;
    timeControl.playPositions.clear();
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName() == "Start Game") {
    gameState =0;
    
  }
}