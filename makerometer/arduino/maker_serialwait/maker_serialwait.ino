#include <Servo.h>
#define NBR_SERVOS 35  // the number of servos, up to 48 for Mega, 12 for other boards
#define FIRST_SERVO_PIN 2 

Servo Servos[NBR_SERVOS] ; // max servos is 48 for mega, 12 for other boards

int allpos[NBR_SERVOS];
String inputString;
int index;
bool lastChar = false;
void setup() {
Serial.begin(9600);     // opens serial port, sets data rate to 9600 bps

for( int i =0; i < NBR_SERVOS; i++){
    Servos[i].attach(FIRST_SERVO_PIN +i);
  }

}

void loop() {

// send data only when you receive data:
while (Serial.available()) {
int inChar = Serial.read();
//Serial.println((char)inChar);
if(inChar == 's'){
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
  for(int i=0; i<NBR_SERVOS; i++){
      Servos[i].write(map(allpos[i],0,100,0,180)); 
      Serial.println(allpos[i]);
      delay(5);
     }
     Serial.println("ready"); 
}

void muoviTutti(int pos){
  for( int k =0; k <NBR_SERVOS; k++) 
    Servos[k].write( map(pos, 0,1023,0,180));   
  delay(15);
  //Serial.println("ready");  
}
