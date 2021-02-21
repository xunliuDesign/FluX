/**
 * FluX
 * A hydrodynamics visualization and modeling tool for landscape designers
 * version 0.0.0
 *
 * by Xun Liu
 * 2016
 * MLA '17
 * Havard University Graduate School of Design
 *
 * Credit:
 * Kernel & Lattice class | by Robert Gerard Pietrusko, 2016 | GSD 6349 Mapping II : Geosimulation
 * PixelFlow              | by Thomas Diewald         , 2016 | http://thomasdiewald.com 
 * ControlP5              | by Andreas Schlegel       , 2012 | www.sojamo.de/libraries/controlp5
 */

/////////////////////////////////////////////////////////////////////////////////
//libraries
///////////////////////////////////////////////////////////////////////////////// 
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import com.thomasdiewald.pixelflow.java.fluid.DwFluidStreamLines2D;

import controlP5.*;


/////////////////////////////////////////////////////////////////////////////////
//variables
///////////////////////////////////////////////////////////////////////////////// 
    
    //input and output
    String inputConstruction = "data/obstacles/column.png";
    String inputTerrain      = "data/terrain/terrain.png";
    String outputPath        = "animation/IAmSuperCool_###";
    String floodDataPath     = "data/geoData/floodData.txt";   
    
    
    // fluid simulation
    DwPixelFlow context;
    DwFluid2D fluid;
    DwFluidStreamLines2D streamlines;                       
    MyFluidData cb_fluid_data;                              
    
    // render pgraphics
    PGraphics2D pg_fluid;                                   //render target
    PGraphics2D pg_density;                                 // texture-buffer, for adding fluid data
    PGraphics2D pg_velocity;                                // texture-buffer, for adding fluid data
    PGraphics2D pg_obstacles;

  
    // some state variables for the GUI/display
    int     fluidgrid_scale            = 10;                //grid size of analysis//large scale analysis needs larger number
    int     BACKGROUND_COLOR           = 0;
    boolean DISPLAY_MODE               = true;
    boolean UPDATE_FLUID               = true;
    boolean DISPLAY_FLUID_TEXTURES     = false;
    boolean DISPLAY_FLUID_VECTORS      = false;
    int     DISPLAY_fluid_texture_mode = 0;                 //render mode: density (0), temperature (1), pressure (2), velocity (3)
    boolean DISPLAY_STREAMLINES        = true;
    int     STREAMLINE_DENSITY         = 15;
    int     VELOCITY_VECTORS_DENSITY   = 10;
    int     contourElevationNumber     = 60;
    int     size_paint                 = 6;
    int     size_clear                 = 10;
    int     floodStep                  = 10;
    //toggle for agents simulation
    boolean simulateTerrain            =true;
    boolean simulateFloodDataforTerrain=false;
    boolean simulatePlant              =true;
    boolean simulateConstruction       =true;
    boolean output                     =false;
    boolean planting                   =false;
    boolean simulateSediment           =false;
    boolean pointDisplay               =true;

   
    ////////////////////////////////
    //my classes
    ////////////////////////////////
    ConstructionPainter   myConstruction;
    Terrain               myTerrain;
     
    //data storage
    float[] fluid_velocity;
    Lattice velocityFieldX, velocityFieldY, velocityMag;
    Lattice terrainElevation;
    Lattice plantsMap;
    Lattice seedsMap;
     
    //agents
    ArrayList<Plants> myPlants_1;
    ArrayList<Plants> myPlants_2;
    ArrayList<Plants> myPlants_3;
    
    //GUI
    ControlP5 cp5;
    DropdownList dropdownlist;
    Slider slider1;
    
    //size
    int simuX=120;
    int simuY=80;
    int viewportX=simuX*fluidgrid_scale;
    int viewportY=simuY*fluidgrid_scale;
    
    //plants
    int   speciesAmount = 3;
    int   plantIDX=0;
    int   [] maximumAge        = { 100, 150, 60 };
    int   [] maximumSize       = { 30 , 20 , 60 };
    int   [] reproduceRange    = {20,20,20};
    float [] reproduceProb     = {0.5,0.2,1};
    float [] minVelocitytoSeed = {0.2,0.2,0.2};
    float [] maxVelocitytoDie  = {1,1,1};
    color [] matureCol         = { color(0,200,0)  , color(200,200,0)   ,color(0,200,200) };
    color [] seedCol           = {color(0,255,0)   , color(255,255,0)  ,color(0,255,255) };
    color [] deadCol           = {color(0,100,0)    , color(100,100,0)     ,color(0,100,100)   };
    float [] growRate          = {0.1,0.1,0.1};
    int   [] competitionRange  = {10,20,30};
    
    int   maximumAgeTemp=100;
    int   maximumSizeTemp=30;
    int   reproduceRangeTemp=20;
    float reproduceProbTemp=0.5;
    float minVelocitytoSeedTemp=0.2;
    float maxVelocitytoDieTemp=1;
    float growRateTemp=0.1;
    int   competitionRangeTemp=10;
  
