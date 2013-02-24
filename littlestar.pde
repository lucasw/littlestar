


class Star
{
int x;
int y;

PImage im;

Star()
{
  im = loadImage("star_px.png");
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

Star star;


void setup()
{
  //size(1280, 720);
  size(640, 360); //, P3D);
  int wd = width/4;
  int ht = height/4;
  println(str(wd) + ' ' + str(ht)); 

  star = new Star();
  //    ((PGraphicsOpenGL)g).textureSampling(0);
  //hint(DISABLE_TEXTURE_MIPMAPS);


}

void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      star.y -= 8;
    } else if (keyCode == DOWN) {
      star.y += 8; 
    } else if (keyCode == LEFT) {
      star.x -= 8; 
    } else if (keyCode == RIGHT) {
      star.x += 8; 
    }
    
  }
}
void draw()
{
  background(0,0,20);
  star.draw();
 
}
