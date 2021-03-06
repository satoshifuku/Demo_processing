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
       for (int j = 0; j < fireworks.get(i).n_star; j++) {
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
  float time;
  color c;

  int life = 50;

  int mode = 0;
  PVector point;

  int n_star = 36;

  Stars[] stars;

  Firework(int x, int y){
    
    life += (int)random(-5, 5);

    location = new PVector[life];
    for (int i = 0; i < life; ++i)
      location[i] = new PVector(x, height); 
    
    v = v_0 = -sqrt(2 * (height - y) * gravity);
    time = -v_0/gravity;

    colorMode(HSB, 255);
    c = color((int)random(0, 255), 120, 255);

    n_star += (int)random(-20, 5);
    stars = new Stars[n_star];
    // mono : transition = 2 : 1
    int temp_mode = (int)random(1, 3)%2;

    for (int i = 0; i < n_star; ++i) {
      stars[i] = new Stars(50, (i + random(-0.4, 0.4))*(2*PI/n_star), c);
      stars[i].color_mode = temp_mode;
    }

  }

  // The function must be used for the transition of modes.
  void checked_mode(){
    if (time <= 0 && mode == 0) {
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
    update_location();
    for (int i = life-1; i > 0; i--) {
      location[i] = location[i-1].copy();
    }    
  }

  void update_location(){
    location[0].x = random(-1 + location[0].x, 1 + location[0].x);
    v += gravity * delta_t;
    location[0].y += v * delta_t;
    time -= delta_t;
  }
}


class Stars
{
  PVector[] location;
  PVector velosity;
  int len_tail = 25;
  int life = 40;
  int togo;
  color c;
  int color_mode =0;

  Stars(float speed, float rad, color c_){
    location = new PVector[len_tail];
    for (int i = 0; i < len_tail; ++i) {
      location[i] = new PVector(-1, -1);  
    }

    location[0].set(0.0,0.0);
    velosity = new PVector(speed * cos(rad), speed * sin(rad));
    life += (int)random(-5, 5);
    togo = life;
    c = c_;
  }

  void draw(PVector c_locat){
    for (int i = 1; i < len_tail; ++i) {
      if (color_mode == 0) {
        stroke(c, 255*togo/life);        
      }
      else{
        color cc = color(hue(c)*(len_tail-random(0.1, 0.9)*i)/len_tail,saturation(c),brightness(c));
        stroke(cc, 255*togo/life);        
      }
      strokeWeight(10 * (len_tail - i)/len_tail);
      line(location[i-1].x + c_locat.x, location[i-1].y + c_locat.y, 
            location[i].x + c_locat.x, location[i].y + c_locat.y);        
    }

    for (int i = len_tail-1; i > 0; i--)
      location[i] = location[i-1].copy();

    update_location();
  
  }

  void update_location(){
    velosity.y += gravity * delta_t;
    location[0].add(velosity.copy().mult(delta_t));
    togo--;
  }

}