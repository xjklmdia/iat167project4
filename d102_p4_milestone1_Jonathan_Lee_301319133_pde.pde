
public Character player;
public Enemy en;
public timeController timeControl;

public boolean isReverse = false;

public  ArrayList <PVector> playPositions;
ArrayList<Block> blocks = new ArrayList<Block>();
ArrayList<Block> blocks2 = new ArrayList<Block>();
ArrayList<Enemy> enemys = new ArrayList<Enemy>();

float speed = 1.8;
float grav = 2;
float ngrav = 2;


PVector upForce = new PVector(0, -speed * 24);
PVector leftForce = new PVector(-speed, 0);
PVector rightForce = new PVector(speed, 0);
PVector gravForce = new PVector(0, grav);
PVector ngravForce = new PVector(0, ngrav);

boolean up, left, right, reset, levelreset;


int repeatX=2;
int gameState = 0;
int countEnemy = 12;
int state = 0;

PImage EnemyImage;
PImage[] standing = new PImage[2];
PImage [] walking = new PImage[4];

void keyPressed() {
  if (keyPressed) {
    if (key == 'W' || key == 'w') up = true;
    else if (key == 'A' || key == 'a') left = true;  
    else if (key == 'D' || key == 'd') right = true;
    else if (key == ' ') isReverse = true;
    else if (key == 'm'|| key == 'M') reset =true;
    else if (key == 'y'|| key == 'Y') levelreset =true;
  }
}
void keyReleased() {
  if (key == 'W' || key == 'w') up = false;
  else if (key == 'A' || key == 'a') left = false;  
  else if (key == 'D' || key == 'd') right = false;
  else if (key == ' ') isReverse = false;
  else if (key == 'm'|| key == 'M') reset =false;
  else if (key == 'y'|| key == 'Y') levelreset =false;
}
void setup() {
  frameRate(30);
  size(1000, 600);
  stroke(200);
  strokeWeight(2);
  fill(63);

  //player = new Character(new PVector(width/4, height/4));
  player = new Character(new PVector(20, height-16));
  player.jumping = true;

  EnemyImage = loadImage("character.png");
  for (int i=0; i < countEnemy; i++) {
    en = new Enemy (EnemyImage, new PVector(20, height), new PVector(2, 3));
    respawnEnemy();
  }


  timeControl = new timeController(new PVector());
  levelone();
  leveltwo();
}

void draw() {
  reset();
  levelreset();
  switch (gameState) {
  case 0:
    levelone();
    gameplay();
    break;
  case 1:
    leveltwo();
    gameplay2();
    break;
  case 2:
    GameOver("URBAD");
  }
}
////////////////////////////////////// VOID GAME PLAY LEVEL 1 ////////////////////////////////////////////////////////////////////////
void gameplay() {
  background(255);
  //layer.detectFloor();

  if (up && !player.jumping) {
    player.jump(upForce);
  }
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);

  timeControl.FixedUpdate();
  timeControl.update();  
  player.update();

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
    en.fall();
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


  for (int i=0; i<enemys.size(); i++) {
    Enemy en = enemys.get(i);
    //en.move(gravForce);
    en.update();
    en.fall();
  }
}

void respawnEnemy() {
  //enemy(img, pvector, pvector);
  Enemy en = new Enemy(EnemyImage, new PVector(random(EnemyImage.width, width-EnemyImage.width), random(EnemyImage.height, height/3)), new PVector(random(2, 3), random(0, 0)));
  enemys.add(en);
}

void GameOver(String str) {
  background(255, 0, 0);
  fill(255);
  text(str, width/2-120, height/2);
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