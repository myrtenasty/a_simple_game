int Length = 1000;
int Max_Human = 80;
int init_population = Max_Human;
String season_name = "Spring";
int season = 0; // 0 for spring, 1 for summer, 2 for autumn, 3 for winter
int day = 0;
int dayCount = 0;
int year = 0;
int days_of_year = 365;
int food_prob = 20; // initial probablity for food generationg
int daily_exp = 20; 
int population = Max_Human;
int teamA = 0;
int teamB = 0;
int imgCount = 1;
int battleCount = 0;
int selectX;
int selectY;
boolean selectOn = false;
boolean pause = false;
boolean selected = false;
boolean selectTarget = false;
int commandStep = 0;

int[][] MAP = new int[Length][Length]; 
int[][] duelMAP = new int[Length][Length];

Human_class[] Human = new Human_class[Max_Human];

void setup(){
  size(Length, Length);
  background(0);
  frameRate(30);
  
  PFont font = createFont("arial",20);
  textFont(font);
}

void draw(){
  if(!pause){
    makeground();
    selectionRect();
    attackCommand();
  }
}



class Human_class
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //人間の状態
  int direction; //人間の動作方向
  int timer; //体内時計
  int hp; //体力
  int vel;
  int lv;
  int exp;
  int atk;
  int def;
  int lvup_exp;
  int bore_cd;
  int gender;
  int max_hp;
  int team;
  boolean combatReady;
  boolean isAttacking;
    
  Human_class(int c, int xp, int yp, int dirt, int t, int h, int tm) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
    vel = 3;
    lv = 1;
    exp = 0;
    atk = 100;
    def = 80;
    lvup_exp = 500;
    bore_cd = 310;
    gender = int(random(100)>50);
    max_hp = 1500;
    team = tm;
    combatReady = false;
    isAttacking = true;
  }



 //人間を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    
    
    fill(0, 255, 0); //健康な状態
    
    if(hp < 300){
      fill(255,255,0); //体力が落ち始めた状態
      vel = 2;
    }
  
    if(hp < 10){
       fill(255,0,0); //危険な状態
       vel = 1;
    }   
       
    //アニメーションは全部で5種類準備
    //体内時間を5で割って、その余りに応じて
    //表示するアニメを決定
    
    int time = timer % 5;
    switch(time){
      
      case 0:
        ellipse(xpos,ypos,6,6);
        fillColor_tm(team);
        rect(xpos-3,ypos+3,6,5); //胴体
        fillColor_c(hp);
        rect(xpos-3,ypos+8,3,5); //左足
        rect(xpos-4,ypos+3,2,5); //左腕
        rect(xpos+2,ypos+3,2,5); //右腕
    
        break;
      case 1:
        ellipse(xpos,ypos,6,6);
        fillColor_tm(team);
        rect(xpos-3,ypos+3,6,5);
        fillColor_c(hp);
        rect(xpos-3,ypos+8,3,4);
        rect(xpos,ypos+8,3,1);        
        break;
       case 2:
        ellipse(xpos,ypos,6,6);
        fillColor_tm(team);
        rect(xpos-3,ypos+3,6,5);
        fillColor_c(hp);
        rect(xpos-3,ypos+8,3,3);
        rect(xpos,ypos+8,3,3);
        break;
        case 3:
        ellipse(xpos,ypos,6,6);
        fillColor_tm(team);
        rect(xpos-3,ypos+3,6,5);
        fillColor_c(hp);
        rect(xpos-3,ypos+8,3,1);
        rect(xpos,ypos+8,3,4);
        break;
        case 4:
        
        //5枚目
        ellipse(xpos,ypos,6,6);
        fillColor_tm(team);
        rect(xpos-3,ypos+3,6,5);
        fillColor_c(hp);
        rect(xpos,ypos+8,3,5);
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
        
    }
  }


