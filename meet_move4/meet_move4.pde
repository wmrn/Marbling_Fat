//oil=-1256004
//meet=-570821
import processing.video.*;  //ビデオライブラリをインポート
Capture video;  //Capture型の変数videoを宣言
PFrame second;

PImage meet_before, tre, meet_after;
PFont pFont, tFont;
int flag;
float r=15.0;
int  score=0;
int count;
float mposy, msize, tposx;
PGraphics msave;
void setup() {

  size(1280, 1024);
  //size(640, 480);
  video = new Capture(this, 1280, 1024, "PC Camera");
  //カメラからのキャプチャーをおこなうための変数を設定、USB_Cameraは名前がそれぞれ変わります。
  video.start();
  second = new PFrame(this);
  second.size(1280, 1024);
  second.noStroke();

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
    mposy+=5;
    if (mposy>=height/2) {
      mposy=height/2;
      flag=2;
    }
  } else if (flag==2) {
    if (video.available() == true) {
      video.read();   
      second.image(video, 0, 0, width, height);
      second.loadPixels();
      second.image(meet_before, 0, 0, width, height);
      for (int i=0; i<width*height; i++) {
        if (0<=brightness(video.pixels[i])&&brightness(video.pixels[i])<=100) {
          second.set(i%width, i/width, color(255, 0, 0));
          if (get(i%width, i/width)==-1256004) {
            flag=3;
          }
        }
      }
    }
    second.updatePixels();
    second.redraw();
  } else if (flag==3) {
    if (video.available() == true) {
      video.read();
      second.image(video, 0, 0, width, height);
      second.loadPixels();
      second.image(meet_before, 0, 0, width, height);
      for (int i=0; i<width*height; i++) {
        if (0<=brightness(video.pixels[i])&&brightness(video.pixels[i])<=100) {
          if (get(i%width, i/width)==-570821) {
            set(i%width, i/width, -1256004);
            count++;
          }
        }
      }
    }   
    second.updatePixels();
    second.redraw();
    if (count<=0) {
      flag=2;
    } else {
      count=0;
    }
  } else if (flag==4) {
    second.background(0);
    background(255);
    image(tre, width/2, height/2, width, height);
    image(meet_after, width/2, height/2, msize, msize*500/710);
    msize-=10;
    if (msize<=width*3/4) {
      price(score, width/2+270, height/2+190);
      msize=width*3/4;
      flag=5;
    }
  } else if (flag==5) {
    background(255);
    image(tre, tposx, height/2, width, height);
    image(meet_after, tposx, height/2, msize, msize*500/710);
    price(score, tposx+270, height/2+190);
    tposx-=20;
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
  if (key==' ') {
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
  ellipse(posx+20, posy+20, 300, 120);
  textFont(pFont);
  textSize(90);
  text(point, posx, posy-10);
  fill(255, 255, 0);
  text(point, posx, posy);

  textFont(tFont);
  textSize(90);
  fill(255, 0, 0);
  text("点", posx+100, posy-9);
  fill(255, 255, 0);
  text("点", posx+100, posy);
}

