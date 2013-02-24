


class Star
{
int x;
int y;

PImage im;

boolean limit_xy;

Star(String name, boolean do_limit_xy)
{
  limit_xy = do_limit_xy;
  im = loadImage(name);
}

void draw()
{
  if (star.x < -im.width/2) {
    star.x = -im.width/2; 
  }
  if (star.x > width - im.width/2) {
    star.x = width - im.width/2; 
  }
  if (star.y < -im.height/2) {
    star.y = -im.height/2; 
  }
  if (star.y > height - im.height/2) {
    star.y = height - im.height/2; 
  }
  
  image(im, x, y, im.width, im.height);
}

};

class Background
{
  Star[] little_star;
  
  Background()
  {
    little_star = new Star[50];
    
    for (int i = 0; i < little_star.length; i++) {
      if ( i < little_star.length*0.9)
      little_star[i] = new Star("star_bg2_px.png", false);
      else
      little_star[i] = new Star("star_bg_px.png", false);
      
      little_star[i].x = (int)random(width);
      little_star[i].y = (int)random(height);
    }
    
  }
  
  void draw()
  {
    background(0,0,30);
    for (int i = 0; i < little_star.length; i++) { 
      little_star[i].x -= 1;
      if (little_star[i].x < -little_star[i].im.width) {
        little_star[i].x = width;
        little_star[i].y = (int)random(height);
      }
      
      if (random(1000) < 990)
      little_star[i].draw();
    }
    
  }
  
} // Background

Star star;
Background background;

//////////////////////////////////////
void setup()
{
  //size(1280, 720);
  size(640, 360); //, P3D);
  int wd = width/4;
  int ht = height/4;
  println(str(wd) + ' ' + str(ht)); 

  star = new Star("star_px.png", true);
  background = new Background();
  //    ((PGraphicsOpenGL)g).textureSampling(0);
  //hint(DISABLE_TEXTURE_MIPMAPS);

  frameRate(15);
}

void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      star.y -= 8;
    } 
    else if (keyCode == DOWN) {
      star.y += 8; 
    } 
    if (keyCode == LEFT) {
      star.x -= 8; 
    } 
    else if (keyCode == RIGHT) {
      star.x += 8; 
    }
    
  }
}
void draw()
{
  background.draw();
  star.draw();
 
}
