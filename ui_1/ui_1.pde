import controlP5.*;
import processing.sound.*;

ControlP5 cp5;

final int[] s_col = {0,50,75,125,175,225,255};
final int text_size = 14;
final float text_scalar = 0.8;

final String[] instruments_name = {"Piano","Guitar","Banjo","BassClarinet","Bassoon","Cello","DoubleBass","Flute","FrenchHorn","Mandolin","Oboe","Saxophone","Trumpet","Viola","Violin"};

Grid current_g;

HashMap<String,Grid> grids;
ListBox instruments_used, instruments;
Button add_btn, remove_btn;
Button play_pause;
Textfield off_col,off_row;
Slider time_beat, volume;
Textfield beat_max_text, beat_delay_text, save_file_text;
Textlabel description;
ListBox max_octave_select, load_file;
int wh=0;
Color c;
int n=0;
boolean slide = false, play = false;
int prev_time = 0, beats_per_second = 20, play_time = 0;
int max_ = 4, max_octave = 8;

ArrayList<SoundFile> s_file;
HashMap<String,Float>  notes;
SoundFile s1 = null;


JSONObject values;
int count_down = 0, tick = 0;

void preLoad(){
  s_file = new ArrayList<SoundFile>();
  s_file.add(new SoundFile(this,"A#3.wav"));
  s_file.add(new SoundFile(this,"guitar_A3.mp3"));
  s_file.add(new SoundFile(this,"banjo_A3.mp3"));
  s_file.add(new SoundFile(this,"bassclarinet_A3.mp3"));
  s_file.add(new SoundFile(this,"bassoon_A3.mp3"));
  s_file.add(new SoundFile(this,"cello_A3.mp3"));
  s_file.add(new SoundFile(this,"doublebass_A3.mp3"));
  s_file.add(new SoundFile(this,"flute_A4.mp3"));
  s_file.add(new SoundFile(this,"frenchhorn_A3.mp3"));
  s_file.add(new SoundFile(this,"mandolin_A3.mp3"));
  s_file.add(new SoundFile(this,"oboe_A4.mp3"));
  s_file.add(new SoundFile(this,"saxophone_A3.mp3"));
  s_file.add(new SoundFile(this,"trumpet_A3.mp3"));
  s_file.add(new SoundFile(this,"viola_A3.mp3"));
  s_file.add(new SoundFile(this,"violin_A3.mp3"));
}

