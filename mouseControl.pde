void mousePressed() {
  commandStep = commandStep%3;
  if(!gameBegin){
    gameBegin = !gameBegin;
    pause = false;
  }
  else if(gameBegin){
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
          MAP[int(GoTarget.x)][int(GoTarget.y)] = 2;
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
        MAP[int(GoTarget.x)][int(GoTarget.y)] = 2;
        commandStep++;
        break;
      }
    }
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
    line(mouseX, mouseY-12, mouseX, mouseY+12);
    line(mouseX-12, mouseY, mouseX+12, mouseY);
    ellipse(mouseX, mouseY, 8, 8);
    ellipse(mouseX, mouseY, 16, 16);
  }
}
