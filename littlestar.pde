
float tm = 0;

// make sprites 2x smaller
int sc = 2;

class Movable
{
  float ax;
  float ay;
  
  float vx;
  float vy;
  
  float x;
  float y;

  int wd;
  int ht;

  float friction;

  boolean limit_xy;
  boolean lock_vx;

  float xlim_pos;
  float xlim_neg;
  float ylim_pos;
  float ylim_neg;

  void update()
  {
    x += vx;
    y += vy;

    if (!lock_vx) {
      vx += ax;
      vx *= 1.0 - friction;
    }

    vy += ay;
    vy *= 1.0 - friction;

    ax = 0;
    ay = 0;
    
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
  
  }// update
};

// TBD need animated version of this
class Sprite extends Movable
{
  PImage im;

  Sprite(String name, boolean do_limit_xy)
  {
    limit_xy = do_limit_xy;
    lock_vx = false;
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

    image(im, x, y, im.width/sc, im.height/sc);
  }

};

/* any number of objects with the same PImage/s
*/
class SpriteCollection
{
  PImage im;

  ArrayList movables;

  SpriteCollection(String file_name)
  {
    setImage(file_name);
  }

  void setImage(String file_name) 
  {
    movables = new ArrayList(); 
    im = loadImage(file_name);
  }

  void draw()
  { 
    imageMode(CENTER);
    for (int i = 0; i < movables.size(); i++) {
      Movable spr = (Movable)movables.get(i);
      spr.update();

      image(im, spr.x, spr.y, im.width/sc, im.height/sc);
    }
  }
}

/* Things that can be collected by players
*/
class Collectables extends SpriteCollection
{
  
  Collectables(String file_name)
  {
    super(file_name);
  }

  /// TBD add some collision handling code
}

class Balloons extends Collectables
{
  
  Balloons(String file_name) 
  {
    super(file_name);

    init();
  }

  // first level
  void init() 
  {

    /**
      twinkle twinkle little star notes
      */
    String notes = 
        "CC GG AA G " 
      + "FF EE DD C " 
      + "GG FF EE D "
      + "GG FF EE D "
      + "CC GG AA G "
      + "FF EE DD C";

    int x = width/2;
    for (int i = 0; i < notes.length(); i++) {
      char c = notes.charAt(i);
      
      if ((c >= 'A') && (c <= 'G')) {
        int note = c - 'A';
        Movable spr = new Movable();
        spr.friction = 0.3;

        spr.x = x;
        // note determines y coordinate 
        spr.y = (note) * height/10.0 - 40;
        println(c + " " + str(note) + " " + str(spr.x) + " " + str(spr.y));
        spr.vx = -3;
        spr.lock_vx = true;
        movables.add(spr);
      } else {
        println(c + " blank");
      }

      x += 40;
    }

  }
/*
for (int i = 0; i < balloons.length; i++) {
    float fr2 = 0.9;
    float fr = 0.1;
    float off = 0.05;
    balloons[i].ax += fr2 * (noise(balloons[i].x * fr, balloons[i].y * fr, tm) - 0.5 - off);
    balloons[i].ay += fr2 * (noise(balloons[i].x * fr, balloons[i].y * fr, tm + 1000) - 0.5 - off);
    balloons[i].draw();
  }
*/

}

class Background
{
  Sprite[] little_star;

  Sprite[] houses;

  Background()
  {
    little_star = new Sprite[40];

    for (int i = 0; i < little_star.length; i++) {
      //if ( i < little_star.length*0.9)
      little_star[i] = new Sprite("star_bg2_px.png", false);
      //else
      //little_star[i] = new Sprite("star_bg_px.png", false);

      little_star[i].x = random(width);
      little_star[i].y = 7 * random(height/10);

      little_star[i].vx = -0.5;
    }

    houses = new Sprite[5];

    for (int i = 0; i < houses.length; i++) {
      houses[i] = new Sprite("house_px.png", false);
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

Sprite star;
Sprite dog;
Background background;

Balloons balloons;

//////////////////////////////////////
void setup()
{
  size(1280, 720);
  //size(640, 360); //, P3D);
  int wd = width/2;
  int ht = height/2;
  println(str(wd) + ' ' + str(ht)); 

  star = new Sprite("star_px.png", true);
  star.friction = 0.2;

  dog = new Sprite("dog_px.png", true);
  dog.friction = 0.3;
  dog.ylim_neg = 5*height/10;
  dog.y = dog.ylim_neg;

  balloons = new Balloons("balloon_px.png");

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
      star.ay -= mv_size;
    } 
    else if (keyCode == DOWN) {
      star.ay += mv_size; 
    } 
    if (keyCode == LEFT) {
      star.ax -= mv_size; 
    } 
    else if (keyCode == RIGHT) {
      star.ax += mv_size; 
    }

  }
}

void draw()
{
  tm += 0.1;

  background.draw();
 
  balloons.draw();
  star.draw();
  dog.draw();


  //saveFrame("littlestar-####.png");

}