void setup(){
 size(1000,800); 
 textSize(text_size);
 frameRate(60);
 preLoad();
 wh = height/4;
 c = new Color();
 cp5 = new ControlP5(this);
 add_btn = cp5.addButton("Add")
             .setValue(0)
             .setPosition(50,height-wh+120)
             .setSize(120,20)
             ;
 
 remove_btn = cp5.addButton("Remove")
             .setValue(0)
             .setPosition(100+add_btn.getWidth(),height-wh+120)
             .setSize(120,20)
             ;
 instruments_used = cp5.addListBox("instruments_used")
                     .setPosition(50, height - wh)
                     .setSize(120, 120)
                     .setItemHeight(15)
                     .setBarHeight(15)
                     .setColorBackground(c.blue_1)
                     .setColorActive(c.blue_3)
                     .setColorForeground(c.blue_2)
                     ;
 instruments_used.getCaptionLabel().setColor(c.white_1);
 instruments_used.getCaptionLabel().toUpperCase(true);
 instruments_used.getValueLabel().setColor(c.white_1);
 instruments_used.addListener(new ControlListener(){
   public void controlEvent(ControlEvent event){
     //current_instrument = event;
    String name = (String)instruments_used.getItem((int)instruments_used.getValue()).get("name");
    current_g = grids.get(name);
    current_g.off_col = Integer.parseInt(off_col.getText());
    current_g.off_row = Integer.parseInt(off_row.getText());
    current_g.bound_col = Integer.parseInt(beat_max_text.getText());
    volume.setValue(current_g.amp);
    //println(name);
   }
 });
 instruments = cp5.addListBox("instruments")
                 .setPosition(instruments_used.getWidth()+100, height - wh)
                 .setSize(120, 120)
                 .setItemHeight(15)
                 .setBarHeight(15)
                 .setColorBackground(c.green_1)
                 .setColorActive(c.green_3)
                 .setColorForeground(c.green_2)
                 ;
 
 instruments.getCaptionLabel().setColor(c.black);
 instruments.getCaptionLabel().toUpperCase(true);
 instruments.getValueLabel().setColor(c.black);
 instruments.addListener(new ControlListener(){
   public void controlEvent(ControlEvent event){
     //current_instrument = event;
   }
 });
 grids = new HashMap<String,Grid>();
 time_beat = cp5.addSlider("Beat")
               .setPosition(150 + add_btn.getWidth() + remove_btn.getWidth(),height-wh+120)
               .setSize(200,20)
               .setRange(0,max_)
               .setNumberOfTickMarks(max_ + 1);
 beat_max_text = cp5.addTextfield("max_beat")
                   .setPosition(200 + add_btn.getWidth() + remove_btn.getWidth() + time_beat.getWidth(),height - wh + 120)
                   .setSize(20,20)
                   .setColor(c.white_1)
                   .setText(Integer.toString(max_));
                   
 beat_max_text.setInputFilter(cp5.INTEGER)
 .setAutoClear(false)
 .addListener(new ControlListener(){
    public void controlEvent(ControlEvent event){
      max_ = Integer.parseInt(event.getStringValue());
      if( max_ <= 0 ) max_ = 2;
      time_beat.setRange(0,max_).setNumberOfTickMarks(max_ + 1);
      if(current_g != null) current_g.bound_col = Integer.parseInt(beat_max_text.getText());
    }
 }).getCaptionLabel().setColor(c.black);
 
 beat_delay_text = cp5.addTextfield("beat_delay/60")
                   .setPosition(250 + beat_max_text.getWidth() + add_btn.getWidth() + remove_btn.getWidth() + time_beat.getWidth(),height - wh + 120)
                   .setSize(20,20)
                   .setColor(c.white_1)
                   .setText(Integer.toString(beats_per_second));
                   
 beat_delay_text.setInputFilter(cp5.INTEGER)
 .setAutoClear(false)
 .addListener(new ControlListener(){
    public void controlEvent(ControlEvent event){
      beats_per_second = Integer.parseInt(event.getStringValue());
      if( beats_per_second <= 0 ) beats_per_second = 2;
    }
 }).getCaptionLabel().setColor(c.black);
 
 play_pause = cp5.addButton("Play")
               .setValue(0)
               .setSize(120,30)
               .setColorBackground(c.blue_3)
               ;
 play_pause.setPosition((width-play_pause.getWidth())/2,height-wh+160)
 .addListener(new ControlListener(){
   public void controlEvent(ControlEvent event){
     Label l = play_pause.getCaptionLabel();
     if(l.getText().equals("Play")){
       l.setText("Pause");
       play_pause.setColorBackground(c.black);
       play = true;
     }else{
       l.setText("Play");
       play_pause.setColorBackground(c.blue_1);
       play = false;
     }
   }
 });  
 
 off_col = cp5.addTextfield("off_col")
                   .setPosition(200 + add_btn.getWidth() + remove_btn.getWidth() + time_beat.getWidth(),height - wh + 160)
                   .setSize(20,20)
                   .setColor(c.white_1)
                   .setText("4");
                   
 off_col.setInputFilter(cp5.INTEGER)
 .setAutoClear(false)
 .addListener(new ControlListener(){
    public void controlEvent(ControlEvent event){
      if(current_g != null){
        current_g.off_col = Integer.parseInt(off_col.getText());
      }
    }
 }).getCaptionLabel().setColor(c.black);
 
 off_row = cp5.addTextfield("off_row")
                   .setPosition(250 + add_btn.getWidth() + remove_btn.getWidth() + time_beat.getWidth() + off_col.getWidth(),height - wh + 160)
                   .setSize(20,20)
                   .setColor(c.white_1)
                   .setText("7");
                   
 off_row.setInputFilter(cp5.INTEGER)
 .setAutoClear(false)
 .addListener(new ControlListener(){
    public void controlEvent(ControlEvent event){
      if(current_g != null){
        current_g.off_row = Integer.parseInt(off_row.getText());
      }
    }
 }).getCaptionLabel().setColor(c.black);
 description = cp5.addLabel("desc")
                 .setSize(100,100)
                 .setPosition(width - 160,height - wh + 120)
                 .setColorBackground(c.black)
                 .setColorForeground(c.black)
                 .setColor(c.black)
                 .setText("Hello world");
 max_octave_select = cp5.addListBox("octave")
                     .setPosition(320 + add_btn.getWidth() + remove_btn.getWidth() + time_beat.getWidth() + off_col.getWidth(),height-wh+120)
                     .setSize(50,80);
 max_octave_select.addItem("6",6).addItem("7",7).addItem("8",8).addItem("9",9).addItem("10",10)
 .addListener(new ControlListener(){
   public void controlEvent(ControlEvent event){
     max_octave = (Integer)max_octave_select.getItem((int)event.getValue()).get("value");
   }
 });                    
 volume = cp5.addSlider("volume")
           .setPosition(15,height - wh)
           .setSize(20,120)
           .setRange(0,1)
           .setValue(0.5);
 volume.getCaptionLabel().setColor(c.black);
 volume.getValueLabel().setColor(c.black);
 volume.addListener(new ControlListener(){
   public void controlEvent(ControlEvent event){
     if(current_g != null) current_g.amp = event.getValue();
   }
 });
 
 save_file_text = cp5.addTextfield("save_file")
                   .setPosition(width - 100,height - wh)
                   .setSize(80,20)
                   .setColor(c.white_1)
                   .setText("test.json");
                   
 save_file_text.setAutoClear(false)
 .addListener(new ControlListener(){
    public void controlEvent(ControlEvent event){
      if(!save_file_text.getText().contains(".json")) return;
      save_file("data/"+save_file_text.getText());
      count_down = 1;
    }
 }).getCaptionLabel().setColor(c.black);
 
 load_file = cp5.addListBox("load")
               .setPosition(width-150 - 80, height - wh)
               .setSize(80,80);
 File[] files = new File(dataPath("")).listFiles();
 int file_num = 0;
 if(files != null){
   for(int i=0 ; i<files.length ; i++){
     if(files[i].getName().contains(".json")){
       load_file.addItem(files[i].getName(),file_num++);
     }
   }
 }
 instruments.addItems(instruments_name);
 
 
 // Sound
 // frequencies
 notes = new HashMap<String,Float>();
 notes.put("C0",16.35);
 notes.put("D0",18.35);
 notes.put("E0",20.60);
 notes.put("F0",21.83);
 notes.put("G0",24.50);
 notes.put("A0",27.50);
 notes.put("B0",30.87);
 notes.put("piano_base",233.08);
 notes.put("guitar_base",220.0);
 notes.put("banjo_base",220.0);
 notes.put("bassclarinet_base",220.0);
 notes.put("bassoon_base",220.0);
 notes.put("cello_base",220.0);
 notes.put("doublebass_base",220.0);
 notes.put("flute_base",440.0);
 notes.put("frenchhorn_base",220.0);
 notes.put("mandolin_base",220.0);
 notes.put("oboe_base",440.0);
 notes.put("saxophone_base",220.0);
 notes.put("trumpet_base",220.0);
 notes.put("viola_base",220.0);
 notes.put("violin_base",220.0);
 }

