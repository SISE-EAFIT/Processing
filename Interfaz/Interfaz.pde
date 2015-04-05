/*
  The theory of the algorithm was taken from:
 https://www.youtube.com/watch?v=PHXAOKQk2dw
 https://www.youtube.com/watch?v=rDPuaNw9_Eo
 https://www.youtube.com/watch?v=xYBM0_dChRE
 http://www.geeksforgeeks.org/pattern-searching-set-7-boyer-moore-algorithm-bad-character-heuristic/
*/

int sSize;       //size of the squares
int[] table;     //array used to save the numerical values of the table
char[] letters;  //array used to save the letters of the table
char[] tex;      //array that represents the string of the text
char[] pat;      //array that represents the string of the pattern
PFont myFont;    //letter type
String text;     //text entered at the begining of the program
String pattern;  //pattern entered at the begining of the program
int step;        //this variable handles the execution of the program
int state;       //this variable handles the execution of the bayernMoore method
int i;           //index of the letter in the tex array that is currently analyzed
int j;           //index of the letter in the pattern array that is currently analyzed
int aux;         //variable that handles the starting position to start analyzing
int xT;          //pixel that handles the position in the tex array (visualy)
int xP;          //pixel that handles the position in the pattern array (visualy)
int distance;    //distance from the start position of the pattern start to the actual position (pixels)
char t;          //char of the current position of the tex array
char p;          //char of the current position of the pattern array
boolean found;   //variable that indicates if the pattern has been found or not
boolean move;    //variable that indicates if the pattern has to be moved
boolean equals;  //variable that indicates if the t and p variables are equals and the aux variable has to be initialized 
int letter;      //position of the letter of the tex array on the letter array
char let;        //actual letter that is in the letter position
int value;       //value in the table of the let char

void setup() {                         //This method is executed only once at the begining, similar to the arduino code
  setCanvas(600, 450);                 //set the window size with 600 as width and 450 as height
  myFont = createFont("arial", 32);    //creates a new font
  textFont(myFont);                    //set the last font as the default font
  textAlign(CENTER);                   //align the text to the center
  text = new String();                 //creates a new String instance
  pattern = new String();              //creates a new String instance
  state = step = 0;                    //creates a new String instance
  distance = sSize = 50;               //initialize the distance and sSize varibles with a value of 50
  equals = true;                       //initialize the equals variables with a value of true
}

void draw() {             //This method is executed after the setUp, acts as an infinite loop  
  switch(step) {          //creates a switch-case for the step variable
  case 0:                 //in case the step variable has a value of 0
    read1();              //calls the read1 method
    break;                //breaks the switch-case
  case 1:                 //in case the step variable has a value of 1
    read2();              //calls the read2 method
    break;                //breaks the switch-case
  case 2:                 //in case the step variable has a value of 2
    paint1();             //calls the print1 method
    break;                //breaks the switch-case
  case 3:                 //in case the step variable has a value of 3
    paint2();             //calls the paint2 method
    break;                //breaks the switch-case
  case 4:                 //in case the step variable has a value of 4
    createTable();        //calls the createTable method
    break;                //breaks the switch-case
  case 5:                 //in case the step variable has a value of 5
    printTable();         //calls the printTable method
    break;                //breaks the switch-case
  case 6:                 //in case the step variable has a value of 6
    bayerMoore();         //calls the bayernMore method
    delay(1000);          //delay the execution by 1000 milliseconds
    break;                //breaks the switch-case
  case 7:                 //in case the step variable has a value of 7
    finish(found);        //calls the finish method
    break;                //breaks the switch-case
  }
}

