import java.net.*;
import java.io.*;
import java.io.InputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;


byte[] arreglo;
Socket sock;
InputStream entrada;
DataInputStream dis;
int posiciones;
BufferedImage imagen2;
InputStream in;
PImage yourpic;

void setup(){
  size(320,470);
  try{
    background(0,0,255);
    sock = new Socket("192.168.0.22",9997);
    entrada = sock.getInputStream();
    dis = new DataInputStream(entrada);
    posiciones = dis.readInt();
    arreglo = new byte[posiciones];
    dis.readFully(arreglo);
    in = new ByteArrayInputStream(arreglo);
    imagen2 = ImageIO.read(in);
    yourpic=new PImage(imagen2.getWidth(),imagen2.getHeight(),PConstants.ARGB);
    imagen2.getRGB(0, 0, yourpic.width, yourpic.height, yourpic.pixels, 0, yourpic.width);
    image(yourpic, 0, 0);
  }
  catch(Exception a){
    fill(255,255,0);
    rect(0,0,50,50);
  }
}


