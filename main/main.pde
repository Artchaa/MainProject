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
  frameRate(60);
  colorMode(RGB, 255);
  fullScreen(P2D, SPAN);
  //size(800, 800, P2D);
  //smooth();
  systems = new ArrayList<ParticleSystem>();
  background(0);
  cols = floor(width/scl);
  rows = floor(height/scl);
  flowfield = new PVector[(cols+1) * (rows+1)];
  //blendMode(SUBTRACT);

  float yoff = 0;
  for (int y = 0; y <= rows; y++) {
    float xoff = 0;
    for ( int x = 0; x <= cols; x++) {
      int index = x + y * cols;
      float angle = noise(xoff, yoff, zoff)*TWO_PI*2;
      v = PVector.fromAngle(angle);
      v.setMag(100*noise(x,y));
      flowfield [index] = v.copy();
      xoff += inc;
      stroke(0, 50);
      pushMatrix();
      translate(x*scl, y*scl);
      rotate(v.heading());
      stroke(255);
      line(0, 0, v.x, v.y);
      popMatrix();
    }
    yoff += inc;
  }
  //zoff += 0.01;
}


void draw() {  

  fill(0, 20);
  noStroke();
  rect(0, 0, width, height);

  for (ParticleSystem ps : systems) {
    ps.run();
  }
  
  float locX = random(width);
  float locY = random(height);
  systems.add(new ParticleSystem(1, new PVector(locX, locY)));
  //for (int i = 0 ; i < width/scl;i++){
  //  for (int j = 0; j<height/scl;j++){
  //    float locX = i * width/scl;
  //    float locY = j * height/scl;
  //    systems.add(new ParticleSystem(1, new PVector(locX, locY)));
  //  }
  //}
}

void mouseReleased() {
  clear();
  v = PVector.fromAngle(0);
  v.setMag(0);
}
