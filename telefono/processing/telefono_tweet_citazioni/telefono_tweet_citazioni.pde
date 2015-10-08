import processing.serial.*; // librerie seriali di Processing
Serial myPort;        // The serial port
boolean connesso = false;
String testo = "nessun messaggio ricevuto";
StringList frasi;

StringList tweets;

Process process;

boolean leggi = false;
// This is where you enter your Oauth info
static String OAuthConsumerKey = "5PiS8pvNlaf4BjPLM1EYA";
static String OAuthConsumerSecret = "VKcWbOklUmtjhXOuxvlpXOVQV8s5QCU98FA938e0E";
// This is where you enter your Access Token info
static String AccessToken = "14461407-YLf56NbfkR1h7f4cSluT4w0qgagEyzTyglKvJfx5o";
static String AccessTokenSecret = "IuC1qCtYzyDTd0ZIAIIi7SCbn3Fyk2HY0dGFmo8QBcoMA";

// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {"#work","@mdbt"
};

TwitterStream twitter = new TwitterStreamFactory().getInstance();

void setup() {
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
  
  tweets = new StringList();
  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
}

void draw(){
  size(200,200);
 // background(0);
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
   delay(1000); // tempo per alzare la cornetta
   int tot_fr = (frasi.size() - 1);
   
   int rand = int(random(tot_fr));
   println(rand + " " + tot_fr);
   String frase = frasi.get(rand);
   TextToSpeech.say(frase, "Alice", 160);
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

// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// This listens for new tweet
StatusListener listener = new StatusListener() {
  public void onStatus(Status status) {

  // println("@" + status.getUser().getScreenName() + " - " + status.getText());
  
    if (status.getText() != null){
      String testo = status.getText();
     // println("tweet " +testo);
      int iment = testo.indexOf("@mdbt");
     
     if(iment >= 0){
      println("menzione" + testo);
      tweets.append(testo);
      if(!leggi){
        myPort.write("1");
      }
     } 
      
    }
      

  }

  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    //System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    //  System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};

