// A simple Particle class
//SinOsc sine;
class Particle {
  PVector prevLocation;
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force;
  float   lifespan;
  float   m = 5;
  //color [] randColors = {#69D2E7, #A7DBD8, #E0E4CC, #F38630, #FA6900, #FF4E50, #F9D423};

  Particle(PVector l) {
    acceleration = new PVector(0, 0);
    velocity     = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    location     = l.copy();
    location     = new PVector (random(width), random(height));
    prevLocation = location.copy();
    lifespan     = 1500.0;
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
    //velocity.sub(velocity.normalize());
    //velocity.limit(10);
    location.add(velocity);
    lifespan -= 5;
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

    stroke(30*velocity.mag(),30*velocity.mag(),255);
    //stroke(255,25*velocity.x,25*velocity.y,lifespan);
    strokeWeight(3);
    line(location.x, location.y, prevLocation.x, prevLocation.y);

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
