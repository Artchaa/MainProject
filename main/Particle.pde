// Simple Particle System
// Daniel Shiffman <http://www.shiffman.net>

// A simple Particle class
SinOsc sine;
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  Particle(PVector l) {
    acceleration = new PVector(0,0);
    //velocity = new PVector(random(-1,1),random(-2,0));
    
    velocity = new PVector(0,0);
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
    lifespan -= 1.6;
  }

  // Method to display
  void display() {
    stroke(0,lifespan);
    //strokeWeight(2);
    noStroke();
    for (int i = 0; i < 80; i++) {
    int d = 1 + (i);
    
    noStroke();
    fill(127, lifespan);
    //    print("d:" + d + " ");
    //    print("alpha:" + alpha + " ");
    
    ellipse(location.x, location.y, d/5, d*2);
    fill(100,lifespan);
    ellipse(location.x, location.y, d/10, d);
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