void bayerMoore() {              //This method is the actual bayerMore algorithm, also handles the visual part
  xT = sSize*i;                  //get the pixel where the letter desired is in the tex array
  xP = sSize*j;                  //get the pixel where the letter desired is in the pat array
  t = getLetter(xT, sSize);      //get the letter that is in the xT pixel 
  p = getLetter(xP, sSize*2);    //get the letter that is in the xP pixel

  switch(state) {                //creates a switch-case for the step variable
  case 0:                        //in case the state variable has a value of 0 
    highlight();                 //calls the highlight method
    break;                       //breaks the switch-case
  case 1:                        //in case the state variable has a value of 1
    compare();                   //calls the compare method
    break;                       //breaks the switch-case
  case 2:                        //in case the state variable has a value of 2
    clean();                     //calls the clean method
    break;                       //breaks the switch-case
  case 3:                        //in case the state variable has a value of 3
    highlightTable();            //calls the highlightTable method
    break;                       //breaks the switch-case
  case 5:                        //in case the state variable has a value of 5
    cleanTable();                //calls the cleanTable method
    break;                       //breaks the switch-case
  case 6:                        //in case the state variable has a value of 6
    move();                      //calls the move method
    break;                       //breaks the switch-case
  }
}

char getLetter(int x, int y) {                      //This method returns the letter of the front end (need the pixel position)
  if (y == sSize) return tex[x/sSize-1];            //if the letter is in the tex array
  else if (y == sSize*2) return pat[x/sSize-1];     //if the letter is in the pat array
  else return letters[x/sSize];                     //if the letter is in the letters array
}

void highlight() {                                  //This method highlight the position that is being analyzed 
  fill(255, 255, 0);                                //with yellow fill
  rect(xT, sSize, sSize, sSize);                    //draws a square on the desired position (tex array) 
  rect(xT, sSize*2+10, sSize, sSize);               //draws a square on the desired position (pat array)

  fill(100, 0, 100);                                //with purple fill 
  text(t, xT+sSize/2, sSize+sSize/2+10);            //draws the corresponding letter on the last square (tex array)
  text(p, xT+sSize/2, sSize*2+sSize/2+20);          //draws the corresponding letter on the last square (pat array)
  state = 1;                                        //set the state as 1
}

void compare() {                                //This method compare the two letters that were obtained before on the bayerMoore mothod
  move = false;                                 //set the move varible as false
  if (p == t && j == 1) {                       //if the two letters are the same and are the first of the pattern
    fill(0, 255, 0);                            //with green fill 
    found = true;                               //set the found varible as true  
    step = 7;                                   //set the state as 7
  } else if (p == t) fill(0, 255, 0);           //if the letters are the same but arent the fist of the pattern with green fill 
  else {                                        //otherwise
    fill(255, 0, 0);                            //with red fill 
    move = true;                                //set the move varible as true
  }

  rect(xT, sSize, sSize, sSize);                //draws a rectangle on the desired position (with the fill set before in the tex array)
  rect(xT, sSize*2+10, sSize, sSize);           //draws a rectangle on the desired position (with the fill set before in the pat array)
  
  fill(100, 0, 100);                            //with purple fill 
  text(t, xT+sSize/2, sSize+sSize/2+10);        //draws the corresponding letter on the last square (tex array)
  text(p, xT+sSize/2, sSize*2+sSize/2+20);      //draws the corresponding letter on the last square (pat array)
  state = 2;                                    //set the state as 2
}

void clean() {                                 //This method repaints the squares with white
  fill(255);                                   //with white fill 
  rect(xT, sSize, sSize, sSize);               //draws a rectangle on the desired position (with the fill set before in the tex array)
  rect(xT, sSize*2+10, sSize, sSize);          //draws a rectangle on the desired position (with the fill set before in the pat array)

  fill(255, 0, 0);                             //with red fill 
  text(t, xT+sSize/2, sSize+sSize/2+10);       //draws the corresponding letter on the last square (tex array)
  fill(0, 0, 255);                             //with blue fill 
  text(p, xT+sSize/2, sSize*2+sSize/2+20);     //draws the corresponding letter on the last square (pat array)

  if (move) {                                  //if move is set as true
    state = 3;                                 //set the state as 3
  } else {                                     //otherwise
    if (equals) {                              //id the equals varible is set as true 
      equals = false;                          //set equals as false
      aux = i;                                 //set the aux varible with the value of the i variable
    }
    i--;                                       //decrements the value of the i variable
    j--;                                       //decrements the value of the j variable
    state = 0;                                 //set the state as 0
  }
}