//人間を動かす部分
  void drive () {
    
    //確率5%で動く方向を変更
    if(random(100) < 5){
      //5種類の動きをランダムにセット
      direction = int(random(5));
    }
    
    //動く方向4方向 + 何も動かない
    //合計5種類を準備
    
    switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + vel + width) % width; //右に動かす
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - vel + width) % width; //左に動かす
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + vel + height) % height; //下に動かす
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - vel + height) % height; //上に動かす
          break;
    }
     
   
   //自分の移動先に存在を代入
     MAP[xpos][ypos] = type;  
    
  }
  
  
  //衝突の判定
  void coll() {
    
    //自分の周囲 10x10 の範囲を探索して、他人がいたら避けるようにする
    if(!combatReady){
    for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 1){
          
          MAP[xpos][ypos] = 0;
          
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 2 + width) % width; 
          }
          if(i > 0){
            xpos = (xpos - 2 + width) % width;
          }
          
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 2 + height) % height;
          }
          if(j > 0){
            ypos = (ypos - 2 + height) % height;
          }
          
          MAP[xpos][ypos] = type; 
          
       
        }
      }
    }
    }
    else{
      for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 1){
          
          MAP[xpos][ypos] = 0;
          
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 1 + width) % width; 
          }
          if(i > 0){
            xpos = (xpos - 1 + width) % width;
          }
          
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 1 + height) % height;
          }
          if(j > 0){
            ypos = (ypos - 1 + height) % height;
          }
          
          MAP[xpos][ypos] = type; 
          
       
        }
      }
    }
    }
  }
  
  
  //食べ物の獲得
  
  void eat(){
    
    int action = 0;
    combatReady = false;
    
    for(int r = 0; r < 100; r++){
      for(int s = 0; s < 360; s=s+10){
          
      int i = int(r * cos(radians(s)));
      int j = int(r * sin(radians(s)));
          
      if ((MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 2)){       
        
            MAP[xpos][ypos] = 0;
            combatReady = true;
             
            if((i > 0)&&(action==0)){
              direction = 1;
              xpos = (xpos + 1 + width) % width; //右に動かす
              action = 1;
            }
            
            if((i < 0)&&(action==0)){
               direction = 2;
               xpos = (xpos - 1 + width) % width; //左に動かす
               action = 1;
            }
          
            if((j > 0)&&(action==0)){
              direction = 3;
              ypos = (ypos + 1 + height) % height; //下に動かす
              action = 1;
            }
            if((j < 0)&&(action==0)){
              direction = 4;
              ypos = (ypos - 1 + height) % height; //上に動かす
              action = 1;
            }       
      }
      if(action == 1)
       break;
      }
    }
    
      //もし食料のところへたどり着いたら、
            //エネルギーが回復
            if((MAP[xpos][ypos] == 2)){
              //println(lv+" "+exp+" "+vel);
              hp = min(hp + 500, max_hp);
              exp += 500;
              if (exp >= lvup_exp){
                  lv++;atk+=20;def+=15;max_hp += 50;hp = min(hp+max_hp/5, max_hp); // only when eating or batlle, hp recovers after level up.
                  if (lv >=5 && lv < 20){vel = 4;}
                  else if (lv >= 20){vel = 5;}
                  //if(j == 1){println(Human[j].lvup_exp);}
                  exp = 0;
                  lvup_exp = 400 + lv * 100;
              }
              //println("after eating: "+lv+" "+exp+" "+vel);
              
            }
            
            MAP[xpos][ypos] = 1;
  }
  
  void bore(){
    if(lv>5 && hp > 1000 && random(100)<1 && bore_cd == 0 && gender == 1){
      int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
      int k2 = (xpos+10 + width)%width; //登場する初期 x座標
      int k3 = ypos; //登場する初期 y座標
      int k4 = int(random(5)); //人間の動作方向をランダムにセット
      int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
      int k6 = 1000 + int(random(200)); //200~400の範囲で体力をセット
      int k7;
      int betray_prob = int(min(100 * (float)population/ (6*(float)init_population), 100));
      //println(population+" "+(6*init_population)+" "+(100 * (float)population/ (6*(float)init_population))+" "+betray_prob);
      int betray = int(random(100)<betray_prob);
      k7 = betray*(1-team) + (1-betray)*team;
      //println(k7);
      Human_class[] temp_human = new Human_class[Max_Human+1];
      for (int i = 0; i < Max_Human; i++){
        temp_human[i] = Human[i];
      }
      temp_human[Max_Human] = new Human_class(k1,k2,k3,k4,k5,k6,k7);
      Human = new Human_class[Max_Human+1];
      for (int j = 0; j < Max_Human + 1; j++){
        Human[j] = temp_human[j];
      }
      Max_Human++;
      fill(5, 255, 255);
      ellipse(k2, k3, 15, 15);
      //println(lv+" "+bore_cd);
      bore_cd = 300;
    }
  }
  
  void duel(){
    for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 1){
          //searching hostile agents around
          for(int m = 0; m < Max_Human; m++){
//            if(abs(Human[m].xpos-((xpos+i+width) % width))<=5 && abs(Human[m].ypos-((ypos+j+height) % height))<=5 && Human[m].combatReady && Human[m].isAttacking && Human[m].team!=team){
            if(abs(Human[m].xpos-((xpos+i+width) % width))==0 && abs(Human[m].ypos-((ypos+j+height) % height))==0 && Human[m].combatReady && Human[m].isAttacking && Human[m].team!=team){
              // injury settlment
              duelMAP[xpos][ypos] = 1;
              hp = hp - (max(5*(Human[m].atk-def), 100));
              if(hp<0){
                type = 0;  //もし体力が0になったら、状態を死に変更
                MAP[xpos][ypos] = 0;
                //println(Human[m].exp);
                Human[m].exp += lv*100;
                if (Human[m].exp >= Human[m].lvup_exp){
                  Human[m].lv++; Human[m].atk+=20; Human[m].def+=15; Human[m].max_hp+=50; Human[m].hp+=500;
                  if (Human[m].lv >=5 && Human[m].lv < 20){Human[m].vel = 4;}
                  else if (Human[m].lv >= 20){Human[m].vel = 5;}
                  //if(j == 1){println(Human[j].lvup_exp);}
                  Human[m].exp = 0;
                  Human[m].lvup_exp = 400 + Human[m].lv * 100;
                }
                //println(Human[m].exp);
              }
            }
          }
        }
      }
    }
  }
  
  
  
}

