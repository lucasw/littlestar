

class Object
{
  float vx;
  float vy;
  
  float x;
  float y;

  int wd;
  int ht;

  float friction;

  boolean limit_xy;

  float xlim_pos;
  float xlim_neg;
  float ylim_pos;
  float ylim_neg;

  void update()
  {
    x += vx;
    y += vy;
    vx *= 1.0 - friction;
    vy *= 1.0 - friction;

    if (limit_xy) {

      if (x < xlim_neg) {
        x = xlim_neg; 
      }
      if (x > xlim_pos) {
        x = xlim_pos; 
      }
      if (y < ylim_neg) {
        y = -ht/2; 
      }
      if (y > ylim_pos) {
        y = ylim_pos; 
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


    ylim_pos = height - ht/2;
    ylim_neg = -ht/2;

    xlim_pos = width - wd/2;
    xlim_neg = -wd/2;

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
    little_star = new Star[40];

    for (int i = 0; i < little_star.length; i++) {
      //if ( i < little_star.length*0.9)
      little_star[i] = new Star("star_bg2_px.png", false);
      //else
      //little_star[i] = new Star("star_bg_px.png", false);

      little_star[i].x = random(width);
      little_star[i].y = 7 * random(height/10);

      little_star[i].vx = -0.5;
    }

    houses = new Star[5];

    for (int i = 0; i < houses.length; i++) {
      houses[i] = new Star("house_px.png", false);
      houses[i].vx = -1.0;
      houses[i].x = random(width);
      houses[i].y = 6*height/10;
    }

  }

  void draw()
  {

    background(0,0,30);
    for (int i = 0; i < little_star.length; i++) { 
      //little_star[i].x -= 1;
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
Star dog;
Background background;

//////////////////////////////////////
void setup()
{
  size(1280, 720);
  //size(640, 360); //, P3D);
  int wd = width/4;
  int ht = height/4;
  println(str(wd) + ' ' + str(ht)); 

  star = new Star("star_px.png", true);
  star.friction = 0.2;

  dog = new Star("dog_px.png", true);
  dog.friction = 0.3;
  dog.ylim_neg = 5*height/10;
  dog.y = dog.ylim_neg;

  background = new Background();
  //    ((PGraphicsOpenGL)g).textureSampling(0);
  //hint(DISABLE_TEXTURE_MIPMAPS);

  frameRate(15);
}

void keyPressed()
{
  float mv_size = 3;
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
  dog.draw();

  //saveFrame("littlestar-####.png");

}

