// A simple Particle class
SinOsc sine;
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color [] randColors = {#69D2E7, #A7DBD8, #E0E4CC, #F38630, #FA6900, #FF4E50, #F9D423};

  Particle(PVector l) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1,1),random(0,2));
    acceleration = new PVector(0,-.1);

    //velocity = new PVector(0, 0);
    location = l.copy();
    lifespan = 156.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 3;
  }

  // Method to display
  void display() {
    stroke(0, lifespan);
    noStroke();
    for (int i = 0; i < 20; i++) {
      int d = 1 + (i);

      noStroke();
      fill(0, 220, 255, lifespan);
      ellipse(location.x, location.y, d/2, d/2);
      //fill(0, 244, 244, lifespan);
      //ellipse(location.x, location.y, d/10, d);
      //fill(127,lifespan);
      //ellipse(location.x,location.y,12,55);
      //fill(100,lifespan);
      //ellipse(location.x,location.y,14,85);
      //fill(80,lifespan);
      //ellipse(location.x,location.y,18,115);
    }
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
