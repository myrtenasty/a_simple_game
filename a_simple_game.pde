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

void setup(){
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
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int k2 = 0; //登場する初期 x座標
     int k3 = 0; //登場する初期 y座標
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
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     int k7 = int(i >= 27);
     int c = (i/9)%3;
     MAP[int(k2)][int(k3)] = 2;
     Human[i] = new Human_class(i,k1,pos,v,k5,k7,c);
     if(i%9 == 0){squadCount++;}
     Human[i].squad = squadCount;
  }
  obstacle();
  
}

void draw(){
    makeground();
    base[1].base1();
    base[0].base2();
    obstacle();
    base[1].generate();
    base[0].generate();
    base[0].hpBar();
    base[1].hpBar();
    if(frameCount%300==299&&gameBegin){base[0].lv++;base[1].lv++;base[0].hp+=base[0].lv*100;base[1].hp+=base[1].lv*100;}
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
          if(Human[j].lv>=5){Human[j].vel_max = 4*int(Human[j].career==0)+5*int(Human[j].career==1)+3*int(Human[j].career==2);}
          Human[j].atk = Human[j].atk + Human[j].lv*(10+5*Human[j].career);
          Human[j].def = Human[j].def + Human[j].lv*(10-Human[j].career);
          Human[j].def_c =Human[j].def_c+min(Human[j].lv, 10);
          Human[j].lvup_exp = Human[j].lvup_exp + Human[j].lv*30;
          Human[j].max_hp =Human[j].max_hp+Human[j].lv*(75*int(Human[j].career==0)+25*int(Human[j].career==1)+50*int(Human[j].career==2));
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

void obstacle(){
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

void winOrLose(){
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

void keyPressed(){
  pause = false;
  gameBegin = true;
}

void gameStart(){
  if(!gameBegin){
    fill(130, 224, 170 );
    rect(0,0,width,height);
    textSize(30);
    fill(255);
    text("Press any key to start", width/2-150, height/2-25);
  }
}

