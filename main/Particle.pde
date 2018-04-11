class Particle {
  PVector location;
  float size;
  float lifespan;
  
  Particle (PVector l){
    
    location = l.get();
    lifespan = 255;
  }
  
  
  void run(){
    update();
    display();
  }
  
  void update(){
    lifespan -=2.0;
  }
  
  void display(){
    rectMode(CENTER);
    fill(127,lifespan);
    ellipse(location.x,location.y,12,20);
    
    
    
  }
  
  
  
}
