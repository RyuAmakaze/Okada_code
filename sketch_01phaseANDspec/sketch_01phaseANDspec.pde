import controlP5.*;

ControlP5 cp5;
int sp;

ControlP5 cp5_2;
int phase;

int max_val = 256;
int phase_interval = 5;

int char_size_mm = 5;

void setup() {
  size(800, 800);
  //noStroke();
  fill(255, 105, 180);
  cp5 = new ControlP5(this);
  cp5.addSlider("sp")
    .setRange(1, 60)
    .setValue(100)
    .setPosition(30, 30)
    .setSize(200, 20);
  cp5_2 = new ControlP5(this);
  cp5_2.addSlider("phase")
    .setRange(0, 255/phase_interval)
    .setValue(100/phase_interval)
    .setPosition(360, 30)
    .setSize(200, 20);
}

void draw() {
  background(240);
  text("CPD:"+str(sp*3/4), 280, 45);
  text("phase modulation: 2*pi*0."+str(phase*phase_interval*100/max_val), 610, 45);
  display();
}

String new_dir_path = "pre_01phase_spec"+str(max_val);
String display_path_1;
String display_path_2;

PImage img1;
PImage img2;


void display(){
  display_path_1 = new_dir_path+'/'+str(phase*phase_interval)+'/'+str(sp)+"_1.png";
  display_path_2 = new_dir_path+'/'+str(phase*phase_interval)+'/'+str(sp)+"_3.png";
  
  img1 = loadImage(display_path_1);
  img2 = loadImage(display_path_2);
  
  img1.filter(GRAY);
  img2.filter(GRAY);
  
  img1.resize( char_size_mm*5, 0 );
  img2.resize( char_size_mm*5, 0 );
  
  image(img1, 380, 80);
  image(img2, 380, 380);
}
