class Binvox implements Voxel {
  
  int boxSize;
  int dim;
  int numVoxels;
  int[][][] voxels;
  float rotX = PI/2;
  float rotY = 0;
  float rotZ = 1.7*PI;
  
  Binvox(int _boxSize, int _dim) {
    boxSize = _boxSize;
    dim = _dim;
    voxels = new int[dim][dim][dim];
  }
  
  public void display() {
    stroke(96);
    strokeWeight(0.5);

    for (int x = 0; x < dim; x++) {
      for (int y = 0; y < dim; y++) {
        for (int z = 0; z < dim; z++) {
          if (voxels[x][y][z]==1) {
            fill(255, 255, 255);
            pushMatrix();
            translate(width/2, height/2);
            rotateX(rotX);
            rotateY(rotY);
            rotateZ(rotZ);
            translate((x-dim/2)*boxSize, (y-dim/2)*boxSize, (z-dim/2)*boxSize);
            box(boxSize);
            popMatrix();
          }
        }
      }
    }
    //rotY += 0.001;
  }
  
  public void read(String fileName) {
    byte bytesData[] = loadBytes(fileName);
    int readpos = 0;
    
    for (int i = 0; i < bytesData.length; i++) {
      if ((char)bytesData[i] == 'd' && (char)bytesData[i+1] == 'a' && (char)bytesData[i+2] == 't' && (char)bytesData[i+3] == 'a') {
        readpos = i + 5;
        break;
      }
    }
    
    int voxpos = 0;
    int x = 0, y = 0, z = 0;
    numVoxels = 0;
    
    while (voxpos < dim * dim * dim) {
      int cell = bytesData[readpos] & 0xff;
      int sequence = bytesData[readpos+1] & 0xff;
      
      if (cell == 0 || cell == 1) {
        for (int i = voxpos; i < voxpos + sequence; i++) {
          voxels[x][y][z] = cell;
          numVoxels += cell;
  
          z += 1;
  
          if (z == dim) {
            z = 0;
            y += 1;
          }
  
          if (y == dim) {
            y = 0;
            x += 1;
          }
  
          if (x == dim) {
            x = 0;
          }
        }
        voxpos = voxpos + sequence;
        readpos = readpos + 2;
      }
    }
  }
  
  public void saveOBJ(String fileName) {
    String[] vertices = new String[numVoxels*24];
    String[] faces = new String[numVoxels*12];
    int index = 0;
    
    for (int x = 0; x < dim; x++) {
      for (int y = 0; y < dim; y++) {
        for (int z = 0; z < dim; z++) {
          if (voxels[x][y][z]==1) {
            vertices[24*index] = strVertex(y, x, z);
            vertices[24*index+1] = strVertex(y, x, z+1);
            vertices[24*index+2] = strVertex(y+1, x, z);
            vertices[24*index+3] = strVertex(y+1, x, z+1);
            vertices[24*index+4] = strVertex(y+1, x, z);
            vertices[24*index+5] = strVertex(y+1, x, z+1);
            vertices[24*index+6] = strVertex(y+1, x+1, z);
            vertices[24*index+7] = strVertex(y+1, x+1, z+1);
            vertices[24*index+8] = strVertex(y+1, x+1, z);
            vertices[24*index+9] = strVertex(y+1, x+1, z+1);
            vertices[24*index+10] = strVertex(y, x+1, z);
            vertices[24*index+11] = strVertex(y, x+1, z+1);
            vertices[24*index+12] = strVertex(y, x+1, z);
            vertices[24*index+13] = strVertex(y, x+1, z+1);
            vertices[24*index+14] = strVertex(y, x, z);
            vertices[24*index+15] = strVertex(y, x, z+1);
            vertices[24*index+16] = strVertex(y, x, z);
            vertices[24*index+17] = strVertex(y+1, x, z);
            vertices[24*index+18] = strVertex(y+1, x+1, z);
            vertices[24*index+19] = strVertex(y, x+1, z);
            vertices[24*index+20] = strVertex(y, x, z+1);
            vertices[24*index+21] = strVertex(y+1, x, z+1);
            vertices[24*index+22] = strVertex(y+1, x+1, z+1);
            vertices[24*index+23] = strVertex(y, x+1, z+1);
            faces[12*index] = strFace(1+index*24, 3+index*24, 4+index*24);
            faces[12*index+1] = strFace(1+index*24, 4+index*24, 2+index*24);
            faces[12*index+2] = strFace(5+index*24, 7+index*24, 8+index*24);
            faces[12*index+3] = strFace(5+index*24, 8+index*24, 6+index*24);
            faces[12*index+4] = strFace(9+index*24, 11+index*24, 12+index*24);
            faces[12*index+5] = strFace(9+index*24, 12+index*24, 10+index*24);
            faces[12*index+6] = strFace(13+index*24, 15+index*24, 16+index*24);
            faces[12*index+7] = strFace(13+index*24, 16+index*24, 14+index*24);
            faces[12*index+8] = strFace(18+index*24, 17+index*24, 20+index*24);
            faces[12*index+9] = strFace(20+index*24, 19+index*24, 18+index*24);
            faces[12*index+10] = strFace(22+index*24, 24+index*24, 21+index*24);
            faces[12*index+11] = strFace(24+index*24, 22+index*24, 23+index*24);
            index += 1;
          }
        }
      }
    }
    
    String[] lines = concat(vertices, faces);
    saveStrings(fileName, lines);
  }

}