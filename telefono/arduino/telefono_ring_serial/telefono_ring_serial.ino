int cornettaPin = 7;
int enablePin = 3;// pwm per controllare frequenza
int in1Pin = 10;//verso
int in2Pin = 11; //verso
int state1 = 0;
bool suona = false;
unsigned long previousMillis = 0;        // will store last time LED was updated
unsigned long previousMillis2 = 0; 
// constants won't change :
const long interval = 30;           // interval at which to blink (milliseconds)
const long interval2 = 1000;  

int lastC = 0;
void setup() {
// put your setup code here, to run once:
Serial.begin(9600);

pinMode(cornettaPin,INPUT);
pinMode(13,OUTPUT);
pinMode(enablePin,OUTPUT);
pinMode(in1Pin, OUTPUT);
pinMode(in2Pin, OUTPUT);

}

void loop() {
int cornetta = digitalRead(cornettaPin);
if(suona){
  drin(); 
}else{
 digitalWrite(enablePin,LOW);
}



if(cornetta){  
digitalWrite(13,HIGH); 
if(lastC == 0){
Serial.println("alzata");
suona = false;
}
}else{
digitalWrite(13,LOW);
if(lastC == 1){
Serial.println("abbassata");
}
}
lastC = cornetta;


}

void squilla(){  
digitalWrite(enablePin,HIGH);
unsigned long currentMillis = millis(); 

if(currentMillis - previousMillis >= interval) {
digitalWrite(in1Pin, state1); 
digitalWrite(in2Pin, !state1); 
 previousMillis = currentMillis; 
 state1 = !state1;
}


}

void drin(){
unsigned long currentMillis = millis();
 previousMillis2 = currentMillis;
  while(currentMillis - previousMillis2 < interval2 && digitalRead(cornettaPin) == LOW){
    squilla();
    currentMillis = millis();  
  }
  delay(1000);

}


void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    Serial.println(inChar);
    if(inChar == '1'){
      suona = true;
    }
  }
}

