//servidor en: /home/alejandro/Escritorio/Semillero/Sockets\ java/Control/ServidorControl2

import java.net.*;
import java.io.*;

int x,y,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6,posX,posY,contador,num,pos,scroll;
boolean estripado,conexion;
Socket sock;
PrintWriter out;
char[] ip;
String ip2,boton;  

void setup(){
  size(320,470);
  background(0);
  x2 = 50;
  y2 = 420;
  x3=50;
  y3=50;
  x4=50;
  y4=150;
  x5=50;
  y5=100;
  orientation(PORTRAIT);
  ip = new char[15];
  pos=0; 
  dibujarInicio();
}

void draw(){}

void dibujarInicio(){
  num=1;
  stroke(255);
  textSize(35);
  for(int i=0;i<400;i+=100){
    for(int j=0;j<300;j+=100){
      fill(0);
      if(i==300&&j==0){
        fill(0,255,0); 
      }
      rect(j,i,100,100);
      fill(255);
      if(num<10){
        text(num,j+40,i+60);
        num++;
      }
    }  
  }
  text('0',140,360);
  text('.',240,360);
  fill(0);
  for(int k=0;k<300;k+=20){
    rect(k,400,20,50); 
  }
}

int reguladorX(){
  x = mouseX;
  x/=100;
  return x*100;
}

int reguladorY(){
  y = mouseY;
  y/=100;
  return y*100; 
}


void instaciarComunicacion(String ip){
  try{
    sock = new Socket(ip,12345);
    out = new  PrintWriter(sock.getOutputStream(),true);
    dibujarMouse();
    conexion = true;
  }
  catch(Exception a){
    fill(255,0,0);
    rect(0,450,300,20);
  }
}

void mouseDragged(){
  if(conexion){
    if(sobreCirculo(x2,y2,100)&&estripado){  
      x2 = mouseX;
      y2 = mouseY;
      dibujarMouse(); 
    }
    else if(sobreCirculo(x3,y3,40)&&estripado){
     x3=mouseX;
     y3=mouseY;
     dibujarMouse();
   }
   else if(sobreCirculo(x4,y4,40)&&estripado){
     x4=mouseX;
     y4=mouseY;
     dibujarMouse();
   }
   else if(sobreCirculo(x5,y5,40)&&estripado){
     x5=mouseX;
     y5=mouseY;
     dibujarMouse();
   }
   else if(sobreCirculo(x5,y5,40)&&!estripado){
     x6=mouseX;
     y6=mouseY;
     dibujarMouse();
     fill(255,255,0);
     ellipse(x6,y6,40,40);
     enviarScroll();
   }
   else if(sobreCirculo(x2,y2,100) && !estripado){  
      x = mouseX;
      y = mouseY;
      dibujarMouse();
      fill(0,0,255);
      ellipse(x,y,50,50);
      enviarMensaje();
   }
  }
}

void enviarScroll(){
  scroll = y6-y5;
  if(scroll>0){
    out.println("S"+2);
  }
  else if(scroll < 0){
    out.println("S"+-2);
  }
}

void mousePressed(){
 if(!conexion){
    x = reguladorX(); 
    y = reguladorY();
    if(x==0&&y==300){
     ip2 = String.valueOf(ip);
     ip2 = ip2.trim();
     instaciarComunicacion(ip2);
    } 
    else if(x==100&&y==300){
      fill(255);
      text('0',contador,445);
      ip[pos]= '0'; 
      pos++;
      contador+=20;
    }
    else if(x==200&&y==300){
      fill(255);
      text('.',contador,445);
      ip[pos]='.';
      pos++;
      contador+=20;
    }
    num=49;
    for(int i=0;i<300;i+=100){
      for(int j=0;j<300;j+=100){
        if(x==j&&y==i && contador<300){
          ip[pos] = (char)num;
          pos++;
          fill(255);
          text(num-48,contador,445);
          contador+=20;
        }
        num++;
      }  
    }
  } 
  else{
   if(sobreCirculo(x3,y3,40) && !estripado){
     boton = "der";
     enviarClic(boton);
   }
   else if(sobreCirculo(x4,y4,40) && !estripado){
     boton = "izq";
     enviarClic(boton);
   }
  }
}

void enviarClic(String boton){
  out.println(boton);
}

void enviarMensaje(){
  posX = x2-x;
  posY = y2-y;
  if(posX>20){
    delay(2);
    out.println("Y"+1);
  }
  else if(posX<-20){
    delay(2);
    out.println("Y"+-1);
  }
  else if(posX>=-20||posX<=20){
    delay(2);
    out.println("Y"+0);
  }
  if(posY>20){
    delay(2);
    out.println("X"+1);
  }
  else if(posY<-20){
    delay(2);
    out.println("X"+-1);
  }
  else if(posY>=-20||posY<=20){
    delay(2);
    out.println("X"+0);
  }
}

void keyPressed(){ 
  if(!conexion){
    fill(0);
    stroke(255);
    if(contador>0 && pos>0){  
      rect(contador-20,400,20,50);
      ip[pos-1]=' ';
      pos--;
      contador-=20;
    }
  }
  else{
    estripado = !estripado;
  }
}

void mouseReleased(){
  if(conexion){
    dibujarMouse();
  }
}

void dibujarMouse(){
  background(0);
  stroke(0);
  fill(100,0,100);
  ellipse(x3,y3,40,40);
  fill(0,0,255);
  ellipse(x4,y4,40,40);
  fill(0);
  stroke(255);
  ellipse(x2,y2,100,100);
  ellipse(x5,y5,70,40);
}


boolean sobreCirculo(int x, int y, int diametro) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diametro/2 ) {
    return true;
  } else {
    return false;
  }
}


