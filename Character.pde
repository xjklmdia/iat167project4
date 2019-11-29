class Character {
  //fields
  public ArrayList playPositions;

  //frames
  int currentFrame = 0;
  int tileWidth = 15;
  int tileHeight = 20; 
  PImage[] frames;

  //instantiation of characters
  PVector pos, vel, dim;
  float damp = 0.9; //constant damping factor
  boolean jumping = false;
  Block block = null;

  //healthbaru
  float maxHealth=10;
  float health = maxHealth;
  float healthPercentage =10;

  //a constructor to initialize the fields above with initial values
  Character(PVector pos) {
    this.pos = pos;

    //blittingcont
    frames = standing;
    PImage sheet = loadImage("Running-mario.gif");
    for (int i = 0; i < walking.length; i++) {
   
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
      
      walking[i] = tile;
    }
    standing[0] = walking[0];
    
    vel = new PVector(); //must create instance
    dim = new PVector(32, 48);    
  }

  boolean levelend = false;

  //move method, PVector force as parameter, add to acceleration
  void move(PVector acc) {
    vel.add(acc);
  }

  //update the physics for the character
  void update() {
    vel.mult(damp); //multiply velocity by dampening factor (0.9-0.99);
    pos.add(vel); //add velocity to position (moves character)
    drawHealthBar();
    if (pos.y + dim.y/2 > height) { 
      //when it goes off the longest block let it land on the floor
      pos.y = height - dim.y/2;
      vel.y=0;
    }

    //

    //////////////////////////////////// game state stuff //////////////////////////////////////////////////
    if (pos.x > 1002) {
      if (gameState == 0) {
        pos.x =0;
        levelend = true;
        gameState=1;
      } else if (gameState==1) {
        pos.x =0; 
        levelend = true;
        gameState=2;
      } else {
        gameState =3;
      }
    }
    
       //framecontrol
    if (frameCount % 6 == 0) {
      currentFrame++;
      println(currentFrame);
      //{    if (currentFrame == walking.length) {
      //currentFrame =0;}
//    //if (pos.x+walking[currentFrame].width<0)
      //pos.x = width+walking [currentFrame].width;
      switch (state) {
        //walking
      case 1:
        if (currentFrame == walking.length) {
          currentFrame = 0;
        }
        changeFrame(walking);
        break;
        //            case ...
      default:
        currentFrame = 0;
        changeFrame(standing);
        break;
      }
    }
  }

  void changeFrame(PImage[]list) {
    //the PImage reference for character is now
    //the frame in the list we want
    frames = list;
  }
  //////////////////////////////////////////////////////////////////////////////// action shit /////////////////////////////////
  void jump(PVector upAcc) {
    move(upAcc);
    jumping = true;
  }

  void landOn(Block b) {
    block = b;
    pos.y = b.pos.y - dim.y /2 - b.dim.y / 2;
    jumping = false;
    vel.y = 0;
  }

  void fall() {
    vel.y *= -2;
  }

  void hit() {
    health --;
    println("dying a horrible death");
    if (health == 0) { 
      gameState =2;
    }
  }

  void drawHealthBar() {
    int healthBarWidth = 50;
    healthPercentage = health/maxHealth;
    pushMatrix();
    translate((pos.x)-25, (pos.y)-10);
    rect(0, 0, healthBarWidth, 2);
    fill(255, 0, 0, 255);
    rect(0, 0, healthBarWidth * healthPercentage, 2);
    popMatrix();
  }

  void drawMe() {
    pushMatrix();
    fill(255, 0, 0);
    translate(pos.x, pos.y);
    //flipping image and drawing frames
    if (vel.x<0) {
      scale(-1, 1);
    }
    PImage img = frames[currentFrame];
    image(img, -img.width/2, -img.height/2+15);
    popMatrix();
  }
}