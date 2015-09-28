import processing.serial.*; // librerie seriali di Processing
Serial myPort;        // The serial port
boolean connesso = false;
int type = 0;

JSONArray values;
String path = "http://www.my-id.org/esempio_2.json";

void setup() {
// elenca le porte seriali
  for(int i=0; i <Serial.list().length;i++){
   println("["+ i +"] " + Serial.list()[i]); 
   text("["+ i +"] " + Serial.list()[i], 15, 20*i +45); 
  }
}

void draw(){
switch(type) {
  case 0: 
    println("Zero");  // Does not execute
    break;
  case 1: 
    println("Uno");  // Prints "One"
    path = "http://www.my-id.org/esempio_2.json";
    break;
    case 2: 
    println("due"); 
    path = "http://www.my-id.org/esempio.json";
    break;
} 
if(type >0){
println("esegui");
  esegui();
  if(type ==2){
   type= 1; 
  }
}

}

void keyPressed() {
  int k = key - 48;
  println(k);
  if(connesso == false && k < 9){
  println("apro seriale " + Serial.list()[k]);
  myPort = new Serial(this, Serial.list()[k], 9600);
   myPort.bufferUntil('\n');
   connesso= true;
  }
if(k ==66){ //R
type = 1;
}
if(k== 68){//T
type = 2;
}
if(k == 73){//Y
type = 3;
}


}

void esegui(){
  
  values = loadJSONArray(path);

  for (int i = 0; i < values.size(); i++) {
    
    JSONObject makerval = values.getJSONObject(i); 

    int id = makerval.getInt("id");
    int tipo = makerval.getInt("type");
    String values = makerval.getString("values");

    println(id + ", " + values );
    delay(2000);
  }
}
