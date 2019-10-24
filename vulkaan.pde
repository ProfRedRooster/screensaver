ArrayList projectiles;   

int colShifter=0, minBurst=10, maxBurst=30, burst=maxBurst;
float angleToMouse;
int mode, modes;
float sourceAngle, dirAngle;

void setup() {
  fullScreen();
  mode = 1;
  modes = 5;
  projectiles = new ArrayList();
  sourceAngle = 0;
  dirAngle = 0;
}





void draw() {
  //burst=(frameRate<29)?(constrain(burst-1,minBurst,maxBurst)):(constrain(burst+1,minBurst,maxBurst)); 
  burst=(int)frameRate; 

  fill(0, 40);
  rect(0, 0, width, height);


  for (int i=projectiles.size()-1; i>=0; i--) {
    Projectile proj = (Projectile) projectiles.get(i);
    proj.update();

    proj.draw();
    if (proj.finished)
      projectiles.remove(i);
  }

  for (int i = 0; i<burst;i++) {

    switch (mode) {
    case 1:
      projectiles.add (new Projectile(width/2, height - height/3, random(80.5, 99.5), random(100, 150)));
      break; 
    case 2:
      projectiles.add (new Projectile(cos(radians(sourceAngle))*200+width/2, sin(radians(sourceAngle))*200+height/2, random(80.5, 99.5), random(100, 150)));
      sourceAngle += 0.2;
      break; 
    case 3:
      projectiles.add (new Projectile(width/2, height/2, random(dirAngle-10, dirAngle+10), random(100, 150)));
      dirAngle += 0.2;
      break; 
    case 4:
      projectiles.add (new Projectile(cos(radians(sourceAngle))*200+width/2, sin(radians(sourceAngle))*200+height/2, random(dirAngle-10, dirAngle+10), random(100, 150)));
      sourceAngle += 0.03;
      dirAngle -= 0.5;
      break; 
    case 5:
      projectiles.add (new Projectile(mouseX, mouseY, random(80.5, 99.5), random(100, 150)));
      break;
    }

    if (sourceAngle > 360) {
      sourceAngle -= 360;
    }

    Projectile proj = (Projectile) projectiles.get(projectiles.size()-1);
    colorMode(HSB, 360, 100, 100);
    proj.fillCol=color(colShifter, random(90, 100), random(55, 100));
  }
  if (colShifter++ > 359) colShifter=0;
}


void keyPressed() {
  mode++;
  if (mode > modes) mode = 1;
}

////////////////////////////////////////
///////////////////////////////////////
class Projectile {               /////
  ///////////////////////////////////
  //////////////////////////////////
  // declare variables
  float startX, startY, vx, vy, x, y, dx, dy, lastX, lastY;
  float angle, velocity, shotangle;
  float t;
  color strokeCol=0, fillCol=255;
  float   strokeAlpha = 255, fillAlpha = 255;

  float size=10; // size of a projectile;
  float gravity = 9.80665; // Earth's free fall acceleration in 9.80665 m/s^2
  boolean finished;
  // finished = out of screen
  // enable/disable calculations/drawing when projectile is out of screen

  ///////////////////////////////////////////////////////////////////////////
  Projectile(float startX, float startY, float angle, float velocity) {  ///
    ///////////////////////////////////////////////////////////////////////
    // init

    this.startX   = startX;
    this.startY   = startY;
    this.angle    = radians(angle);
    this.velocity = velocity;

    this.t = 1.0;          // Time (ticks)


    // initial velocity vector
    this.vx = cos(this.angle) * this.velocity; 
    this.vy = -1 * sin(this.angle) * this.velocity + this.gravity; 
    // "-1 *" = flip curve upside down
  }
  /////////////////////
  void update() {  ///
    /////////////////
    // calculations
    if (!finished) {
      if (x<0 || x>width || y>height || (fillAlpha == 0)) 
        finished = true;



      this.lastX = x;
      this.lastY = y;
      // horizontal forces: just velocity
      x = cos(this.angle) * this.velocity * this.t; 
      // vertical forces: velocity and gravity
      y = -1 * sin(this.angle) * this.velocity * this.t + this.gravity * sq(this.t); 

      // translate

      //    y *= -1; // flip curve upside down (I suppose y = -y works too)
      //subtract initial vector
      x -= this.vx; 
      y -= this.vy;
      // translate to relationship to starting postition
      x += this.startX;
      y += this.startY;
      this.t += 0.1; // update time
    }
  }

  ////////////////////////////
  void draw() {           ///
    ////////////////////////
    // show on the screen
    if (!finished) {

      dx = x-lastX;
      dy = y-lastY;

      fill(fillCol, fillAlpha);
      noStroke();
      ellipse(x, y, size, size);

      stroke(0);
      fill(255);

      // show nose ?
    }
  }
}

