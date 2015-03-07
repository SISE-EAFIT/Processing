import java.net.*;
import java.io.*;
import java.io.InputStream;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;


byte[] arreglo;
Socket sock;
InputStream entrada;
DataInputStream dis;
Bitmap bimg;
int posiciones;
InputStream in;
PImage img;

void setup(){
  orientation(PORTRAIT);
  try{
    background(0,0,255);
    sock = new Socket("192.168.0.22",9997);
    entrada = sock.getInputStream();
    dis = new DataInputStream(entrada);
    posiciones = dis.readInt();
    arreglo = new byte[posiciones];
    dis.readFully(arreglo);
    in = new ByteArrayInputStream(arreglo);
    bimg = BitmapFactory.decodeByteArray(arreglo,0,arreglo.length);
    img=new PImage(bimg.getWidth(), bimg.getHeight(), PConstants.ARGB);
    bimg.getPixels(img.pixels, 0, img.width, 0, 0, img.width, img.height);
    img.updatePixels();
    image(img, 0, 0);
  }
  catch(Exception a){
    fill(255,255,0);
    rect(0,0,50,50);
  }
}

/*
 public PImage getAsImage() {
    try {
      ByteArrayInputStream bis=new ByteArrayInputStream(bytes); 
      Bitmap bimg = BitmapFactory.decodeStream(bis); 
      PImage img=new PImage(bimg.getWidth(), bimg.getHeight(), PConstants.ARGB);
      // non-Android function:  : bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
      bimg.getPixels(img.pixels, 0, img.width, 0, 0, img.width, img.height);
      img.updatePixels();
      return img;
    }
*/







