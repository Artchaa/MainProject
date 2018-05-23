//A Project by Pouya Aflatoun


/*
  Phases to implement:
  1. sound to be affected by angle of the wind, using a panner class.
  2. a GUI to control some of the constants.
  3. a small amount of intentional perlin noise on the current flowfield to make a 
  windy effect.
  4. Creating averages based on neighbouring data points.
  5. 


*/
float size;
float lifespan;
int scl = 40;
int particleCount = 1000;
int cols, rows;
PVector v;
JSONObject openData;
PVector [] flowfield;
ArrayList<ParticleSystem> systems;
import java.util.Iterator;
import beads.*;
float xLoc;
float yLoc;
// These handles can be used to calculate the size of the output screen as well as the lat lon of the map
float latStart  =  -10;
float latStop   =  -40;
float lonStart  =  110;
float lonStop   =  160;
// 0 for grabbing new set of data 1 is for using original data 2 for when data is loaded
int ready = 1;
Table savedData;
float backgroundG = 10;
float alpha = 10;

AudioContext ac;
Glide carrierFreq, modFreqRatio;




void settings() {
  int screenX = abs(int(lonStop-lonStart)*40);
  int screenY = abs(int(latStop-latStart)*50);
  size(screenX, screenY, P2D);
}

void setup() {
  ac = new AudioContext();
  carrierFreq = new Glide(ac, 500);
  modFreqRatio = new Glide(ac, 1);
  Function modFreq = new Function(carrierFreq, modFreqRatio) {
    public float calculate() {
      return x[0] * x[1];
    }
  };
  WavePlayer freqModulator = new WavePlayer(ac, modFreq, Buffer.SINE);
  Function carrierMod = new Function(freqModulator, carrierFreq) {
    public float calculate() {
      return x[0] * 400.0 + x[1];
    }
  };
  WavePlayer wp = new WavePlayer(ac, carrierMod, Buffer.SINE);
  Gain g = new Gain(ac, 1, 0.1);
  g.addInput(wp);
  ac.out.addInput(g);
  ac.start();




  cols = floor(width/scl);
  rows = floor(height/scl);
  flowfield = new PVector[(cols+1)*(rows+1)];
  frameRate(60);
  colorMode(RGB, 255);
  //fullScreen(P2D, SPAN);

  systems = new ArrayList<ParticleSystem>();
  background(0);
  if (ready == 0 ) {
    thread("loadData");
  }
}


void draw() {  
  //ready 0 is when the code is capturing data from online JSON.
  //ideally a simple loading screen, a particle system with no specific force value would be nice to be added as a future step
  if (ready == 0) 
  {  // nothing is currently loaded here. Needs a text.
  } else 
  //Here is where data is captured online, but the code reads it off a file on the computer.
  if (ready == 1 ) 
  {
    savedData = loadTable("21.05.18 - over australia.csv", "header");
    for (TableRow row : savedData.rows()) {
      int index   = row.getInt("index");
      float angle = radians(row.getFloat("deg"));
      flowfield[index] = PVector.fromAngle(angle);
      float speed = row.getFloat("speed");
      flowfield[index].setMag(speed);
    }
    ready =2;
  }
  //This is where all the magic happens.
  if (ready == 2) {
    //This visual is to slowly fade the particles.
    //alpha value helps removing the particles faster off the screen

    fill(backgroundG, alpha);
    noStroke();
    rect(0, 0, width, height);

    //This is toe change the coordinates into mercator projections. 
    //It is not very well visible when working on only a smaller part of the map. But it works.
    float locX = mercX(random(width));
    float locY = mercY(random(height));
    for (ParticleSystem ps : systems) {
      ps.run();
    }
    systems.add(new ParticleSystem(particleCount, new PVector(locX, locY)));
    //this is to override the lines of the flowfield to check as to whether particles are in fact following the wind.
    for (int y = 0; y <= rows; y++) {
      for ( int x = 0; x <= cols; x++) {
        int index = x + y * cols;
        pushMatrix();
        translate(x*scl, y*scl);
        rotate(flowfield[index].heading());
        stroke(255);
        strokeWeight(1);
        //line(0, 0, flowfield[index].mag(), 0);
        popMatrix();
      }
    }
  }

  // this is where mouse input is used

  int x     = floor(mouseX/scl);
  int y     = floor(mouseY/scl);
  int temp  = cols;
  int index = x + y * temp;
  float  carfreq   = flowfield[index].mag();
  carfreq = map(carfreq, 0, 17, 0, width);
  float  modfreq   = (flowfield[index].heading());
  modfreq = map(modfreq, -PI, PI, 0, height);

  carrierFreq.setValue(carfreq / width * 1000 + 50);
  //modFreqRatio.setValue((1 - modfreq / height) * 10 + 0.1); 
  //println(flowfield[index].heading());
}

void mouseClicked() {
}

// This thread will only run if the ready is in state 0 meaning that you are requesting online data.
void loadData() {
  savedData = new Table();
  savedData.addColumn("index");
  savedData.addColumn("lat");
  savedData.addColumn("lon");
  savedData.addColumn("deg");
  savedData.addColumn("speed");
  float lat=0;
  float lon=0;
  for (int y = 0; y <= rows; y++) {
    lat = y;
    lat = map(lat, 0, rows, latStart, latStop);
    for ( int x = 0; x <= cols; x++) {
      TableRow newRow = savedData.addRow();
      int index = x + y*cols;
      lon =  x;
      lon = map(lon, 0, cols, lonStart, lonStop);
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
      v.setMag(speed);
      flowfield [index] = v.copy();
      newRow.setInt("index", index);
      newRow.setFloat("lat", lat);
      newRow.setFloat("lon", lon);
      newRow.setFloat("deg", deg);
      newRow.setFloat("speed", speed);
    }
  }
  ready = 1;

  saveTable(savedData, "21.05.18 - over australia.csv");
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
