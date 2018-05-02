// A simple Particle class
//SinOsc sine;
class Particle {
  PVector prevLocation;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float   lifespan;
  //color [] randColors = {#69D2E7, #A7DBD8, #E0E4CC, #F38630, #FA6900, #FF4E50, #F9D423};

  Particle(PVector l) {
    acceleration = new PVector(0, 0);
    velocity     = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    location     = l.copy();
    location     = new PVector (random(width), random(height));
    prevLocation = location.copy();
    lifespan     = 1350.0;
  }

  void run() {
    display();
    update();
  }


  // Method to update location
  void update() {
    prevLocation = location.copy();

    //acceleration.add(force);
    acceleration = force;
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
    lifespan -= 2;
  }

  // Method to display - tiny circles.
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
    
    //stroke(0, lifespan);
    //int d = 10;
    //stroke(255,25*velocity.mag(),25*velocity.mag(),lifespan);
    stroke(255,25*velocity.x,25*velocity.y,lifespan);
    strokeWeight(5);
    //fill(96, 186, 215, lifespan);
    //ellipse(location.x, location.y, d/8, d/8);
    //line(prevLocation.x,prevLocation.y,location.x,location.y);
    line(location.x,location.y,prevLocation.x,prevLocation.y);

    int x     = floor(location.x/scl);
    int y     = floor(location.y/scl);
    int temp  = cols;
    int index = x + y * temp;
    force     = flowfield[index];
  force.setMag(2);
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
