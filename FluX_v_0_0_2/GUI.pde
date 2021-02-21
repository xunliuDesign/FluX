  
  
  public void createGUI(){
    cp5 = new ControlP5(this);
    
    int sx, sy, px, py, oy;
    
    sx = 100; sy = 14; oy = (int)(sy*1.5f);
    
     int gui_w = 200;
     int gui_x = viewportX-gui_w;
     int gui_y = 0;
     color GUIBackgroundCol = color(16, 180);
    

    ////////////////////////////////////////////////////////////////////////////
    // GUI - FLUID
    ////////////////////////////////////////////////////////////////////////////
    Group group_fluid = cp5.addGroup("fluid");
    {
      group_fluid.setHeight(20).setSize(gui_w, 300)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_fluid.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
      cp5.addButton("Fluid Reset").setGroup(group_fluid).plugTo(this, "fluid_reset"     ).setSize(80, 18).setPosition(px    , py);
      cp5.addButton("+"          ).setGroup(group_fluid).plugTo(this, "fluid_resizeUp"  ).setSize(39, 18).setPosition(px+=82, py);
      cp5.addButton("-"          ).setGroup(group_fluid).plugTo(this, "fluid_resizeDown").setSize(39, 18).setPosition(px+=41, py);
      
      px = 10;
     
      cp5.addSlider("velocity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
          .setRange(0, 1).setValue(fluid.param.dissipation_velocity).plugTo(fluid.param, "dissipation_velocity");
      
      cp5.addSlider("density").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 1).setValue(fluid.param.dissipation_density).plugTo(fluid.param, "dissipation_density");
      
      cp5.addSlider("temperature").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 1).setValue(fluid.param.dissipation_temperature).plugTo(fluid.param, "dissipation_temperature");
      
      cp5.addSlider("vorticity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 1).setValue(fluid.param.vorticity).plugTo(fluid.param, "vorticity");
          
      cp5.addSlider("iterations").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 80).setValue(fluid.param.num_jacobi_projection).plugTo(fluid.param, "num_jacobi_projection");
            
      cp5.addSlider("timestep").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 1).setValue(fluid.param.timestep).plugTo(fluid.param, "timestep");
          
      cp5.addSlider("gridscale").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(0, 50).setValue(fluid.param.gridscale).plugTo(fluid.param, "gridscale");
      
      RadioButton rb_setFluid_DisplayMode = cp5.addRadio("fluid_displayMode").setGroup(group_fluid).setSize(80,18).setPosition(px, py+=(int)(oy*1.5f))
          .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(2)
          .addItem("Density"    ,0)
          .addItem("Temperature",1)
          .addItem("Pressure"   ,2)
          .addItem("Velocity"   ,3)
          .activate(DISPLAY_fluid_texture_mode);
      for(Toggle toggle : rb_setFluid_DisplayMode.getItems()) toggle.getCaptionLabel().alignX(CENTER);
      
      cp5.addRadio("fluid_displayVelocityVectors").setGroup(group_fluid).setSize(18,18).setPosition(px, py+=(int)(oy*2.5f))
          .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
          .addItem("Velocity Vectors", 0)
          .activate(DISPLAY_FLUID_VECTORS ? 0 : 2);
    }
    
    
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - STREAMLINES
    ////////////////////////////////////////////////////////////////////////////
    Group group_streamlines = cp5.addGroup("streamlines");
    {
      group_streamlines.setHeight(20).setSize(gui_w, 150)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_streamlines.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
      cp5.addSlider("line density").setGroup(group_streamlines).setSize(sx, sy).setPosition(px, py)
          .setRange(5, 20).setValue(STREAMLINE_DENSITY).plugTo(this, "STREAMLINE_DENSITY");
      
      cp5.addSlider("line length").setGroup(group_streamlines).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(5, 300).setValue(streamlines.param.line_length).plugTo(streamlines.param, "line_length");
      
      cp5.addSlider("Velocity scale").setGroup(group_streamlines).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(1, 50).setValue(streamlines.param.velocity_scale).plugTo(streamlines.param, "velocity_scale");
      
      cp5.addSlider("Velocity min").setGroup(group_streamlines).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(1, 200).setValue(streamlines.param.velocity_min).plugTo(streamlines.param, "velocity_min");
      
      cp5.addRadio("streamlines_displayStreamlines").setGroup(group_streamlines).setSize(18,18).setPosition(px, py+=(int)(oy*1.5f))
          .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
          .addItem("StreamLines", 0)
          .activate(DISPLAY_STREAMLINES ? 0 : 2);
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - TERRAIN
    ////////////////////////////////////////////////////////////////////////////
    Group group_terrain = cp5.addGroup("TERRAIN");
    {
      group_terrain.setHeight(20).setSize(gui_w, 140)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_terrain.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
      cp5.addRadio("toggleTerrain").setGroup(group_terrain).setSize(18,18).setPosition(px, py)
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("terrain", 0)
      .activate(simulateTerrain ? 0 : 2);
      
      
      cp5.addSlider("CONTOUR").setGroup(group_terrain).setSize(sx-50,sy).setPosition(px+90, py)
          .setRange(20, 200).setValue(contourElevationNumber).plugTo(this, "contourElevationNumber");
          
      cp5.addRadio("toggleFloodData").setGroup(group_terrain).setSize(18,18).setPosition(px,py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("FloodData", 0)
      .activate(simulateFloodDataforTerrain ? 0 : 2);
      
      cp5.addSlider("floodstep").setGroup(group_terrain).setSize(sx-50,sy).setPosition(px+90, py)
      .setRange(1, 50).setValue(floodStep).plugTo(this, "floodStep");
      
      cp5.addRadio("toggleSediment").setGroup(group_terrain).setSize(18,18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("sediment", 0)
      .activate(simulateSediment ? 0 : 2);
      
      cp5.addButton("Sediment Reset").setGroup(group_terrain).plugTo(this, "sedimentReset").setSize(80, 18).setPosition(px+90,py);
      
      cp5.addRadio("togglePointDisplay").setGroup(group_terrain).setSize(18,18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Point Visualization", 0)
      .activate(pointDisplay ? 0 : 2);
      
      cp5.addButton("Terrain Reset").setGroup(group_terrain).plugTo(this, "terrainReset").setSize(80, 18).setPosition(px+90,py);
    }
    
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - DRAW
    //////////////////////////////////////////////////////////////////////////// 
    Group group_draw = cp5.addGroup("draw");
    {
      group_draw.setHeight(20).setSize(gui_w, 140)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_draw.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
      cp5.addTextlabel("label1").setText("Right click mouse to draw your intervention.")
      .setGroup(group_draw).setPosition(px, py);
      
      cp5.addTextlabel("label2").setText("Left  click mouse to erase your intervention.")
      .setGroup(group_draw).setPosition(px, py+=(int)(oy));
      
      cp5.addRadio("toggleConstruction").setGroup(group_draw).setSize(18,18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Construction", 0)
      .activate(simulateTerrain ? 0 : 2);
      
      cp5.addButton("Drawing Reset").setGroup(group_draw).plugTo(this, "drawingReset"     ).setSize(80, 18).setPosition(px+80,py);
     
      cp5.addSlider("paintSize").setGroup(group_draw).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
          .setRange(2, 20).setValue(size_paint).plugTo(this, "size_paint");
      
      cp5.addSlider("clearSize").setGroup(group_draw).setSize(sx, sy).setPosition(px, py+=oy)
          .setRange(2, 40).setValue(size_clear).plugTo(this, "size_clear");
   
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - PLANTING
    //////////////////////////////////////////////////////////////////////////// 
    Group group_planting = cp5.addGroup("planting");
    {
      group_planting.setHeight(20).setSize(gui_w, 440)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_planting.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
       cp5.addTextlabel("label3").setText("Center click mouse to plant your tree.").setGroup(group_planting).setPosition(px, py);
       
       cp5.addTextlabel("label4").setText("Set species & properties before planting.").setGroup(group_planting).setPosition(px, py+=(int)(oy));
      
       cp5.addRadio("togglePlanting").setGroup(group_planting).setSize(18,18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Planting", 0)
      .activate(simulatePlant ? 0 : 2);
      
       cp5.addButton("Plants Reset").setGroup(group_planting).plugTo(this, "plantsReset").setSize(80, 18).setPosition(px+80,py);
       
       cp5.addSlider("maximumAge").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(10, 200).setValue(maximumAge[plantIDX]).plugTo(this, "maximumAge[plantIDX]");
      
       cp5.addSlider("maximumSize").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(10, 200).setValue(maximumSize[plantIDX]).plugTo(this, "maximumSize[plantIDX]");
      
       cp5.addSlider("reproduceRange").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(10, 200).setValue(reproduceRange[plantIDX]).plugTo(this, "reproduceRange[plantIDX]");
      
       slider1=cp5.addSlider("reproduceProb").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 2).setValue(reproduceProb[plantIDX]).plugTo(this, "reproduceProbTemp");
      
       cp5.addSlider("minVelocitytoSeed").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 1).setValue(minVelocitytoSeed[plantIDX]).plugTo(this, "minVelocitytoSeed[plantIDX]");
      
       cp5.addSlider("maxVelocitytoDie").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 5).setValue(maxVelocitytoDie[plantIDX]).plugTo(this, "maxVelocitytoDie[plantIDX]");
      
       cp5.addSlider("growRate").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 1).setValue(growRate[plantIDX]).plugTo(this, "growRate[plantIDX]");
      
       cp5.addSlider("competitionRange").setGroup(group_planting).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 50).setValue(competitionRange[plantIDX]).plugTo(this, "competitionRange[plantIDX]");
      
          
       dropdownlist= cp5.addDropdownList("myList").setGroup(group_planting).setSize(100,100).setPosition(px, py+=(int)(oy*1.5f))
       .setItemHeight(20).setBarHeight(15).plugTo(this,"plantIDX").close();
       dropdownlist.getCaptionLabel().set("select species");
       for (int i=0;i<speciesAmount;i++) {
            dropdownlist.addItem("species "+(i+1), i);
         }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - input and output
    ////////////////////////////////////////////////////////////////////////////

    Group group_text = cp5.addGroup("Input & Output");{
      group_text.setHeight(20).setSize(gui_w, 200)
      .setBackgroundColor(GUIBackgroundCol).setColorBackground(GUIBackgroundCol);
      group_text.getCaptionLabel().align(CENTER, CENTER);
      
      px = 10; py = 15;
      
      cp5.addTextfield("Input Construction").setGroup(group_text).setPosition(px, py)
      .setValue(inputConstruction).setAutoClear(false);
      
      cp5.addTextfield("Input Terrain").setGroup(group_text).setPosition(px,  py+=(int)(oy*2f))
      .setValue(inputTerrain).setAutoClear(false);
      
      cp5.addTextfield("Output").setGroup(group_text).setPosition(px,  py+=(int)(oy*2f))
      .setValue(outputPath).setAutoClear(false);
      
      cp5.addRadio("toggleRecording").setGroup(group_text).setSize(18,18).setPosition(px, py+=(int)(oy*2f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Recording", 0)
      .activate(output ? 0 : 2);

      
       
      
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // GUI - ACCORDION
    ////////////////////////////////////////////////////////////////////////////
    cp5.addAccordion("acc").setPosition(gui_x, gui_y).setWidth(gui_w).setSize(gui_w, viewportY)
      .setCollapseMode(Accordion.MULTI)
      .addItem(group_fluid)
      .addItem(group_streamlines)
      .addItem(group_terrain)
      .addItem(group_draw)
      .addItem(group_planting)
      .addItem(group_text);
   
  }
}
  
  
    
/////////////////////////////////////////////////////////////////////////////////
//mouse and key
/////////////////////////////////////////////////////////////////////////////////

void mousePressed(){
    boolean mouse_input = !cp5.isMouseOver() && mousePressed && !myConstruction.isDrawing();
    if(mouse_input){
        if(mouseButton == LEFT   ) myConstruction.beginDraw(1); // add obstacles
        if(mouseButton == RIGHT  ) myConstruction.beginDraw(2); // remove obstacles
        if(mouseButton == CENTER ) planting = true; 
    }
  }
  
void mouseDragged(){
    myConstruction.continueDraw();
  }
  
void mouseReleased(){
    myConstruction.endDraw();
    planting = false;
  } 
  
  public void fluid_resizeUp(){
    fluid.param.dissipation_velocity +=0.1f;
    fluid.param.dissipation_velocity= constrain(fluid.param.dissipation_velocity,0.11,1);
    println(fluid.param.dissipation_velocity);
  }
  public void fluid_resizeDown(){
    fluid.param.dissipation_velocity -=0.1f;
    fluid.param.dissipation_velocity= constrain(fluid.param.dissipation_velocity,0.11,1);
    println(fluid.param.dissipation_velocity);
  }
  public void fluid_reset(){
    fluid.reset();
  }
  public void fluid_togglePause(){
    UPDATE_FLUID = !UPDATE_FLUID;
  }
  public void fluid_displayMode(int val){
    DISPLAY_fluid_texture_mode = val;
    DISPLAY_FLUID_TEXTURES = DISPLAY_fluid_texture_mode != -1;
    
  }
  public void fluid_displayVelocityVectors(int val){
    DISPLAY_FLUID_VECTORS = val != -1;
  }

  public void streamlines_displayStreamlines(int val){
    DISPLAY_STREAMLINES = val != -1;
  }
  public void drawingReset(){
    myConstruction.drawingReset();
  }
  public void toggleTerrain(int val){
    simulateTerrain = val != -1;
  }
  public void toggleConstruction(int val){
   simulateConstruction = val != -1; 
  }
  public void togglePlanting(int val){
   simulatePlant = val != -1; 
  }
  public void plantsReset(){
    if(plantIDX==0) myPlants_1.clear();
    if(plantIDX==1) myPlants_2.clear();
    if(plantIDX==2) myPlants_3.clear();
  }
  public void toggleFloodData (int val){
    simulateFloodDataforTerrain = val != -1;
  }
  public void toggleSediment(int val){
   simulateSediment= val !=-1; 
  }
  public void sedimentReset(){
    myTerrain.resetSediment();
  }
  public void terrainReset(){
    myTerrain.resetTerrain();
  }
  public void toggleRecording(int val){
    output = val != -1;
  }
  public void togglePointDisplay(int val){
    pointDisplay =val != -1; 
  }
  
  //public void keyReleased(){
  //  if(key == 's') fluid_togglePause(); // pause / unpause simulation
  //  if(key == '+') fluid_resizeUp();    // increase fluid-grid resolution
  //  if(key == '-') fluid_resizeDown();  // decrease fluid-grid resolution
  //  if(key == 'r') fluid_reset();       // restart simulation
        
  //  if(key == 'o') { 
  //       output =!output;    
  //      if(output) println("recording on");
  //      if(!output) println("recording off");
  //    }

    
  //  if(key == '1') DISPLAY_fluid_texture_mode = 0; // density
  //  if(key == '2') DISPLAY_fluid_texture_mode = 1; // temperature
  //  if(key == '3') DISPLAY_fluid_texture_mode = 2; // pressure
  //  if(key == '4') DISPLAY_fluid_texture_mode = 3; // velocity
    
  //  if(key == 'q') DISPLAY_FLUID_TEXTURES = !DISPLAY_FLUID_TEXTURES;
  //  if(key == 'w') DISPLAY_FLUID_VECTORS  = !DISPLAY_FLUID_VECTORS;
  //  if(key == 'e') DISPLAY_STREAMLINES    = !DISPLAY_STREAMLINES;
    
  //  if(key == 't') simulateTerrain        = !simulateTerrain;
  //  if(key == 'p') simulatePlant          = !simulatePlant;
  //  if(key == 'c') simulateConstruction   = !simulateConstruction;
    
  //  if(key == ']') contourElevationNumber++;
  //  if(key == '[') contourElevationNumber--;
    
  //}
  