void draw(){
  background(220);
  tick = tick>10000? 0 :tick + 1;
  if(tick % 200 == 0 && !play){
    for(SoundFile i : s_file){
      i.stop();
    }
  }
  if(play){
    float p1 = prev_time==0 ? time_beat.getValue() + 1 : time_beat.getValue();
    time_beat.setValue(p1 > time_beat.getMax() ? 0 : p1);
    prev_time = (prev_time + 1)%(beats_per_second);
  }
  
  if(play && play_time != (int)time_beat.getValue()){
    int p1 = 0;
    for(SoundFile i : s_file){
      i.stop();
    }
    for(String i : grids.keySet()){
      Grid g1 = grids.get(i);
      int t1 = (int)time_beat.getValue();
      Cell c1 = null;
      for(int j=0 ; j<g1.cells.size() ; j++){
        c1 = g1.cells.get(j);
        if(c1.row+1 == t1){
          p1 = j;
          break;
        }
      }
      while(c1 != null  && c1.row+1 == t1){
        if(c1.lighten){
          // Do something by using c1.col
          float note_base = 1;
          for(int kk = 0 ; kk<instruments_name.length ; kk++){
            if(i.contains(instruments_name[kk])){
              s1 = s_file.get(kk);
              s1.amp(g1.amp);
              s1.play();
              note_base = notes.get(instruments_name[kk].toLowerCase()+"_base");
            }
          }
          if(c1.col % 7 == 0){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("B0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 1){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("A0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 2){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("G0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 3){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("F0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 4){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("E0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 5){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("D0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }else if(c1.col % 7 == 6){
            int q1 = (c1.col+7)/7;
            
            if(s1 != null){
              s1.rate(notes.get("C0")*pow(2,max_octave-q1)/note_base);
              //s1.play();
            }
          }
        }
        //println(c1.row,c1.col);
        try{
          c1 = g1.cells.get(++p1);
        }catch(Exception e){
          c1 = null;
        }
      }
    }
    play_time = (int)time_beat.getValue();
  }
  
  description.setText("Max-Beat = "+max_+"\nBeat-Delay = "+beat_delay_text.getText()+"\nOff-Col = "+off_col.getText()+"\nOff-Row = "+off_row.getText()+"\nMax-Octave = "+max_octave);
  
  if(count_down > 0){
    push();
    fill(c.green_3);
    rect(width/2-175,100,250,100);
    fill(c.black);
    text("saving done",width/2-70,150);
    pop();
    count_down++;
    if(count_down == 40) count_down = 0;
  }
  
  if(current_g == null) return;
  current_g.draw();
  if(mousePressed && current_g.collision(mouseX,mouseY)){
    current_g.del_offset(mouseX-pmouseX,0);
    int off = 0;
    off = mouseX+mouseY - pmouseX-pmouseY;
    if(off != 0) slide = true;
  }
}

void mouseReleased(){
  if(current_g != null && current_g.collision(mouseX,mouseY)){
    if(!slide){
      current_g.set_cell((-current_g.off_x+mouseX)/current_g.wx,(-current_g.off_y+mouseY)/current_g.wy);
      make_sound((-current_g.off_x+mouseX)/current_g.wx,(-current_g.off_y+mouseY)/current_g.wy);
      tick = 0;
    }else slide = false;
  }
}

void make_sound(int row, int col){
  Cell c1 = null;
  for(int i=0 ; i<current_g.cells.size() ; i++){
    if(current_g.cells.get(i) != null && current_g.cells.get(i).row == row && current_g.cells.get(i).col == col){
      c1 = current_g.cells.get(i);
      break;
    }
  }
  if(c1 == null) return;
  if(c1.lighten){
    float note_base = 1;
    for(int kk = 0 ; kk<instruments_name.length ; kk++){
      String s3 = (String)instruments_used.getItem((int)instruments_used.getValue()).get("name");
      if(s3.contains(instruments_name[kk])){
        s1 = s_file.get(kk);
        s1.amp(current_g.amp);
        s1.play();
        note_base = notes.get(instruments_name[kk].toLowerCase()+"_base");
      }
    }
    if(c1.col % 7 == 0){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("B0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 1){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("A0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 2){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("G0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 3){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("F0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 4){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("E0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 5){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("D0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    }else if(c1.col % 7 == 6){
      int q1 = (c1.col+7)/7;
      
      if(s1 != null){
        s1.rate(notes.get("C0")*pow(2,max_octave-q1)/note_base);
        //s1.play();
      }
    } 
  }
}

public void Add(){
  try{
    String name = (String)instruments.getItem((int)instruments.getValue()).get("name")+" "+Integer.toString(n);
    instruments_used.addItem(name,n++);
    Grid g = new Grid();
    g.set_bound(width,height-wh-15);
    g.set_size(g.wx,g.h/34);
    grids.put(name,g);
  }catch(Exception e){}
}

public void Remove(){
  try{
    String name = (String)instruments_used.getItem((int)instruments_used.getValue()).get("name");
    instruments_used.removeItem(name);
    grids.remove(name);
    current_g = null;
  }catch(Exception e){}
}

//void keyPressed(){
//  if(key == 's' || key == 'S'){
//    save_file("data/text.json");
//  }
//}

public void save_file(String name){
  values = new JSONObject();
  values.setInt("max_octave",max_octave);
  values.setInt("max_",max_);
  values.setInt("n",n);
  values.setString("off_col",off_col.getText());
  values.setString("off_row",off_row.getText());
  values.setInt("beats_per_second",beats_per_second);
  
  JSONObject grids_object = new JSONObject();
  for(String k : grids.keySet()){
    JSONArray cells_array = new JSONArray();
    Grid g1 = grids.get(k);
    for(int j=0 ; j<g1.cells.size() ; j++){
      JSONObject cell_obj = new JSONObject();
      cell_obj.setInt("row",g1.cells.get(j).row);
      cell_obj.setInt("col",g1.cells.get(j).col);
      cell_obj.setBoolean("lighten",g1.cells.get(j).lighten);
      cell_obj.setFloat("amp",g1.amp);
      cells_array.setJSONObject(j,cell_obj);
    }
    grids_object.setJSONArray(k,cells_array);
  }
  values.setJSONObject("grids",grids_object);
  saveJSONObject(values,name);
  load_file.clear();
  File[] files = new File(dataPath("")).listFiles();
   int file_num = 0;
   if(files != null){
     for(int i=0 ; i<files.length ; i++){
       if(files[i].getName().contains(".json")){
         load_file.addItem(files[i].getName(),file_num++);
       }
     }
   }
}

void load(ControlEvent event){
  try{
    instruments_used.clear();
    current_g = null;
    grids.clear();
    String name = (String)load_file.getItem((int)event.getValue()).get("name");
    JSONObject obj = loadJSONObject("data/"+name);
    //println(obj);
    off_row.setText(obj.getString("off_row"));
    off_col.setText(obj.getString("off_col"));
    if(current_g != null){
      current_g.off_col = Integer.parseInt(off_col.getText());
      current_g.off_row = Integer.parseInt(off_row.getText());
    }
    n = obj.getInt("n");
    max_ = obj.getInt("max_");
    beat_max_text.setText(Integer.toString(max_));
    if( max_ <= 0 ) max_ = 2;
    time_beat.setRange(0,max_).setNumberOfTickMarks(max_ + 1);
    if(current_g != null) current_g.bound_col = Integer.parseInt(beat_max_text.getText());
    max_octave = obj.getInt("max_octave");
    beats_per_second = obj.getInt("beats_per_second");
    beat_delay_text.setText(Integer.toString(beats_per_second));
    
    JSONObject grids_object = obj.getJSONObject("grids"); 
    for(Object i : grids_object.keys()){
      String s1 = (String)i;
      JSONArray cells = grids_object.getJSONArray(s1);
      Grid g1 = new Grid();
      for(int j=0 ; j<cells.size() ; j++){
        JSONObject cell = cells.getJSONObject(j);
        int row = cell.getInt("row");
        int col = cell.getInt("col");
        boolean lighten = cell.getBoolean("lighten");
        float amp = cell.getFloat("amp");
        g1.set_cell(row,col);
        if(!lighten) 
          g1.set_cell(row,col);
        g1.amp = amp;
        g1.set_bound(width,height-wh-15);
        g1.set_size(g1.wx,g1.h/34);
      }
      instruments_used.addItem(s1,n);
      grids.put(s1,g1);
    }
  }catch(Exception e){}
}
