ArrayList<Firework> fireworks = new ArrayList<Firework>();
  

void setup()
{
  size(900,600);

}

void draw()
{
  background(#000000);
  for (int i = 0; i < fireworks.size(); ++i) {
    fireworks.get(i).draw_point();
     
    if( fireworks.get(i).check() ){
      fireworks.remove(i);
    }    

  }  
}


void mousePressed() {
  if (mouseButton == LEFT) {
    // println("Pressed");
    fireworks.add(new Firework(mouseX, mouseY));
  }
}


class Firework
{
  PVector location;

  int lifespan;
  int fade;
  color c;
  Firework(int x, int y){
    location = new PVector(x, y);  

    lifespan = 255;
    fade = (int)random(1, 5);
    colorMode(HSB, 255);
    c = color((int)random(0, 255), 120, 255);
  }

  void draw_point(){
    noStroke();
    lifespan -= fade;
    println(lifespan);
    fill(c, lifespan);    
    ellipse(location.x, location.y, 30, 30);
  }
  
  boolean check(){
    if(lifespan <= 0)
      return true;
    else {
      return false;
    }
  }
}