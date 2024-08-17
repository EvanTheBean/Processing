PImage picture;
PImage picture2;
PImage picture3;
String[] colors;
int x, y;
void settings()
{
  picture = loadImage("picture.jpg");
  picture.loadPixels();
  size(picture.width * 3, picture.height);
}


void setup()
{
  colors = loadStrings("colors.txt");
  image(picture,0,0);
  x = 0; y = 0;
  picture2 = picture.copy();
  picture3 = picture.copy();
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

color parse(String string)
{
  string = string.replace("#","");
  String rs = string.substring(0,2);
  String gs = string.substring(2,4);
  String bs = string.substring(4);
  //print(rs + " " + gs + " " + bs);
  return color(unhex(rs),unhex(gs),unhex(bs));
}

float colorDif(color a, color b)
{
  PVector c1 = new PVector(red(a), green(a), blue(a));
  PVector c2 = new PVector(red(b), green(b), blue(b));
  return abs(c1.dist(c2));
}

PVector quantErr(PVector error, float per)
{
  return new PVector(int(error.x * per),int( error.y * per), int(error.z * per));
}

color addColors(color a, PVector b)
{
  float r = red(a) + b.x;
  if(r > 255)
  {
    r = 255;
  }
  if(r < 0)
  {
    r = 0;
  }
  float g = green(a) + b.y;
  if(g > 255)
  {
    g = 255;
  }
  if(g < 0)
  {
    g = 0;
  }
  float bl = blue(a) + b.z;
  if(bl > 255)
  {
    bl = 255;
  }
  if(bl < 0)
  {
    bl = 0;
  }
  return color(r,g,bl);
}

void draw()
{
  picture.loadPixels();
  picture2.loadPixels();
  picture3.loadPixels();
  
  
  for(int y = 0; y < picture.height; y++)
  {
    for(int x =0; x < picture.width; x++)
    {
      color pix = picture2.pixels[index(x,y)];
      //PVector oldC2 = new PVector(red(pix),green(pix),blue(pix));
      //print(oldC2);
      //float oldR = red(pix); float oldG = green(pix); float oldb = blue(pix);
      float closestDistance;
      color closestColor;
      int c = 0;
      color co = parse(colors[c]);
      closestDistance = colorDif(pix,co);
      closestColor = co;
      c++;
      while(c < colors.length)
      {
        co = parse(colors[c]);
        
        if(closestDistance > colorDif(pix,co))
        {
          closestDistance = colorDif(pix,co);
          closestColor = co;
        }
        
        c++;
      }
      
      picture2.pixels[index(x,y)] = closestColor;
      
      
      
      color pix2 = picture3.pixels[index(x,y)];
      PVector oldC = new PVector(red(pix2),green(pix2),blue(pix2));
      //print(oldC);
      //float oldR = red(pix); float oldG = green(pix); float oldb = blue(pix);
      c = 0;
      co = parse(colors[c]);
      closestDistance = colorDif(pix2,co);
      closestColor = co;
      c++;
      while(c < colors.length)
      {
        co = parse(colors[c]);
        
        if(closestDistance > colorDif(pix2,co))
        {
          closestDistance = colorDif(pix2,co);
          closestColor = co;
        }
        
        c++;
      }
      
      picture3.pixels[index(x,y)] = closestColor;
      //DITHERING
      //PVector oldC = new PVector(red(pix),green(pix),blue(pix));
      PVector newC = new PVector(red(closestColor),green(closestColor),blue(closestColor));
      PVector dif = new PVector(oldC.x - newC.x, oldC.y-newC.y,oldC.z - newC.z);
      //print(oldC + " " + newC + " " + dif + "\n");
      /*if(abs(oldC.dist(new PVector(255.0,255.0,255.0))) < 255)
      {
        print(oldC + " " + newC + " " + dif + "\n");
      }*/
      
      if(index(x+1,y) != -1)
      {
        color oldColor = picture3.pixels[index(x+1,y)];
        picture3.pixels[index(x+1,y)] = addColors(picture3.pixels[index(x+1,y)], quantErr(dif,7.0/16.0));
        //print (oldColor + " " + picture3.pixels[index(x+1,y)] + " " + quantErr(dif,7.0/16.0) + "\n");
        //print(red(oldColor) + " " + green(oldColor) + " " + blue(oldColor) + " | " + red(picture3.pixels[index(x+1,y)]) + " " + green(picture3.pixels[index(x+1,y)]) + " " + blue(picture3.pixels[index(x+1,y)]) + " | " + dif + " | " + (quantErr(dif,7.0/16).x) + " " + (quantErr(dif,7.0/16).y)+ " " + (quantErr(dif,7.0/16).z) + "\n");
      }
      if(index(x-1,y + 1) != -1)
      {
        picture3.pixels[index(x-1,y + 1)] =addColors(picture3.pixels[index(x-1,y + 1)] ,quantErr(dif,3.0/16.0));
      }
      if(index(x,y + 1) != -1)
      {
        picture3.pixels[index(x,y + 1)] = addColors(picture3.pixels[index(x,y + 1)] , quantErr(dif,5.0/16.0));
      }
      if(index(x+1,y + 1) != -1)
      {
        picture3.pixels[index(x+1,y + 1)] = addColors(picture3.pixels[index(x+1,y + 1)] , quantErr(dif,1.0/16.0));
      }
      
    }
  }
  picture2.updatePixels();
  picture3.updatePixels();
  image(picture2,picture.width,0);
  image(picture3,picture.width * 2,0);
  //print(x + " " + y + "\n");
  
  
  /*
  if(y < picture.height)
  {
      x++;
      if(x >= picture.width)
      {
        x = 0;
        y++;
      }
  }
  */
  saveFrame("newPicture.jpg");
}