void highlightTable() {                                             //This method highlight the needed value of the table
  letter = getPos(letters, getLetter(xT, sSize));                   //gets the position of the current letter in the tex array
  let = getLetter(sSize*letter, sSize*3);                           //get the letter at that pixel
  value = table[sSize*letter/sSize];                                //get the value asociated with that letter into the table
  if (let == 0) let = '*';                                          //if the let varialbe is equals to null, then set let as *

  fill(255, 165, 0);                                                //with orange fill 
  rect(sSize*(letter+1), sSize*4+30, sSize, sSize);                 //draws a square at the desired position (letters array)
  rect(sSize*(letter+1), sSize*5+30, sSize, sSize);                 //draws a square at the desired position (table array)

  fill(100, 0, 100);                                                //with purple fill 
  text(let, sSize*(letter+1)+sSize/2, sSize*4+sSize/2+40);          //prints the letter on its square
  text(value, sSize*(letter+1)+sSize/2, sSize*5+sSize/2+40);        //prints the value on its square

  state = 5;
}


void cleanTable() {                                                        //This method cleans the square that has been compared
  fill(255);                                                               //with white fill 
  rect(sSize*(letter+1), sSize*4+30, sSize, sSize);                        //draws a rect at the desired position (letters array)
  rect(sSize*(letter+1), sSize*5+30, sSize, sSize);                        //draws a rect at the desired position (table array)

  fill(100, 0, 100);                                                       //with purple fill 
  text(let, sSize*(letter+1)+sSize/2, sSize*4+sSize/2+40);                 //prints the letter on the correct square
  text(value, sSize*(letter+1)+sSize/2, sSize*5+sSize/2+40);               //prints the value on the correct square

  state = 6;                                                               //set state as 6
}

void move() {                                                              //This method calculates where it should be the patron to continue the algorithm
  j = pat.length;                                                          //the position of the pattern is the last letter
  int increment = table[getPos(letters, getLetter(sSize*(i), sSize))];     //calculates how much the pattern should be move
  if (!equals) {                                                           //if the equals variable is false
    equals = true;                                                         //set equals as true
    i = aux;                                                               //set i with his value before start comparing this position of the pattern
  }
  i += increment;                                                          //increments the i variable
  if (i > tex.length) {                                                    //if the pattern overflowed the text
    found = false;                                                         //set found as false
    step = 7;                                                              //set step as 7
    return;                                                                //dont move the pattern
  }
  paint2(distance+=sSize*increment);                                       //move the pattern to the next position
  state = 0;                                                               //set state as 0
}

public void read1() {                             //This method gets and prints the text value
  background(0);                                  //set the background as black
  fill(0, 255, 0);                                //with green fill 
  text("Enter the text", width/2, width/2);       //print the "Enter the text" string on the screen at the desired position
  fill(255);                                      //with white fill 
  text(text, width/2, width/2+50);                //prints the content of the text variable at the desired position
}

public void read2() {                             //This method gets and prints the pattern value
  background(0);                                  //set the background as black
  fill(0, 0, 255);                                //with blue fill 
  text("Text: "+text, width/2, width/2-50);       //prints the value of the text variable at the desired position
  fill(0, 255, 0);                                //with green fill 
  text("Enter the pattern", width/2, width/2);    //prints the "Enter the pattern" string at the desired position
  fill(255);                                      //with white fill 
  text(pattern, width/2, width/2+50);             //prints the content of the pattern variable at the desired position
}

