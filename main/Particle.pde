// A simple Particle class
class Particle {
  PVector prevLocation;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float   lifespan = 15;
  float spanCheck = lifespan;
  float delay = 3;
  float   m = 5;
  color c;
  float maxSpeed = 14;
  float minSpeed = 7;
  float ra;
  float rb;
  float rc;
  
  float ga;
  float gb;
  float gc;
  
  float ba;
  float bb;
  float bc;
  
  float cr;
  float cg;
  float cb;
  
  float mag;
  
  //color [] randColors = {#69D2E7, #A7DBD8, #E0E4CC, #F38630, #FA6900, #FF4E50, #F9D423};

  Particle(PVector l) {
    acceleration = new PVector(0, 0);
    velocity     = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    location     = l.copy();
    location     = new PVector (random(width), random(height));
    prevLocation = location.copy();
  }

  void run() {
    display();
    update();
  }

  // Method to update location
  void update() {
    prevLocation = location.copy();
    acceleration = force;
    velocity.add(acceleration);
    PVector currentVelocity = velocity.copy();
    currentVelocity.setMag(currentVelocity.mag()*.3);
    velocity.sub(currentVelocity);
    //println(velocity.mag());
    //velocity.limit(10);
    location.add(velocity);
    lifespan -= 1;
  }

  // Method to display
  void display() {
    if (location.x <0) {
      location.x = width;
      prevLocation = location;
    }
    if (location.x >width) {
      location.x = 0;
      prevLocation = location;
    }
    if (location.y <0) {
      location.y = 0;
      prevLocation = location;
    }
    if (location.y >height) {
      location.y = height;
      prevLocation = location;
    }
    
    
    // this is where the colour calculations happen
    // if lifespan is 1-2 less than initial lifespan, i can start printing!
    if ( spanCheck > lifespan+delay){
    ra = -72;
    rb = 216;
    rc = 105;
    
    ga = -54;
    gb = 58;
    gc = 209;
    
    ba = 95;
    bb = -285;
    bc = 230;
    mag = map(velocity.mag(),minSpeed,maxSpeed,0,2);

    if (mag>2){
      mag = 2;
    }
    else if (mag<0){
     mag = 0; 
    }
    
    
    cr = (mag*mag)*ra + mag*rb + rc; if ( cr > 255){cr=255;}
    cg = (mag*mag)*ga + mag*gb + gc; if ( cg > 255){cg=255;}
    cb = (mag*mag)*ba + mag*bb + bc; if ( cb > 255){cb=255;}
    c = color(cr,cg,cb);
    
    stroke(c);
    strokeWeight(1);
    line(location.x, location.y, prevLocation.x, prevLocation.y);
    }
    int x     = floor(location.x/scl);
    int y     = floor(location.y/scl);
    int temp  = cols;
    int index = x + y * temp;
    force     = flowfield[index];
  }

  void updatePrev() {
    prevLocation = location;
  }


  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
