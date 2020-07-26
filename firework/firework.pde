ArrayList<Firework> fireworks = new ArrayList<Firework>();

float delta_t = 0.1;
float gravity = 9.8;

void setup()
{
  size(900,600);
  frameRate(60);
}

void draw()
{
  background(#000000);
  for (int i = 0; i < fireworks.size(); ++i) {
    fireworks.get(i).to_clicked_location();
     
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
  float v, v_0;
  int fade;
  color c;

  float t;

  Firework(int x, int y){
    location = new PVector(x, height);  
    v_0 = -sqrt(2 * (height - y) * gravity);
    v = v_0;
    t = -v_0/gravity;
    fade = (int)random(1, 5);
    colorMode(HSB, 255);
    c = color((int)random(0, 255), 120, 255);
  }

  void to_clicked_location(){
    noStroke();
    location.x = random(-1 + location.x, 1 + location.x);
    v += gravity * delta_t;
    location.y += v * delta_t;
    t -= delta_t;
    fill(c);    
    ellipse(location.x, location.y, 10, 10);
  }
  
  boolean check(){
    if(t <= 0)
      return true;
    else 
      return false;
  }
}