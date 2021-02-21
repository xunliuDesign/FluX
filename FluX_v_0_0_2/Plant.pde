public class Plants
{
/////////////////////////////////////////////////////////////////////////////////
//variables
/////////////////////////////////////////////////////////////////////////////////
    int maximumAge;
    int maximumSize;
    int reproduceRange;
    float reproduceProb;
    float minVelocitytoSeed;
    float maxVelocitytoDie;
    color seedCol;
    color matureCol;
    color deadCol;
    float growRate;
    int competitionRange;
    
    Kernel k, kSeeds;
    PVector loc;
    PVector vel;
    int w= viewportX;
    int h= viewportY;
    boolean drawIt = true; 
    int age=0;
    int deadAge=0;
    float size = 5;
    boolean Seeding = false;
    boolean IsAlive = true;
    boolean IsReproduce = false;
    float velocityScale=2f;
    boolean IsOutside=false;

/////////////////////////////////////////////////////////////////////////////////
//constructor
/////////////////////////////////////////////////////////////////////////////////
Plants(int _maximumAge, int _maximumSize, int _reproduceRange, float _reproduceProb, float _minVelocitytoSeed, float _maxVelocitytoDie,color _seedCol, color _matureCol, color _deadCol, float _growRate,int _competitionRange)
{  
  maximumAge=_maximumAge;
  maximumSize=_maximumSize;
  reproduceRange=_reproduceRange;
  reproduceProb=_reproduceProb;
  minVelocitytoSeed=_minVelocitytoSeed;
  maxVelocitytoDie=_maxVelocitytoDie;
  seedCol = _seedCol;
  matureCol =_matureCol;
  deadCol = _deadCol;
  growRate=_growRate;
  competitionRange=_competitionRange;
  createStart();
  
  k= new Kernel();
  k.isNotTorus();
  k.setNeighborhoodDistance(competitionRange);
  
  kSeeds= new Kernel();
  kSeeds.isNotTorus();
  kSeeds.setNeighborhoodDistance(2);
}
  
/////////////////////////////////////////////////////////////////////////////////
//functions
/////////////////////////////////////////////////////////////////////////////////  
void createStart(){
   loc = new PVector(mouseX, mouseY);
   vel = new PVector( 0, 0 );
}


void createRandomStart(){
    int randomX = (int) random( 0, 10 );
    int randomY = (int) random( 0, h );
    if (random(1)<0.5){
        loc = new PVector( randomX, randomY );
    }
    else{
       loc = new PVector( randomY, viewportY-randomX );
    }
    vel = new PVector( 0, 0 );
  }

  
void updateFlow(){        
      vel.x= velocityFieldX.get((int)loc.x/fluidgrid_scale,(int)loc.y/fluidgrid_scale)* velocityScale;
      vel.y= velocityFieldY.get((int)loc.x/fluidgrid_scale,(int)loc.y/fluidgrid_scale)* velocityScale;
      
      if(!Seeding){
          loc.x += vel.x;
          loc.y += vel.y;
        }     
  }
  
void drawMyself(){
      checkIfSeeding();
      checkIfAlive();
      if(IsAlive){
          if(Seeding && IsAlive){
              noFill();
              stroke(matureCol);
              strokeWeight(1);
              ellipse( loc.x, loc.y, size, size);
            }  
          else {
              fill(seedCol);
              noStroke();
              ellipse( loc.x, loc.y, size, size);
            }  
          }
      else {
              noFill();
              stroke(deadCol,100);
              strokeWeight(1);
              ellipse( loc.x, loc.y, size, size);
            }  
  }

void checkIfSeeding(){
      if(vel.mag()<minVelocitytoSeed){
        Seeding=true;
      }
    }

void checkIfAlive(){
       if(Seeding){
         if(vel.mag()>maxVelocitytoDie) IsAlive=false; 
         else if(age>maximumAge)IsAlive=false;
         else if(k.hasNeighbor(plantsMap,(int)loc.x,(int)loc.y,1)) IsAlive=false;
       }
       else if(!Seeding && kSeeds.hasNeighbor(seedsMap,(int)loc.x,(int)loc.y,1)) 
       {
         IsAlive =false;
         deadAge =21;
       }
    }
    
void checkIfReproduce(){
     if(random(0,1)<reproduceProb/100 && Seeding && IsAlive && age>20){
     IsReproduce=true;
   }
}

void grow(){
  checkIfSeeding();
  checkIfAlive();
  checkIfReproduce();
  if(!Seeding && !IsOutside)
  {
    seedsMap.put((int)loc.x,(int)loc.y,1);
  }
  if(Seeding && IsAlive && !IsOutside)
  { 
    age++;
    if(size<maximumSize ){
          size += growRate;
    }
    plantsMap.put((int)loc.x,(int)loc.y,1);
  }
  if(!IsAlive)deadAge++;
}

void checkEdge(){
  if(loc.x<1 || loc.x>viewportX-1 || loc.y<1 || loc.y> viewportY-1){
    IsOutside = true;
  }
}

}// end of class



