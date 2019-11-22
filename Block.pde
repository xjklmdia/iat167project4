class Block {
  //class creates blocks to land on
  PVector pos, dim;
  Block(PVector pos, PVector dim) {
    // set arguments to block position and dimensions
    this.pos = pos;
    this.dim = dim;
  }

  boolean isOn(Character c) {
    // check if character is on block
    //if absolute character position x - block position x is less than character dimension x/2 + block dimension x /2 then character is on block
    //if (abs(c.pos.x - pos.x) < c.dim.x / 2 + dim.x / 2) {
    if (abs(c.pos.x - (pos.x-c.pos.x)) < c.dim.x / 2 + dim.x / 2) {
      return true;
    }
    return false;
  }

  boolean bump(Character c) {
    if (abs(c.pos.x - (pos.x-c.pos.x)) < c.dim.x / 2 + dim.x / 2 &&
      //if (abs(c.pos.x - pos.x )< c.dim.x / 2 + dim.x / 2 &&
      abs(c.pos.y - pos.y) < c.dim.y / 2 + dim.y / 2) {
      return true;
    }
    return false;
  }

  boolean ebump(Enemy e) {
    if (abs(e.pos.x - (pos.x-e.pos.x)) < e.dim.x / 2 + dim.x / 2 &&
      //if (abs(c.pos.x - pos.x )< c.dim.x / 2 + dim.x / 2 &&
      abs(e.pos.y - pos.y) < e.dim.y / 2 + dim.y / 2) {
      return true;
    }
    return false;
  }

  boolean eisOn(Enemy e) {
    // check if character is on block
    //if absolute character position x - block position x is less than character dimension x/2 + block dimension x /2 then character is on block
    //if (abs(c.pos.x - pos.x) < c.dim.x / 2 + dim.x / 2) {
    if (abs(e.pos.x - (pos.x-e.pos.x)) < e.dim.x / 2 + dim.x / 2) {
      return true;
    }
    return false;
  } 
  //;    void drawMe() {
  void drawMe(Character c) {
    noStroke();
    pushMatrix();
    fill(0);
    //    translate(pos.x, pos.y);
    translate(-c.pos.x+pos.x, pos.y);
    rect(-dim.x/2, -dim.y/2, dim.x, dim.y);
    popMatrix();
  }
}