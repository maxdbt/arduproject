import processing.serial.*; // librerie seriali di Processing



Serial myPort;        // The serial port
boolean connesso = false;

StringList tweets;


boolean manda = true;
// This is where you enter your Oauth info
static String OAuthConsumerKey = "5PiS8pvNlaf4BjPLM1EYA";
static String OAuthConsumerSecret = "VKcWbOklUmtjhXOuxvlpXOVQV8s5QCU98FA938e0E";
// This is where you enter your Access Token info
static String AccessToken = "14461407-YLf56NbfkR1h7f4cSluT4w0qgagEyzTyglKvJfx5o";
static String AccessTokenSecret = "IuC1qCtYzyDTd0ZIAIIi7SCbn3Fyk2HY0dGFmo8QBcoMA";

// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {"#work"
};

TwitterStream twitter = new TwitterStreamFactory().getInstance();

void setup() {
  size(700,700);
  
  // elenca le porte seriali
  for(int i=0; i <Serial.list().length;i++){
   println("["+ i +"] " + Serial.list()[i]); 
   text("["+ i +"] " + Serial.list()[i], 15, 20*i +45); 
  }
  
  tweets = new StringList();
  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
}

void draw(){
  background(0);
  textSize(32);
text("ci sono " + tweets.size() + " messaggi in attesa", 10, 30); 
fill(0, 102, 153);
 if(tweets.size() >0){
 println("ci sono " + tweets.size() + " messaggi in attesa");
 int ypos = 70;
for(String s : tweets){
       println(s);
       text(s, 10, ypos); 
       ypos = ypos + 40;
 } 
}
}

void stampaTutto(){
 
     for(String s : tweets){
       println(s);
       s= s + "\n";
       myPort.write(s);
     }
     tweets.clear();

}

void stampaUltimo(){
 if(tweets.size() >0){
    String tweet = tweets.get(0);
    println(tweet);
    tweet = tweet + "\n";   
    myPort.write(tweet);
    tweets.remove(0);
} 
  
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
    //tweets.append("prova del tweet più lungo del mondo " + k);
    tweets.append("sos" + k);
  }
  
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

void mousePressed() {
  
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
     println("tweet " +testo);
      int iment = testo.indexOf("@mdbt");
     
     if(iment >= 0){
      println("menzione" + testo);
      tweets.append(testo);
      
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

