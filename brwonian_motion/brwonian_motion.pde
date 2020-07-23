int n_particles = 500;
Particle[] particles = new Particle[n_particles];

boolean setcolor = false;

color color_background = #ffffff;
color color_particle = #959595;// #ffffff or #959595;
color color_focus =  #dd2743;

float speed = 100.0;

int radius_smallest = 1;
int radius_biggest = 9;

boolean mode_depth0field = false;

void setup()
{
  size(1000,500);
  
  for(int i=0;i<n_particles;i++)
  {
    float radius_particle = random(radius_smallest, radius_biggest);
    PVector pv = new PVector(random(radius_particle, width - radius_particle), 
                             random(radius_particle, height - radius_particle));

    particles[i] = new Particle(pv, radius_particle, speed, i, particles);
  }
}

void draw()
{
  background(color_background);
  
  boolean flag = true;
  for (int i=0;i<n_particles;i++)
  {

    particles[i].move();
    particles[i].collide();


    flag = true;  
    if(n_particles - (int)n_particles/20 < i )
      flag = false;
    particles[i].draw(flag);  
  
  }
}



class Particle
{
  PVector location;
  float radius;

  PVector translation;
  
  float elasticity = 0.1;
  int id;
  Particle[] others;
  
  float scaled_speed;

  float dof;

  PVector wall_v = new PVector(0, 0);

  float coefficient = 0.9999;

  Particle(PVector locat,float rr, float speed_, int id_,Particle[] others_)
  {
    location = locat;
    radius = rr;
    
    id = id_;
    others = others_;

    scaled_speed = 10 * speed_/width;
    
    translation = new PVector(random(-1, 1) * scaled_speed, random(-1, 1) * scaled_speed);

    dof = pow(radius /radius_biggest, 2); //f^2/nc (n = 1, c = 1)
  }
  
  void collide()
  {
    int start_by_id = id+1;
    PVector vector_particles;
    PVector vector_particles_n;
    PVector velocity_v;
    
    for (int i=start_by_id; i<others.length; i++)
    {

      //Current distance of two particles.      
      vector_particles = PVector.sub(others[i].location, location);
      float dist = sqrt( pow(vector_particles.x, 2) + pow(vector_particles.y, 2));

      // Distance of collision of two particles
      float dist_two_particle = others[i].radius + radius;

      // When the collide particles.
      if (dist < dist_two_particle)
      {

        vector_particles_n = vector_particles.copy().normalize();

        velocity_v = PVector.sub(translation, others[i].translation);
        vector_particles_n.copy().mult(dist_two_particle - dist);
        float dot = PVector.dot(velocity_v, vector_particles_n);
        float dot_m = (1.0 + coefficient)/(radius + others[i].radius) * dot;
        translation.add(vector_particles_n.copy().mult(-radius * dot_m));

        //other
        velocity_v = PVector.sub(translation, others[i].translation);     
        others[i].translation.add(vector_particles_n.copy().mult(others[i].radius * dot_m));

        // Push back partickes (not correct. sphere-swept volume is better.)
        PVector back_v = vector_particles_n.copy().mult(0.5 * (dist_two_particle - dist));
        location.sub(back_v);
        others[i].location.sub(back_v.copy().mult(-1.0));

      }      
    }
  }
  
  void move()
  {
    //Translate an particle.
    location.add(translation);

    boolean coll_window = false;
    float dist = 10000000.0;

    // Collide a particle in the y-axis of window wedge.
    if (location.x > (width-radius))
    {
      location.x = width-radius;
      wall_v.set(-1, 0);
      dist = abs(location.x - (width-radius));
    }
    else if (location.x < radius)
    {
      location.x = radius;
      wall_v.set(1, 0);
      dist = abs(location.x - radius);
    }

    // Collide a particle in the x-axis.
    if (location.y > (height-radius))
    {
      location.y = height-radius;
      wall_v.set(0, -1);
      dist = abs(location.y - (height-radius));      
    }
    else if (location.y < radius)
    {
      location.y = radius;
      wall_v.set(0, 1);
      dist = abs(location.y - radius);      
    }

    // Inverse a translation of a particle.
    if(dist < 10000000.0){

      float ref_len = 2.0 * PVector.dot(translation, wall_v);
      PVector ref_v = PVector.sub(translation, wall_v.copy().mult(ref_len));
      //own
      translation = ref_v.copy();
    }
  }
  
  void draw(boolean focus)
  {
    ellipseMode(RADIUS);
    noStroke();
    if (focus == true)
      if (mode_depth0field == false)
        fill(color_particle);
      else

        fill(color_particle, 255 * dof);      
    else
      if (mode_depth0field == false)
        fill(color_focus);
      else
        fill(color_focus, 255 * dof);
    ellipse(location.x,location.y,radius,radius);
  }
  
}