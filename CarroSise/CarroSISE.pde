import ketai.sensors.*;
import java.io.*;
import java.net.*;
import org.json.simple.JSONObject;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

JSONObject json;
JSONObject json2;
KetaiSensor sensor;
float accelerometerY, numY;
DataOutputStream out;
ServerSocket sock;
Socket conexion;
DatagramSocket socket;
int mtu = 7981;
int lastTimestamp = -1;
int lastSequence = -1;
PImage img;
ByteArrayOutputStream stream;
ByteArrayInputStream context;
byte[] arreglo;
Bitmap bimg;

void setup()
{
  try{
    orientation(LANDSCAPE);
    sock = new ServerSocket(4545);
    conexion = sock.accept();
    socket = new DatagramSocket(5555);
    out = new DataOutputStream(conexion.getOutputStream());
    json =new JSONObject();
    json2 =new JSONObject();
    resetJson();
    json.put("controller",json2);
    sensor = new KetaiSensor(this);
    sensor.start();
  }
  catch(Exception a){
    fill(255,0,0);
    rect(0,0,100,100);
  }
}

void draw(){
try{
    byte[] buffer = new byte[mtu];
    DatagramPacket packet = new DatagramPacket(buffer, buffer.length);       
    socket.receive(packet);
    if (packet.getLength() > 0) {
      byte[] data = packet.getData();              
      int sync = data[0] << 8 | (data[1] & 0xFF);
      int sequence = data[2] << 8 | (data[3] & 0xFF);
      sequence &= 0xFFFF;
      int timestamp = data[4] << 24 | (data[5] & 0xFF) << 16 | (data[6] & 0xFF) << 8 | (data[7] & 0xFF);
      int lastchunk = 0;
      for (int i = 8; i < data.length; ++i) {
        int chunk = (data[i] & 0xFF);               
        if (lastchunk == 0xFF && chunk == 0xD8) {
          // Inicio del frame;
          stream = new ByteArrayOutputStream();
          stream.write(lastchunk);
        }
        if (stream != null) {
          stream.write(data[i]);
          if (lastchunk == 0xFF && chunk == 0xD9) {
            // Fin del frame
            if(lastTimestamp != -1 && lastSequence != -1
                && (timestamp<lastTimestamp || sequence<lastSequence)){
              // Se rechaza la imagen, por estar desactualizado.
              stream.reset();
              stream.close();                  
              stream = null;
              break;
            }
            arreglo = stream.toByteArray();
            context = new ByteArrayInputStream(arreglo);
            bimg = BitmapFactory.decodeByteArray(arreglo,0,arreglo.length);
            dibujar();     
            stream.reset();
            stream.close();      
            stream = null;                           
            break;
          }
        }             
        lastchunk = chunk;
        lastTimestamp = timestamp;
        lastSequence = sequence;
      }
    } 
  } 
  catch (Exception e) {}
}

void dibujar(){
  img=new PImage(bimg.getWidth(), bimg.getHeight(), PConstants.ARGB);
  bimg.getPixels(img.pixels, 0, img.width, 0, 0, img.width, img.height);
  img.updatePixels();
  image(img, 0, 0);
}

void resetJson(){
  json2.put("throttle", 0);
  json2.put("turn", 0);
}

void registrarJson(String id, JSONObject module){
  json.put(id,module);
}

void enviarJson(String obj){
  try{    
    byte[] utf8 = obj.getBytes("UTF-8");
    out.write(utf8);
  }
  catch(Exception a){}  
}

void actualizarJson(int throttle, int turn){
  json2.put("throttle", throttle);
  json2.put("turn", turn);
}

void mouseDragged(){
  if(mouseX>width/2){
   if(accelerometerY<50 && accelerometerY > 20){
     json2.put("turn", 40);
     json2.put("throttle", 40);
   }
   else if(accelerometerY > -60 && accelerometerY < -15){
     json2.put("turn", -40);
     json2.put("throttle", 40);
   }
   else{
     json2.put("throttle", 80);
   }
  } 
  else{
   json2.put("throttle", -90);
   json2.put("turn", 0);
  }
  enviarJson(json.toJSONString() + "\r\n");
}

void mouseReleased(){
  json2.put("throttle", 0);
  json2.put("turn", 0);
  enviarJson(json.toJSONString() + "\r\n");
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerY = y*-10;
}

