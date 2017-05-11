import processing.opengl.*;

int boxSize = 8;
int dim = 32; // voxel grid size
int maxIter = 0;
int remaining;
String fileName = "";
boolean record = true;
ArrayList<File> binvoxFiles = new ArrayList();

Voxel voxel = new Binvox(boxSize, dim);

void setup() {
  size(500, 500, OPENGL);
  smooth();
  noStroke();
  frameRate(2);
  camera(250, 100, 400, width/2, height/2, 0, 0, 1, 0);
  noLoop();
  selectFolder("Select a folder to process", "folderSelected");
}

void draw() {
  if (maxIter > 0) {
    remaining = binvoxFiles.size();
  
    if (remaining > 0) {
      fileName = binvoxFiles.get(0).getName();
      voxel.read(binvoxFiles.get(0).getPath());
      binvoxFiles.remove(0);
    } else {
      record = false;
    }
    
    customLight();
    background(0);
    voxel.display();
    
    if (record) {
      saveFrame("img/" + fileName + ".png");
      voxel.saveOBJ("obj/" + fileName + ".obj");
    } else {
      println("end rendering");
      exit();
    }
  }
}