import java.io.InputStream;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.awt.Robot;
import java.awt.Rectangle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

PImage yourpic;
BufferedImage originalImage;
byte[] imageInByte;
ByteArrayOutputStream baos;
InputStream in;
BufferedImage bImageFromConvert;
Robot control;
Rectangle pantalla;

void setup(){
  size(320,470);
  try{
    pantalla = new Rectangle(320,470);
    control = new Robot();
    originalImage = control.createScreenCapture(pantalla);
    baos = new ByteArrayOutputStream();
    ImageIO.write(originalImage, "jpg", baos);
    baos.flush();
    imageInByte = baos.toByteArray();
    baos.close();
      
    //in = new ByteArrayInputStream(imageInByte);
    Bitmap bitmap = BitmapFactory.decodeByteArray(imageInByte,0,imageInByte.length);
    //originalImage = ImageIO.read(in);
    
    yourpic=new PImage(bitmap.getWidth(),bitmap.getHeight(),PConstants.ARGB);
    originalImage.getRGB(0, 0, yourpic.width, yourpic.height, yourpic.pixels, 0, yourpic.width);
    yourpic.updatePixels();
  
    image(yourpic, 0, 0);
  }
  catch(Exception a){}
}



