//_______________________________________________
//                                         CONFIG
// Platform
floor_depth=3;
//sizeX=3;   3x3 tubes
//sizeY=3;

// Tube holes
upperHoleDiameter=19.5;
//upperHoleSpacing=6;
spacing=24; // center to center

// Posts
postHole=6;
postDiameter=postHole+3;
postHeight=10;

// Post placement
postCountX=2;   // must be even; 2,4,etc.
postCountY=2;

// Printer Nozzle: Used to calculate post sleeves
extrudeWidth=0.05;

catcherDiameter=14;
catcherHeight=7;

//_______________________________________________
//                                     CALCULATED
// Platform
block_height = floor_depth ;
postRangeX=spacing*(floor(postCountX/2)-0.5);
postRangeY=spacing*(floor(postCountY/2)-0.5);

//_______________________________________________
//                                          TUBES
module tubePlatformStrong(){
    hull() {
        for (x = [-postRangeX:spacing:postRangeX]) {
            for (y = [-postRangeY:spacing:postRangeY]) {
                translate(v=[x,y,-block_height/2]) 
                    cylinder(r=postDiameter/1.5,h=block_height,$fn=10);
            }
        }
    }
}

module tubeplatform(){
  union() {
    for (x = [-spacing:spacing:spacing]) {
	  for (y = [-spacing:spacing:spacing]) {
		translate(v=[x,y,-block_height/2]) 
			cylinder(r=(spacing+spacing-upperHoleDiameter)/2,h=block_height);
	  }
    }
  }
}

module tubeholes(){
  union() {
    for (x = [-spacing:spacing:spacing]) {
	  for (y = [-spacing:spacing:spacing]) {
		translate(v=[x,y,-block_height/2-1]) cylinder(r=upperHoleDiameter/2,h=block_height+4);
	  }
    }
  }
}

module tubeCatchers() {
  union() {
    for (x = [-spacing:spacing:spacing]) {
	  for (y = [-spacing:spacing:spacing]) {
        difference() {
        translate(v=[x,y,0]) 
              cylinder(r=catcherDiameter/2,h=catcherHeight,$fn=30);
        translate(v=[x,y,catcherHeight]) 
              cylinder(r2=catcherDiameter,r1=0,h=catcherHeight*2,center=true,$fn=30);
        translate(v=[x,y,0]) 
              cylinder(r=catcherDiameter/4,h=catcherHeight,$fn=30);
        }
	  }
    }
  }
}

//_______________________________________________
//                                          POSTS
module peg(radius,height) {
  union() {
      H=height+radius;
		translate(v=[0,0,H]) 
				sphere(radius,$fn=30);
        cylinder(r=radius,h=H, $fn=30);
        difference() {
            rFat=radius+1;
            sphere(rFat, $fn=30);
            translate(v=[0,0,-rFat]) 
                       cylinder(r=rFat*2,h=rFat,$fn=30);
            }
  }
}

module pegHole(radius,height) {
    peg(radius+extrudeWidth, height);
}

module pegSolid(radius,height) {
    peg(radius-extrudeWidth, height);
}

module posthole(x,y) {
  union() {
    radius=postHole/2;
    translate(v=[x,y,-block_height/2-0.01]) 
            pegHole(radius,postHeight);
  }
}

module post(x,y) {
    radius=postDiameter/2;
    rFat=radius+1;
    difference() {
      union() {
        // Barrel (bottom)
        translate(v=[x,y,+block_height/2]) 
            pegSolid(radius,postHeight-1);
        
            // Receiver at top
            translate(v=[x,y,postHeight-2+block_height/2+rFat])
                cylinder(r1=radius,r2=rFat,h=rFat,$fn=30);
        }
        
        // Drill receiver slot in place
        translate(v=[x,y,postHeight+block_height/2+rFat*2-2.45])
            rotate([0,180,0])
                posthole(0,0);
    }
}

module postAndPeg(x,y) {
  union() {
        radius=postDiameter/2;
        // Barrel (bottom)
        translate(v=[x,y,+block_height/2]) 
            pegSolid(radius,postHeight+1);
        
        // Peg (top)
        rPeg=postHole/2;
        translate(v=[x,y,postHeight+block_height/2+1]) 
            pegSolid(rPeg,postHeight+radius);            
    }
}

//_______________________________________________
//                                  SUBASSEMBLIES
module outerposts(){
    for (x = [-postRangeX:spacing:postRangeX]) {
        for (y = [-postRangeY:spacing:postRangeY]) {
            postAndPeg(x,y);
        }
    }
}

module outerpostReceivers(){
    for (x = [-postRangeX:spacing:postRangeX]) {
        for (y = [-postRangeY:spacing:postRangeY]) {
            post(x,y);
        }
    }
}

module outerpostholes(){
    for (x = [-postRangeX:spacing:postRangeX]) {
        for (y = [-postRangeY:spacing:postRangeY]) {
            posthole(x,y);
        }
    }
}

//_______________________________________________
//                                     ASSEMBLIES
module top(){
  difference(){
	 union() {
        tubeplatform();
        tubePlatformStrong(); 
        outerpostReceivers();
	  }
      tubeholes();
	}
}

module middle(){
  difference(){
	 union() {
        tubeplatform();
        tubePlatformStrong(); 
        outerposts();
	  }
      tubeholes();
	  outerpostholes();
	}
}

module bottom(){
  difference(){
	 union() {
        tubeplatform();
        tubePlatformStrong(); 
        outerposts();
        tubeCatchers();
	  }
	}
}

module assembly(){
    translate(v=[0,0,40]) 
        rotate([0,180,0])
            top();
    middle();
    translate(v=[0,0,-20]) 
        bottom();
}

//top();
//middle();
bottom();
//assembly();
