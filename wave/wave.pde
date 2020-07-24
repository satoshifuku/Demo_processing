float[][] ut_past;
float[][] ut_current;
float[][] ut_feature;

// Phase velocity(recommend:0<s2<0.5)
float s2 = 0.1; 

//size of grid
int len_glid = 20;

int mode_grid = 2;

int n_grid_w;
int n_grid_h; 

// pouring_location 
float plx = 0.4;
float ply = 0.4;

color color_background = #ffffff;
color color_focus =  #3044ff;
int alpha_weight = 20;

int window_width;
int window_height;

int radius;

// frequency of updating the simulation. 
// The bigger number is the slower of the simulation.
int interval = 2;
int count;

void setup() {
  
  size(1000, 1000);  //windows size
  frameRate(60);
  
  window_width = width;
  window_height = height;

  n_grid_w = (int)(width/len_glid);
  n_grid_h = (int)(height/len_glid);

  ut_past = new float[n_grid_w][n_grid_h];
  ut_current = new float[n_grid_w][n_grid_h];
  ut_feature = new float[n_grid_w][n_grid_h];
  
  int pouring_x =  (int)(plx * n_grid_w);
  int pouring_y =  (int)(ply * n_grid_h);
  
  ut_feature[pouring_x][pouring_y] = 1;
   
  radius = max(window_height /n_grid_w, window_height /n_grid_h);
  
  count = 0;
}

void draw() {
    background(color_background);
    ellipseMode(RADIUS);
    noStroke();
    fill(color_focus);
    
    for (int x=0; x<n_grid_w; x++){
      for (int y=0; y<n_grid_h; y++){
          
        float aa = radius * (exp(3*ut_feature[x][y] - 1) - 1);
        
        if(mode_grid == 1){
          ellipse(radius*(x+0.5),radius*(y+0.5), aa, aa);
        }
        else if (mode_grid == 2) {
        fill(color_focus, alpha_weight * 100 * (exp(ut_current[x][y]) - 1 ));
        ellipse(radius*(x+0.5),radius*(y+0.5),radius/2, radius/2);                          
        }
        else {
        }

    }
  }
  if(count%interval ==0){
    update_simulation();
    count = 0;
  }
  count++;
}

void update_simulation()
{
  update_uts_value();
  calcurate_u_feature();
  set_boundary();
}

void calcurate_u_feature(){

  for (int x=1; x<n_grid_w-1; x++) {
    for (int y=1; y<n_grid_h-1; y++) {
      ut_feature[x][y] = 2*ut_current[x][y] - ut_past[x][y] +
                          s2*(calcurate_ux(x, y) + calcurate_uy(x, y));
    }
  }

}


float calcurate_ux(int x, int y){
  return ut_current[x+1][y]-2*ut_current[x][y]+ut_current[x-1][y];
}


float calcurate_uy(int x, int y){
  return ut_current[x][y+1]-2*ut_current[x][y]+ut_current[x][y-1];
}


void set_boundary(){

  for (int x=0; x<n_grid_w; x++){
    for (int y=0; y<n_grid_h; y++){

    //In x
    ut_feature[0][y] = 0;
    ut_feature[n_grid_w-1][y] = 0;

    //In y
    ut_feature[x][0] = 0;
    ut_feature[x][n_grid_h-1] = 0;
    }
  }
}

void update_uts_value(){
  
  for (int x=0; x<n_grid_w; x++){
    for (int y=0; y<n_grid_h; y++){
      ut_past[x][y] = ut_current[x][y];
      ut_current[x][y] = ut_feature[x][y];
    }
  }

}