/////////////////////////////////////////////////////////////////////////////////
//setup
/////////////////////////////////////////////////////////////////////////////////
void settings(){
  size(viewportX,viewportY,P2D);
  smooth(4);
}

void setup() {

    // library context
    surface.setLocation(0, 0);
    context = new DwPixelFlow(this);
    streamlines = new DwFluidStreamLines2D(context);
    
    // fluid simulation
    fluid = new DwFluid2D(context, viewportX, viewportY, fluidgrid_scale);
    
    // some fluid parameters
    fluid.param.dissipation_velocity = 1f;
    fluid.param.dissipation_density  = 1f;

    // adding data to the fluid simulation
    // The fluid data can be changed in "MyFluidData class"
    cb_fluid_data = new MyFluidData();
    fluid.addCallback_FluiData(cb_fluid_data);
      
    // render-target
    pg_fluid     = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg_density   = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg_density.noSmooth();
    pg_density.beginDraw();
    pg_density.clear();
    pg_density.endDraw();
    pg_velocity  = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg_velocity.noSmooth();
    pg_velocity.beginDraw();
    pg_velocity.clear();
    pg_velocity.endDraw();
    pg_obstacles  = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg_obstacles.noSmooth();
    pg_obstacles.beginDraw();
    pg_obstacles.clear();
    pg_obstacles.endDraw();

    //velocity field
    velocityFieldX   =  new Lattice(viewportX/fluidgrid_scale,viewportY/fluidgrid_scale);
    velocityFieldY   =  new Lattice(viewportX/fluidgrid_scale,viewportY/fluidgrid_scale);
    velocityMag      =  new Lattice(viewportX/fluidgrid_scale,viewportY/fluidgrid_scale);
    terrainElevation =  new Lattice(viewportX/fluidgrid_scale,viewportY/fluidgrid_scale);
    plantsMap        =  new Lattice(viewportX, viewportY);
    seedsMap         =  new Lattice(viewportX, viewportY);
    

    //GUI
        createGUI();  
        
    ////////////////////////////////
    //my classes
    ////////////////////////////////
    myConstruction  = new ConstructionPainter();   
    myTerrain       = new Terrain();
    myTerrain.loadFloodData(floodDataPath);
    myPlants_1        = new ArrayList<Plants>(); 
    myPlants_2        = new ArrayList<Plants>();
    myPlants_3        = new ArrayList<Plants>();

    
    frameRate(20);
    
  }// end of setup
  
