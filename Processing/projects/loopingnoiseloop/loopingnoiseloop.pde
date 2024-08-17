float ra1, zoff, ra2;

void setup()
{
  size(800,800);
  ra1 = 0;
  ra2 = 0;
}

void draw()
{
  background(0);
  translate(width/2, height/2);
  //float r = map(noise(cos(ra),sin(ra)),0,1,100,200);
  if(ra2 >= TWO_PI)
  {
    ra2= 0;
    print("endloop");
    exit();
  }
  //print(ra2);
  float timeNoise = 1;
  float rNoise = 3;
  float xnoise2 = map(cos(ra2),-1,1,0,timeNoise); float ynoise2 = map(sin(ra2),-1,1,5,5 + timeNoise);
  zoff = map(noise(xnoise2,ynoise2),0,1,0,5);
  for(int i = 0; i < 255; i += 5)
  {
   beginShape();
  stroke(i);
  //strokeWeight(i/20);
  noFill();
  for(float a = 0; a < TWO_PI; a +=0.1)
  {
    float xnoise1 = map(cos(a),-1,1,i,i + rNoise); float ynoise1 = map(sin(a),-1,1,i,i+rNoise);
    float r = map(noise(xnoise1,ynoise1,zoff + i),0,1,i,i *1.5);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x,y);
  }
  endShape(CLOSE); 
  }
  saveFrame("heart####.png");
  ra2 += TWO_PI/360;
  //noLoop();
}
