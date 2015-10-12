import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;

import java.util.List;
import java.util.Iterator;

import processing.serial.*; // librerie seriali di Processing
Serial myPort;        // The serial port
boolean connesso = false;
String testo = "nessun messaggio ricevuto";
StringList frasi;

StringList tweets;

Process process;

boolean leggi = false;

ConfigurationBuilder   cb;
Query query;
Twitter twitter;

ArrayList<String> twittersList;
ArrayList<String> twittersList_old;
ArrayList<String> twittersList_new = new ArrayList<String>();
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
  
  frasi = new StringList();
frasi.append("La risposta è dentro di te ma è quella sbagliata");
frasi.append("La domanda è malposta, forse te volevi chiedere: Maestro che ore sono?");
frasi.append("Due rette parallele non si incontrano mai... e se si incontrano non si salutano");
frasi.append("Non scherziamo che c’è gente che ci muore");
frasi.append("Non sai che fare, non sai dove andare, miagoli nel buio");
frasi.append("Tu come la vedi?");
frasi.append("Mica posso fa' tutto io qua. Te lo sai oggi a che ora mi sono alzato? Alle sette meno un quarto!");
frasi.append("La risposta non la devi cercare fuori, la risposta è dentro di te. E però è sbagliata!");
frasi.append("Gli ultimi saranno i primi, ma lo sportello chiude alle 12");
frasi.append("Non rimandare a domani quello che puoi fare dopodomani");
  //FONT
  font = createFont("NexaLight-16.vlw", fontSize, true);
  textFont(font, fontSize);

  //You can only search once every 1 minute
  time = new Timer(10000); //1 min with 10 secs

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("7TqpojOAKn9v5rws9hp1rt43K");   
  cb.setOAuthConsumerSecret("8wwBJdvgMQZCGiO37YCxHV4HigKId1Pj6imzbt1SieMjTvGj03");   
  cb.setOAuthAccessToken("3911012368-3tfSxG9zdBF7vAMxiPPukQuwUJdJ8ggMIpVpvlc");   
  cb.setOAuthAccessTokenSecret("obCKmeJabsFo9jXD11ZGk67wFveRQqiGNTMDgUdnFKPxI");
  

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();

  //SEARCH
  twittersList = queryTwitter(numberSearch);
  twittersList_old = twittersList;
}

void draw() {
  background(50);

  //draw twitters
   drawTwitters(twittersList_new);


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
}

ArrayList<String> queryTwitter(int nSearch) {
  ArrayList<String> twitt = new ArrayList<String>();

  query = new Query("#lcutest3");
  query.setCount(nSearch);
  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    println("New Tweet : ");
    for (Status tw : tweets) {
      String msg = tw.getText();
      String usr = tw.getUser().getScreenName();
      String twStr = "@"+usr+": "+msg;
     // println(twStr);
      twitt.add(twStr);
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
//  int index = 0;
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
  twittersList_new = twittersList;
  nuovi = twittersList.size();
}
if(twittersList_old.size() > 0 && twittersList.size() > 0){ // alcuni dei tweet ricevuti sono nuovi
  for(String s: twittersList){
    println(s);
    if(s.equals(twittersList_old.get(0))==false){
      nuovi = nuovi + 1;
      twittersList_new.add(s); 
    }else{
      break;
    }
    
  }
}


 if(nuovi >0){
   println("ci sono " + nuovi + " nuovi tweet");
   myPort.write("1");
 }else{
   println("no " + nuovi);
   
 }
  
}

void svuota(){
  twittersList_new.clear();
  println("svuotato " + twittersList_new.size());
}
  
  void keyPressed() {
  int k = key - 48;
  println(k);
  if(connesso ==false){
  println("apro seriale " + Serial.list()[k]);
  myPort = new Serial(this, Serial.list()[k], 9600);
   myPort.bufferUntil('\n');
   connesso= true;
  }else{
    tweets.append("prova del tweet più lungo del mondo " + k);
  }
  
}

