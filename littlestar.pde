
StarPlayer star_player;
StarPlayer dog;
Background background;

Balloons balloons;
Collectables clouds;

PFont font;

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

  // value to player if encountered- positive is good and adds to score
  // negative reduces score and is bad.
  int value;

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
        y = ylim_neg; 
      }
      if (y > ylim_pos) {
        y = ylim_pos; 
      }

    }
  
  }// update


  void collided(Movable spr)
  {

  }
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

    xlim_neg = wd/4;
    xlim_pos = width - wd/4;
    
    ylim_neg = ht/4;
    ylim_pos = height - ht/4;
  }

  void draw()
  {
    update();

    image(im, x, y, im.width/sc, im.height/sc);
  }

  void collided(Movable spr)
  {
    super.collided(spr); 
  }
  
}

class StarPlayer extends Sprite
{
  int score; 

  StarPlayer(String name)
  {
    super(name, true);

    dir_cmd = new DirectionCommands();
  }
 
  DirectionCommands dir_cmd;
  float mv_size = 5;
  
  void handleDirCommands()
  {
    // handle multiple key presses
    if (dir_cmd.key_up && dir_cmd.key_down) {
      rect(10, 10, 10, 30);
      if (dir_cmd.most_recent_vert > 0) {
        ay -= mv_size; 
      } else {
        ay += mv_size; 
      }
    } else if (dir_cmd.key_up) {
      rect(10, 0, 10, 30);
      ay -= mv_size; 
    } else if (dir_cmd.key_down) {
      rect(10, 20, 10,10);
      ay += mv_size; 
    }

    if (dir_cmd.key_left && dir_cmd.key_right) {
      if (dir_cmd.most_recent_horiz > 0) {
        ax += mv_size * 0.5; 
      } else {
        // TBD make this a function of forward velocity
        ax -= mv_size * 1.5; 
      }
    } else if (dir_cmd.key_right) {
      ax += mv_size; 
    } else if (dir_cmd.key_left) {
      ax -= mv_size; 
    }
  }

  void draw()
  {
    handleDirCommands();
    super.draw();
  }

  void collided(Movable spr) 
  { 
    super.collided(spr);

    score += spr.value;
    
    if (spr.value < 0) {
      float fx = ((vx > 0) ? 1 : -1);
      float fy = ((vy > 0) ? 1 : -1);
      
      ax -= 30 * fx;
      x  -= 10 * fx;
      
      ay -= 10 * fy;
      y  -= 5 * fy;
    }
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

  int missed = 0;

  boolean collisionTest(Sprite test) 
  { 

    boolean rv = false;
    for (int i = 0; i < movables.size(); i++) {
      Movable spr = (Movable)movables.get(i);

      float dx = abs(spr.x - test.x);
      float dy = abs(spr.y - test.y);
  
      if ((dx < test.wd * 0.3) && (dy < test.ht * 0.3)) {
        rv = true;

        collide(test, spr, i);
      }

      // TBD does this belong here?
      if ( spr.x < -10 ) {
        missed++;
        rv = true;
        movables.remove(i);
      }

    } 
   
    if (rv) {
      println("missed " + str(missed) + ", remaining " + str(movables.size()) );
    }

    return rv;
  } // collisionTest

  void collide(Movable test, Movable spr, int i) 
  {
    test.collided(spr);
    movables.remove(i);
  }
}

// TBD doesn't have anything over parent class currently
class Balloons extends Collectables
{
  
  Balloons(String file_name) 
  {
    super(file_name);
  }

  void collide(Movable test, Movable spr, int i) 
  {
    super.collide(test, spr, i);
  }

  // first level
  //int x_level_end = 


}

class Level
{
  void init(String filename, Balloons balloons, Collectables clouds) 
  {

    PImage level = loadImage(filename); //"level1.png");

    // image is tiled into square, need to spread it out
    final int m_ht = 8;
    level.loadPixels();
    for (int y = 0; y < m_ht; y++) {
      for (int x = 0; x < level.width*(level.height/m_ht); x++) {
        
        final int im_x = x % level.width;
        final int im_y = x/m_ht + y;
        final int ind = im_y * level.width + im_x;

        final float spr_x = width/2 + x * 60;
        final float spr_y = y * height/12.0 + 40;
        if (level.pixels[ind] == color(255, 255, 255)) {
          Movable spr = new Movable();
          spr.friction = 0.0;

          spr.x = spr_x;
          // note determines y coordinate 
          spr.y = spr_y;
          //println(c + " " + str(note) + " " + str(spr.x) + " " + str(spr.y));
          spr.vx = -6;
          spr.lock_vx = true;
          spr.value = 1;
          balloons.movables.add(spr);
        } 
        else if (level.pixels[ind] == color(0, 0, 0)) {
          Movable spr = new Movable();
          spr.friction = 0.0;

          spr.x = spr_x;
          // note determines y coordinate 
          spr.y = spr_y;
          //println(c + " " + str(note) + " " + str(spr.x) + " " + str(spr.y));
          spr.vx = -6;
          spr.lock_vx = true;
          spr.value = -5;
          clouds.movables.add(spr);
        }

      }
    }
    println("total balloons " + str(balloons.movables.size()) );
    println("total clouds " + str(clouds.movables.size()) );

    if (false) {
       
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
        //println(c + " " + str(note) + " " + str(spr.x) + " " + str(spr.y));
        spr.vx = -3;
        spr.lock_vx = true;
        balloons.movables.add(spr);
      } else {
        //println(c + " blank");
      }

      x += 40;
    }
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

