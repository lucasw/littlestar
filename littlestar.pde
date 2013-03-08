

class Object
{
  float vx;
  float vy;
  
int x;
int y;

int wd;
int ht;

boolean limit_xy;
  
  void update()
  {
    x += vx;
  y += vy;
  vx *= 0.8;
  vy *= 0.8;
    
  if (limit_xy) {
  if (x < -wd/2) {
     x = -wd/2; 
  }
  if (x > width - wd/2) {
    x = width - wd/2; 
  }
  if (y < -ht/2) {
    y = -ht/2; 
  }
  if (y > height - ht/2) {
    y = height - ht/2; 
  }
  
  }
  
  }// draw
};

class Star extends Object
{

PImage im;

Star(String name, boolean do_limit_xy)
{
  limit_xy = do_limit_xy;
  im = loadImage(name);
  
  wd = im.width;
  ht = im.height;
}

void draw()
{
  update();
  
  image(im, x, y, im.width, im.height);
}

};

class Background
{
  Star[] little_star;
  
  Star[] houses;
  
  Background()
  {
    little_star = new Star[50];
    
    for (int i = 0; i < little_star.length; i++) {
      //if ( i < little_star.length*0.9)
      little_star[i] = new Star("star_bg2_px.png", false);
      //else
      //little_star[i] = new Star("star_bg_px.png", false);
      
      little_star[i].x = (int)random(width);
      little_star[i].y = 8*(int)random(height/10);
    }
    
    houses = new Star[5];
    
    for (int i = 0; i < houses.length; i++) {
      houses[i] = new Star("house_px.png", false);
      houses[i].x = (int)random(width);
      houses[i].y = 6*height/10;
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
    
    for (int i = 0; i < houses.length; i++) { 
    houses[i].draw();
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
  float mv_size = 2;
  if (key == CODED) {
    if (keyCode == UP) {
      star.vy -= mv_size;
    } 
    else if (keyCode == DOWN) {
      star.vy += mv_size; 
    } 
    if (keyCode == LEFT) {
      star.vx -= mv_size; 
    } 
    else if (keyCode == RIGHT) {
      star.vx += mv_size; 
    }
    
  }
}
void draw()
{
  background.draw();
  star.draw();
 
}
