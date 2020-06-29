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
  
  
  void base1(){
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
      box1[i] = int(random(100)>50);
    }
  }
    for(int j = 0; j < 9; j++){
      stroke(0);
      fill(255-255*box1[j]);
      rect(width/2-3*SBS+(j%3)*(2*SBS), height-8*SBS+(j/3)*(2*SBS), SBS*2, SBS*2);
    }
  }
  
void base2(){
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
      box2[i] = int(random(100)>50);
    }
  }
    for(int j = 0; j < 9; j++){
      stroke(0);
      fill(255-255*box2[j]);
      rect(width/2-3*SBS+(j%3)*(2*SBS), 6*SBS-(j/3)*(2*SBS), SBS*2, SBS*2);
    }
  }
  
void generate(){
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
            float k2 = float(width/2-2*SBS+(j%3)*(2*SBS));
            float k3 = float(height-7*SBS+(j/3)*(2*SBS));
            PVector pos = new PVector(k2, k3);
            PVector v = new PVector(0, 0);
            int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
            int k7 = 1;
            MAP[int(k2)][int(k3)] = 2;
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
            Human[Max_Human].max_hp =Human[Max_Human].max_hp+Human[Max_Human].lv*(75*int(c==0)+25*int(c==1)+50*int(c==2));
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
            float k2 = float(width/2-2*SBS+(j%3)*(2*SBS));
            float k3 = float(7*SBS-(j/3)*(2*SBS));
            PVector pos = new PVector(k2, k3);
            PVector v = new PVector(0, 0);
            int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
            int k7 = 0;
            MAP[int(k2)][int(k3)] = 2;
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
            Human[Max_Human].max_hp =Human[Max_Human].max_hp+Human[Max_Human].lv*(75*int(c==0)+25*int(c==1)+50*int(c==2));
            Human[Max_Human].hp = Human[Max_Human].max_hp;
            Max_Human++;
          }
        }
      }
    }
  }
}

void hpBar(){
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

int rules (int a, int b, int c) {
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
