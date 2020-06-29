void cast(PVector p, int timer){
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
