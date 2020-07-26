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
      fireworks.get(i).lift_shell();
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
  float shll_radius = 10.0;
  PVector[] location;
  float v, v_0;
  int fade;
  color c;
  float t;

  int life = 30;

  int mode = 0;
  PVector point;

  int n_star = 36;

  Stars[] stars = new Stars[36];

  Firework(int x, int y){
    
    life += (int)random(-5, 5);

    location = new PVector[life];
    for (int i = 0; i < life; ++i)
      location[i] = new PVector(x, height); 
    
    v = v_0 = -sqrt(2 * (height - y) * gravity);
    t = -v_0/gravity;

    fade = (int)random(1, 5);
    colorMode(HSB, 255);
    c = color((int)random(0, 255), 120, 255);

    for (int i = 0; i < n_star; ++i) {
      stars[i] = new Stars(50, (i + random(-0.4, 0.4))*(2*PI/(n_star)), c );
    }

  }
  void checked_mode(){
    if (t <= 0 && mode == 0) {
      mode = 1;
      point = location[0].copy();
    }
    else if (stars[0].togo <= 0 && mode == 1) {
      mode = 2;
    }

  }

  void lift_shell(){
    float temp;
    noStroke();
    for (int i = 0; i < life; ++i) {
      temp = (float)(life-i)/life;
      fill(c, 255*temp);
      ellipse(location[i].x, location[i].y, 
              shll_radius*temp, shll_radius*temp);

    }
    update_shell_location();
    for (int i = life-1; i > 0; i--) {
      location[i] = location[i-1].copy();
    }
    
  }

  void update_shell_location(){
    location[0].x = random(-1 + location[0].x, 1 + location[0].x);
    v += gravity * delta_t;
    location[0].y += v * delta_t;
    t -= delta_t;
  }
}


class Stars
{
  PVector[] location;
  PVector velosity;
  int length = 20;
  int life = 40;
  int togo;
  color c;

  Stars(float speed, float rad, color c_){
    location = new PVector[length];
    for (int i = 0; i < length; ++i) {
      location[i] = new PVector(-1, -1);  
    }

    location[0].set(0.0,0.0);
    velosity = new PVector(speed * cos(rad), speed * sin(rad));
    togo = life;
    c = c_;
  }

  void draw(PVector c_locat){
    for (int i = 1; i < length; ++i) {
        stroke(c, 255*togo/life);
        strokeWeight(10 * (length - i)/length);
        line(location[i-1].x + c_locat.x, location[i-1].y + c_locat.y, 
             location[i].x + c_locat.x, location[i].y + c_locat.y);        
    }

    for (int i = length-1; i > 0; i--) {
      location[i] = location[i-1].copy();
    }

    velosity.y += gravity * delta_t;
    location[0].add(velosity.copy().mult(delta_t));
    togo--;

  }
}