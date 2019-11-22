class Character {
  //fields
  public ArrayList playPositions;
  PImage img;

  PVector pos, vel, dim;
  float damp = 0.9; //constant damping factor
  boolean jumping = false;
  Block block = null;

  //a constructor to initialize the fields above with initial values
  Character(PVector pos, PImage img) {
    this.pos = pos;
    this.img = img;
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

    if (pos.y + dim.y/2 > height) { 
      //when it goes off the longest block let it land on the floor
      pos.y = height - dim.y/2;
      vel.y=0;
    }
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


  void drawMe() {
    pushMatrix();
    fill(255, 0, 0);
    translate(pos.x, pos.y);
    scale(1);
    image(img, 0, 0);
    popMatrix();
  }
}
