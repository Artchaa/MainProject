//Rose Cheif 

float size;
float lifespan;
int scl = 50;
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
float xLoc;
float yLoc;
// 0 for grabbing new set of data 1 is for using original data 2 for when data is loaded
int ready = 1;
Table savedData;

void setup() {

  frameRate(60);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);
  size(1200, 1200, P2D);
  systems = new ArrayList<ParticleSystem>();
  background(0);
  //thread("loadData");
  //if (ready == 1 ) {
  //  savedData = loadTable("myData.csv","header");
  //  cols = floor(width/scl);
  //  rows = floor(height/scl);
  //  flowfield = new PVector[(cols+1)*(rows+1)];
  //    for (TableRow row : savedData.rows()) {
  //        int index   = row.getInt("index");
  //        float angle = radians(row.getFloat("deg"));
  //        flowfield[index] = PVector.fromAngle(angle);
  //        //flowfield[index].setMag(1);
  //        float speed = row.getFloat("speed");
  //        println(speed);
  //        flowfield[index].setMag(.1*speed);
  //        println(flowfield[index].mag());
  //        }
  //       ready =2;    
  //    }
}


void draw() {  
  if (ready == 0) {
  } else 
  if (ready == 1 ) {
    savedData = loadTable("myData.csv","header");
    cols = floor(width/scl);
    rows = floor(height/scl);
    flowfield = new PVector[(cols+1)*(rows+1)];
      for (TableRow row : savedData.rows()) {
          int index   = row.getInt("index");
          float angle = radians(row.getFloat("deg"));
          flowfield[index] = PVector.fromAngle(angle);
          //flowfield[index].setMag(1);
          float speed = row.getFloat("speed");
          println(speed);
          flowfield[index].setMag(speed*0.01);
          println(flowfield[index].mag());
          }
         ready =2;    
      }
    if (ready == 2){
    fill(0, 40);
    noStroke();
    rect(0, 0, width, height);
    for (ParticleSystem ps : systems) {
      ps.run();
    }
    

    float locX = mercX(random(width));
    float locY = mercY(random(height));
    systems.add(new ParticleSystem(400, new PVector(locX, locY)));
    for (int y = 0; y <= rows; y++) {
      for ( int x = 0; x <= cols; x++) {
        int index = x + y * cols;
          pushMatrix();
          translate(x*scl, y*scl);
          rotate(flowfield[index].heading());
          stroke(255);
          strokeWeight(3);
          //line(0, 0, 100*flowfield[index].mag(), 0);
          println(flowfield[index].mag());
          popMatrix();
      }
    }
  }
}


void loadData() {
  savedData = new Table();
  savedData.addColumn("index");
  savedData.addColumn("lat");
  savedData.addColumn("lon");
  savedData.addColumn("deg");
  savedData.addColumn("speed");
  cols = floor(width/scl);
  rows = floor(height/scl);
  flowfield = new PVector[(cols+1)*(rows+1)];
  float lat=0;
  float lon=0;
  for (int y = 0; y <= rows; y++) {
    lat = y;
    lat = map(lat, 0, rows, -90,90);
    for ( int x = 0; x <= cols; x++) {
      TableRow newRow = savedData.addRow();
      int index = x + y*cols;
      lon =  x;
      lon = map(lon, 0, cols, -180, 180);
      println("lon " + lon +" lat "+ lat);
      openData = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&appid=a2d6cd4e138f25e8b9e0cf1c7ad377f0&units=metric"); 
      JSONObject wind = openData.getJSONObject("wind");
      float deg = 0;
      if (wind.isNull("deg") == true) {
      } else {
        deg = wind.getFloat("deg");
      }
      float speed = wind.getFloat("speed");
      float angle = radians(deg);
      v = PVector.fromAngle(angle);
      //println(angle+"   " + deg);
      v.setMag(speed);
      //println(v.mag());
      flowfield [index] = v.copy();
      newRow.setInt("index", index);
      newRow.setFloat("lat", lat);
      newRow.setFloat("lon", lon);
      newRow.setFloat("deg", deg);
      newRow.setFloat("speed", speed);
    }
  }
  ready = 1;

  saveTable(savedData, "myData.csv");
  //println(savedData);
  //if (ready == true){
  //for (int y = 0; y <= cols; y++) {
  //lat = y;
  //lat = map(lat, 0, (height/scl), 10, 40);
  //for ( int x = 0; x <= rows; x++) {
  //    println(savedData.getRowCount());
  //int index = x + y * cols;
  //float speed = savedData.getFloat("lat",index);
  //float angle = radians(deg);
  //v = PVector.fromAngle(angle);
  //v.setMag(speed/10);
  //flowfield [index] = v.copy();
  //  }
  //}
  //}
}


float mercX(float lon) {
  lon = radians (lon);
  float a = (256/PI) * pow(2, 1);
  float b = lon + PI;
  lon = a * b;
  return lon;
}

float mercY(float lat) {
  lat = radians (lat);
  float a = (256/PI) * pow(2, 1);
  float b = (tan ( PI/4+ lat /2 ));
  float c = PI - log(b);

  return a * c ;
}
