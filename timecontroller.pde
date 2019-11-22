public class timeController {
  public int keyFrame = 15;
  private int frameCounter =0;
  private int reverseCounter =-1;

  public ArrayList <PVector> playPositions;
  public boolean isReverse = false;

  PVector pos;
  int MaxSize = 10;
  //holding player data
  timeController(PVector pos) {
    //set arguments for time controller 
    this.pos = pos;
    playPositions = new ArrayList<PVector>();
  }

  //determine whether reverse is active or not.
  //when the button is pressed, take the size-1 position in the arraylist 
  //teleport character to that position
  //put a timer on keypress like double click
  void update() {
    if (key==' ' && playPositions.size() > 0) {
      isReverse = true;
      if (reverseCounter == -1) {
        reverseCounter = 0;
        fill(0, 255, 0, 80);
        rect(0, 0, width, height);
      } 
      //println(" I am Reversing Time");
    } else {
      isReverse = false;
      if (reverseCounter >= 0) {
        reverseCounter = -1;
      }

      //println("I am not reversing time");
    }
  }

  //void reverseCounter(Character p){
  //  this.reverseCounter =p;
  //}

  //saving player data
  //create a statement where the player position is saved every 5 frames
  void FixedUpdate() {

    if (!isReverse) {
      if (frameCounter < keyFrame) {
        frameCounter ++;
      } else {
        frameCounter =0;
        PVector ppos = player.pos.copy();
        playPositions.add(ppos);
        println("Pos[" + (playPositions.size()-1) + "]: (" + ppos.x + ", " + ppos.y + ")");
      }
    } else { // reversing time

      if (reverseCounter >0) {
        reverseCounter --;
      } else if (reverseCounter == 0) {
        // I want to create the array here that collects arraysize-1
        PVector lpos = playPositions.get(playPositions.size()-1);
        println("Latest Pos[" + (playPositions.size()-1) + "]: (" + lpos.x + ", " + lpos.y + ")");
        player.pos = lpos;
        playPositions.remove(playPositions.size()-1);
        reverseCounter = 15;
      }
    }
  }
}