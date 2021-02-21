ASCgrid dem;
PImage imgDem;

void setup(){
 size(1000,1000); 
 dem= new ASCgrid("houston.asc");
 imgDem=dem.updateImage();
 imgDem.resize(height,width);

}


void draw(){
  image(imgDem,0,0);
  
  if(mousePressed){
        if(mouseButton == CENTER){
          saveFrame("out/IAmSuperCool_###");
        }
  }
  
}