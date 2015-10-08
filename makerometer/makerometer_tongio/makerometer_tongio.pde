import processing.serial.*; // librerie seriali di Processing
import processing.net.*;
import java.util.*;
Serial myPort;        // The serial port
boolean connesso = false;
int type = 0;

JSONArray values;
String path = "http://www.my-id.org/esempio_2.json";

Client c;
String data;

ArrayList<Zone> zoneList;

void setup() {
// elenca le porte seriali
  for(int i=0; i <Serial.list().length;i++){
   println("["+ i +"] " + Serial.list()[i]); 
   text("["+ i +"] " + Serial.list()[i], 15, 20*i +45); 
  }
  zoneList = new ArrayList();
  c = new Client(this, "37.59.104.55", 80); // Connect to server on port 80
  c.write("GET /mf2015/index.php?startDate=2015-09-20T13:46:15.104Z&endDate=2015-09-30T18:56:21.104Z&name=all&resolution=0 HTTP/1.0\r\n");
  c.write("\r\n");
  
}

void draw(){
  if (c.available() > 0) { // If there's incoming data from the client...
    data = c.readString(); // ...then grab it and print it
    println(data);
  }
  
  switch(type) {
    case 0: 
     // println("Zero");  // Does not execute
      break;
    case 1: 
      println("Uno");  // Prints "One"
      path = "http://37.59.104.55/mf2015/index.php?startDate=2015-09-20T13:46:15.104Z&endDate=2015-09-30T18:56:21.104Z&name=all&resolution=0";
      break;
      case 2: 
      println("due"); 
      path = "http://www.my-id.org/esempio.json";
      break;
  } 
  if(type >0){
    esegui();
    printZones(zoneList);
    printZonesAsCsvDemmerda(zoneList);
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

void printZones(ArrayList<Zone> z){
 
  for(int i=0;i<z.size();i++){
    Zone t = z.get(i);
    println(t.name);
    println(t.perc);
  
    for(int j=0;j<t.emotionList.size();j++){
      Emotion e = t.emotionList.get(j);
      println(e.name);
      println(e.perc);
    }  
  }
  
}

void printZonesAsCsvDemmerda(ArrayList<Zone> z){
  String csv="";
  for(int i=0;i<z.size();i++){
    Zone t = z.get(i);
    csv = csv + t.name + ",";
    csv = csv + t.perc + ",";
    for(int j=0;j<t.emotionList.size();j++){
      Emotion e = t.emotionList.get(j);
      csv = csv + e.name + ",";
      csv = csv + e.perc + ",";
    }  
    csv = csv + ";";
  }
  println(csv);
}


void esegui(){
  
  JSONObject values;
  values = loadJSONObject(path);

  //for (int i = 0; i < values.size(); i++) {
    
    Iterator<?> keys = values.keyIterator();
    Zone z;
    while(keys.hasNext()){
      String key = (String) keys.next();
      z = new Zone();
      z.name = key;
      JSONObject obj = values.getJSONObject(key);
      z.perc = obj.getFloat("perc");
      for(int i=0;i<obj.getJSONArray("results").size();i++){
        Emotion e = new Emotion();
        e.name = obj.getJSONArray("results").getJSONObject(i).getString("emotion");
        e.perc = obj.getJSONArray("results").getJSONObject(i).getFloat("perc");
        z.emotionList.add(e);
      }
      zoneList.add(z);
    }
    /*int id = makerval.getInt("id");
    int tipo = makerval.getInt("type");
    String values = makerval.getString("values");
    String send = values + "x";
    myPort.write(send);*/ 
    delay(200);
  //}
}


class Zone{
 
 public String name;
 public Float perc;
 
 public ArrayList<Emotion> emotionList;
 
 public Zone(){
   emotionList = new ArrayList(); 
 }
  
}

class Emotion{
  public String name;
  public Float perc;
}
