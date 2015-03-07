import ketai.sensors.*;

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;
float numX, numY, numZ;

void setup()
{
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(36);
}

void draw()
{
  background(78, 93, 75);
  numX = accelerometerX*10;
  numY = accelerometerY*10;
  numZ = accelerometerZ*10;
  text("Accelerometer: \n" + 
    "x: " + nfp((int)numX,0) + "\n" +
    "y: " + nfp((int)numY,0) + "\n" +
    "z: " + nfp((int)numZ,0) + "\n", 0, 0, width, height);
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}
