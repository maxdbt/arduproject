JSONArray values;

void setup() {

  values = loadJSONArray("http://www.my-id.org/esempio.json");

  for (int i = 0; i < values.size(); i++) {
    
    JSONObject makerval = values.getJSONObject(i); 

    int id = makerval.getInt("id");
    int tipo = makerval.getInt("type");
    String values = makerval.getString("values");

    println(id + ", " + values );
  }
}


