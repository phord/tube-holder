//_______________________________________________
//                                         CONFIG
// Platform
wall_width=1;
floor_depth=2;

// Tube holes
upperHoleDiameter=19.5;
wallWidth=1;
//upperHoleSpacing=6;
spacing=24; // center to center
tubeHeight = 38;

// Catchers
catcherDiameter=upperHoleDiameter;
catcherHeight=14;
drainRadius=catcherDiameter/5;

// Bridges between tubes
connectors=2;

// Number of tubes across X down
N=3;

// Resolution
tubeFacets=30;

//_______________________________________________
//                                     CALCULATED
totalHeight = tubeHeight + catcherHeight + floor_depth ;
n=N-1;
outerHoleDiameter=upperHoleDiameter + wallWidth*2;

module tubeCatchers() {
  union() {
    for (X = [0:n]) {
	  for (Y = [0:n]) {
        x=X*spacing;
        y=Y*spacing;
        difference() {
        translate(v=[x,y,0]) 
              cylinder(r=catcherDiameter/2,h=catcherHeight,$fn=tubeFacets);
        translate(v=[x,y,catcherHeight]) 
              cylinder(r2=catcherDiameter,r1=0,h=catcherHeight*2,center=true,$fn=tubeFacets);
        translate(v=[x,y,-1]) 
              cylinder(r=drainRadius,h=catcherHeight+floor_depth+2,$fn=tubeFacets);
        }
	  }
    }
  }
}

module tubeDrains() {
  union() {
    for (X = [0:n]) {
	  for (Y = [0:n]) {
        x=X*spacing;
        y=Y*spacing;
        translate(v=[x,y,-1]) 
              cylinder(r=drainRadius,h=catcherHeight+floor_depth+2,$fn=tubeFacets);
	  }
    }
  }
}

module tubeplatform(){
  union() {
    for (X = [0:n]) {
      for (Y = [0:n]) {
        x=X*spacing;
        y=Y*spacing;
        translate(v=[x,y,0]) 
            cylinder(r=(spacing+spacing-upperHoleDiameter)/2,h=floor_depth,$fn=tubeFacets);
      }
    }
  }
}

module tubeBridges(){
  difference() {
      union() {
        l=n*outerHoleDiameter;
        for (z = [tubeHeight/connectors:tubeHeight/connectors:tubeHeight]) {  
          for (Y = [0:n]) {
            y=Y*spacing;
            w=outerHoleDiameter/4;
            translate(v=[0,y,z]) 
              scale([1,2,1])
                rotate([0,90,0])
                    cylinder(r=w/2, h=l,$fn=tubeFacets/2);
            translate(v=[y,0,z]) 
                  rotate([-90,90,0])
              scale([1,2,1])
                    cylinder(r=w/2, h=l,$fn=tubeFacets/2);
          }
      } 
    }
    tubeholes();
  }
}

module tubeWalls(){
  union() {
    for (X = [0:n]) {
	  for (Y = [0:n]) {
        x=X*spacing;
        y=Y*spacing;
		translate(v=[x,y,floor_depth-0.1]) 
//			cylinder(r=upperHoleDiameter/2+1,h=block_height);
			cylinder(r=outerHoleDiameter/2,h=totalHeight - floor_depth,$fn=tubeFacets);
	  }
    }
  }
}

module tubeholes(){
  union() {
    for (X = [0:n]) {
	  for (Y = [0:n]) {
        x=X*spacing;
        y=Y*spacing;
		translate(v=[x,y,floor_depth-0.1]) 
          cylinder(r=upperHoleDiameter/2,h=tubeHeight+catcherHeight+1,$fn=tubeFacets);
	  }
    }
  }
}

module top_middle(depth){
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

module top(){
	top_middle(floor_depth);
}


top();
//tubeplatform();
