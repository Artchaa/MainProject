PVector location;
float size;
float lifespan;
float scl = 100;
int cols, rows;
float inc = 0.1;
float zoff = 0;
int sp = 0 ;
PVector v;
PVector [] flowfield;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
import java.util.Iterator;


void setup() {
  //frameRate(30);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(800, 800, P2D);
  smooth();
  systems = new ArrayList<ParticleSystem>();
  background(255);
  cols = floor(width/scl);
  rows = floor(height/scl);
  flowfield = new PVector[(cols+1) * (rows+1)];
}


void draw() {  
  background(255, 255, 255, 1);

  float yoff = 0;
  for (int y = 0; y <= rows; y++) {
    float xoff = 0;
    for ( int x = 0; x <= cols; x++) {
      int index = x + y * cols;
      float angle = noise(xoff, yoff, zoff)*TWO_PI*4;
      v = PVector.fromAngle(angle);
      flowfield [index] = v.copy();
      xoff += inc;
      stroke(0, 50);
      pushMatrix();
      translate(x*scl, y*scl);
      rotate(v.heading());
      line(0, 0, scl, 0);
      popMatrix();
    }
    yoff += inc;
  }
  zoff += 0.001;
  //fill(0,40);



  for (ParticleSystem ps : systems) {
  ps.run();
  }
}

void mousePressed() {
    systems.add(new ParticleSystem(1, new PVector(random(width), random(height))));
}
