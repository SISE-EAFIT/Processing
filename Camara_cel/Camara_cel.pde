import java.io.*;
import java.net.*;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

DatagramSocket socket;
int mtu = 8000;
PImage img;
ByteArrayOutputStream stream;
ServerSocket sock;
Socket conexion;
ByteArrayInputStream context;
byte[] arreglo;
Bitmap bimg;

void setup(){
  orientation(LANDSCAPE);
  try {
    sock = new ServerSocket(4545);
    conexion = sock.accept();
    socket = new DatagramSocket(5555);
  } 
  catch (Exception e) {}
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

                
                    
                    
                    
                                
                               

                                

            
