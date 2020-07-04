import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class a_simple_game extends PApplet {

int Length = 1280;
int Width = 720;
int Max_Human = 54;
int init_population = Max_Human;
String season_name = "Spring";
int season = 0; // 0 for spring, 1 for summer, 2 for autumn, 3 for winter
int day = 0;
int dayCount = 0;
int year = 0;
int days_of_year = 365;
int food_prob = 20; // initial probablity for food generationg
int daily_exp = 8; 
int population = Max_Human;
int teamA = 0;
int teamB = 0;
int squadCount = 0;
int imgCount = 1;
int battleCount = 0;
int selectX;
int selectY;
int selectX2;
int selectY2;
PVector GoTarget;
boolean selectOn = false;
boolean pause = true;
boolean gameBegin = false;
boolean selectTarget = false;
int commandStep = 0;
int SBS = 14;
int box1[] = new int[9];
int box2[] = new int[9];
boolean newAgent = false;
int[] rule = {0, 0, 0, 0, 0, 1, 1, 2};

boolean win = false;
boolean lose = false;


int[][] MAP = new int[Length][Width]; 
int[][] duelMAP = new int[Length][Width];

Human_class[] Human = new Human_class[Max_Human];
base_class[] base = new base_class[2];

public void setup(){
  size(Length, Width);
  background(0);
  frameRate(30);
  
  PFont font = createFont("arial",20);
  textFont(font);
  
  for(int i=0; i< Length; i++){
    for(int j=0; j< Width; j++){
      MAP[i][j] = 0;
    }
  }
  
  for(int m = 0; m < 2; m++){
    int p1x;
    int p1y;
    int p2x;
    int p2y;
    int t;
    if(m == 0){
      p1x = width/2-3*SBS;
      p1y = 2*SBS;
      p2x = width/2+3*SBS;
      p2y = 8*SBS;
      t = 0;
    }
    else{
      p1x = width/2-3*SBS;
      p1y = height-8*SBS;
      p2x = width/2+3*SBS;
      p2y = height-2*SBS;
      t = 1;
    }
    PVector p1 = new PVector((float)p1x, (float)p1y);
    PVector p2 = new PVector((float)p2x, (float)p2y);
    base[m] = new base_class(p1, p2, t);
    for(int mm = p1x; mm < p2x; mm++){
      for(int nn = p1y; nn < p2y; nn++){
        MAP[mm][nn] = 3;
      }
    }
  }
  
  for(int i=0; i < Max_Human; i++){
     int k1 = 1; //\u751f\u304d\u3066\u3044\u308b\u4eba\u9593\u306e\u72b6\u614b\u30921\u3001\u6b7b\u3093\u3067\u3044\u308b\u5834\u5408\u306f 0
     int k2 = 0; //\u767b\u5834\u3059\u308b\u521d\u671f x\u5ea7\u6a19
     int k3 = 0; //\u767b\u5834\u3059\u308b\u521d\u671f y\u5ea7\u6a19
     int no = i/9;
     switch(no){
       case 0:
       k2 = width/10-2*SBS+(i%9)%3*2*SBS;
       k3 = height/10+(i%9)/3*2*SBS;
       break;
       case 1:
       k2 = width/2-2*SBS+(i%9)%3*2*SBS;
       k3 = height/5+(i%9)/3*2*SBS;
       break;
       case 2:
       k2 = 9*width/10-2*SBS+(i%9)%3*2*SBS;
       k3 = height/10+(i%9)/3*2*SBS;
       break;
       case 3:
       k2 = width/10-2*SBS+(i%9)%3*2*SBS;
       k3 = 9*height/10-5*SBS+(i%9)/3*2*SBS;
       break;
       case 4:
       k2 = width/2-2*SBS+(i%9)%3*2*SBS;
       k3 = 4*height/5-5*SBS+(i%9)/3*2*SBS;
       break;
       case 5:
       k2 = 9*width/10-2*SBS+(i%9)%3*2*SBS;
       k3 = 9*height/10-5*SBS+(i%9)/3*2*SBS;
       break;
     }
     PVector pos = new PVector((float)k2, (float)k3);
     PVector v = new PVector(0, 0);
     int k5 = PApplet.parseInt(random(5)); //\u4eba\u9593\u306e\u4f53\u5185\u6642\u8a08\u30920\uff5e4\u306e\u9593\u3067\u30bb\u30c3\u30c8
     int k7 = PApplet.parseInt(i >= 27);
     int c = (i/9)%3;
     MAP[PApplet.parseInt(k2)][PApplet.parseInt(k3)] = 2;
     Human[i] = new Human_class(i,k1,pos,v,k5,k7,c);
     if(i%9 == 0){squadCount++;}
     Human[i].squad = squadCount;
  }
  obstacle();
  
}

public void draw(){
    makeground();
    base[1].base1();
    base[0].base2();
    obstacle();
    base[1].generate();
    base[0].generate();
    base[0].hpBar();
    base[1].hpBar();
    if(frameCount%300==299){base[0].lv++;base[1].lv++;}
    selectionRect();
    attackCommand();
    
    for(int j=0; j < Max_Human; j++){
      if(Human[j].type == 1){
        Human[j].draw();
      if(!pause){
//      if(Human[j].selected && commandStep == 3 && Human[j].type == 1){
        Human[j].duel();
        if(!Human[j].isAttacking){Human[j].attackBase(MAP);}
        Human[j].protectOrAttack();
        Human[j].drive();
        Human[j].exp+=daily_exp;
        if (Human[j].exp>=Human[j].lvup_exp){
          Human[j].lv += 1;
          if(Human[j].lv>=5){Human[j].vel_max = 4*PApplet.parseInt(Human[j].career==0)+5*PApplet.parseInt(Human[j].career==1)+3*PApplet.parseInt(Human[j].career==2);}
          Human[j].atk = Human[j].atk + Human[j].lv*(10+5*Human[j].career);
          Human[j].def = Human[j].def + Human[j].lv*(10-Human[j].career);
          Human[j].def_c =Human[j].def_c+min(Human[j].lv, 10);
          Human[j].lvup_exp = Human[j].lvup_exp + Human[j].lv*30;
          Human[j].max_hp =Human[j].max_hp+Human[j].lv*(75*PApplet.parseInt(Human[j].career==0)+25*PApplet.parseInt(Human[j].career==1)+50*PApplet.parseInt(Human[j].career==2));
          Human[j].hp = min(Human[j].hp+200, Human[j].max_hp);
          Human[j].exp = 0;
        }
//        println("dist=of "+j+"is "+Human[j].distToObs);
//        println(selectX + " " + selectY + " " + selectX2 + " " + selectY2);
//        println("command step is "+commandStep);
      }
    }
    }
//    println("type of end is"+Human[Max_Human-1].type);
//    println("hp is "+Human[53].hp);
   winOrLose();
   gameStart();
}

public void makeground(){
  fill(56, 159, 91); //\u3061\u3087\u3063\u3068\u8584\u3081\u306e\u30b0\u30ea\u30fc\u30f3
  rect(0,0,width,height);  
}

public void fillColor_tm(int tm){
  switch(tm){
    case 0:
    fill(128, 0, 128);
    break;
    case 1:
    fill(0, 0, 255);
  }
}

public void fillColor_c(int hp){
    fill(0,255,0); //\u5065\u5eb7\u306a\u72b6\u614b
    if(hp < 300){
      fill(255,255,0); //\u4f53\u529b\u304c\u843d\u3061\u59cb\u3081\u305f\u72b6\u614b
    }
    if(hp < 10){
       fill(255,0,0); //\u5371\u967a\u306a\u72b6\u614b
    }
}

public void obstacle(){
  noStroke();
  fill(160,64,0);
  rect(width/5, height/4, width/5, height/2);
  rect(3*width/5, height/4 , width/5, height/2);
  for(int i = width/5; i <= 2*width/5; i++){
    for(int j = height/4; j <= 3*height/4; j++){
      MAP[i][j] = 1;
    }
  }
  for(int i = 3*width/5; i <= 4*width/5; i++){
    for(int j = height/4; j <= 3*height/4; j++){
      MAP[i][j] = 1;
    }
  }
//  println("obs:"+MAP[width/2][100]);
}

public void winOrLose(){
  if((base[1].hp>0 && base[0].hp<=0)||win){
    win = true;
    fill(52, 152, 219);
    rect(0,0,width,height); 
    textSize(50);
    fill(255);
    text("You Win!", width/2-100, height/2-25);
  }
  else if((base[0].hp>0 && base[1].hp<=0)||lose){
    lose = true;
    fill(192, 57, 43);
    rect(0,0,width,height);
    textSize(50);
    fill(255);
    text("You Lose", width/2-100, height/2-25);
  }
}

public void keyPressed(){
  pause = false;
  gameBegin = true;
}

public void gameStart(){
  if(!gameBegin){
    fill(130, 224, 170 );
    rect(0,0,width,height);
    textSize(30);
    fill(255);
    text("Press any key to start", width/2-150, height/2-25);
  }
}

class base_class
{
  PVector position1;
  PVector position2;
  int hp;
  int def;
  int lv;
  int max_hp;
  int team;
  boolean occupied;
  
  base_class(PVector p1, PVector p2, int t){
    position1 = p1;
    position2 = p2;
    max_hp = 5000;
    hp = max_hp;
    def = 400;
    lv = 1;
    team = t;
    occupied = true;
  }
  
  
  public void base1(){
  occupied = false;
  for(int m = width/2-3*SBS; m < width/2+3*SBS; m++){
    for(int n = height-8*SBS; n < height-2*SBS; n++){
      if(MAP[m][n] == 2){
        occupied = true;
        break;
      }
    }
  }
  if(frameCount%60 == 1 && !occupied){
    hp += 200;
    hp = min(hp, max_hp);
    for(int i = 0; i < 9; i++){
      box1[i] = PApplet.parseInt(random(100)>50);
    }
  }
    for(int j = 0; j < 9; j++){
      stroke(0);
      fill(255-255*box1[j]);
      rect(width/2-3*SBS+(j%3)*(2*SBS), height-8*SBS+(j/3)*(2*SBS), SBS*2, SBS*2);
    }
  }
  
public void base2(){
  occupied = false;
  for(int m = width/2-3*SBS; m < width/2+3*SBS; m++){
    for(int n = 2*SBS; n < 8*SBS; n++){
      if(MAP[m][n] == 2){
        occupied = true;
        break;
      }
    }
  }
  if(frameCount%60 == 1 && !occupied){
    hp += 200;
    hp = min(hp, max_hp);
    for(int i = 0; i < 9; i++){
      box2[i] = PApplet.parseInt(random(100)>50);
    }
  }
    for(int j = 0; j < 9; j++){
      stroke(0);
      fill(255-255*box2[j]);
      rect(width/2-3*SBS+(j%3)*(2*SBS), 6*SBS-(j/3)*(2*SBS), SBS*2, SBS*2);
    }
  }
  
public void generate(){
  if(team == 1){
    if(newAgent){
      int sum = 0;
      for(int i = 0; i < 6; i++){
        sum = sum + box1[i];
      }
      int newA = 6 - sum;
      int c = rules(box1[6], box1[7], box1[8]);
      if (newA > 0 && !occupied){
        hp = hp - newA*(300-20*newA+c*80);
        for(int j = 0; j < 6; j++){
          if(box1[j] == 0){
            int k1 = 1;
            float k2 = PApplet.parseFloat(width/2-2*SBS+(j%3)*(2*SBS));
            float k3 = PApplet.parseFloat(height-7*SBS+(j/3)*(2*SBS));
            PVector pos = new PVector(k2, k3);
            PVector v = new PVector(0, 0);
            int k5 = PApplet.parseInt(random(5)); //\u4eba\u9593\u306e\u4f53\u5185\u6642\u8a08\u30920\uff5e4\u306e\u9593\u3067\u30bb\u30c3\u30c8
            int k7 = 1;
            MAP[PApplet.parseInt(k2)][PApplet.parseInt(k3)] = 2;
            Human_class[] temp_human = new Human_class[Max_Human+1];
            for (int i = 0; i < Max_Human; i++){
              temp_human[i] = Human[i];
            }
            temp_human[Max_Human] = new Human_class(Max_Human,k1,pos,v,k5,k7,c);
            Human = new Human_class[Max_Human+1];
            for (int jj = 0; jj < Max_Human + 1; jj++){
              Human[jj] = temp_human[jj];
            }
            Human[Max_Human].selected=true;
            Human[Max_Human].squad = squadCount;
            Human[Max_Human].lv = sum+lv;
            if(Human[Max_Human].lv>=5){Human[Max_Human].vel_max+=1;}
            Human[Max_Human].atk = Human[Max_Human].atk + Human[Max_Human].lv*(10+5*c);
            Human[Max_Human].def = Human[Max_Human].def + Human[Max_Human].lv*(10-c);
            Human[Max_Human].def_c =Human[Max_Human].def_c+min(Human[Max_Human].lv, 10);
            Human[Max_Human].lvup_exp = Human[Max_Human].lvup_exp + Human[Max_Human].lv*30;
            Human[Max_Human].max_hp =Human[Max_Human].max_hp+Human[Max_Human].lv*(75*PApplet.parseInt(c==0)+25*PApplet.parseInt(c==1)+50*PApplet.parseInt(c==2));
            Human[Max_Human].hp = Human[Max_Human].max_hp;
            Max_Human++;
          }
        }
      }
    }
    newAgent = false;
  }
  else if (team == 0){
    if (hp > max_hp/2 && frameCount%60 == 59){
      int sum = 0;
      for(int i = 0; i < 6; i++){
        sum = sum + box2[i];
      }
      int newA = 6 - sum;
      int c = rules(box2[6], box2[7], box2[8]);
      if(newA > 0 && !occupied){
        hp = hp - newA*(300-20*newA+c*80);
        for(int j = 0; j < 6; j++){
          if(box2[j] == 0){
            int k1 = 1;
            float k2 = PApplet.parseFloat(width/2-2*SBS+(j%3)*(2*SBS));
            float k3 = PApplet.parseFloat(7*SBS-(j/3)*(2*SBS));
            PVector pos = new PVector(k2, k3);
            PVector v = new PVector(0, 0);
            int k5 = PApplet.parseInt(random(5)); //\u4eba\u9593\u306e\u4f53\u5185\u6642\u8a08\u30920\uff5e4\u306e\u9593\u3067\u30bb\u30c3\u30c8
            int k7 = 0;
            MAP[PApplet.parseInt(k2)][PApplet.parseInt(k3)] = 2;
            Human_class[] temp_human = new Human_class[Max_Human+1];
            for (int i = 0; i < Max_Human; i++){
              temp_human[i] = Human[i];
            }
            temp_human[Max_Human] = new Human_class(Max_Human,k1,pos,v,k5,k7,c);
            Human = new Human_class[Max_Human+1];
            for (int jj = 0; jj < Max_Human + 1; jj++){
              Human[jj] = temp_human[jj];
            }
            Human[Max_Human].lv = sum+lv;
            if(Human[Max_Human].lv>=5){Human[Max_Human].vel_max+=1;}
            Human[Max_Human].atk = Human[Max_Human].atk + Human[Max_Human].lv*(10+5*c);
            Human[Max_Human].def = Human[Max_Human].def + Human[Max_Human].lv*(10-c);
            Human[Max_Human].def_c =Human[Max_Human].def_c+min(Human[Max_Human].lv, 10);
            Human[Max_Human].lvup_exp = Human[Max_Human].lvup_exp + Human[Max_Human].lv*30;
            Human[Max_Human].max_hp =Human[Max_Human].max_hp+Human[Max_Human].lv*(75*PApplet.parseInt(c==0)+25*PApplet.parseInt(c==1)+50*PApplet.parseInt(c==2));
            Human[Max_Human].hp = Human[Max_Human].max_hp;
            Max_Human++;
          }
        }
      }
    }
  }
}

public void hpBar(){
  stroke(0);
  noFill();
  rect((int)position1.x, (int)position2.y+10, 6*SBS, 5);
  noStroke();
  if(hp > max_hp/2){
    fill(0, 255, 0);
  }
  else if (hp > max_hp/4){
    fill(255, 255, 0);
  }
  else{
    fill(255, 0, 0);
  }
  rect((int)position1.x, (int)position2.y+10,max(6*SBS*hp/max_hp, 0), 5);
}

public int rules (int a, int b, int c) {
    if (a == 1 && b == 1 && c == 1) return rule[0];
    if (a == 1 && b == 1 && c == 0) return rule[1];
    if (a == 1 && b == 0 && c == 1) return rule[2];
    if (a == 1 && b == 0 && c == 0) return rule[3];
    if (a == 0 && b == 1 && c == 1) return rule[4];
    if (a == 0 && b == 1 && c == 0) return rule[5];
    if (a == 0 && b == 0 && c == 1) return rule[6];
    if (a == 0 && b == 0 && c == 0) return rule[7];
    return 0;
  }

}
class Human_class
{

  int no;
  PVector position;
  int type; //\u4eba\u9593\u306e\u72b6\u614b
  PVector vel; //\u4eba\u9593\u306e\u52d5\u4f5c\u65b9\u5411
  PVector acc;
  PVector target;
  int timer; //\u4f53\u5185\u6642\u8a08
  int hp; //\u4f53\u529b
  float vel_max;
  float maxforce;
  float distToObs;
  int lv;
  int exp;
  int atk;
  int def;
  int def_c;
  int lvup_exp;
  int max_hp;
  int team;
  int squad;
  boolean attackingBase;
  boolean isAttacking;
  boolean selected;
  
  int career;
    
  Human_class(int n,int con, PVector p, PVector v, int t, int tm, int c) {
    no = n;
    position = p;
    type = con;
    vel = v;
    acc = new PVector(0, 0);
    target = null;
    timer = t;
    vel_max = 3*PApplet.parseInt(c==0)+4*PApplet.parseInt(c==1)+2*PApplet.parseInt(c==2);
    maxforce = 0.1f;
    distToObs = 10000.0f;
    lv = 1;
    exp = 0;
    atk = 100+40*c;
    def = 80-20*c;
    def_c = 30*c;
    lvup_exp = 500;
    max_hp = 1500*PApplet.parseInt(c==0)+500*PApplet.parseInt(c==1)+1000*PApplet.parseInt(c==2);
    hp = max_hp;
    team = tm;
    squad = 0;
    attackingBase = false;
    isAttacking = false;
    selected = false;
    
    career = c;
  }



 //\u4eba\u9593\u3092\u63cf\u753b\u3059\u308b\u90e8\u5206
  public void draw () {
 
    smooth();
    noStroke();
    
    //\u4f53\u529b\u306b\u3088\u3063\u3066\u8272\u3092\u5909\u66f4\u3057\u307e\u3057\u3087\u3046
    fill(255, 0, 0);
    textSize(10); 
    text("lv "+lv, position.x-10, position.y-10);
    
    
    fill(0, 255, 0); //\u5065\u5eb7\u306a\u72b6\u614b
    
    if(hp < 300){
      fill(255,255,0); //\u4f53\u529b\u304c\u843d\u3061\u59cb\u3081\u305f\u72b6\u614b
      vel.mult(0.8f);
    }
  
    if(hp < 10){
       fill(255,0,0); //\u5371\u967a\u306a\u72b6\u614b
       vel.mult(0.5f);
    }   
       
    //\u30a2\u30cb\u30e1\u30fc\u30b7\u30e7\u30f3\u306f\u5168\u90e8\u30675\u7a2e\u985e\u6e96\u5099
    //\u4f53\u5185\u6642\u9593\u30925\u3067\u5272\u3063\u3066\u3001\u305d\u306e\u4f59\u308a\u306b\u5fdc\u3058\u3066
    //\u8868\u793a\u3059\u308b\u30a2\u30cb\u30e1\u3092\u6c7a\u5b9a
    
    int time = timer % 5;
    motion(time, career, isAttacking, attackingBase, position, team, hp);
//    if(selected){println("target is "+target+" squad is "+squad);}
    selectBox();
  }

// draw select box  
public void selectBox() {
  if(commandStep == 1){
    if (position.x >= min(selectX, mouseX) && position.x <= max(selectX, mouseX) && position.y >= min(selectY, mouseY) && position.y <= max(selectY, mouseY) && team == 1){
      noFill();
      stroke(255, 0, 0);
      line(position.x+SBS, position.y+SBS, position.x+SBS, position.y+SBS/2);
      line(position.x+SBS, position.y+SBS, position.x+SBS/2, position.y+SBS);
      line(position.x+SBS, position.y-SBS, position.x+SBS, position.y-SBS/2);
      line(position.x+SBS, position.y-SBS, position.x+SBS/2, position.y-SBS);
      line(position.x-SBS, position.y+SBS, position.x-SBS, position.y+SBS/2);
      line(position.x-SBS, position.y+SBS, position.x-SBS/2, position.y+SBS);
      line(position.x-SBS, position.y-SBS, position.x-SBS, position.y-SBS/2);
      line(position.x-SBS, position.y-SBS, position.x-SBS/2, position.y-SBS);
    }
  }
  else if (commandStep == 2){
    if (position.x >= min(selectX, selectX2) && position.x <= max(selectX, selectX2) && position.y >= min(selectY, selectY2) && position.y <= max(selectY, selectY2) && team == 1){
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      line(position.x+SBS, position.y+SBS, position.x+SBS, position.y+SBS/2);
      line(position.x+SBS, position.y+SBS, position.x+SBS/2, position.y+SBS);
      line(position.x+SBS, position.y-SBS, position.x+SBS, position.y-SBS/2);
      line(position.x+SBS, position.y-SBS, position.x+SBS/2, position.y-SBS);
      line(position.x-SBS, position.y+SBS, position.x-SBS, position.y+SBS/2);
      line(position.x-SBS, position.y+SBS, position.x-SBS/2, position.y+SBS);
      line(position.x-SBS, position.y-SBS, position.x-SBS, position.y-SBS/2);
      line(position.x-SBS, position.y-SBS, position.x-SBS/2, position.y-SBS);
      strokeWeight(1);
      selected = true;
      squad = squadCount;
    }
    else {
      selected = false;
    }
  }
  else if (commandStep == 3){
    if (selected){
      target = GoTarget;
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      line(position.x+SBS, position.y+SBS, position.x+SBS, position.y+SBS/2);
      line(position.x+SBS, position.y+SBS, position.x+SBS/2, position.y+SBS);
      line(position.x+SBS, position.y-SBS, position.x+SBS, position.y-SBS/2);
      line(position.x+SBS, position.y-SBS, position.x+SBS/2, position.y-SBS);
      line(position.x-SBS, position.y+SBS, position.x-SBS, position.y+SBS/2);
      line(position.x-SBS, position.y+SBS, position.x-SBS/2, position.y+SBS);
      line(position.x-SBS, position.y-SBS, position.x-SBS, position.y-SBS/2);
      line(position.x-SBS, position.y-SBS, position.x-SBS/2, position.y-SBS);
      strokeWeight(1);
    }
  }
}

// define target point for agents


//\u4eba\u9593\u3092\u52d5\u304b\u3059\u90e8\u5206
  public void drive () {
    MAP[PApplet.parseInt(position.x)][PApplet.parseInt(position.y)] = 0;
    
    PVector sep = seperate();
    PVector ali = align();
    PVector tar = goToTarget(); 
    PVector obs = dodgeObstacle(MAP);
    PVector cha = chase();
    PVector flac = new PVector(random(-0.3f, 0.3f), random(-0.3f, 0.3f));
    if (distToObs >= 10){
      sep.mult(1.5f);
      ali.mult(1.0f);
      tar.mult(1.5f);
      obs.mult(3.2f);
      cha.mult(0.8f);
      flac.mult(0.1f);
//      if(selected){println("sep is "+sep.mag()+" ali is "+ali.mag()+" tar is "+tar.mag());}
//      println("not dodge "+frameCount);
    }
    else{
      sep.mult(0.0f);
      ali.mult(0.5f);
      tar.mult(0.3f);
      obs.mult(10);
      cha.mult(0);
      flac.mult(0.5f);
//      println("dodge"+frameCount);
    }
    
    
    acc.add(sep);
    acc.add(ali);
    acc.add(tar);
    acc.add(obs);
    acc.add(flac);
//    if(selected){println("acc is "+acc.mag());}
    
    if(!isAttacking && !attackingBase){
      position.add(vel);
      int newX = ((int)position.x + width) % width;
      int newY = ((int)position.y + height) % height;
      position = new PVector((float)newX,(float)newY);
    }
    else{
      position = position;
    }
    vel.add(acc);
    vel.limit(vel_max);
    acc.mult(0);
    timer++;
    
    MAP[PApplet.parseInt(position.x)][PApplet.parseInt(position.y)] = 2;
    
  }
  
  // force to keep a certain distance from agents in the same team
  public PVector seperate(){
//    if(selected){println("seperate begin");}
    float desiredseperation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for(int j=0; j < Max_Human; j++){
      if(Human[j].team == team && Human[j].position != position && Human[j].type == 1){
        float d = PVector.dist(position, Human[j].position);
//        println("dist to "+j+"is"+d);
//        println(Max_Human);
//        println("my team is"+team);
//        println("type of 82 is"+Human[82].type);
        if((d >0) && (d < desiredseperation)){
          PVector diff = PVector.sub(position, Human[j].position);
          diff.normalize();
          diff.div(d);
          steer.add(diff);
          count++;
        }
      }
    }
    
    if (count > 0){
//      if(selected){println("seperate begin");}
      steer.div((float)count);
    }
    if (steer.mag() > 0){
      steer.normalize();
//      if(selected){println("steer1 is "+steer.mag());}
      steer.mult(vel_max);
//      if(selected){println("steer2 is "+steer.mag());}
      steer.sub(vel);
//      if(selected){println("steer3 is "+steer.mag());}
      steer.limit(maxforce);
//      if(selected){println("steer4 is "+steer.mag());}
    }
    return steer;
  }
  
  //force to keep average velocity in a squad
  public PVector align(){
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (int j = 0; j < Max_Human; j++){
      if(Human[j].squad == squad && Human[j].type == 1){
        float d = PVector.dist(position, Human[j].position);
        if (d > 0){
          sum.add(Human[j].vel);
          count++;
        }
      }
    }
    if (count > 0){
      sum.div((float)count);
      sum.normalize();
      sum.mult(vel_max);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxforce);
      return steer;
    }
    else{
      return new PVector(0, 0);
    }
  }
  
  // force to target
  public PVector goToTarget(){
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (int j = 0; j < Max_Human; j++){
      if (Human[j].squad == squad && Human[j].type == 1){
        float d = PVector.dist(position, Human[j].position);
        if (d > 0){
          sum.add(Human[j].position);
          count++;
        }
      }
    }
    if (count > 0){
      if (target == null){
        sum.div(count);
        return seek(sum);
      }
      else{
        return seek(target);
      }
    }
    else{
      return new PVector(0, 0);
    }
  }
  
  // seek target
  public PVector seek(PVector target){
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(vel_max);
    
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }
  
  
  // dodge obstacle
  public PVector dodgeObstacle(int[][] map){
    int dodgedist = 80;
    float desiredDist = 25.0f;
    float obsDist = 10000;
    float obsDist_temp = 0;
    PVector dodge = new PVector(0, 0);
    PVector closestObs = new PVector(0, 0);
    int xpos = 0;
    int ypos = 0;
    for(int i = PApplet.parseInt(position.x) - dodgedist; i<PApplet.parseInt(position.x) + dodgedist; i++){
      for(int j = PApplet.parseInt(position.y) - dodgedist; j<PApplet.parseInt(position.y) + dodgedist; j++){
        xpos = (i+width)%width; ypos = (j+height)%height;
        if(map[xpos][ypos] == 1 || map[xpos][ypos] == 3){
          PVector obsPos = new PVector(xpos, ypos);
          obsDist_temp = PVector.dist(position, obsPos);
          if (obsDist_temp > 0 && obsDist_temp < obsDist){
            obsDist = obsDist_temp;
            closestObs = obsPos;
          }
        }
        
      }
    }
    distToObs = obsDist;
    if (obsDist < desiredDist) {
    PVector diff = PVector.sub(position, closestObs);
    diff.normalize();
    diff.div(max(obsDist-8.0f, 0.0001f));        // Weight by distance
    dodge.add(diff);
    }

    // As long as the vector is greater than 0
    if (dodge.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      dodge.normalize();
      dodge.mult(vel_max);
      dodge.sub(vel);
      dodge.limit(maxforce);
    }
//    println("dodge is " + dodge);
    return dodge;
    
    
  }
  
  public PVector chase(){
    float searchDist = 70;
    float primaryDist = 100;
    int chaseTar = 0;
    int count = 0;
    PVector steer = new PVector(0,0);
    for(int i = 0; i < Max_Human; i++){
      float d = PVector.dist(position, Human[i].position);
      if(d>0 && d<searchDist && Human[i].team != team && Human[i].hp >= 0 && Human[i].lv<lv){
        if(d<primaryDist){
          primaryDist = d;
          chaseTar = i;
          count++;
        }
      }
    }
    if(count>0){
      PVector desired = PVector.sub(Human[chaseTar].position, position);
      desired.normalize();
      desired.mult(vel_max);
    
      steer = PVector.sub(desired, vel);
      steer.limit(maxforce);
    }
    return steer;
    
  }
  
  public void protectOrAttack(){
    boolean guard = random(100)>50;
    if(team == 0){
      PVector sum = new PVector(0, 0);
      int count = 0;
      if(atk < base[1-team].def || guard){
        for(int i = 0; i < Max_Human; i++){
          if(Human[i].attackingBase && Human[i].team != team && Human[i].type == 1){
//            sum.add(Human[i].position);
//            count++;
              target = Human[i].position;
              break;
          }
        }
      }
      else{
        sum.add(base[1-team].position1);
        sum.add(base[1-team].position2);
        sum.div(2);
        target=sum;
      }
    if (count > 0){
      sum.div(count);
      target = sum;
    }
    }
  }
  
  public void duel(){
    float duelDist = 0;
    int atkTar = 0;
    if(career==0 || career==1){
      duelDist = 20;
    }
    else if(career==2){
      duelDist = 40;
    }
    for(int i = 0; i < Max_Human; i++){
      float d = PVector.dist(position, Human[i].position);
      if(d>0 && d<duelDist && Human[i].team != team && Human[i].hp >= 0){
        isAttacking = true;
        atkTar = i;
        break;
      }
      else{
        isAttacking = false;
      }
    }
    if(timer%5 == 3 && isAttacking){
      if(career==0 || career==1){
        Human[atkTar].hp = Human[atkTar].hp-max(atk/20, atk-Human[atkTar].def);
      }
      else if(career==2){
        Human[atkTar].hp = Human[atkTar].hp-max(atk/20, atk*Human[atkTar].def_c/100);
//        if(no == 53){println("attacking, oppenent is "+atkTar+" opponent hp is "+Human[atkTar].hp);}
      }
      if(Human[atkTar].hp <= 0){
        exp+=Human[atkTar].lv*100;
        Human[atkTar].type = 0;
        if(exp>=lvup_exp){
          lv += 1;
          if(lv>=5){vel_max = 4*PApplet.parseInt(career==0)+5*PApplet.parseInt(career==1)+3*PApplet.parseInt(career==2);}
          atk = atk + lv*(10+5*career);
          def = def + lv*(10-career);
          def_c =def_c+min(lv, 10);
          lvup_exp = lvup_exp + lv*30;
          max_hp =max_hp+lv*(75*PApplet.parseInt(career==0)+25*PApplet.parseInt(career==1)+50*PApplet.parseInt(career==2));
          hp = min(hp+200, hp);
          exp = 0;
        }
      }
    }
    
    if(isAttacking && career==2){
      cast(Human[atkTar].position, timer);
    }
  }
  
  public void attackBase(int[][] map){
    int standDist = 0;
    int searchDist = 100;
    float baseDist = 10000;
    float baseDist_temp = 0;
    int xpos = 0;
    int ypos = 0;
    int count = 0;
    
    for(int i = PApplet.parseInt(position.x) - searchDist; i < PApplet.parseInt(position.x) + searchDist; i++){
      for(int j = PApplet.parseInt(position.y) - searchDist; j < PApplet.parseInt(position.y) + searchDist; j++){
        xpos = (i+width)%width; ypos = (j+height)%height;
        if(map[xpos][ypos] == 3){
          PVector basePos = new PVector(xpos, ypos);
          baseDist_temp = PVector.dist(position, basePos);
          if (baseDist_temp > 0 && baseDist_temp < baseDist){
            baseDist = baseDist_temp;
            count++;
          }
        }
      }
    }
    if(career==0 || career==1){
      standDist = 30;
    }
    else if(career==2){
      standDist = 60;
    }
    
    if(count>0){
      if(PVector.dist(position, base[1-team].position1)<200 && atk > base[1-team].def){
        if(baseDist<=standDist){
          attackingBase = true;
        }
      }
      else{
        attackingBase = false;
      }
    }
    
    if(timer%5 == 3 && attackingBase){
      base[1-team].hp = base[1-team].hp - max(0, atk-base[1-team].def)/10;
      hp = hp - 80;
    }
  
  if(attackingBase && career==2){
    PVector sum = new PVector(0, 0);
    sum.add(base[1-team].position1);
    sum.add(base[1-team].position2);
    sum.div(2);
    cast(sum, timer);
  }
  }
  
}
public void cast(PVector p, int timer){
  int time = timer%5;
  switch(time){
    case 0:
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 5, 5);
    break;
    case 1:
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 10, 10);
    break;
    case 2:
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 10, 10);
    stroke(255, 0, 0);
    strokeWeight(3);
    noFill();
    ellipse(p.x, p.y, 18, 18);
    strokeWeight(1);
    break;
    case 3:
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 10, 10);
    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);
    ellipse(p.x, p.y, 18, 18);
    strokeWeight(2);
    ellipse(p.x, p.y, 24, 24);
    strokeWeight(1);
    break;
    case 4:
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, 10, 10);
    break;
  }
  
}
public void motion(int time, int c, boolean atk, boolean atkB, PVector p, int t, int hp){
  switch(c){
    case 0:
    if(atk || atkB){
      switch(time){
        case 0:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+4, p.y-4);
        strokeWeight(1);
        break;
        case 1:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+6, p.y-3);
        strokeWeight(1);
        break;
        case 2:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
        case 3:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+12, p.y+2);
        strokeWeight(1);
        break;
        case 4:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+16, p.y+8);
        strokeWeight(1);
        break;
      }
    }
    else{
      switch(time){
        case 0:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
        case 1:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,4);
        rect(p.x,p.y+8,3,1);
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
        case 2:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,3);
        rect(p.x,p.y+8,3,3);
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
        case 3:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x-3,p.y+8,3,1);
        rect(p.x,p.y+8,3,4);
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
        case 4:
        ellipse(p.x,p.y,6,6);
        fillColor_tm(t);
        rect(p.x-3,p.y+3,6,5);
        fillColor_c(hp);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5); 
        rect(p.x+2,p.y+3,2,5);
        stroke(255);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+8, p.y-2);
        strokeWeight(1);
        break;
      }
    }
    break;
    case 1:
    if(atk || atkB){
      switch(time){
        case 0:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 1:
        rect(p.x-15, p.y-7, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-12, p.y-4, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 2:
        rect(p.x-17, p.y-8, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-14, p.y-5, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 3:
        rect(p.x-15, p.y-7, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-12, p.y-4, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 4:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
      }
    }
    else{
      switch(time){
        case 0:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 4);
        rect(p.x-2, p.y+4, 2, 1);
        rect(p.x+3, p.y+4, 2, 4);
        rect(p.x+6, p.y+4, 2, 1);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 1:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 3);
        rect(p.x-2, p.y+4, 2, 2);
        rect(p.x+3, p.y+4, 2, 3);
        rect(p.x+6, p.y+4, 2, 2);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 2:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 2);
        rect(p.x-2, p.y+4, 2, 3);
        rect(p.x+3, p.y+4, 2, 2);
        rect(p.x+6, p.y+4, 2, 3);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 3:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 1);
        rect(p.x-2, p.y+4, 2, 4);
        rect(p.x+3, p.y+4, 2, 1);
        rect(p.x+6, p.y+4, 2, 4);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
        case 4:
        rect(p.x-13, p.y-6, 8, 8);
        rect(p.x-5, p.y+4, 2, 2);
        rect(p.x-2, p.y+4, 2, 3);
        rect(p.x+3, p.y+4, 2, 2);
        rect(p.x+6, p.y+4, 2, 3);
        fillColor_tm(t);
        rect(p.x-5,p.y-3,12,7);
        fill(0);
        ellipse(p.x-10, p.y-3, 2, 2);
        fillColor_c(hp);
        rect(p.x+7, p.y-3, 5, 2);
        break;
      }
    }
    break;
    case 2:
    if(atk || atkB){
      switch(time){
        case 0:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
        case 1:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+8, p.x+4, p.y-8);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-8,4,4);
        break;
        case 2:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+5, p.x+4, p.y-11);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-11,4,4);
        break;
        case 3:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+5, p.x+4, p.y-11);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-11,4,4);
        break;
        case 4:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+5, p.x+4, p.y-11);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-11,4,4);
        break;
      }
    }
    else{
      switch(time){
        case 0:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5); 
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
        case 1:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,2);
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,4);
        rect(p.x-4,p.y+3,8,1);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
        case 2:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,3);
        rect(p.x-4,p.y+3,8,3);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
        case 3:
        ellipse(p.x,p.y,6,6);
        rect(p.x-3,p.y+8,3,5);
        rect(p.x,p.y+8,3,5);
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,1);
        rect(p.x-4,p.y+3,8,4);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
        case 4:
        ellipse(p.x,p.y,6,6);
        rect(p.x,p.y+8,3,5);
        rect(p.x-4,p.y+3,2,5);
        rect(p.x+2,p.y+3,2,5);
        fillColor_tm(t);
        rect(p.x-2,p.y+3,4,5);
        rect(p.x-4,p.y+3,8,2);
        triangle(p.x, p.y-6, p.x-3, p.y-2, p.x+3, p.y-2);
        triangle(p.x, p.y+5, p.x-4, p.y+12, p.x+4, p.y+12);
        fillColor_c(hp);
        stroke(160, 64, 0);
        strokeWeight(2);
        line(p.x+4, p.y+12, p.x+4, p.y-4);
        strokeWeight(1);
        noStroke();
        fill(255, 0, 0);
        ellipse(p.x+4,p.y-4,4,4);
        break;
      }
    }
    break;
  }
}
public void mousePressed() {
  commandStep = commandStep%3;
  if(mouseX>=width/2-3*SBS && mouseX<=width/2+3*SBS && mouseY >= height-8*SBS && mouseY <= height-2*SBS){
    switch(commandStep){
      case 0:
         pause = true;
         newAgent = true;
         selectOn = false;
         selectTarget = true;
         selectX = width/2-3*SBS;
         selectY = height-8*SBS;
         selectX2 = width/2+3*SBS;
         selectY2 = height-4*SBS;
         squadCount++;
         commandStep++;
         commandStep++;
         break;
         
      case 2:
        selectTarget = false;
        pause = false;
        GoTarget = new PVector(mouseX, mouseY);
        MAP[PApplet.parseInt(GoTarget.x)][PApplet.parseInt(GoTarget.y)] = 2;
        commandStep++;
        break;
    }
  }
  else{
    switch(commandStep){
    case 0:
       println(1);
       selectOn = true;
       pause = true;
       selectX = mouseX;
       selectY = mouseY;
       commandStep++;
       squadCount++;
       break;
    case 1:
       println(2);
       selectOn = false;
       selectTarget = true;
       selectX2 = mouseX;
       selectY2 = mouseY;
       commandStep++;
       break;
    case 2:
       println(3);
       selectTarget = false;
       pause = false;
       GoTarget = new PVector(mouseX, mouseY);
       MAP[PApplet.parseInt(GoTarget.x)][PApplet.parseInt(GoTarget.y)] = 2;
       commandStep++;
       break;
    }
  }
}

public void selectionRect(){
  if (selectOn){
    noFill();
    stroke(255, 0, 0);
    rect(selectX, selectY, mouseX - selectX, mouseY - selectY);
 }
}

public void attackCommand(){
  if (selectTarget){
    noFill();
    stroke(255, 0, 0);
    line(mouseX, mouseY-12, mouseX, mouseY+12);
    line(mouseX-12, mouseY, mouseX+12, mouseY);
    ellipse(mouseX, mouseY, 8, 8);
    ellipse(mouseX, mouseY, 16, 16);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a_simple_game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
