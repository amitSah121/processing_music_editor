class Color{
  color red_1 = color(255,0,0);
  color red_2 = lerpColor(color(255,0,0),color(0),0.15);
  color red_3 = lerpColor(color(255,0,0),color(0),0.25);
  color red_4 = lerpColor(color(255,0,0),color(0),0.35);
  color red_5 = lerpColor(color(255,0,0),color(0),0.45);
  color blue_1 = color(0,0,255);
  color blue_2 = lerpColor(color(0,0,255),color(0),0.15);
  color blue_3 = lerpColor(color(0,0,255),color(0),0.25);
  color blue_4 = lerpColor(color(0,0,255),color(0),0.35);
  color blue_5 = lerpColor(color(0,0,255),color(0),0.45);
  color green_1 = color(0,255,0);
  color green_2 = lerpColor(color(0,255,0),color(0),0.15);
  color green_3 = lerpColor(color(0,255,0),color(0),0.25);
  color green_4 = lerpColor(color(0,255,0),color(0),0.35);
  color green_5 = lerpColor(color(0,255,0),color(0),0.45);
  color yellow_1 = color(255,255,0);
  color yellow_2 = lerpColor(color(255,255,0),color(0),0.15);
  color yellow_3 = lerpColor(color(255,255,0),color(0),0.25);
  color yellow_4 = lerpColor(color(255,255,0),color(0),0.35);
  color yellow_5 = lerpColor(color(255,255,0),color(0),0.45);
  color white_1 = color(255);
  color white_2 = lerpColor(color(255),color(0),0.15);
  color white_3 = lerpColor(color(255),color(0),0.25);
  color white_4 = lerpColor(color(255),color(0),0.35);
  color white_5 = lerpColor(color(255),color(0),0.45);
  color black = color(0);
}

class Cell{
  int row=0,col=0;
  boolean lighten = false;
  
  Cell(int r,int c){
    this.row = r;
    this.col = c;
  }
  
  void set_light(boolean b){
    this.lighten = b;
  }
  
  void set_pos(int row,int col){
    this.row = row;
    this.col = col;
  }
}

class Grid{
  ArrayList<Cell> cells;
  color b = color(s_col[3]);
  int wx=30,wy=30;
  int off_x=0, off_y=0;
  int w=width,h=height;
  int off_col = 7, off_row = 0, bound_row = 35, bound_col = 100;
  float amp = 1;
  
  Grid(){
    this.cells = new ArrayList<Cell>();
  }
  
  Grid set_cell(int r,int c){
    Cell temp = null;
    for(int i=0 ; i<this.cells.size() ; i++){
      Cell temp1 = this.cells.get(i);
      if(temp1.row == r && temp1.col == c){
        temp = temp1;
        break;
      }
    }
    if(temp != null){
      temp.set_light(!temp.lighten);
      return this;
    }
    Cell p =new Cell(r,c);
    p.set_light(true);
    this.cells.add(p);
    this.cells.sort((a,b)->((a.row*1000+a.col) - (b.row*1000+b.col)));
    return this;
  }
  
  Grid set_size(int a,int b){
    this.wx = a;
    this.wy = b;
    return this;
  }
  
  Grid set_bound(int w,int h){
   this.w = w;
   this.h = h;
   return this;
  }
  
  Grid set_offset(int a, int b){
    this.off_x = a;
    this.off_y = b;
    return this;
  }
  
  Grid del_offset(int a, int b){
    this.off_x += a;
    this.off_y += b;
    if(this.off_x > 0) this.off_x = 0;
    if(this.off_y > 0) this.off_y = 0;
    return this;
  }
  
  
  void draw(){
    push();
    translate(this.off_x,this.off_y);
    noStroke();
    for(int i=0 ; i < this.cells.size() ; i++){
      Cell p = this.cells.get(i);
      if(!p.lighten) noFill();
      else fill(this.b);
      rect(p.row*this.wx,p.col*this.wy,this.wx,this.wy);
    }
    pop();
    push();
    stroke(color(s_col[0]));
    for(int i=0 ; i<=(this.w-this.off_x)/this.wx ; i++){strokeWeight(1);
        stroke(s_col[0]);
      if(i == 0 || i == bound_col ){
        stroke(color(s_col[0],0,0));
        strokeWeight(5);
      }else if(this.off_col > 0 && i%off_col == 0){
        stroke(color(0,s_col[0],0));
        strokeWeight(2);
      }
      line(this.off_x+i*this.wx,this.off_y,this.off_x+i*this.wx,this.h);
    }
    for(int i=0 ; i<=(this.h-this.off_y)/this.wy ; i++){
        strokeWeight(1);
        stroke(s_col[0]);
        if(i == 0 || i == bound_row - 1){
          stroke(color(s_col[0],0,0));
          strokeWeight(5);
        }else if(off_row > 0 && i%off_row == 0 && i != 0){
          stroke(color(s_col[6],0,0));
          strokeWeight(2);
        }
      line(this.off_x,this.off_y+i*this.wy,this.w,this.off_y+i*this.wy);
    }
    pop();
  }
  
  boolean collision(int x,int y){
    return (x > 0 && x < 0+this.w && y > 0 && y < 0+this.h);
  }
  
}


//class Button{
//  int x=0,y=0,w=16,h=32;
//  int rad = 8;
//  int padx=8,pady=16, wrap_sizex = 50, wrap_sizey = 50;
//  String t = "";
//  color s=color(255,0),f=color(s_col[0]),b=color(s_col[6]);
//  boolean wrap = false;
//  boolean color_darken = false;
//  float darken_amt = 0.05;
  
//  Button set_text(String t){
//    this.t = t;
//    this.adjust_wh();
//    return this;
//  }
  
//  Button set_pos(int x,int y){
//    this.x = x;
//    this.y = y;
//    return this;
//  }
  
//  Button set_padding(int padx,int pady){
//    this.padx = padx;
//    this.pady = pady;
//    adjust_wh();
//    return this;
//  }
  
//  void adjust_wh(){
//    if(!wrap){
//      this.w = (int)textWidth(this.t)+2*this.padx;
//      this.h = (int)(textAscent()*text_scalar + 2*this.pady);
//    }else{
//      this.w = this.wrap_sizex + 2*this.padx;
//      this.h = this.wrap_sizey + 2*this.pady;
//    }
//  }
  
//  Button set_color_darken(boolean b,float darken_amt){
//    this.color_darken = b;
//    this.darken_amt = darken_amt;
//    return this;
//  }
  
//  Button set_wrap(boolean b){
//    this.wrap = b;
//    this.adjust_wh();
//    return this;
//  }
  
//  Button set_wrap_size(int sizex,int sizey){
//    this.wrap_sizex = sizex;
//    this.wrap_sizey = sizey;
//    this.adjust_wh();
//    return this;
//  }
  
//  void draw(){
//    push();
//    translate(this.x,this.y);
//    stroke(this.s);
//    fill(!color_darken?this.b:lerpColor(this.b,color(s_col[0]),this.darken_amt));
//    rect(0,0,this.w,this.h,this.rad);
//    translate(this.padx,this.pady+(!wrap?textAscent()*text_scalar:0));
//    fill(this.f);
//    if(!wrap){
//      text(this.t,0,0);
//    }else{
//      text(this.t,0,0,this.wrap_sizex,this.wrap_sizey);
//    }
//    pop();
//  }
  
//  boolean collision(int x,int y){
//    return (x > this.x && x < this.x+this.w && y > this.y && y < this.y+this.h);
//  }
  
//}
