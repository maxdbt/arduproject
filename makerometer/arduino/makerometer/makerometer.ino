#include <Servo.h>
#define NBR_SERVOS 7  // the number of servos, up to 48 for Mega, 12 for other boards
#define FIRST_SERVO_PIN 2 

Servo Servos[NBR_SERVOS] ; // max servos is 48 for mega, 12 for other boards

int pos = 0;      // variable to store the servo position 
int potPin = 0;   // connect a pot to this pin.

int allpos[7];

void setup()
{
  Serial.begin(9600);
  for( int i =0; i < NBR_SERVOS; i++){
    Servos[i].attach( FIRST_SERVO_PIN +i);
  }
    muoviTutti(90);
}
void loop()
{ 

 while (Serial.available() > 0) {
// if (Serial.read() == 'y'){
//   muoviTutti(90);
// }
    // look for the next valid integer in the incoming serial stream:
    for(int k = 0; k < NBR_SERVOS; k++){
    allpos[k] = Serial.parseInt();

 }
    // look for the ending character
    if (Serial.read() == 'x') {
      Serial.println("entra");
    for( int i = 0; i <NBR_SERVOS; i++){ 
    Servos[i].write(map(allpos[i],0,100,0,180));   
    Serial.println(allpos[i]);
  //delay(15); 
    }
         
    }
  } 
 
}

void muoviTutti(int pos){
  for( int k =0; k <NBR_SERVOS; k++) 
    Servos[k].write( map(pos, 0,1023,0,180));   
  delay(15);    
}
