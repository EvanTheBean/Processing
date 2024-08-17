PImage picture;
PImage picture2;
PImage picture3;
String[] colors;
int x, y, factor;
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
  factor = 2;
  //picture3.resize(picture.width/factor, picture.height/factor);
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

float colorDif(color a, color b) //<>//
{
  PVector c1 = new PVector(red(a), green(a), blue(a));
  PVector c2 = new PVector(red(b), green(b), blue(b));
  return abs(c1.dist(c2));
}

PVector quantErr(PVector error, float per)
{
  return new PVector(int(error.x * per),int( error.y * per), int(error.z * per));
}

color average(color[] all)
{
  int r = 0,g = 0,b = 0;
  for(int i = 0; i < all.length; i++)
  {
    r+=red(all[i]);
    g+=green(all[i]);
    b+=blue(all[i]);
  }
  //print(r + " " ); 
  r /= all.length;
   //print(r + "\n" );
  g /= all.length;
  b /= all.length;
  //print (r + ", " + g + ", " + b + "\n");
  return color(r,g,b);
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
  
  for(int y = 0; y < picture.height; y+=1)
  {
    for(int x =0; x < picture.width; x+=1)
    {
      picture3.pixels[index(x,y)] = color(255,255,255);
    }
  }
  
  //print (picture.height + " " + picture.width + "\n");

  for(int y = 0; y < picture.height; y+=factor)
  {
    for(int x =0; x < picture.width; x+=factor)
    {
      color[] pix = new color[factor * factor];
      int index = 0;
      for(int y2 = y; y2 < y + factor && y2 < picture.height; y2++)
      {
        for (int x2 = x; x2 < x + factor && x2 < picture.width; x2++)
        {
          //print(x + " " + x2 + "   " + y + " " + y2 + "  " + index + "\n");
          pix[index] = picture2.pixels[index(x2,y2)];
          index++;
         }
       }
       //print("finshed a block\n");
      
      //color pix = picture2.pixels[index(x,y)];
      color av = average(pix);
      //print(red(av) + "\n");
      for(int y2 = 0; y2 < factor && y+y2 < picture.height; y2++)
      {
        for (int x2 = 0; x2 < factor && x+x2 < picture.width; x2++)
        {
           picture2.pixels[index(x + x2,y + y2)] = av;
           picture2.updatePixels();
           picture3.pixels[index(x/factor,y/factor)] = av;
           picture3.updatePixels();
        }
      }
      //print(x + " going sideways \n");
    }
    //print(y+ " going up \n\n");
  }
  //print (x + " " + y + " " + factor);
  picture2.updatePixels();
  picture3.updatePixels();
  image(picture2,picture.width,0);
  image(picture3,picture.width * 2,0);
  //print(x + " " + y + "\n");
  
  looping = false;
  saveFrame("newPicture.jpg");
}
