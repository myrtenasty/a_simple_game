void motion(int time, int c, boolean atk, boolean atkB, PVector p, int t, int hp){
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
