PImage picture;
PImage picture2;
PImage picture3;
String[] colors;
int x, y, checkSize, size;
float factor;
void settings()
{
  picture = loadImage("picture.jpg");
  picture.loadPixels();
  size(picture.width * 3, picture.height);
}


void setup()
{
  image(picture,0,0);
  x = 0; y = 0;
  picture2 = picture.copy();
  picture3 = picture.copy();
  factor = 10;
  size = 1;
  checkSize = 1;
}

int index(int x, int y)
{
  //print (x + " " + picture.width + " " + y +  " " + picture.height + "\n");
  if(x < picture.width && y < picture.height && x >= 0 && y >= 0)
  {
      return x+y * picture.width;
  }
  return -1;
}

float colorDif(color a, color b)
{
  PVector c1 = new PVector(red(a), green(a), blue(a));
  PVector c2 = new PVector(red(b), green(b), blue(b));
  //print(abs(c1.dist(c2)) + "\n");
  return abs(c1.dist(c2));
}

void draw()
{
  background(0);
  picture.loadPixels();
  picture2.loadPixels();
  for(int y = 0; y < picture.height; y+=1)
  {
    for(int x =0; x < picture.width; x+=1)
    {
      picture3.pixels[index(x,y)] = color(255,255,255);
      picture2.pixels[index(x,y)] = picture.pixels[index(x,y)];
    }
  }
  
  for(int y = 0; y < picture.height - checkSize; y++)
  {
    for(int x = 0; x < picture.width - checkSize; x++)
    {
      color a = picture.pixels[index(x,y)];
      color b = picture.pixels[index(x+checkSize,y)];
      color c = picture.pixels[index(x,y+checkSize)];
      if(colorDif(a,b) > factor || colorDif(a,c) > factor)
      {
        for(int y2 = y - size; y2 < y + size; y2 ++)
        {
          for(int x2 = x - size; x2 < x + size; x2 ++)
          {
            if(index(x2,y2) < picture.pixels.length && x2 > -1 && y2 > -1 && index(x2,y2) > -1)
            {
              //print(x2 + " " + x + " " + y2 + " " + y + " " + size);
              picture3.pixels[index(x2,y2)] = color(0,0,0);
              picture2.pixels[index(x2,y2)] = color(0,0,0);
            }
          }
        }
      }
    }
  }
  picture2.updatePixels();
  picture3.updatePixels();
  image(picture,0,0);
  image(picture2,picture.width,0);
  image(picture3,picture.width * 2,0);
  //looping = false;
  
  textSize(32);
  text(factor + " " + size + " " + checkSize, 20, 40); 
  fill(0, 0, 0);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //println(e);
  if(keyPressed)
  {
    if(key == 'Q' || key == 'q')
    {
       size -= e;
    }
    else if(key == 'W' || key == 'w')
    {
       checkSize -= e;
       if(checkSize < 1)
       {
         checkSize =1;
       }
    }
    //print(size  + " size\n");
  }
  else
  {
    factor += e;
    //print(factor  + " factor\n");
  }
}