void keyPressed() {                                                                                     //This method is executed when a key is pressed
  switch(step) {                                                                                        //creates a switch-case for the step variable
  case 0:                                                                                               //in case the step variable has a value of 0
    if (key == ENTER) step = 1;                                                                         //if the pressed key is enter then set the step variable as 1
    else if (key == BACKSPACE && text.length() > 0) text = text.substring(0, text.length() - 1);        //otherwise if the pressed key is backspace and the length of the text is bigger than
                                                                                                        // 0 then erase the last letter of the string
    else if (key > 31 && key < 126) text += key;                                                        //otherwise if the pressed key has a character of the ascii table that has a value 
                                                                                                        //bigger than 31 and smaller than 126 then add the char to de string
    break;                                                                                              //breaks the switch-case
  case 1:                                                                                               //in case the step variable has a value of 1
    if (key == ENTER) {                                                                                 //if the pressed key is enter 
      step = 2;                                                                                         //set step as 2
      int textGrid = text.length()*sSize + sSize*2;                                                     //gets the number of pixels that the text is going to need
      int patternGrid = pattern.length()*sSize + sSize*2;                                               //gets the number of pixels that the pattern is going to need
      if (textGrid > width) setCanvas(textGrid, height);                                                //if the text doesnt fit the screen then resize the screen
      else if (patternGrid > width) setCanvas(patternGrid, height);                                     //otherwise if the pattern doesnt fit the screen then resize the screen 
    } else if (key == BACKSPACE && pattern.length() > 0) pattern = pattern.substring(0, pattern.length() - 1);   //otherwise if the pressed key is backspace and the length of the pattern is
                                                                                                                 //bigger than 0 then erase the last letter of the string
    else if (key > 31 && key < 126) pattern += key;                                                     //otherwise if the pressed key has a character of the ascii table that has a value 
                                                                                                        //bigger than 31 and smaller than 126 then add the char to de string
    break;                                                                                              //breaks the switch-case
  }
}

public void setCanvas(int x, int y) {        //This method resizes the screen if its needed
  frame.setSize(x, y);                       //resize the window 
  size(x, y);                                //resize the canvas
}

public void paint1() {                                      //This method prints the tex array
  background(0);                                            //set the background as black
  tex = text.toCharArray();                                 //initialize the tex array with the text
  int x = 0;                                                //declares and initialize the x variable with 0
  for (int j=1; j<tex.length+1; j++) {                      //runs over the tex array
    fill(255);                                              //with white fill 
    rect(x+=sSize, sSize, sSize, sSize);                    //draws a square at the desired position (draws the tex array) 
    fill(255, 0, 0);                                        //with red fill
    text(tex[j-1], sSize*j+sSize/2, sSize+sSize/2+10);      //prints the actual letter in its own square
  } 
  step = 3;                                                 //set step as 3
}

void paint2() {                                          //This method prints the pattern array
  pat = pattern.toCharArray();                           //initialize the pat array with the pattern
  i = j = pat.length;                                    //initialize the i and j varialbes with the length of the pattern
  int x = 0;                                             //declares and initialize the x variable with 0
  for (int j=1; j<pat.length+1; j++) {                   //runs over the pat array
    fill(255);                                           //with white fill 
    rect(x+=sSize, sSize*2+10, sSize, sSize);            //draws a square at the desired position (draws the pat array) 
    fill(0, 0, 255);                                     //with blue fill
    text(pat[j-1], x+sSize/2, sSize*2+10+sSize/2+10);    //prints the actual letter in its own square
  }
  step = 4;                                              //set step as 4
}

void paint2(int x) {                                                              //This method moves the pattern array
  int start = x;                                                                  //declares and initialize the start variable with the content of the x variable
  x -= sSize;                                                                     //decrements the value of the x variable
  for (int j=1; j<pat.length+1; j++) {                                            //runs over the pat array
    fill(255);                                                                    //with white fill
    rect(x+=sSize, sSize*2+10, sSize, sSize);                                     //draws a the pat array at the desired position
    fill(0, 0, 255);                                                              //with blue fill
    text(pat[j-1], x+sSize/2, sSize*2+10+sSize/2+10);                             //prints the actual letter in its own square
  }
  fill(0);                                                                        //with black fill
  for (int j=start-=sSize; j>=0; j-=sSize) rect(j, sSize*2+10, sSize, sSize);     //deletes the old squares
}

