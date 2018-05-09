float size;
float lifespan;
int scl = 100;
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
//import 
float zoomFrom;
float zoomTo;
int   zoomDuration;
int   zoomStart;
float zoomValue = 1;
float xLoc;
float yLoc;

void setup() {
  zoomTo   = 1.0;
  zoomFrom = 2.0;
  zoomDuration = 1000;
  zoomStart = -zoomDuration;

  //JSONObject wind = openData.getJSONObject("wind");
  //float deg = wind.getFloat("deg");
  //float speed = wind.getFloat("speed");
  //println(deg+" " + speed);

  frameRate(60);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(300, 300, P2D);
  systems = new ArrayList<ParticleSystem>();
  background(0);
  cols = (width/scl);
  rows = (height/scl);
  flowfield = new PVector[(cols+1) * (rows+1)];
  float lat=23;
  float lon=24;
  //float yoff = 0;

  for (int y = 0; y <= cols; y++) {
    //float xoff = 0;
    lat = y;
    lat = map(lat, 0, floor(height/scl), 10,40);
    for ( int x = 0; x <= rows; x++) {
      int index = x + y * cols;
      lon =  x;
      lon = map(lon, 0, floor(width/scl), -30, -10);
      println("lon " + lon +" lat "+ lat);
      openData = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&appid=a2d6cd4e138f25e8b9e0cf1c7ad377f0&units=metric"); 
      JSONObject wind = openData.getJSONObject("wind");
      //println(wind);
      //float deg = 0;
      
      float deg = 0;

      
      
           if (wind.isNull("deg") == true) {
        println("The species is undefined");
      } else {
      deg = wind.getFloat("deg");      }
  
  
  
      //else{ float deg = 0;}
      float speed = wind.getFloat("speed");
      //float speed = 1;
      println(deg+" " + speed);

      float angle = radians(deg);
      v = PVector.fromAngle(angle);
      v.setMag(speed/10);
      flowfield [index] = v.copy();
      //xoff += inc;
      stroke(0, 50);
      pushMatrix();
      translate(x*scl, y*scl);
      rotate(v.heading());
      stroke(255);
      line(0, 0, v.x, v.y);
      popMatrix();
    }
    //yoff += inc;
  }
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
  //    line(0, 0, v.mag(), 0);
  //    popMatrix();
  //  }
  //  yoff += inc;
  //}
  ////zoff += 0.01;
  for (ParticleSystem ps : systems) {
    ps.run();
  }

  float locX = random(width);
  float locY = random(height);
  systems.add(new ParticleSystem(100, new PVector(locX, locY)));
}

//float zoomState() {
//  float elapsed = millis() - zoomStart; // check timer
//  if (elapsed < zoomDuration) { // don't zoom past 100% duration
//    return lerp(zoomFrom, zoomTo, elapsed/zoomDuration); // zoom based on elapsed time
//  } else {
//    return zoomTo;
//  }
//}



//void mouseClicked() {
//  if (mouseButton == LEFT) {
//    if (zoomState() == zoomTo) { // act only if we are not already mid-zoom
//      float tmp = zoomFrom; 
//      zoomFrom = zoomTo; 
//      zoomTo = tmp; // swap values
//      zoomStart = millis(); // start timer
//    }
//  }
//}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (zoomValue<=6) {
        zoomValue += .01;
      }
    }
    if (zoomValue>1) {
      if (keyCode == DOWN) {
        zoomValue -=0.01;
      }
    }
  }

  if (key == CODED) {
    if (keyCode == LEFT) {
      if (xLoc >=10) {
        xLoc -= 10;
      }
    }
    if (keyCode == RIGHT) {
      if (xLoc<=width) {
        xLoc += 10;
      }
    }
  }
}