/////////////////////////////////////////////////////////////////////////////////
//draw
/////////////////////////////////////////////////////////////////////////////////
void draw() {   
    ////////////////////////////////
    // update simulation
    ////////////////////////////////
    
    if(UPDATE_FLUID){
      if (simulateTerrain){
        if(!simulateFloodDataforTerrain) myTerrain.cutContour(contourElevationNumber);
        else myTerrain.cutContourbyFloodData(floodStep);   //the number here is simulation rate. The larger the slower.
      }
      
      //add obstacles, include: terrain, construction, sediment
       pg_obstacles.beginDraw();
       pg_obstacles.blendMode(BLEND);
       pg_obstacles.clear();
       if (simulateTerrain){
         pg_obstacles.copy(myTerrain.output() ,0,0,viewportX,viewportY,0,0,viewportX,viewportY);
       }
       if (simulateConstruction){
         pg_obstacles.copy(myConstruction.output(),0,0,viewportX,viewportY,0,0,viewportX,viewportY);
       }
       pg_obstacles.endDraw();
      
      fluid.addObstacles(pg_obstacles);
      fluid.update();
    }
    
       fluid_velocity = fluid.getVelocity(fluid_velocity);
       transformVelocityField();

    
    ////////////////////////////////
    // clear render target
    ////////////////////////////////
    
    pg_fluid.beginDraw();
    pg_fluid.background(BACKGROUND_COLOR);
    pg_fluid.endDraw();
    
    ////////////////////////////////
    //display
    ////////////////////////////////
    
    if(DISPLAY_FLUID_TEXTURES){
      fluid.renderFluidTextures(pg_fluid, DISPLAY_fluid_texture_mode);
      if(DISPLAY_MODE) pg_fluid.filter(GRAY);
    }
 
    if(DISPLAY_FLUID_VECTORS){
      fluid.renderFluidVectors(pg_fluid, VELOCITY_VECTORS_DENSITY);
    }
    
    if(DISPLAY_STREAMLINES){
      streamlines.render(pg_fluid, fluid, STREAMLINE_DENSITY);
    }

    if(DISPLAY_MODE) pg_fluid.filter(INVERT);
    image(pg_fluid, 0, 0);
    image(pg_obstacles,0,0);
    if(simulateSediment&&frameCount>200){
        myTerrain.drawSedimentMap();
        myTerrain.updateTerrain();
    }
  
    ////////////////////////////////
    // agents
    ////////////////////////////////
    if(simulatePlant){
        
            plantsMap.clear();
            seedsMap .clear();
            if(planting){
               
               maximumAge         [plantIDX] = maximumAgeTemp;
               maximumSize        [plantIDX] = maximumSizeTemp;
               reproduceRange     [plantIDX] = reproduceRangeTemp;
               reproduceProb      [plantIDX] = reproduceProbTemp;
               minVelocitytoSeed  [plantIDX] = minVelocitytoSeedTemp;
               maxVelocitytoDie   [plantIDX] = maxVelocitytoDieTemp;
               growRate           [plantIDX] = growRateTemp;
               competitionRange   [plantIDX] = competitionRangeTemp;
               maximumAge         [plantIDX] = maximumAgeTemp;

              
               if(plantIDX==0) {
                 myPlants_1.add(new Plants(maximumAge[0],maximumSize[0],reproduceRange[0],
               reproduceProb[0],minVelocitytoSeed[0],maxVelocitytoDie[0],seedCol[0],matureCol[0],deadCol[0],growRate[0],competitionRange[0])); 
               }
               if(plantIDX==1){
                 myPlants_2.add(new Plants(maximumAge[1],maximumSize[1],reproduceRange[1],
               reproduceProb[1],minVelocitytoSeed[1],maxVelocitytoDie[1],seedCol[1],matureCol[1],deadCol[1],growRate[1],competitionRange[1])); 
               }
               if(plantIDX==2){
                 myPlants_3.add(new Plants(maximumAge[2],maximumSize[2],reproduceRange[2],
               reproduceProb[2],minVelocitytoSeed[2],maxVelocitytoDie[2],seedCol[2],matureCol[2],deadCol[2],growRate[2],competitionRange[2])); 
               }               
            }
        
            if(myPlants_1.size() > 0){
              for(Plants p : myPlants_1)
                { 
                  p.updateFlow();
                  p.grow();
                  p.drawMyself();
                }
              }
              
            if(myPlants_2.size() > 0){
              for(Plants p : myPlants_2)
                {
                  p.updateFlow();
                  p.grow();
                  p.drawMyself();
                }
              }
              
             if(myPlants_3.size() > 0){
              for(Plants p : myPlants_3)
                {
                  p.updateFlow();
                  p.grow();
                  p.drawMyself();
                }
              }
            plants_1_PopDynamics();
            plants_2_PopDynamics();
            plants_3_PopDynamics();
          

      }//end of simulatePlants
    
    myConstruction.displayBrush(this.g);
    ////////////////////////////////
    // info
    ////////////////////////////////
    
    String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", fluid.fluid_w, fluid.fluid_h, fluid.simulation_step, frameRate);
    surface.setTitle(txt_fps);
    
    if(output){
    saveFrame(cp5.get(Textfield.class,"Output").getText());
    }
    
    
  }// end of draw
  