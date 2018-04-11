PVector location;
float size;
float lifespan;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
//ArrayList COLORS> = [ '#69D2E7', '#A7DBD8', '#E0E4CC', '#F38630', '#FA6900', '#FF4E50', '#F9D423' ];

  
void setup(){
  size (800,800);
  smooth();
  systems = new ArrayList<ParticleSystem>();
  background(255);
  lifespan = 255;


}


void draw(){  
  background(255);  
  for (ParticleSystem ps: systems) {
    ps.run();
    //sine =  new SinOsc(this);
    //sine.play();
    //ps.addParticle(); 
  }
}

void mousePressed() {
  systems.add(new ParticleSystem(1,new PVector(mouseX,mouseY)));
}


  
  
 
