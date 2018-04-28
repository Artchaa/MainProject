PVector location;
float size;
float lifespan;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
import java.util.Iterator;


void setup() {
  frameRate(30);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(800, 800, P2D);
  smooth();
  systems = new ArrayList<ParticleSystem>();
  background(0);
}


void draw() {  
  //background(0,1);  
  fill(0,8);
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
