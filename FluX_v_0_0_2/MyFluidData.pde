class MyFluidData implements DwFluid2D.FluidData{
  
  @Override
  public void update(DwFluid2D fluid) {
    
/////////////////////////////////////////////////////////////////////////////////
//update method 1: using mouse press to add density&velocity
/////////////////////////////////////////////////////////////////////////////////
      
      // if(mousePressed){
      //    float px     = mouseX;
      //    float py     = viewportY-mouseY;
      //    float vx     = (mouseX - pmouseX) * +15;
      //    float vy     = (mouseY - pmouseY) * -15;
      //    fluid.addVelocity(px, py, 14, vx, vy);
      //    fluid.addDensity (px, py, 20, 0.0f, 0.4f, 1.0f, 1.0f);
      //    fluid.addDensity (px, py,  8, 1.0f, 1.0f, 1.0f, 1.0f);
      // }
          
/////////////////////////////////////////////////////////////////////////////////
//update method 2: add initial flow from left
/////////////////////////////////////////////////////////////////////////////////

    int fluidAddNumY = (int) viewportY / fluidgrid_scale;

    for(int i = 0 ; i < fluidAddNumY ; i++){
      fluid.addVelocity(fluidgrid_scale, i*fluidgrid_scale,fluidgrid_scale,20,0);
      fluid.addDensity( fluidgrid_scale, i*fluidgrid_scale,fluidgrid_scale,0.0f, 0.4f, 1.0f, 1.0f);
    }
    

/////////////////////////////////////////////////////////////////////////////////
//update method 3: add initial flow from left-bottom corner
/////////////////////////////////////////////////////////////////////////////////
    //int fluidAddNumX = (int) viewportX / fluidgrid_scale;
    //int fluidAddNumY = (int) viewportY / fluidgrid_scale;
    //for(int i = 0 ; i < fluidAddNumX ; i++){
    //  fluid.addVelocity(i*fluidgrid_scale, fluidgrid_scale,fluidgrid_scale,20,20);  
    //  fluid.addDensity(i*fluidgrid_scale, fluidgrid_scale,fluidgrid_scale,0.0f, 0.4f, 1.0f, 1.0f);
    //}
    //for(int i = 0 ; i < fluidAddNumY ; i++){
    //  fluid.addVelocity(fluidgrid_scale, i*fluidgrid_scale,fluidgrid_scale,20,20);
    //  fluid.addDensity( fluidgrid_scale, i*fluidgrid_scale,fluidgrid_scale,0.0f, 0.4f, 1.0f, 1.0f);
    //}
    
    
/////////////////////////////////////////////////////////////////////////////////
//more update method
/////////////////////////////////////////////////////////////////////////////////    
//in future, maybe the fluid direction can be set by mouse at first
// also the initial velocity and initial range....when I have time

  }
  //end of update
  
}//end of MyFluid Data class



void transformVelocityField(){
   for(int i=0; i<viewportX/fluidgrid_scale; i++){
     for(int j=0; j<viewportY/fluidgrid_scale; j++){
      int w_grid  = fluid.tex_velocity.src.w;
      int px_grid = i;
      int py_grid = viewportY/fluidgrid_scale - 1 - j;

      int PIDX    = py_grid * w_grid + px_grid;
      PIDX = constrain(PIDX, 0, (viewportY/fluid.grid_scale-1)*(viewportX/fluid.grid_scale-1));
      
      velocityFieldX.put(i,j, fluid_velocity[PIDX * 2 + 0]);
      velocityFieldY.put(i,j, -fluid_velocity[PIDX * 2 + 1]);
      velocityMag.put(i,j, sqrt(sq(velocityFieldX.get(i,j))+sq(velocityFieldY.get(i,j))));
     }
   }
}