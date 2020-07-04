class Human_class
{

  int no;
  PVector position;
  int type; //人間の状態
  PVector vel; //人間の動作方向
  PVector acc;
  PVector target;
  int timer; //体内時計
  int hp; //体力
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
    vel_max = 3*int(c==0)+4*int(c==1)+2*int(c==2);
    maxforce = 0.1;
    distToObs = 10000.0;
    lv = 1;
    exp = 0;
    atk = 100+40*c;
    def = 80-20*c;
    def_c = 30*c;
    lvup_exp = 500;
    max_hp = 1500*int(c==0)+500*int(c==1)+1000*int(c==2);
    hp = max_hp;
    team = tm;
    squad = 0;
    attackingBase = false;
    isAttacking = false;
    selected = false;
    
    career = c;
  }



 //人間を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    fill(255, 0, 0);
    textSize(10); 
    text("lv "+lv, position.x-10, position.y-10);
    
    
    fill(0, 255, 0); //健康な状態
    
    if(hp < 300){
      fill(255,255,0); //体力が落ち始めた状態
      vel.mult(0.8);
    }
  
    if(hp < 10){
       fill(255,0,0); //危険な状態
       vel.mult(0.5);
    }   
       
    //アニメーションは全部で5種類準備
    //体内時間を5で割って、その余りに応じて
    //表示するアニメを決定
    
    int time = timer % 5;
    motion(time, career, isAttacking, attackingBase, position, team, hp);
//    if(selected){println("target is "+target+" squad is "+squad);}
    selectBox();
  }

// draw select box  
void selectBox() {
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


//人間を動かす部分
  void drive () {
    MAP[int(position.x)][int(position.y)] = 0;
    
    PVector sep = seperate();
    PVector ali = align();
    PVector tar = goToTarget(); 
    PVector obs = dodgeObstacle(MAP);
    PVector cha = chase();
    PVector flac = new PVector(random(-0.3, 0.3), random(-0.3, 0.3));
    if (distToObs >= 10){
      sep.mult(2.2);
      ali.mult(1.0);
      tar.mult(2.0);
      obs.mult(3.0);
      cha.mult(0.8);
      flac.mult(0.1);
//      if(selected){println("sep is "+sep.mag()+" ali is "+ali.mag()+" tar is "+tar.mag());}
//      println("not dodge "+frameCount);
    }
    else{
      sep.mult(0.0);
      ali.mult(0.5);
      tar.mult(0.3);
      obs.mult(10);
      cha.mult(0);
      flac.mult(0.5);
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
    
    MAP[int(position.x)][int(position.y)] = 2;
    
  }
  
  // force to keep a certain distance from agents in the same team
  PVector seperate(){
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
  PVector align(){
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
  PVector goToTarget(){
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
  PVector seek(PVector target){
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(vel_max);
    
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }
  
  
  // dodge obstacle
  PVector dodgeObstacle(int[][] map){
    int dodgedist = 80;
    float desiredDist = 25.0f;
    float obsDist = 10000;
    float obsDist_temp = 0;
    PVector dodge = new PVector(0, 0);
    PVector closestObs = new PVector(0, 0);
    int xpos = 0;
    int ypos = 0;
    for(int i = int(position.x) - dodgedist; i<int(position.x) + dodgedist; i++){
      for(int j = int(position.y) - dodgedist; j<int(position.y) + dodgedist; j++){
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
    diff.div(max(obsDist-8.0, 0.0001));        // Weight by distance
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
  
  PVector chase(){
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
  
  void protectOrAttack(){
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
  
  void duel(){
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
          if(lv>=5){vel_max = 4*int(career==0)+5*int(career==1)+3*int(career==2);}
          atk = atk + lv*(10+5*career);
          def = def + lv*(10-career);
          def_c =def_c+min(lv, 10);
          lvup_exp = lvup_exp + lv*30;
          max_hp =max_hp+lv*(75*int(career==0)+25*int(career==1)+50*int(career==2));
          hp = min(hp+200, hp);
          exp = 0;
        }
      }
    }
    
    if(isAttacking && career==2){
      cast(Human[atkTar].position, timer);
    }
  }
  
  void attackBase(int[][] map){
    int standDist = 0;
    int searchDist = 100;
    float baseDist = 10000;
    float baseDist_temp = 0;
    int xpos = 0;
    int ypos = 0;
    int count = 0;
    
    for(int i = int(position.x) - searchDist; i < int(position.x) + searchDist; i++){
      for(int j = int(position.y) - searchDist; j < int(position.y) + searchDist; j++){
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
