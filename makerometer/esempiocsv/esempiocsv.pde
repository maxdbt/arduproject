import processing.serial.*; // librerie seriali di Processing
Serial myPort;        // The serial port
int ind = 0;
StringList valArray;
void setup() {
 myPort = new Serial(this, Serial.list()[3], 9600);
   myPort.bufferUntil('\n');
}

void draw() {
  background(50);
}
void serialEvent (Serial myPort) {
 // get the ASCII string:
String inString = myPort.readStringUntil('\n');
if (inString != null) {
 // trim off any whitespace:
 inString = trim(inString);
 println("ricevuto : " + inString);
 if(inString.equals("go")){
   println("vai");  
   ind = 0;
   manda(valArray.get(ind));
   ind++;
 }
 if(inString.equals("next")){
   
 manda(valArray.get(ind));
 ind++;
}
if(inString.equals("ready") && ind < valArray.size()){
   
 manda(valArray.get(ind));
 ind++;
}
}
}

void mousePressed() {
  //TextToSpeech.say(testo, "Alice", 170);

leggi();
 myPort.write("s");
  
}

void leggi(){
  valArray = new StringList();
  String lines[] = loadStrings("esempio_csv.txt");
println("there are " + lines.length + " lines");
for (int i = 0 ; i < lines.length; i++) {
  //println(lines[i]);
  String[] q = splitTokens(lines[i],",");
    for(int k = 0; k < q.length; k++){
      //manda(q[k]);
      valArray.append(q[k]);
    }
  
}
println("lun " + valArray.size());
}
  
 void manda(String val){
   val = val + "\n";
   println(val);
   myPort.write(val);
 }
