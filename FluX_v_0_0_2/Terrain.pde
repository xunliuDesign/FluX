public class Terrain
{
/////////////////////////////////////////////////////////////////////////////////
//variables
/////////////////////////////////////////////////////////////////////////////////

//Now there is some problem with terrain data
//Because I transformed from asc file to image and lost the elevation data at the beginning
//I should use asc file directly....in future
//But it is just an idea to show that terrain can be changed by sedimentation and flooding

    PGraphics2D pg;
    PImage imgDem;
    PImage imgContour;
    PImage imgSediment;
    PImage imgVis;
    int contourElevationNumber;
    float [] myFloodData;
    int floodSimulationRate;
    int sedimentSimulationRate=3;
    Lattice terrainElevation;
    float minVelocityforSiltation=0.1;
    float maxVelocityforErrosion=50;
    

/////////////////////////////////////////////////////////////////////////////////
//constructor
/////////////////////////////////////////////////////////////////////////////////
Terrain(){
    pg = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg.smooth(4);
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    imgDem = loadImage(cp5.get(Textfield.class,"Input Terrain").getText());
    imgDem.resize(viewportX,viewportY);
    terrainElevation =  new Lattice(viewportX/fluidgrid_scale,viewportY/fluidgrid_scale);
    imgSediment= new PImage();
    imgVis = new PImage();
}


/////////////////////////////////////////////////////////////////////////////////
//function  : cutContour
/////////////////////////////////////////////////////////////////////////////////  
public void cutContour(int _contourElevationNumber){
    imgContour=createImage(viewportX,viewportY,ARGB);
    imgVis=createImage(viewportX,viewportY,ARGB);
    contourElevationNumber = _contourElevationNumber;
    imgDem.loadPixels();
    imgContour.loadPixels();
    imgVis.loadPixels();
    for(int i = 0; i<imgDem.pixels.length;i++){
      float elevationHere=(red(imgDem.pixels[i])+green(imgDem.pixels[i])+blue(imgDem.pixels[i]))/3;
      if(elevationHere>contourElevationNumber)
      {
       imgContour.pixels[i]=imgDem.pixels[i];
       int x= i%viewportX;
       int y =round(i/viewportX);
       if(x%3==0 && y%3==0){
          imgVis.pixels[i]=imgDem.pixels[i];
       }
       else imgVis.pixels[i]=color(255);
      }
    }
}


/////////////////////////////////////////////////////////////////////////////////
//function : output 
///////////////////////////////////////////////////////////////////////////////// 
public PGraphics2D output(){
    pg.beginDraw();
    pg.clear();
    if(pointDisplay){
      pg.copy(imgVis,0,0,viewportX,viewportY,0,0,viewportX,viewportY); 
    }
    else
      pg.copy(imgContour,0,0,viewportX,viewportY,0,0,viewportX,viewportY); 
    pg.endDraw();
 return pg; 
}


public void loadFloodData(String _floodDataPath){
  String[] FloodData= loadStrings(_floodDataPath);
  myFloodData= new float[FloodData.length];
  for(int i =0;i<FloodData.length;i++)
  {
    FloodData[i]=FloodData[i].replace("'","");
    myFloodData[i]=float(FloodData[i]);
  } 
}


public void cutContourbyFloodData(int _floodSimulationRate){
   floodSimulationRate=_floodSimulationRate; 
   int n=round(frameCount/floodSimulationRate);
   int n_loop=n % myFloodData.length;
   //float ctEle=myFloodData[n];
   //This part is added because the elevation is not real data,after it changed to real data ,this needs to be changed too
   float ctEle=(myFloodData[n_loop]-50)*5;
   cutContour((int)ctEle);
}

//public void InitializeTerrainData(Lattice _terrainElevation){
//  terrainElevation=_terrainElevation;
//  imgDem.loadPixels();
//  for(int i=0; i < terrainElevation.w; i++){
//   for(int j=0; j < terrainElevation.h; j++){
//     int ID = j*terrainElevation.w+i;
//     float elevationHere=(red(imgDem.pixels[ID])+green(imgDem.pixels[ID])+blue(imgDem.pixels[ID]))/3;
//     terrainElevation.put(i,j,elevationHere);
//   }
//  }
//}

void Siltation(){
 for(int i=0; i < terrainElevation.w; i++){
   for(int j=0; j < terrainElevation.h; j++){
     if(velocityMag.get(i,j)< minVelocityforSiltation && velocityMag.get(i,j)!=0){
      terrainElevation.increment(i,j); 
     }
   }
  }
}

void Errosion(){
   for(int i=0; i < terrainElevation.w; i++){
   for(int j=0; j < terrainElevation.h; j++){
     if(velocityMag.get(i,j)> maxVelocityforErrosion && velocityMag.get(i,j)<100){
      terrainElevation.decrement(i,j); 
     }
   }
  }
}

void drawSedimentMap(){
  if(frameCount%sedimentSimulationRate==0){
  Siltation();
  Errosion();
  imgSediment= terrainElevation.updatePImage(-100,100);
  imgSediment.resize(viewportX, viewportY);
  }
}

void updateTerrain(){
    imgDem.loadPixels();
    imgSediment.loadPixels();
    for(int i = 0; i<imgSediment.pixels.length;i++){
      float sedHere=(red(imgSediment.pixels[i])+green(imgSediment.pixels[i])+blue(imgSediment.pixels[i]))/3;
      float eleHere=(red(imgDem.pixels[i])+green(imgDem.pixels[i])+blue(imgDem.pixels[i]))/3;
      if(sedHere > 150 && eleHere < sedHere)
      {
       eleHere += 1;
       imgDem.pixels[i]=color(eleHere,eleHere,eleHere);
      }
    } 
}
  
void resetSediment(){
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    imgDem = loadImage(inputTerrain);
    imgDem.resize(viewportX,viewportY);
    imgSediment= new PImage();
    terrainElevation.clear();
}

void resetTerrain(){
    imgDem = loadImage(cp5.get(Textfield.class,"Input Terrain").getText());
    imgDem.resize(viewportX,viewportY);
}



  
}// end of class