/*
    Parametric test tube holder
*/

//_______________________________________________
//                                         CONFIG
// Platform
wallWidth=1;
floorDepth=2;

// Tube holes
holeDiameter=19.5;
wallWidth=1;
spacing=24; // center to center
tubeHeight = 38;

// Catchers (bottom of tube holder)
catcherDiameter=holeDiameter;
catcherHeight=5;
catcherHeight2=catcherHeight;
drainRadius=catcherDiameter/6;

// Bridges between tubes
connectors=2;
connectorRatio=1.5;

// Number of tubes across and down
NX=3;
NY=3;

// Resolution
tubeFacets=60;

//_______________________________________________
//                                     CALCULATED
totalHeight = tubeHeight + catcherHeight + floorDepth ;
nx=NX-1;
ny=NY-1;
tubeDiameter=holeDiameter + wallWidth*2;

module tubeCatchers() {
  union() {
    for (X = [0:nx]) {
	  for (Y = [0:ny]) {
        x=X*spacing;
        y=Y*spacing;
        difference() {
        translate(v=[x,y,0])
              cylinder(r=catcherDiameter/2,h=catcherHeight,$fn=tubeFacets);
        translate(v=[x,y,catcherHeight])
              cylinder(r2=catcherDiameter,r1=0,h=catcherHeight2,center=true,$fn=tubeFacets);
        translate(v=[x,y,-1])
              cylinder(r=drainRadius,h=catcherHeight+floorDepth+2,$fn=tubeFacets);
        }
	  }
    }
  }
}

module tubeDrains() {
  union() {
    for (X = [0:nx]) {
	  for (Y = [0:ny]) {
        x=X*spacing;
        y=Y*spacing;
        translate(v=[x,y,-1])
              cylinder(r=drainRadius,h=catcherHeight+floorDepth+2,$fn=tubeFacets);
	  }
    }
  }
}

module tubeplatform(){
  union() {
    for (X = [0:nx]) {
      for (Y = [0:ny]) {
        x=X*spacing;
        y=Y*spacing;
        translate(v=[x,y,0])
            cylinder(r=(spacing/4+holeDiameter)/2+wallWidth,h=floorDepth,$fn=tubeFacets);
      }
    }
  }
}

module tubeBridges(){
  difference() {
      union() {
        lx=nx*spacing;
        ly=ny*spacing;
        for (Z = [1:connectors]) {
          z = Z*tubeHeight/connectors;
          w=tubeDiameter/4;
          for (Y = [0:ny]) {
            y=Y*spacing;
            translate(v=[0,y,z])
              rotate([0,90,0])
                scale([1,connectorRatio,1])
                  cylinder(r=w/2, h=lx,$fn=tubeFacets/2);
          }
          for (X = [0:nx]) {
            x=X*spacing;
            translate(v=[x,0,z])
              rotate([-90,90,0])
                scale([1,connectorRatio,1])
                  cylinder(r=w/2, h=ly,$fn=tubeFacets/2);
          }
      }
    }
    tubeholes();
  }
}

module tubeWalls(){
  union() {
    for (X = [0:nx]) {
	  for (Y = [0:ny]) {
      x=X*spacing;
      y=Y*spacing;
      translate(v=[x,y,floorDepth-0.1])
      cylinder(r=tubeDiameter/2,h=totalHeight - floorDepth,$fn=tubeFacets);
      }
    }
  }
}

module tubeholes(){
  union() {
    for (X = [0:nx]) {
      for (Y = [0:ny]) {
        x=X*spacing;
        y=Y*spacing;
        translate(v=[x,y,floorDepth-0.1])
          cylinder(r=holeDiameter/2,h=tubeHeight+catcherHeight+1,$fn=tubeFacets);
      }
    }
  }
}

module xray(){
    translate(v=[-spacing/2,spacing*NX/2,tubeHeight/2])
      cube([spacing,NX*spacing, tubeHeight*2],center=true);
}

module assembly(depth){
  difference(){
    union() {
      difference() {
        union() {
          tubeWalls();
          tubeBridges();
        }
        tubeholes();
      }
      tubeplatform();
      tubeCatchers();
    }
    tubeDrains();
  }
}

difference() {
    assembly();
    // Uncomment the next line for a cut-away view of the inside of the tube
    //xray();
}
