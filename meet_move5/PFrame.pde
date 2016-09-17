import javax.swing.JFrame;
import java.awt.Dimension;
import java.awt.Image;
import java.util.List;

class PFrame extends PApplet {
  JFrame frame;
  PApplet parent;

  PFrame(PApplet _parent) {
    parent = _parent;
    frame = new JFrame(parent.frame.getTitle());
    frame.setIconImages(parent.frame.getIconImages());
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setResizable(false);
    size(200, 200);
    frame.add(this);
    frame.setVisible(true);
    init();
    noLoop();
  }

  void setup() {
  }

  void draw() {
  }

  void mouseClicked() {
    parent.mouseClicked();
  }

  void mouseDragged() {
    parent.mouseDragged();
  }

  void mouseMoved() {
    parent.mouseMoved();
  }

  void mousePressed() {
    parent.mousePressed();
  }

  void mouseWheel(MouseEvent event) {
    parent.mouseWheel(event);
  }

  void keyPressed() {
    parent.keyPressed();
  }

  void keyReleased() {
    parent.keyReleased();
  }

  void keyTyped() {
    parent.keyTyped();
  }

  void size(int _width, int _height) {
    super.resize(_width, _height);
    frame.getContentPane().setPreferredSize(new Dimension(_width, _height));
    frame.pack();
  }
}
