PVector location;
float size;
float lifespan;
float scl = 300;
int cols, rows;
float inc = 0.1;
float zoff = 0;
int sp = 0 ;
PVector v;
JSONObject openData;
PVector [] flowfield;
ArrayList<ParticleSystem> systems;
import processing.sound.*;
import java.util.Iterator;


void setup() {

  
  
  float lat = -90;
  float lon =-181;
  if (lat >= -90 && lat <= 90 && lon >=-180 && lon <= 180) {
    openData = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&appid=a2d6cd4e138f25e8b9e0cf1c7ad377f0&units=metric");  
    JSONObject wind = openData.getJSONObject("wind");
    float deg = wind.getFloat("deg");
    float speed = wind.getFloat("speed");
    println(deg+" " + speed);
  } else {
    println("invalid lat lon");
  }


  frameRate(60);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(800, 600, P2D);
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
      v.setMag(100*noise(x, y));
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
  
  //float yoff = 0;
  //for (int y = 0; y <= rows; y++) {
  //  float xoff = 0;
  //  for ( int x = 0; x <= cols; x++) {
  //    int index = x + y * cols;
  //    float angle = noise(xoff, yoff, zoff)*TWO_PI*2;
  //    v = PVector.fromAngle(angle);
  //    v.setMag(100*noise(x, y));
  //    flowfield [index] = v.copy();
  //    xoff += inc;
  //    stroke(0, 50);
  //    pushMatrix();
  //    translate(x*scl, y*scl);
  //    rotate(v.heading());
  //    stroke(255);
  //    //line(0, 0, v.x, v.y);
  //    popMatrix();
  //  }
  //  yoff += inc;
  //}
  //zoff += 0.01;
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
