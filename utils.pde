void folderSelected(File selection) {
  if (selection.isDirectory()) {
    String absPath = selection.getAbsolutePath();
    listFiles(absPath, binvoxFiles);
    maxIter = binvoxFiles.size();
    println("number of data: " + maxIter);
    loop();
  }
}

void listFiles(String dirName, ArrayList<File> files) {
  File directory = new File(dirName);
  File[] flist = directory.listFiles();

  for (File file : flist) {
    if (file.isFile() && file.getName().endsWith(".binvox")) {
      files.add(file);
    } else if (file.isDirectory()) {
      listFiles(file.getAbsolutePath(), files);
    }
  }
}

void customLight() {
  ambientLight(128, 128, 128);
  directionalLight(200, 200, 200, 1, 0.5, -1);
}

String strVertex(int x, int y, int z) {
  return "v " + x + ".0 " + y + ".0 " + z + ".0";
}

String strFace(int a, int b, int c) {
  return "f " + a + " " + b + " " + c;
}