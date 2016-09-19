//脂の部分から赤身の部分に向かってmouseをドラッグしてください
//脂を描くことができます
//書き終わったら「GO」ボタンを押してください
//タッチパネルの接触がとても悪いのでとても書きずらいです。
//一番の骨格全部mouse&keyで実装
//oil=-1256004
//meet=-570821
PImage meet_before, tre, meet_after;
PFont pFont, tFont;
int flag;
int  score=0;
float mposy, msize, tposx;
PGraphics msave;
ArrayList marbs;
float marbWidth = 0.3;
float marbHeight= 1;
int count;

void setup() {
  size(640, 480);
  smooth();
  noStroke();
  marbs = new ArrayList();
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
    mposy+=3;
    if (mposy>=height/2) {
      mposy=height/2;
      flag=2;
    }
  } else if (flag==2) {
  go(width-80, height-60);
  }else if (flag==3 && get(mouseX, mouseY)==-570821) {
    for (int i = marbs.size ()-1; i >= count; i--) { 
      Marb marb = (Marb) marbs.get(i);
      if (mousePressed) {
        if (marb.h>=5) {
          marb.h=marb.h;
          if (marb.w>=3) {
            marb.w=marb.w;
          } else {
            marb.w+=0.3;
          }
        } else {
          marb.h+=0.3;
        }
      }
      marb.display();
    }
    marbs.add(new Marb(mouseX, mouseY, marbWidth, marbHeight));
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
    tposx-=3;
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
if (flag==2) {
    if (get(mouseX, mouseY)==-1256004) {
      flag=3;
    } else if (dist(mouseX, mouseY, width-80, height-60)<=90) {
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
}

void mouseReleased() {
  if (flag==3) {
    flag=2;
    count=marbs.size();
  }
}

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
