class Background {
  PImage img;
  int repeatX, repeatY;
  float speed;

  //instantiated background method
  Background(String path, int repeatX, int repeatY, float speed) {
    img = loadImage(path);
    this.repeatX = repeatX;
    this.repeatY = repeatY;
    this.speed = speed;
  }

  //call the class as a drawme method
  void drawMe(PVector pos) {
    pos.mult(speed);

    int tilesX = -(floor(pos.x/img.width));
    int tilesY = -(floor(pos.y/img.height));
    println(floor(pos.x/img.width));
    for (int i = tilesX-1; i< tilesX+repeatX; i++) {
      for (int j = tilesY-1; j<tilesY+repeatY; j++) {
        image(img, pos.x +img.width * i, pos.y+ img.height *j);
      }
    }
  }
}