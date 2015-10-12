/*
  Morse Code Project
  
  This code will loop through a string of characters and convert these to morse code.  
  It will blink two LED lights and play audio on a speaker.  
 */
 
 
//**************************************************//
//   Type the String to Convert to Morse Code Here  //
//**************************************************//
#include <Servo.h>

Servo myServo;
int sval = 95; //valore di stop del servo
int vel = 70; //velocità del servo
// Create variable to define the output pins
int led12 = 12;      // blink an led on output 12
int led6 = 6;        // blink an led on output 6
int btnPin = 9;
int audio8 = 8;      // output audio on pin 8
int note = 1200;      // music note/pitch

/*
	Set the speed of your morse code
	Adjust the 'dotlen' length to speed up or slow down your morse code
		(all of the other lengths are based on the dotlen)

	Here are the ratios code elements:
	  Dash length = Dot length x 3
	  Pause between elements = Dot length
		  (pause between dots and dashes within the character)
	  Pause between characters = Dot length x 3
	  Pause between words = Dot length x 7
  
				http://www.nu-ware.com/NuCode%20Help/index.html?m...
*/
int dotLen = 100;     // length of the morse code 'dot'
//int dashLen = dotLen * 3;    // length of the morse code 'dash'
int dashLen = dotLen;
int elemPause = dotLen;  // pausa del dot
int elemPause2 = dotLen;  // pausa del dash 
int Spaces = dotLen * 3;     // length of the spaces between characters
int wordPause = dotLen * 7;  // length of the pause between words
int scorrimento = 500; //delay per far scorrere un po' di pasta


//variabili per la stringa da scrivere
String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete

//debounce
int buttonState = LOW;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin

// the following variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers


int btn_old = LOW;
// the setup routine runs once when you press reset:
void setup() {                
     // initialize serial:
  Serial.begin(9600);
  // reserve 200 bytes for the inputString:
  inputString.reserve(200);
  // initialize the digital pin as an output for LED lights.
  pinMode(led12, OUTPUT); 
  pinMode(led6, OUTPUT); 
  pinMode(btnPin, INPUT);
  myServo.attach(3);
  myServo.write(sval);
}

// Create a loop of the letters/words you want to output in morse code (defined in string at top of code)
void loop()
{ 
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
        Serial.println("OK");
      }
    }
  } 
   lastButtonState = reading;
//  if(btn == HIGH && btn_old == LOW){
//    Serial.println("OK");
//  }
//  btn_old = btn;
  
  //cosa fare quando arriva una stringa completa
   if (stringComplete) {
     Serial.println("ricevuto");
     myServo.write(vel);
     delay(scorrimento); //faccio scorrere un po' di pasta
    Serial.println(inputString.length());
   char stringToMorseCode[inputString.length()];
   inputString.toCharArray(stringToMorseCode,inputString.length());
    Serial.println(stringToMorseCode);
    for (int i = 0; i < inputString.length() - 1; i++)
  {
    // Get the character in the current position
	char tmpChar = stringToMorseCode[i];
	// Set the case to lower case
	tmpChar = toLowerCase(tmpChar);
	// Call the subroutine to get the morse code equivalent for this character
	GetChar(tmpChar);
Serial.println(i);
  }
 // LightsOff(100);
 delay(scorrimento); //faccio scorrere un po' di pasta
 myServo.write(sval);
  Serial.println("pronto");
    // clear the string:
    inputString = "";
    stringComplete = false;
  }		
}

//void scrivi(){
// // Loop through the string and get each character one at a time until the end is reached
//  for (int i = 0; i < sizeof(stringToMorseCode) - 1; i++)
//  {
//    // Get the character in the current position
//	char tmpChar = stringToMorseCode[i];
//	// Set the case to lower case
//	tmpChar = toLowerCase(tmpChar);
//	// Call the subroutine to get the morse code equivalent for this character
//	GetChar(tmpChar);
//Serial.println(i);
//  }
//  
//  // At the end of the string long pause before looping and starting again
//  //LightsOff(100);	 
//}
// DOT
void MorseDot()
{
  digitalWrite(led12, HIGH);  	// turn the LED on 
//  digitalWrite(led6, HIGH); 
  //tone(audio8, note, dotLen);	// start playing a tone
  delay(dotLen);             	// hold in this position
}

// DASH
void MorseDash()
{
//  digitalWrite(led12, HIGH);  	// turn the LED on 
  digitalWrite(led6, HIGH);
  //tone(audio8, note, dashLen);	// start playing a tone
  delay(dashLen);               // hold in this position
}

// Turn Off
void LightsOff(int delayTime)
{
  digitalWrite(led12, LOW);    	// turn the LED off  	
  digitalWrite(led6, LOW);
  noTone(audio8);	       	   	// stop playing a tone
  delay(delayTime);            	// hold in this position
}

// *** Characters to Morse Code Conversion *** //
void GetChar(char tmpChar)
{
	// Take the passed character and use a switch case to find the morse code for that character
	switch (tmpChar) {
	  case 'a':	
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'b':
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'c':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'd':
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'e':
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'f':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'g':
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'h':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'i':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'j':
	    MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		break;
      case 'k':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'l':
	    MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
      case 'm':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'n':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'o':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'p':
	    MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 'q':
	    MorseDash();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'r':
	    MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 's':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
	  case 't':
	    MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'u':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'v':
	    MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'w':
	    MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'x':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'y':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		break;
	  case 'z':
	    MorseDash();
		LightsOff(elemPause2);
		MorseDash();
		LightsOff(elemPause2);
		MorseDot();
		LightsOff(elemPause);
		MorseDot();
		LightsOff(elemPause);
		break;
	  default: 
		// If a matching character was not found it will default to a blank space
		LightsOff(Spaces);			
	}
}

void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    }
  }
}

/* 
	Unlicensed Software:
	
	This is free and unencumbered software released into the public domain.

	Anyone is free to copy, modify, publish, use, compile, sell, or
	distribute this software, either in source code form or as a compiled
	binary, for any purpose, commercial or non-commercial, and by any
	means.

	In jurisdictions that recognize copyright laws, the author or authors
	of this software dedicate any and all copyright interest in the
	software to the public domain. We make this dedication for the benefit
	of the public at large and to the detriment of our heirs and
	successors. We intend this dedication to be an overt act of
	relinquishment in perpetuity of all present and future rights to this
	software under copyright law.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
	OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
	ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.

	For more information, please refer to 
*/