void plants_1_PopDynamics(){
  for(int n =0; n< myPlants_1.size(); n++){
    Plants pTemp= myPlants_1.get(n);
    if(pTemp.IsReproduce){
      Plants babyPlants= new Plants
      (pTemp.maximumAge, pTemp.maximumSize, pTemp.reproduceRange, pTemp.reproduceProb,
      pTemp.minVelocitytoSeed, pTemp.maxVelocitytoDie,pTemp.seedCol, pTemp.matureCol, pTemp.deadCol, pTemp.growRate,pTemp.competitionRange); 
      
      babyPlants.loc.x=pTemp.loc.x+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      babyPlants.loc.y=pTemp.loc.y+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      
      myPlants_1.add(babyPlants);
    }
    if(pTemp.deadAge>20 ){
     myPlants_1.remove(n);
     n--;
    } 

  }
}

void plants_2_PopDynamics(){
  for(int n =0; n< myPlants_2.size(); n++){
    Plants pTemp= myPlants_2.get(n);
    if(pTemp.IsReproduce){
      Plants babyPlants= new Plants
      (pTemp.maximumAge, pTemp.maximumSize, pTemp.reproduceRange, pTemp.reproduceProb,
      pTemp.minVelocitytoSeed, pTemp.maxVelocitytoDie,pTemp.seedCol, pTemp.matureCol, pTemp.deadCol, pTemp.growRate,pTemp.competitionRange); 
      
      babyPlants.loc.x=pTemp.loc.x+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      babyPlants.loc.y=pTemp.loc.y+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      
      myPlants_2.add(babyPlants);
    }
    if(pTemp.deadAge>20  || pTemp.IsOutside){
     myPlants_2.remove(n);
     n--;
    } 
  }
}

void plants_3_PopDynamics(){
  for(int n =0; n< myPlants_3.size(); n++){
    Plants pTemp= myPlants_3.get(n);
    if(pTemp.IsReproduce){
      Plants babyPlants= new Plants
      (pTemp.maximumAge, pTemp.maximumSize, pTemp.reproduceRange, pTemp.reproduceProb,
      pTemp.minVelocitytoSeed, pTemp.maxVelocitytoDie,pTemp.seedCol, pTemp.matureCol, pTemp.deadCol, pTemp.growRate,pTemp.competitionRange); 
      
      babyPlants.loc.x=pTemp.loc.x+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      babyPlants.loc.y=pTemp.loc.y+random(-pTemp.reproduceRange,+pTemp.reproduceRange);
      
      myPlants_3.add(babyPlants);
    }
    if(pTemp.deadAge>20  || pTemp.IsOutside){
     myPlants_3.remove(n);
     n--;
    } 
  }
}