void createTable() {                                                             //This method creates the table that is used to jump over the text in the algorithm
  boolean repeated;                                                              //variable used to know if a letter is already on the table or not  
  int idx = 0;                                                                   //start index                                                 
  letters = new char[pat.length+1];                                              //creates the letters array
  for (int j=0; j<pat.length; j++) {                                             //runs over the pat array
    if (exists(letters, pat[j])) repeated = true;                                //if the actual letter of the array is already on the letter array, then set repeated as true
    else repeated = false;                                                       //otherwise set repeated as false
    if (!repeated) letters[idx++] = pat[j];                                      //if repeated is equals to false add the letter to the letters array
  }
  table = new int[idx+1];                                                        //creates the table array
  for (int j=0; j<pat.length-1; j++) {                                           //runs over the pat array minus one
    idx = getPos(letters, pat[j]);                                               //get the index of the actual letter on the letters array
    table[idx] = max(1, pat.length-1-j);                                         //calculates the value of the letter and save it on the table array
  } 
  char last = pat[pat.length-1];                                                 //gets the last letter of the pat array
  char[] temp = pattern.substring(0,pattern.length()-1).toCharArray();           //gets the pat array without the last position
  if (!exists(temp, last)) table[table.length-2] = pat.length;                   //if the last letter is unique on the array then set his value as the length of the pat array
  else table[getPos(letters, last)] = 1;                                         //otherwise set his value as 1
  table[table.length-1] = pat.length;                                            //the value of the table at the last position is the length of the pat array
  step = 5;                                                                      //set step as 5
}

boolean exists(char[] a, char b) {                                      //This method checks if a char is into a char array
  for (int i : a) if (i==b) return true;                                //runs all the array, if the char at the current position is equals to the searched one return true
  return false;                                                         //if the char searched wasnt found then return false
}

int getPos(char[] a, char b) {                                          //This method gets the position of a char into a char array
  for (int j=0; j<a.length; j++) if (b == a[j]) return j;               //runs all the array and if the char at that position is equals to the searched char then return the actual position
  return table.length-1;                                                //if the char searched wasnt found then return the table length minus one
}

void printTable() {
  fill(0, 150, 0);                                                      //with green fill 
  rect(sSize, sSize*3+30, sSize*table.length, sSize);                   //draws a rectangle at the desired position
  fill(0, 0, 200);                                                      //with blue fill 
  text("Table", sSize*table.length/2+sSize, sSize*3+30+sSize/2+10);     //prints the "Table" string on the last rectangle
  int x = 0;                                                            //declares and initialize the x variable with a value of 0
  for (int j=1; j<table.length+1; j++) {                                //runs all the table array
    fill(255);                                                          //with white fill 
    rect(x+=sSize, sSize*4+30, sSize, sSize);                           //draws the corresponding square of the letter array
    fill(100, 0, 100);                                                  //with purple fill 
    text(letters[j-1], x+sSize/2, sSize*4+sSize/2+40);                  //prints the letter on each square 
  }
  text('*', x+sSize/2, sSize*4+sSize/2+40);                             //prints the * char at the last square  
  x = 0;                                                                //set x as 0
  for (int j=1; j<table.length+1; j++) {                                //runs all the table array
    fill(255);                                                          //with white fill 
    rect(x+=sSize, sSize*5+30, sSize, sSize);                           //draws the corresponding square of the table array
    fill(100, 0, 100);                                                  //with purple fill 
    text(table[j-1], x+sSize/2, sSize*5+sSize/2+40);                    //prints the value on each square
  }
  if (pat.length > tex.length) {                                        //if the pattern is bigger than the text
    found = false;                                                      //set found as false
    step = 7;                                                           //set step as 7
  } else step = 6;                                                      //otherwise set step as 6
}

public void finish(boolean found) {                          //This method is the last to be executed, determines if the pattern was found or not
  if (found) {                                               //if the patter was found
    fill(0, 255, 0);                                         //with green fill 
    text("found at index "+(i-1), width/2, height-sSize);    //draws the "founded at index" string on the screen at the desired position
  } else {                                                   //otherwise
    fill(255, 0, 0);                                         //with red fill 
    text("pattern not found", width/2, height-sSize);        //draws the "pattern not found" string on the screen at the desired position
  }
  rect(sSize, height-sSize*2, width-sSize*2, sSize/2);       //draw a rectangle at the bottom of the screen with stuffing as before to indicate whether it has been found or not the pattern
}

