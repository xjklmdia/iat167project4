
float speed = 1.8;
float grav = 2;
float ngrav = 2;
float maxHealth = 10;
PVector upForce = new PVector(0, -speed * 24);
PVector leftForce = new PVector(-speed, 0);
PVector rightForce = new PVector(speed, 0);
PVector gravForce = new PVector(0, grav);
PVector ngravForce = new PVector(0, ngrav);

boolean up, left, right, reset, levelreset;

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