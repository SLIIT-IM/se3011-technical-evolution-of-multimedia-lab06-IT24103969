//Variables
  
  //Enemies
  float er = 15;           //enemy radius
  int en = 8;       //number of enemies
  float[] ex = new float[en];     //enemy positions
  float[] ey = new float[en];     //enemy positions
  float[] evx = new float[en];     //enemy positions
  float[] evy = new float[en];   //enemy velocities

  //Player
  float pr = 20;         //player radius
  float px, py;     //position
  float vx, vy;     //velocity
  float accel;      //acceleration
  float friction;   //slowing down
  float gravity = 0.6;    //falling speed increases
  float jumpForce = -12;  //upward velocity when jumping
  int lives = 3;    //number of lives

  //States + Timer
  int state = 0;  //Start=0,  Play=1,  Game over(Lose)=2,  Win=3
  int startTime;
  int duration = 30;  //in seconds
  boolean canHit = true;
  int lastHitTime = 0;
  int hitCooldownMs = 800;  
  
void setup(){
  size(700,350);
  frameRate(60);
  
  //Initialising player
  px= width/2;
  py= height -pr;
  
  accel = 0.5;
  friction =0.9;
  
  //Initialising enemies
  for(int i=0; i<en; i++){
    ex[i] = random(er,width-er);
    ey[i] = random(er,height-er);
    
    evx[i] = random(-3,3);
    evy[i] = random(-3,3);
    
    if(abs(evx[i])<1){
      evx[i] = 2;
    }
    
    if(abs(evy[i])<1){
      evy[i] = 2;
    }    
  }
}


void draw(){
  background(240);
//Screens  
  //START screen
  if (state == 0){
    textAlign(CENTER,CENTER);
    textSize(24);
    fill(0);
    text("Press ENTER to Start", width/2, height/2);
  }
  
  
  //PLAY screen + Timer
  if(state == 1){
    int timeElapsed = (millis() - startTime) / 1000;     //converting to seconds
    int timeLeft = duration - timeElapsed;  
      
    //Game logic
    //Player +  Movement
      noStroke();
      fill(80,160,255);
      ellipse(px,py,pr*2,pr*2); 
      
      vy+=gravity;
      
      if(keyPressed){
        if(keyCode == RIGHT) vx+=accel;
        if(keyCode == LEFT) vx-=accel;
      }
      
      vx*= friction;
      px +=vx;
      py+=vy;
        
      px = constrain(px,pr,width-pr);
      py = constrain(py,pr,height-pr);
      
      if(py> height-pr){
        py = height - pr;
        vy=0;
      }
      
    //Enemies
    fill(255,100,100);
    for(int i=0; i<en; i++){
      ellipse(ex[i],ey[i], er*2, er*2);
      ex[i] = ex[i]+evx[i];
      ey[i] = ey[i] + evy[i];
      
      if(ex[i]>width - er || ex[i]<er){
        evx[i] *=-1;
      }

      if(ey[i]>height - er || ey[i]<er){
        evy[i] *= -1;
      }
      
      float d = dist(px, py, ex[i], ey[i]);   //Calculate distance between the player and enemy
      if(d < (pr+er) && millis()-lastHitTime > hitCooldownMs){        //Collision = orbs overlap
          lives--;
          lastHitTime = millis();
          
          px = random(pr, width-pr);
          py = random(py, height-pr);
      } 
    }
    
      //Player
      
              
      textAlign(LEFT,TOP);
      textSize(18);
      fill(0);
      text("Time Left: " + timeLeft, 20,20);
      text("LIVES LEFT: " + lives, 20,40);
    
    if(lives <=0){
      state = 2;    //Switch to GAME OVER screen    
    }else if(timeLeft <=0){
      state = 3;    //Switch to WIN screen
    }
  }
  
  
  //GAMEOVER screen
  if(state==2){
    noStroke();
    fill(255,35);
    rect(0,0,width, height); 
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Time Over! Press R to reset.", width/2, height/2);
  } 
  
  //WIN screen
  if(state==3){
    background(200,255,200);
    textAlign(CENTER,CENTER);
    textSize(24);
    fill(0);
    text("YOU WON! Press R to restart", width/2, height/2);
  }
}



void keyPressed(){
//Changing states (screen)
  //PLAY
  if(state == 0 && key == ENTER){
    state = 1;
    startTime = millis();   //starts timer
  }
  
  //RESET GAME
  if((state==2 || state==3) && (key == 'r' || key == 'R')){
    lives = 3;
    state=0;
  }
  
  if(state==1 && key == ' ' && py>=height-pr){
    vy=jumpForce;
  }
}
