import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.ImageIO;
import java.net.*;

DatagramSocket socket;
int mtu = 8000;
PImage yourpic;
ByteArrayOutputStream stream;
ServerSocket sock;
  Socket conexion;
  BufferedImage context;
  byte[] arreglo;

void setup(){
  size(640,480);
  try {
    sock = new ServerSocket(4545);
      conexion = sock.accept();
    socket = new DatagramSocket(5555);
  
     } catch (IOException e) {
                
            } catch (Exception e) {
                
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
                    
                    int timestamp = data[4] << 24 | 
                            (data[5] & 0xFF) << 16 | 
                            (data[6] & 0xFF) << 8 | 
                            (data[7] & 0xFF);

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
                               context = ImageIO.read(new ByteArrayInputStream(arreglo));

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
    
            } catch (IOException e) {
                
            } catch (Exception e) {
                
            }
}

void dibujar(){
 yourpic=new PImage(context.getWidth(),context.getHeight(),PConstants.ARGB);
 context.getRGB(0, 0, yourpic.width, yourpic.height, yourpic.pixels, 0, yourpic.width);
 image(yourpic, 0, 0); 
}

                
                    
                    
                    
                                
                               

                                

            
