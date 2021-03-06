int n_particles = 500;
Particle[] particles = new Particle[n_particles];

boolean setcolor = false;

color color_background = #ffffff;
color color_particle = #959595;// #ffffff or #959595;
color color_focus =  #dd2743;

float speed = 100.0; // Maximum speed of the particles.
float delta_t = 1.0; //Step time in the simulation.

//The smallest and biggest radius of the particle.
int radius_smallest = 1;
int radius_biggest = 9;

boolean mode_depth0field = false;

//up, right, left, bottom
PVector[] wall_vs = {new PVector(1, 0), new PVector(0, 1),
                  new PVector(0, -1), new PVector(-1, 0)}; 
PVector wall_vn; 

void setup()
{
  size(900,600);
  
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
  PVector velocity;
  float radius;  
  float mass;    

  float coefficient = 0.9999;

  int id;
  Particle[] others;
  
  float scaled_speed;

  float dof = 1.0;

  PVector particles_v, particles_vn;
  PVector particles_vel_v;
  PVector back_v;
  PVector from_pivot;
  PVector pivot; 
 
  Particle(PVector locat,float rr, float speed_, int id_,Particle[] others_)
  {
    location = locat;
    radius = rr;
    mass = radius;
    
    id = id_;
    others = others_;

    scaled_speed = 10 * speed_/width;
    
    if(mode_depth0field == false)    
      velocity = new PVector(random(-1, 1), random(-1, 1)).mult(scaled_speed);
    else{
      float tt = 5 * pow(radius /radius_biggest, 2);
      velocity = new PVector(random(-1, 1), random(-1, 1)).mult(scaled_speed * tt);      
    }
    dof = pow(radius /radius_biggest, 2); //f^2/nc (n = 1, c = 1)
  }
  
  void collide()
  {
    int start_by_id = id+1;
    
    for (int i=start_by_id; i<others.length; i++)
    {

      //Current distance of two particles.      
      particles_v = PVector.sub(others[i].location, location);
      float dist = particles_v.mag();

      // Distance of collision of two particles
      float dist_two_particle = others[i].radius + radius;

      boolean flag_col = false;
      if(mode_depth0field == true){
        if(radius - others[i].radius <= 2.0)
          flag_col = true;  
      }
      else{
        flag_col = true;
      }

      // When the collide particles.
      if ((dist < dist_two_particle) && (flag_col == true))
      {

        particles_vn = particles_v.copy().normalize();

        particles_vel_v = PVector.sub(velocity, others[i].velocity);
        float dot = PVector.dot(particles_vel_v, particles_vn);
        float dot_m = (1.0 + coefficient)/(mass + others[i].mass) * dot;
        velocity.add(particles_vn.copy().mult(-others[i].mass * dot_m));

        //other
        particles_vel_v.mult(-1);
        others[i].velocity.add(particles_vn.copy().mult(mass * dot_m));

        // Push back partickes along the vector between particles 
        //(not correct. sphere-swept volume is better.)
        back_v = particles_vn.copy().mult(0.5 * (dist_two_particle - dist));
        location.sub(back_v);
        others[i].location.sub(back_v.mult(-1.0));

      }      
    }
  }
  
  void move()
  {
    //Translate an particle.
    location.add(PVector.mult(velocity, delta_t));

    float dist = 0.0;

    for(int i=0;i<4;i++){
      pivot = new PVector(width * (int)(byte(i)&byte(1)), height * (int)(byte(i)&byte(2)>>1));
      wall_vn = wall_vs[i].copy().rotate(HALF_PI);      
      from_pivot = location.copy().sub(pivot);  //Vector from pivot to a location of the particle.
      dist = abs(cross2d(wall_vs[i], from_pivot))/ wall_vs[i].mag(); // Virtical distance from the wall to the particle.

      if ( dist <= radius){
        // Push back particke
        location.add(wall_vn.copy().mult(abs(dist - radius)));

        //bounce the particle
        float ref_len = 2.0 * PVector.dot(velocity, wall_vn);
        PVector ref_v = PVector.sub(velocity, wall_vn.copy().mult(ref_len));
        velocity = ref_v.copy();
    }
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
  

  float cross2d(PVector v1, PVector v2){
    return v1.x*v2.y-v2.x*v1.y;
  }  

}