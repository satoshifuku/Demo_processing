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
    fireworks.get(i).checked_mode();
    if (fireworks.get(i).mode == 0 ) {
      fireworks.get(i).to_clicked_location();
    }
    if (fireworks.get(i).mode == 1 ) {
       for (int j = 0; j < 36; j++) {
          fireworks.get(i).stars[j].draw(fireworks.get(i).point);         
       }
    }
    else if( fireworks.get(i).mode == 2 ){
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
  int mode = 0;
  PVector point;
  Stars[] stars = new Stars[36];

  Firework(int x, int y){
    location = new PVector(x, height);  
    v_0 = -sqrt(2 * (height - y) * gravity);
    v = v_0;
    t = -v_0/gravity;
    fade = (int)random(1, 5);
    colorMode(HSB, 255);
    c = color((int)random(0, 255), 120, 255);

    for (int i = 0; i < 36; ++i) {
      stars[i] = new Stars(50, i * (2*3.14/(36-1)), c );
    }

  }
  void checked_mode(){
    if (t <= 0 && mode == 0) {
      mode = 1;
      point = location.copy();
    }
    else if (stars[0].dulation <= 0) {
      mode = 2;
    }
  }

  void lift_shell(){
    noStroke();
    location.x = random(-1 + location.x, 1 + location.x);
    v += gravity * delta_t;
    location.y += v * delta_t;
    t -= delta_t;
    fill(c);    
    ellipse(location.x, location.y, 10, 10);
  }
}


class Stars
{
  PVector[] location;
  PVector velosity;
  int length = 20;
  int lifespan = 40;
  int dulation;
  color c;

  Stars(float speed, float rad, color c_){
    location = new PVector[length];
    for (int i = 0; i < length; ++i) {
      location[i] = new PVector(-1, -1);  
    }

    location[0].set(0.0,0.0);
    velosity = new PVector(speed * cos(rad), speed * sin(rad));
    dulation = lifespan;
    c = c_;
  }

  void draw(PVector c_locat){
    for (int i = 1; i < length; ++i) {
        stroke(c, 255*dulation/lifespan);
        strokeWeight(10 * (length - i)/length);
        line(location[i-1].x + c_locat.x, location[i-1].y + c_locat.y, 
             location[i].x + c_locat.x, location[i].y + c_locat.y);        
    }

    for (int i = length-1; i > 0; i--) {
      location[i] = location[i-1].copy();
    }

    velosity.y += gravity * delta_t;
    location[0].add(velosity.copy().mult(delta_t));
    dulation--;

  }
}