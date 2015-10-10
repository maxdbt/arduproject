import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;

import java.util.List;
import java.util.Iterator;

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

  //FONT
  font = createFont("NexaLight-16.vlw", fontSize, true);
  textFont(font, fontSize);

  //You can only search once every 1 minute
  time = new Timer(10000); //1 min with 10 secs

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("5PiS8pvNlaf4BjPLM1EYA");   
  cb.setOAuthConsumerSecret("VKcWbOklUmtjhXOuxvlpXOVQV8s5QCU98FA938e0E");   
  cb.setOAuthAccessToken("14461407-YLf56NbfkR1h7f4cSluT4w0qgagEyzTyglKvJfx5o");   
  cb.setOAuthAccessTokenSecret("IuC1qCtYzyDTd0ZIAIIi7SCbn3Fyk2HY0dGFmo8QBcoMA");
  

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
 }else{
   println("no " + nuovi);
   
 }
  
}

void svuota(){
  twittersList_new.clear();
  println("svuotato " + twittersList_new.size());
}
  

