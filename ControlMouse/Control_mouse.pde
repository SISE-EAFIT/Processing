//servidor en: /home/alejandro/Escritorio/Semillero/Sockets\ java/Control/ServidorControl

import java.net.*;
import java.io.*;

Socket sock;
PrintWriter out;
int x,y,contador,num,pos;
char[] ip;
boolean conexion;
String ip2;  

void setup(){
  background(0);
  orientation(PORTRAIT);
  ip = new char[15];
  pos=0; 
  dibujarInicio();
  fill(0);
  for(int k=0;k<300;k+=20){
    rect(k,400,20,50); 
  }
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
    out.println(width);
    out.println(height);
    background(0,255,0);
    conexion = true;
  }
  catch(Exception a){
    fill(255,0,0);
    rect(0,450,300,20);
  }
}

void mouseDragged(){
  if(conexion){  
    x = mouseX;
    y = mouseY;
    background(0);
    textSize(30);
    fill(255);
    text(x,170,200);
    text(y,230,200);
    enviarMensaje();
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
}

void enviarMensaje(){
  try{
    delay(2);
    out.println(x);
    delay(2);
    out.println(y);
  }
  catch(Exception a){
    fill(255,0,0);
    rect(0,0,width,height);
  } 
}


