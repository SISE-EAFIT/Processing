int x,y,contador,num,pos;
char[] ip;

void setup(){
  num=1;
  pos=0; 
  ip = new char[15];
  size(300,500); 
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

void draw(){}

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
  x = reguladorX(); 
  y = reguladorY();
  if(x==0&&y==300){
   fill(0);
   rect(0,450,300,50);
   String ip2 = new String(ip);
   ip2 = ip2.trim();
   fill(255);
   text(ip2,0,490);
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

void keyPressed(){
  fill(0);
  stroke(255);
  if(contador>0){  
    rect(contador-20,400,20,50);
    ip[pos-1]=' ';
    pos--;
    contador-=20;
  }
}

