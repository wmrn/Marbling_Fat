//kinectでmouse部分の実装済
//oil=-1256004
//meet=-570821
import SimpleOpenNI.*;
SimpleOpenNI kinect;
PFrame secondFrame;

PImage meet_before, tre, meet_after;
PFont pFont, tFont;
int flag;
float r=15.0;
int  score=0;
int mousepos, distance, pmousepos;
float mposy, msize, tposx;
PGraphics msave;
void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this); // 初期化
  kinect.enableDepth(); // 深度画像の有効化
  if (kinect.enableRGB() == false) {
    println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
    exit();
    return;
  }
  secondFrame = new PFrame(this);
  secondFrame.size(640, 480);

  meet_before = loadImage("bace.png");
  tre = loadImage("tre.png");
  imageMode(CENTER);
  pFont=loadFont("KomikaBoogie-48.vlw");
  tFont=createFont("MS Gothic", 48, true);
  textAlign(CENTER, CENTER);
  mposy=-height/2;
  msize=width;
  tposx=width/2;
}

void draw() {
  if (flag==1) {
    background(255);
    image(meet_before, width/2, mposy, width, height);
    mposy++;
    if (mposy>=height/2) {
      mposy=height/2;
      flag=2;
    }
  } else if (flag==2) {
    kinect.update();// データの更新
    secondFrame.image(kinect.rgbImage(),0,0,width,height);
    secondFrame.image(meet_before, 0, 0, width, height);   
    int [] depthMap = kinect.depthMap();// 中心の距離を表示
    distance=100000;
    pmousepos=0;
    for (int i=0; i<width*height; i++) {
      if (depthMap[i]>0 && distance>depthMap[i]) {
        pmousepos=i;
        distance=depthMap[i];
      }
    }
    if (get(pmousepos%width, pmousepos/width)==-1256004) {
      flag=3;
    }
    fill(255, 0, 0);
    secondFrame.ellipse(pmousepos%width, pmousepos/width, 10, 10);
    secondFrame.redraw();
  } else if (flag==3) {
    kinect.update();// データの更新
   secondFrame.image(kinect.rgbImage(),0,0,width,height); 
    secondFrame.image(meet_before, 0, 0, width, height);  
    int [] depthMap = kinect.depthMap();// 中心の距離を表示
    distance=100000;
    mousepos=0;
    for (int i=0; i<width*height; i++) {
      if (depthMap[i]>0 && distance>depthMap[i]) {
        mousepos=i;
        distance=depthMap[i];
      }
    }
    fill(255, 0, 0);
    secondFrame.ellipse(mousepos%width, mousepos/width, 10, 10);
    if (get(mousepos%width, mousepos/width)==-570821) {
      r-=1.0;
      if (r>1) {
        stroke(-1256004);
        strokeWeight(r);
        line(mousepos%width, mousepos/width, pmousepos%width, pmousepos/width);
      }
    }
    pmousepos=mousepos;
    if (distance>400) {//☆
      flag=2;
      r=15.0;
    }
    secondFrame.redraw();
  } else if (flag==4) {
    background(255);
    image(tre, width/2, height/2, width, height);
    image(meet_after, width/2, height/2, msize, msize*500/710);
    msize--;
    if (msize<=width*3/4) {
      price(score, width/2+150, height/2+80);
      msize=width*3/4;
      flag=5;
    }
  } else if (flag==5) {
    background(255);
    image(tre, tposx, height/2, width, height);
    image(meet_after, tposx, height/2, msize, msize*500/710);
    price(score, tposx+150, height/2+80);
    tposx--;
    if (tposx<-width/2) {
      flag=0;
    }
  } else if (flag==0) {
    mposy=-height/2;
    msize=width;
    tposx=width/2;
    score=0;
    flag=1;
  }
}

void mousePressed() {
  println(flag);
}
/*void mousePressed() {
 if (flag==2 && get(mouseX, mouseY)==-1256004) {
 flag=3;
 }
 }*/

/*void mouseReleased() {
 flag=2;
 r=15.0;
 }*/

void keyPressed() {
  if (flag==2 && key==' ') {
    loadPixels();
    msave=createGraphics(width, height, JAVA2D);
    msave.beginDraw();
    msave.background(255, 255, 255, 0);
    for (int i=0; i<width*height; i++) {
      if (pixels[i]==-1256004) {
        msave.set(i%width, i/width, -1256004);
      } else if (pixels[i]==-570821) {
        msave.set(i%width, i/width, -570821);
      }
    }
    msave.endDraw();
    msave.save("msave.png");
    meet_after=loadImage("msave.png");

    float oil=0;
    float lean=0;
    float ideal=0; 
    loadPixels();
    for (int i=0; i<width*height; i++) {
      if (pixels[i]==-1256004) {
        oil++;
      } else if (pixels[i]==-570821) {
        lean++;
      }
    }
    ideal=lean*3/7;
    if (ideal>=oil) {
      score=int(100*oil/ideal);
    } else {
      score=int(100*ideal/oil);
    }    
    flag=4;
  }
}

void price(int point, float posx, float posy) {
  noStroke();
  fill(255, 0, 0);
  ellipse(posx+10, posy+10, 150, 60);
  textFont(pFont);
  textSize(45);
  text(point, posx, posy-5);
  fill(255, 255, 0);
  text(point, posx, posy);

  textFont(tFont);
  textSize(45);
  fill(255, 0, 0);
  text("点", posx+50, posy-3);
  fill(255, 255, 0);
  text("点", posx+50, posy);
}

