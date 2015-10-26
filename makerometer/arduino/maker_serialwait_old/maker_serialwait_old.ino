#include <Servo.h>
#define NBR_SERVOS 35  // the number of servos, up to 48 for Mega, 12 for other boards
#define FIRST_SERVO_PIN 2 

Servo Servos[NBR_SERVOS] ; // max servos is 48 for mega, 12 for other boards
int allpos_old[NBR_SERVOS];
int allpos[NBR_SERVOS];
String inputString;
int index;
bool lastChar = false;
void setup() {
Serial.begin(9600);     // opens serial port, sets data rate to 9600 bps

for( int i =0; i < NBR_SERVOS; i++){
    Servos[i].attach(FIRST_SERVO_PIN +i);
  }
  
  muoviTutti(30);
//stacca();
}

void loop() {
 //muoviTutti(50);

// send data only when you receive data:
while (Serial.available()) {
int inChar = Serial.read();
//Serial.println((char)inChar);
if(inChar == 's'){
  index = 0;
  Serial.println("go");
}else{
if(isDigit(inChar)){
    inputString += (char)inChar;
}
  if(inChar == '\n'){
    
    //Serial.println(inputString);
    int num = inputString.toInt();
    //Serial.println(num);
    inputString = "";
    allpos[index] = num;
    index++;
    //Serial.println(index);
    if(index == NBR_SERVOS){
      index = 0;
      muovi();
    }else{
     Serial.println("next"); 
    }
  }
}
}
}

void muovi(){
 attacca();
  for(int i=0; i<NBR_SERVOS; i++){
    
    if(allpos[i] > allpos_old[i]){
      int deg = 0;
     // Serial.println("magg");
      for(int j = allpos_old[i]; j < (allpos[i] + 1) ; j++){
         Serial.println(j);
          deg = map(j,0,100,10,170);
          //Serial.println(allpos[i]);
         // Serial.println(deg);
           Servos[i].write(deg);
          delay(5); 
            
       }
       if(deg <10){
              Servos[i].detach();
            }
    }else if(allpos[i] < allpos_old[i]){
        int deg = 0;
      for(int j = allpos_old[i]; j > (allpos[i] -1); j--){
        Serial.println(j);
          int deg = map(j,0,100,10,170);
          //Serial.println(allpos[i]);
         // Serial.println(deg);
           Servos[i].write(deg); 
           delay(5); 
            
       }
       if(deg <10){
                Servos[i].detach();
            }
    }
      
    allpos_old[i] = allpos[i];  
      
      
    }
    
    
//     int deg = map(allpos[i],0,100,10,170);
//     //Serial.println(allpos[i]);
//     Serial.println(deg);
//      Servos[i].write(deg); 
//      if(allpos[i] <20){
//        Servos[i].detach();
//      }
      //delay(15);
 //    }
 // stacca();
  // delay(50);
     Serial.println("ready"); 
}

void muoviTutti(int pos){
  for( int k =0; k <NBR_SERVOS; k++){ 
    Servos[k].write(pos);   
  //delay(15);
  //Serial.println("ready");  
  }
  //stacca();
}

void stacca(){
  for( int i =0; i < NBR_SERVOS; i++){
    Servos[i].detach();
  }
}

void attacca(){
  for( int i =0; i < NBR_SERVOS; i++){
    Servos[i].attach(FIRST_SERVO_PIN +i);
  }
}

void initPos(){
 for( int i =0; i < NBR_SERVOS; i++){
    allpos[i] = 0;
  } 
}
  
  
  
