int cornettaPin = 7;
int btnPin = 12;
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

//variabili per debounce
// Variables will change:

int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin

// the following variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers



void setup() {
// put your setup code here, to run once:
Serial.begin(9600);

pinMode(cornettaPin,INPUT);
pinMode(13,OUTPUT);
pinMode(enablePin,OUTPUT);
pinMode(in1Pin, OUTPUT);
pinMode(in2Pin, OUTPUT);
pinMode(btnPin, INPUT);

}

void loop() {
int cornetta = digitalRead(cornettaPin);
if(suona){
  drin(); 
}else{
 digitalWrite(enablePin,LOW);
}
//debounce
int reading = digitalRead(btnPin);
if (reading != lastButtonState) {
    // reset the debouncing timer
    lastDebounceTime = millis();
  }
  
   if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer
    // than the debounce delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState) {
      buttonState = reading;

      // only toggle the LED if the new button state is HIGH
      if (buttonState == HIGH) {
        Serial.println("premuto");
        suona = true;
      }
    }
  } 
  lastButtonState = reading;
  



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

