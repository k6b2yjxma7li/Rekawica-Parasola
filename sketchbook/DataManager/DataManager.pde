import processing.serial.*;

Serial port;
String strX, strY, strZ;
float GX, GY, GZ;

int time = 0;

int N = 100000;
int[] x = new int[N];
int[] y = new int[N];
int[] z = new int[N];

void setup() {
  String[] portList = Serial.list();
  String portName = null;
  for(int i=0; i < portList.length; i++) {
    if(match(portList[i], "ACM0")!=null) {
      portName = portList[i];
    }
  }
  if(portName!=null) {
    port = new Serial(this, portName, 230400);
  }else {
    print("Port initialization error.");
  }
  //GRAPHICS INIT
  size(1366, 768, P3D);
  background(0);
  noFill();
  stroke(255);
  strokeWeight(1);
  smooth();
}

void draw() {
  translate(width/2, height/2);
  background(0);
  //
  if(port!=null) {
    //DATA COLLECTING AND PREPROCESSING
    if((port.available() > 0)) {
      strX = port.readStringUntil('\n');
      strY = port.readStringUntil('\n');
      strZ = port.readStringUntil('\n');
      /*if(time<10) {
        //handler of initial vector
      }*/
      boolean test = (strX!=null)&&(strY!=null)&&(strZ!=null);
      if(test) {
        float vect = 50.0;
        GX = float(strX);
        GY = float(strY);
        GZ = float(strZ);
        x[time] = (int)(GX/vect);
        y[time] = (int)(GY/vect);
        z[time] = (int)(GZ/vect);
        //print(x[time]+" "+y[time]+" "+z[time]+"\n");
        time++;
      }
    }
  }
  //
  //MOUSE ROTATION
  if(mouseButton==LEFT) {
    rotateY(mouseX/100.0);
    rotateZ(mouseY/100.0);
  }
  //
  //AXES AND NAMES
  noStroke();
  strokeWeight(1);
  drawAxes(300.0);
  drawSphere(0,0,0,2);
  stroke(255);
  //
  //DRAWING POINTS
  strokeWeight(3);
  for(int i = 0; i<time; i++) {
    stroke(255);
    point(x[i], y[i], z[i]);
  }
  //RED AVERAGE DOT DRAWING
  float xi, yi, zi;
  xi = 0.0;
  yi = 0.0;
  zi = 0.0;
  int ease = 20; //NUMBER OF POINTS USED TO AVERAGE
  if(time > ease){
    for(int n = 1; n<ease; n++) {
      xi+=x[time-n];
      yi+=y[time-n];
      zi+=z[time-n];
    }
  }
  xi /= ease;
  yi /= ease;
  zi /= ease;
  strokeWeight(8);
  stroke(255,0,0);
  point(xi,yi,zi);
  //GREEN AVERAGE DOT DRAWING
  /*float xa, ya, za;
  xa = 0.0;
  ya = 0.0;
  za = 0.0;
  for(int n = 0; n<time; n++) {
    xa+=x[n];
    ya+=y[n];
    za+=z[n];
  }
  xa /= time;
  ya /= time;
  za /= time;
  strokeWeight(8);
  stroke(0,255,0);
  point(xa, ya, za);*/
  //ZEROING DATA IF OUT OF BOUNDS
  if(time>=N) {
    time = 0;
  }
  if(port!=null) {
    port.clear();
  }
}
//
//CENTRAL SPHERE 
void drawSphere(float x, float y, float z, float r) {
  noStroke();
  fill(255,255,255);
  translate(x,y,z);
  sphere(r);
}
//COSMETIC PART - AXIS
void drawAxes(float size){
  stroke(255);
  //X  - red
  stroke(255,0,0);
  text("X", 300, 0, 0);
  line(0,0,0,size,0,0);
  //X' - magenta
  stroke(255,0,255);
  text("-X", -300, 0, 0);
  line(0,0,0,-size,0,0);
  //Y - green
  stroke(0,255,0);
  text("Y", 0, 300, 0);
  line(0,0,0,0,size,0);
  //Y' - yellow
  stroke(255,255,0);
  text("-Y", 0, -300, 0);
  line(0,0,0,0,-size,0);
  //Z - blue
  stroke(0,0,255);
  text("Z", 0, 0, 300);
  line(0,0,0,0,0,size);
  //Z' - cyan
  stroke(0,255,255);
  text("-Z", 0, 0, -300);
  line(0,0,0,0,0,-size);
}