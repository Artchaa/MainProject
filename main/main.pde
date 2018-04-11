PVector location;
float size;
float lifespan;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
import java.util.Iterator;

  
void setup(){
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(800,800,P2D);
  smooth();
  systems = new ArrayList<ParticleSystem>();
  background(0);
}


void draw(){  
  background(0);  
  for (ParticleSystem ps: systems) {
    ps.run();
  }
}

void mousePressed() {
  systems.add(new ParticleSystem(1,new PVector(mouseX,mouseY)));
}
