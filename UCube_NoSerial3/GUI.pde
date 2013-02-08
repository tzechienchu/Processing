//void mouseDragged() {
//  float x1 = mouseX-pmouseX;
//  float y1 = mouseY-pmouseY;
//  rotX = (mouseY * -0.01);
//  rotY = (mouseX * 0.01);
//}
//
//
//void translations() {  
//  translate(width/2, height/2);
//  rotateX(rotX);
//  rotateY(rotY);
//}

void initControllers() {
  nav=new Nav3D(); 
  // nav.rotX=PI/6;
  // nav.rotY=PI/6;

  controlP5 = new ControlP5(this);
  controlP5.addButton("Refresh",0,100,100,80,19);
  controlP5.addButton("Hull", 0,100,120,80,19);
  controlP5.addButton("WireFrame", 0,100,140,80,19);
  controlP5.addButton("Grid", 0,100,160,80,19);
  controlP5.addButton("Export", 0,100,180,80,19);
  controlP5.addButton("Spline", 0,100,200,80,19);
}



// pass mouse and key events to our Nav3D instance
void mouseDragged() {
  // ignore mouse event if cursor is over controlP5 GUI elements
  if(controlP5.window(this).isMouseOver()) return;

  nav.mouseDragged();
}

void keyPressed() {
  nav.keyPressed();
}


void drawGrid() {

  //draw rest of grid 
  //(spacing * (gridSize -1) * -1) /2 = center around 0 
  int xpos = 0;
  int ypos = 0;
  int zpos = 0;

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      for( int k = 0; k < gridSize; k++) {
        stroke(100);
        strokeWeight(2);  
        point(xpos, ypos, zpos);
        //println(xpos + "," + ypos + "," + zpos);
        xpos += spacing;
      }
      xpos = 0;
      ypos -= spacing;
    }
    xpos = 0;
    ypos = 0;
    zpos += spacing;
  }
}

void drawAxes() {

  strokeWeight(1);
  stroke(255,0,255);
  line(0,0,0, 100,0,0);
  fill(255,0,255);
  text("X", 220, 0);
  stroke(0,255,0);
  line(0,0,0, 0,-100,0);
  fill(0,255,0);
  text("Y", 0, -220);
  stroke(0,0,255);
  line(0,0,0, 0,0,100);
  fill(0,0, 255);
  text("Z", 0, 0, 220);
  fill(0,0,0);
}

public void Hull(int theValue) { 
  counter++;
  println(counter);
  drawHull();
}

public void WireFrame(int theValue) {

  if(counter == 0) {
    drawHull();
  }

  if (doFill == true) {
    doFill = false;
  }
  else if (doFill == false) {
    doFill = true;
  }
}

public void Grid(int theValue) {

  if (doGrid == true) {
    doGrid = false;
  }
  else if (doGrid == false) {
    doGrid = true;
  }
}


public void Spline(int theValue) {

  if(doSpline == true) {
    println("spline = true");
    doSpline = false;
  }

  else if(doSpline == false) {
    println("spline = false");
    doSpline = true;
  }
}

public void drawSpline() {

  if(points.length > 3) {


    sVectors = new Vec3D[0];

    for(int i = 0; i <points.length; i++) {

      float x = (float)points[i].x;
      float y = (float)points[i].y;
      float z = (float)points[i].z;

      Vec3D tempVect = new Vec3D(x,y,z);
      sVectors = (Vec3D[])append(sVectors, tempVect);
    }

    Spline3D spline = new Spline3D(sVectors);
    java.util.List vertices = spline.computeVertices(8);

    noFill();
    beginShape();
    for(Iterator i=vertices.iterator(); i.hasNext(); ) {
      Vec3D v=(Vec3D)i.next();
      vertex(v.x,v.y,v.z);
    }
    endShape();
  }
}



public void Export(int theValue) {
  outputSTL();
}


void outputSTL() {

  TriangleMesh mySTL = new TriangleMesh();

  for(int i = 0; i < vectors.length; i+=3) {

    mesh.addFace(vectors[i], vectors[i+1], vectors[i+2]);
    //println(vectors[i] + " " + vectors[i+1] + " " + vectors[i+2]);
  }

  mySTL.addMesh(mesh);
  mySTL.saveAsSTL(selectOutput());
}
