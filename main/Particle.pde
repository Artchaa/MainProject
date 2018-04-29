// A simple Particle class
//SinOsc sine;
class Particle {
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
    lifespan     = 135.0;
  }

  void run() {
    update();
    display();
  }


  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1;
  }

  // Method to display - tiny circles.
  void display() {
    stroke(0, lifespan);
    noStroke();
    int d = 10;
    noStroke();
    fill(0, 0, 255, lifespan);
    ellipse(location.x, location.y, d, d);
    if (location.x <0) {
      location.x = width;
    }
    if (location.x >width) {
      location.x = 0;
    }
    if (location.y <0) {
      location.y = height;
    }
    if (location.y >height) {
      location.y = 0;
    }

    int x     = floor(location.x/scl);
    int y     = floor(location.y/scl);
    int temp  = cols;
    int index = x + y * temp;
    force     = flowfield[index];
    force.setMag(.1);
    acceleration.add(force);
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
