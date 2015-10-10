import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;

import java.util.List;
import java.util.Iterator;

import processing.serial.*; // librerie seriali di Processing
Serial myPort;        // The serial port
boolean connesso = false;
boolean manda = true;
boolean show = false;

ConfigurationBuilder   cb;
Query query;
Twitter twitter;

ArrayList<String> twittersList;
ArrayList<String> twittersList_old;
ArrayList<String> tweets = new ArrayList<String>();
ArrayList<String> usrnames = new ArrayList<String>();
ArrayList<String> usr_tweets = new ArrayList<String>();
Timer             time;

//Number twitters per search
int numberSearch = 3;

PFont font;
int   fontSize = 14;

void setup() {
  size(670, 650);
  background(0);
  smooth(4);
// elenca le porte seriali
  for(int i=0; i <Serial.list().length;i++){
   println("["+ i +"] " + Serial.list()[i]); 
   text("["+ i +"] " + Serial.list()[i], 15, 20*i +45); 
  }


  //FONT
  font = createFont("NexaLight-16.vlw", fontSize, true);
  textFont(font, fontSize);

  //You can only search once every 1 minute
  time = new Timer(10000); //1 min with 10 secs

  //Acreditacion
  cb = new ConfigurationBuilder();
  //setting account @thepastacode
  cb.setOAuthConsumerKey("dUtFHgBEpcMN8V0q9kOJ8PF6B");   
  cb.setOAuthConsumerSecret("BZ9itSSXzW7P57HJwJ9tf16mBJlrGX2ruI7Tqh0ifOficm2dTo");   
  cb.setOAuthAccessToken("3919910657-39UAfhU9hrcvN15MG1rEbUgB6s3wTP5dO3QhNY9");   
  cb.setOAuthAccessTokenSecret("XGRUPpPElG5RYVLHFYXAyXRmN5n6vzB2LhPZBbxLPdIuj");
  

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();

  //SEARCH
  twittersList = queryTwitter(numberSearch);
  twittersList_old = twittersList;
}

void draw() {
  background(50);

  //draw twitters
  if(show){
  drawTwitters(tweets);
  }else{
drawTwitters(usr_tweets);
  }

  if (time.isDone()) {
    twittersList = queryTwitter(numberSearch);
    compare();
    twittersList_old = twittersList;
  
    time.reset();
  }
  
  text(time.getCurrentTime(), 20, 30);

  time.update();
}

void drawTwitters(ArrayList<String> tw) {
  if(tw.size() > 0){
  Iterator<String> it = tw.iterator();
  int i = 0;

  while (it.hasNext ()) {
    String twitt = it.next();
    fill(150);
    text(i + 1, 27, 60 + i*(fontSize)*4 + fontSize);
    fill(220);
    text(twitt, 50, 60 + i*(fontSize)*4, 600,  fontSize*4);
    i++;
  }
  }
//  for(String t: tweets){
//    println(t);
//  }
}

ArrayList<String> queryTwitter(int nSearch) {
  ArrayList<String> twitt = new ArrayList<String>();
usrnames.clear();
  query = new Query("#famocose @thepastacode");
  query.setCount(nSearch);
  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    println("New Tweet : ");
    for (Status tw : tweets) {
      String msg = tw.getText();
       //rimuovo l'hashtag
       msg = msg.replaceAll("#","");
       String reg = "\\s*\\bfamocose\\b";
       msg = msg.replaceAll(reg, "");
       msg = msg.replaceAll("@","");
       reg = "\\s*\\bthepastacode\\b";
       msg = msg.replaceAll(reg, "");
       //println(k);
      
      String usr = tw.getUser().getScreenName();
      //String twStr = "@"+usr+": "+msg;
      String twStr = "@"+usr;
      usrnames.add(twStr);
     // println(twStr);
      twitt.add(msg); // dentro twitt va solo il messaggio
    }
    
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }

  return twitt;
}

void compare(){
   println("tw " + twittersList.size());
   println("old " + twittersList_old.size());
  //svuota();
  int index = 0;
  int nuovi = 0;
  println("confronta");
// for(String s: twittersList){
//  if(twittersList_old.size() > index){
//    if(s.equals(twittersList_old.get(index))==false){
//      nuovi = nuovi + 1;
//    }else{ 
//     index++;
//    }
//  }else{
//    println("old finito");
//    //nuovi = nuovi +  (twittersList.size() - twittersList_old.size());
//  }
// }
if(twittersList_old.size() == 0 && twittersList.size() > 0){ // tutti i tweet ricevuti sono nuovi
println("tutti nuovi");
  tweets = twittersList;
  usr_tweets = usrnames;
  nuovi = twittersList.size();
}
if(twittersList_old.size() > 0 && twittersList.size() > 0){ // alcuni dei tweet ricevuti sono nuovi
  for(String s: twittersList){
    println(s);
    if(s.equals(twittersList_old.get(0))==false){
      nuovi = nuovi + 1;
      usr_tweets.add(usrnames.get(index));
      tweets.add(s); 
      index++;
    }else{
      break;
    }
    
  }
}


 if(nuovi >0){
   println("ci sono " + nuovi + " nuovi tweet");
 }else{
   println("no " + nuovi);
   
 }
  
}

void svuota(){
  tweets.clear();
  println("svuotato " + tweets.size());
}
  
  void serialEvent (Serial myPort) {
 // get the ASCII string:
String inString = myPort.readStringUntil('\n');
 
 if (inString != null) {
 // trim off any whitespace:
 inString = trim(inString);
 println("ricevuto : " + inString);
 if(inString.equals("pronto") == true){
   println("tweet stampato");
   manda = true;
 }
 if(inString.equals("ricevuto") == true){
   println("tweet in stampa");
   manda = false;
 }
 if(inString.equals("OK") == true){
   println("OK");
   if(manda){
     stampaUltimo();
   }
   
 }

}
}



void delay(int delay){
  int time = millis();
  while(millis() - time <= delay);
}

void stampaTutto(){
 
     for(String s : tweets){
       println(s);
       s= s + "\n";
       myPort.write(s);
     }
     tweets.clear();
     usr_tweets.clear();

}

void stampaUltimo(){
 if(tweets.size() >0){
    String tweet = tweets.get(0);
    println(tweet);
    tweet = tweet + "\n";   
    myPort.write(tweet);
    tweets.remove(0);
    usr_tweets.remove(0);
} 
  
}

void keyPressed() {
  int k = key - 48;
  println(k);
  if(connesso ==false && k < 10){
  println("apro seriale " + Serial.list()[k]);
  myPort = new Serial(this, Serial.list()[k], 9600);
   myPort.bufferUntil('\n');
   connesso= true;
  }else{
    //tweets.append("prova del tweet più lungo del mondo " + k);
    //tweets.add("sos" + k);
    
    if(k == 69){
      show = !show;
    }
  }
  
}