    houses = new Sprite[25];
    
    float last_x = 0;
    for (int i = 0; i < houses.length; i++) {
      houses[i] = new Sprite("house_px.png", false);
      houses[i].vx = -1.0;
      houses[i].x = random(300) + last_x;
      last_x = houses[i].x;
      houses[i].y = 7*height/10 - houses[i].im.height/4+ 8;
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
    
    fill(0,50,0);
    rect(0, 7 * height / 10, width, 3 * height / 10);
  }

} // Background


//////////////////////////////////////
void setup()
{
  size(1280, 720);
  //size(640, 360); //, P3D);
  int wd = width/2;
  int ht = height/2;
  println(str(wd) + ' ' + str(ht)); 

  star_player = new StarPlayer("star_px.png");
  star_player.friction = 0.2;
  star_player.x = 100;
  star_player.y = 100;
  star_player.ylim_pos = 6*height/10;

  dog = new StarPlayer("dog_px.png");
  dog.mv_size = 26.0;
  dog.friction = 0.8;
  dog.ylim_neg = 7*height/10;
  dog.ylim_pos = height - 50;
  dog.y = dog.ylim_neg + 100;

  balloons = new Balloons("balloon_px.png");
  clouds = new Collectables("bad_cloud_px.png");  

  Level level = new Level();
  level.init("level1.png", balloons, clouds);

  background = new Background();
  //    ((PGraphicsOpenGL)g).textureSampling(0);
  //hint(DISABLE_TEXTURE_MIPMAPS);

  // Comic Sans MS Bold
  font = createFont("Courier 10 Pitch Italic", 4, false);
  
  //println(PFont.list());
  frameRate(15);
}

class DirectionCommands {

boolean key_up = false;
boolean key_down = false;
// 1 = positive, 0 = nothing, -1 = negative
int most_recent_vert = 0;
int most_recent_horiz = 0;
boolean key_left = false;
boolean key_right = false;
}

void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      star_player.dir_cmd.key_up = true;
      star_player.dir_cmd.most_recent_vert = 1;
    } 
    if (keyCode == DOWN) {
      star_player.dir_cmd.key_down = true;
      star_player.dir_cmd.most_recent_vert = -1;
    } 
    if (keyCode == LEFT) {
      star_player.dir_cmd.key_left = true;
      star_player.dir_cmd.most_recent_horiz = -1;
    } 
    if (keyCode == RIGHT) {
      star_player.dir_cmd.key_right = true;
      star_player.dir_cmd.most_recent_horiz = 1;
    }

  }

  if (key == 'w') {
      dog.dir_cmd.key_up = true;
      dog.dir_cmd.most_recent_vert = 1;
    } 
    if (key == 's') {
      dog.dir_cmd.key_down = true;
      dog.dir_cmd.most_recent_vert = -1;
    } 
    if (key == 'a') {
      dog.dir_cmd.key_left = true;
      dog.dir_cmd.most_recent_horiz = -1;
    } 
    if (key == 'd') {
      dog.dir_cmd.key_right = true;
      dog.dir_cmd.most_recent_horiz = 1;
    }


}

void keyReleased()
{
  if (key == CODED) {
    if (keyCode == UP) {
      star_player.dir_cmd.key_up = false;
    } 
    
    if (keyCode == DOWN) {
      star_player.dir_cmd.key_down = false;
    } 
    if (keyCode == LEFT) {
      star_player.dir_cmd.key_left = false;
    } 
    
    if (keyCode == RIGHT) {
      star_player.dir_cmd.key_right = false;
    }

  }
  
  if (key == 'w') {
      dog.dir_cmd.key_up = false;
    } 
    
    if (key == 's') {
      dog.dir_cmd.key_down = false;
    } 
    if (key == 'a') {
      dog.dir_cmd.key_left = false;
    } 
    
    if (key == 'd') {
      dog.dir_cmd.key_right = false;
    }
}

int count = 0;
void drawAll()
{
  background.draw();
  balloons.draw();
  star_player.draw();
  clouds.draw();
  dog.draw();

  textFont(font);
  textSize(32);
  fill(255);

  {
    int score = star_player.score;
    boolean sign = score >= 0;
    if (!sign) score = -score;

  String msg = str(score);
  if (score < 10) {
    msg = "00" + msg;
  }
  else if (score < 100) {
    msg = "0" + msg;
  }

  if (sign) {
    msg = "+" + msg;
  } else {
    msg = "-" + msg;
  }

  text(msg, 10, 30);
  
  if ((count < 25) &&
    (count % 4 < 2)) {
    textSize(128);
    text("GET READY", width/4, height/2);
  }

  if ((balloons.movables.size()== 0) && (clouds.movables.size() == 0) &&
    (count % 2 == 0)) {
    textSize(128);
    text("LEVEL COMPLETE", width/4, height/2);
  }

  }

  count++;
}

void draw()
{
  
  tm += 0.1;
 
  balloons.collisionTest(star_player); 
  clouds.collisionTest(star_player); 
  drawAll();

  //saveFrame("littlestar-####.png");

}

