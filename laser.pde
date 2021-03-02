PImage destination;  
PImage destination_erode;  

import processing.video.*;
int sumax, sumay, xkod, ykod;

Capture cam;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[13]);
    cam.start();     
    
  }
  destination = createImage(640,480, RGB);
  destination_erode= createImage(640,480, RGB);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  
  float threshold = 254;

  cam.loadPixels();
  destination.loadPixels();
  
  destination_erode.loadPixels();
  
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++ ) {
      int loc = x + y*cam.width;
      if (red(cam.pixels[loc]) > threshold) {
        destination.pixels[loc]  = color(255);  // White
      }  else {
        destination.pixels[loc]  = color(0);    // Black
      }
    }
  }
 
    destination_erode.updatePixels();   
    destination.updatePixels();
    image(destination,0,0);
    filter(ERODE);
    filter(ERODE);
    filter(ERODE);
    filter(ERODE);
    filter(ERODE);
    //filter(ERODE);
    filter(ERODE);
    filter(DILATE);
    int bele=0;
    sumax = 0;
    sumay = 0;
    
    for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++ ) {
      int locnovo = x + y * cam.width;
      if ( destination.pixels[locnovo] == color(255)){
           bele++; 
           sumax += x;
           sumay += y;
      }
    }
  }
    
    if(bele!=0){
     xkod = sumax / bele;
     ykod = sumay / bele;
    }

    double rastojanje = sqrt((xkod - 320)*(xkod-320) + (ykod - 240)*(ykod - 240));
    println(rastojanje);
}