void serialEvent (Serial myPort) {
 // get the ASCII string:
String inString = myPort.readStringUntil('\n');
 
 if (inString != null) {
 // trim off any whitespace:
 inString = trim(inString);
 println("ricevuto : " + inString);
 if(inString.equals("alzata") == true){
   println("leggi");
   leggi = true;
   delay(500); // tempo per alzare la cornetta
   int tot_fr = (frasi.size() - 1);
   
   int rand = int(random(tot_fr));
   println(rand + " " + tot_fr);
   String frase = frasi.get(rand);
   TextToSpeech.say(frase, "Alice", 160);
   
   svuota();
//   if(tweets.size() >0){
//     for(int i=(tweets.size() - 1);i>-1;i--){
//       String tweet = tweets.get(tweets.size() - 1);
//       println(tweet);
//       TextToSpeech.say(tweet, "Alice", 160);
//       tweets.remove(tweets.size() - 1);
//      //delay(4000);
//     }
//     for(String s : tweets){
//       println(s);
//       TextToSpeech.say(s, "Alice", 160);
//     }
//     tweets.clear();
//   }else{
//   
//   TextToSpeech.say(testo, "Alice", 160);
//   }
 }else{
  leggi = false; 
  println("abbassata");
 }
   
 }
}
void delay(int delay){
  int time = millis();
  while(millis() - time <= delay);
}

void mousePressed() {
  //TextToSpeech.say(testo, "Alice", 170);
  myPort.write("1");
}

// the text to speech class
import java.io.IOException;

static class TextToSpeech extends Object {

  // Store the voices, makes for nice auto-complete in Eclipse

  // male voices
  static final String ALEX = "Alex";
  static final String BRUCE = "Bruce";
  static final String FRED = "Fred";
  static final String JUNIOR = "Junior";
  static final String RALPH = "Ralph";

  // female voices
  static final String ALICE = "Alice";
  static final String KATHY = "Kathy";
  static final String PRINCESS = "Princess";
  static final String VICKI = "Vicki";
  static final String VICTORIA = "Victoria";

  // novelty voices
  static final String ALBERT = "Albert";
  static final String BAD_NEWS = "Bad News";
  static final String BAHH = "Bahh";
  static final String BELLS = "Bells";
  static final String BOING = "Boing";
  static final String BUBBLES = "Bubbles";
  static final String CELLOS = "Cellos";
  static final String DERANGED = "Deranged";
  static final String GOOD_NEWS = "Good News";
  static final String HYSTERICAL = "Hysterical";
  static final String PIPE_ORGAN = "Pipe Organ";
  static final String TRINOIDS = "Trinoids";
  static final String WHISPER = "Whisper";
  static final String ZARVOX = "Zarvox";

  // throw them in an array so we can iterate over them / pick at random
  static String[] voices = {
    ALEX, BRUCE, FRED, JUNIOR, RALPH, ALICE, KATHY,
    PRINCESS, VICKI, VICTORIA, ALBERT, BAD_NEWS, BAHH,
    BELLS, BOING, BUBBLES, CELLOS, DERANGED, GOOD_NEWS,
    HYSTERICAL, PIPE_ORGAN, TRINOIDS, WHISPER, ZARVOX
  };

  // this sends the "say" command to the terminal with the appropriate args
  static void say(String script, String voice, int speed) {
    Process process = null;
    
    try {
     process = Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + script});
    }
    catch (IOException e) {
      System.err.println("IOException");
    }
    try{
    process.waitFor();
    }catch(InterruptedException e){
      System.err.println("IEException");
    }
//    try {
//      Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + "stocazzoooo"});
//    }
//    catch (IOException e) {
//      System.err.println("IOException");
//    }
  }

  // Overload the say method so we can call it with fewer arguments and basic defaults
  static void say(String script) {
    // 200 seems like a resonable default speed
    say(script, ALICE, 200);
  }

}

