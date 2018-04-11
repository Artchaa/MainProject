Particle ps;

void setup(){
  size (640,480);
  smooth();
  ps = new Particle();
}


void draw(){
  background(255);
  if (mousePressed){
    stroke(0);
    translate(mouseX,mouseY);
    strokeWeight(2);
    fill(150);
    
    rectMode(CENTER);
    rect(0,0,10,100);
    
  }
  
  
  
}