void makeground(){
  fill(56, 159, 91); //ちょっと薄めのグリーン
  rect(0,0,width,height);  
}

void fillColor_tm(int tm){
  switch(tm){
    case 0:
    fill(128, 0, 128);
    break;
    case 1:
    fill(0, 0, 255);
  }
}

void fillColor_c(int hp){
    fill(0,255,0); //健康な状態
    if(hp < 300){
      fill(255,255,0); //体力が落ち始めた状態
    }
    if(hp < 10){
       fill(255,0,0); //危険な状態
    }
}

void mousePressed() {
  commandStep = commandStep%3;
  switch(commandStep){
    case 0:
       println(1);
       selectOn = true;
       selectX = mouseX;
       selectY = mouseY;
       commandStep++;
       break;
    case 1:
       println(2);
       selectOn = false;
       selectTarget = true;
       commandStep++;
       break;
    case 2:
       println(3);
       selectTarget = false;
       commandStep++;
       break;
  }
}

void selectionRect(){
  if (selectOn){
    noFill();
    stroke(255, 0, 0);
    rect(selectX, selectY, mouseX - selectX, mouseY - selectY);
 }
}

void attackCommand(){
  if (selectTarget){
    noFill();
    stroke(255, 0, 0);
    line(mouseX, mouseY-10, mouseX, mouseY+10);
    line(mouseX-10, mouseY, mouseX+10, mouseY);
  }
}
