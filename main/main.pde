PVector location;
float size;
float lifespan;
float scl = 50;
float cols, rows;
float inc = 0.1;
float zoff = 0;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
import java.util.Iterator;


void setup() {
  frameRate(30);
  colorMode(RGB, 255);
  fullScreen(P2D, SPAN);
  //size(800, 800, P2D);
  smooth();
  systems = new ArrayList<ParticleSystem>();
  background(255);
  cols = floor(width/scl);
  rows = floor(height/scl);
}


void draw() {  
  float yoff = 0;
  for (int y = 0 ; y < rows;y++){
    float xoff = 0;
    for ( int x = 0 ; x < cols ; x++){
     //float index = (x+y*width)*4;
     float angle = noise(xoff,yoff,zoff)*TWO_PI;
     PVector v = PVector.fromAngle(angle);
     xoff += inc;
     stroke(0);
     pushMatrix();
     translate(x*scl,y*scl);
     rotate(v.heading());
     line(0,0,scl,0);
     popMatrix();
    }
    yoff += inc;
  }
  zoff += 0.04;
  fill(255,30);
  rect(0,0,width,height);
  //clear();
  for (ParticleSystem ps : systems) {
    ps.run();
  }
}

void mousePressed() {
  for (int i = 1; i< 160; i++) {
    systems.add(new ParticleSystem(1, new PVector(random(width), random(height))));
  }
}
