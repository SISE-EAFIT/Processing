//servidor en: /home/alejandro/Escritorio/Semillero/Sockets\ java/computador-raspberry/Minecraft/ServidorMinecraft

import java.net.*;
import java.io.*;

int x,y,contador,num,pos;
Socket sock;
PrintWriter salida;
boolean izq;
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

void mousePressed(){
  if(!conexion){
    x = reguladorX(); 
    y = reguladorY();
    if(x==0&&y==300){
     ip2 = String.valueOf(ip);
     ip2 = ip2.trim();
     instanciarComunicacion(ip2);
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

void instanciarComunicacion(String ip){
  try{
    sock = new Socket(ip,9997);
    salida = new PrintWriter(sock.getOutputStream(),true);
    conexion = true;
    dibujarBotones();
  }
  catch(Exception a){
    fill(255,0,0);
    rect(0,450,300,20);
  } 
}

void iniciarComunicacion(){
    if(izq){
      delay(2);
      salida.println("Z"+y);
      delay(2);
      salida.println("Z"+x);
    }
    else{
      delay(2);
      salida.println("D"+y);
      delay(2);
      salida.println("D"+x);
    }
}

void dibujarBotones(){
  background(0);
  stroke(255);
  fill(0);
  ellipse(210,100,200,200);
  ellipse(210,380,200,200);
  stroke(0);
  fill(255,100,0);
  rect(0,130,50,100);
  fill(0,0,255);
  rect(0,10,50,100);
  fill(90,0,110);
  triangle(0,250,50,300,0,350);
  triangle(50,360,0,410,50,460);
}



void mouseDragged(){
  if(conexion){    
    x=mouseX;
    y=mouseY;
    if(sobreCirculo(210,100,200)){
      dibujarBotones();
      fill(255,0,0);
      ellipse(x,y,100,100);
      izq = true; 
      iniciarComunicacion();
    }
    if(sobreCirculo(210,380,200)){
      dibujarBotones();
      fill(0,255,0);
      ellipse(mouseX,mouseY,100,100);
      izq = false; 
      iniciarComunicacion();
    }
  }
}


void mouseReleased(){
  if(conexion){
    dibujarBotones();
    fill(255,0,0);
    ellipse(210,100,100,100); 
    fill(0,255,0);
    ellipse(210,380,100,100);
  }
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



