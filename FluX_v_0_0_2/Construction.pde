public class ConstructionPainter
{
/////////////////////////////////////////////////////////////////////////////////
//variables
/////////////////////////////////////////////////////////////////////////////////
  int draw_mode = 0;                        //draw mode: not drawing (0), adding obstacles (1), removing obstacles (2)
  PGraphics2D pg;
  float paint_x, paint_y;
  float clear_x, clear_y;
  color shading = color(200,200,200);
  color colStroke = color(255,0,0);
  float strokesize =2;
  PImage imgConstruction;


/////////////////////////////////////////////////////////////////////////////////
//constructor
/////////////////////////////////////////////////////////////////////////////////
ConstructionPainter()
{
    pg = (PGraphics2D) createGraphics(viewportX, viewportY, P2D);
    pg.smooth(4);
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    
    imgConstruction = loadImage(cp5.get(Textfield.class,"Input Construction").getText());
    imgConstruction.resize(viewportX,viewportY);
    pg.copy(imgConstruction,0,0,viewportX,viewportY,0,0,viewportX,viewportY); 
}

/////////////////////////////////////////////////////////////////////////////////
//functions : drawing/removing obstacles
/////////////////////////////////////////////////////////////////////////////////  

public void drawingReset(){
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    
    imgConstruction = loadImage(cp5.get(Textfield.class,"Input Construction").getText());
    imgConstruction.resize(viewportX,viewportY);
    pg.copy(imgConstruction,0,0,viewportX,viewportY,0,0,viewportX,viewportY);  
}

public void beginDraw(int mode){
      paint_x = mouseX;
      paint_y = mouseY;
      this.draw_mode = mode;
      if(mode == 1){
        pg.beginDraw();
        pg.blendMode(REPLACE);
        pg.strokeWeight(strokesize);
        pg.stroke(colStroke);
        //pg.noStroke();
        pg.fill(shading);
        pg.ellipse(mouseX, mouseY, size_paint, size_paint);
        pg.endDraw();
      }
      if(mode == 2){
        clear(mouseX, mouseY);
      }
    }
    
public boolean isDrawing(){
      return draw_mode != 0;
    }
    
public void continueDraw(){
      paint_x = mouseX;
      paint_y = mouseY;

      if(draw_mode == 1){
        pg.beginDraw();
        pg.blendMode(REPLACE);
        pg.strokeWeight(size_paint);
        pg.stroke(shading);
        pg.line(mouseX, mouseY, pmouseX, pmouseY);
        pg.endDraw();
      }
      if(draw_mode == 2){
        clear(mouseX, mouseY);
      }
    }

public void endDraw(){
      this.draw_mode = 0;
    }
    
public void clear(float x, float y){
      clear_x = x;
      clear_y = y;
      pg.beginDraw();
      pg.blendMode(REPLACE);
      pg.noStroke();
      pg.fill(0, 0);
      pg.ellipse(x, y, size_clear, size_clear);
      pg.endDraw();
    }
    
public void displayBrush(PGraphics dst){
      if(draw_mode == 1){
        dst.strokeWeight(1);
        dst.stroke(0);
        dst.fill(255,50,50);
        dst.ellipse(paint_x, paint_y, size_paint, size_paint);
      }
      if(draw_mode == 2){
        dst.strokeWeight(1);
        dst.stroke(200);
        dst.fill(200,100);
        dst.ellipse(clear_x, clear_y, size_clear, size_clear);
      }
    }
    
public PGraphics2D output(){
  return pg;
}

}// end of class