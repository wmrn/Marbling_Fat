class Marb {
  float x1, y1;
  float speed;
  float gravity;
  float w, h;

  Marb(float tempX1, float tempY1, float tempW, float tempH) {
    x1 = tempX1;
    y1 = tempY1;
    w=tempW;
    h = tempH;
    speed = 0;
    gravity = 0.8;
    noFill();
  }

  void move() {
    speed = speed + gravity;
    y1 = y1 + speed;
    if (y1 > height) {
      speed = speed * -1.8;
      y1 = height;
    }
  }

  void display() {
    strokeJoin(ROUND);
    strokeWeight(w);
    stroke(-1256004);
    fill(-1256004);
    ellipse(x1, y1, h, h);
    /*
    pushMatrix();
     translate(x1, y1);  //中心となる座標
     float rad=atan2(y1 - height, x1 - width);
     
     rotate(rad); // 左へ90度回転
     
     //円を均等に3分割する点を結び、三角形をつくる
     beginShape();
     for (int i = 0; i < 3; i++) {
     vertex(h*cos(radians(360*i/3)), h*sin(radians(360*i/3)));
     }
     endShape(CLOSE);
     
     popMatrix();
     */
  }

  void marb(float posx1, float posx2, float posy1, float posy2, float w, float h) {
    pushMatrix();
    translate(posx1, posy1);  // 原点をウインドウの中心に
    float a = atan2(posx2-posy1, posx2-posx1)+atan2(posx2-height/2, posx2-width/2)+radians(180);
    rotate(a);          // マウスカーソルの方向へ回転
    beginShape();
    for (int theta = 180; theta < 360; theta++) {
      vertex( w * pow(cos(radians(theta)), 3), h * 1.4 * pow(sin(radians(theta)), 3));
    }
    endShape(CLOSE);
    popMatrix();
  }
}

