class Enemy {
  PImage img;
  PVector pos, vel, dim;
  boolean jumping = false;
  Block block = null;

  Enemy(PImage img, PVector pos, PVector vel) {
    this.pos = pos;
    this.img = img;
    this.vel =vel;
    dim = new PVector (32, 48);
  }

  void move(PVector acc) {
    vel.add(acc);
    jumping = true;
  }


  void update() {
    pos.add(vel);
    detectEdges();  
    drawMe();

    //if (pos.y + dim.y/2 > height) { 
    //  //when it goes off the longest block let it land on the floor
    //  pos.y = height - dim.y/2;
    //  vel.y=0;
    //}
  }

  void detectEdges() {
    if (pos.x <= 0 || (pos.x - img.width) >= width) {
      vel.x *= -(random(1, 1.3));
    }
    //if (pos.y  >= height/2)
    //{
    //  pos.y = -img.height/2;
    //}
  }

  void elandOn(Block b) {
    block = b;
    pos.y = b.pos.y - dim.y/2 - b.dim.y/2;
    jumping = false;
    vel.y=0;
  }


  void fall() {
    vel.y *=-2;
  }

  void drawMe() {
    pushMatrix();
    fill(0, 255, 0);
    translate(pos.x, pos.y);
    scale(.25);
    image(img, 0, 0);
    popMatrix();
  }
}