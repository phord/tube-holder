//_______________________________________________
//                                         CONFIG
// Platform
floor_depth=1;
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
extrudeWidth=0.3;

//_______________________________________________
//                                     CALCULATED
// Platform
block_height = floor_depth ;
postRangeX=spacing*(floor(postCountX/2)-0.5);
postRangeY=spacing*(floor(postCountY/2)-0.5);

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

module peg(radius,height) {
  union() {
      H=height+radius;
		translate(v=[0,0,H]) 
				sphere(radius,$fn=30);
        cylinder(r=radius,h=H, $fn=30);
        difference() {
            rFat=radius+0.5;
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

module post(x,y,height) {
  union() {
        radius=postDiameter/2;
        // Barrel (bottom)
        translate(v=[x,y,-block_height/2]) 
            pegSolid(radius,postHeight+1);
        
        // Peg (top)
        rPeg=postHole/2;
        translate(v=[x,y,postHeight-block_height/2+1]) 
            pegSolid(rPeg,postHeight+radius);            
    }
}

module outerposts(){
    
    for (x = [-postRangeX:spacing:postRangeX]) {
        for (y = [-postRangeY:spacing:postRangeY]) {
            post(x,y);
        }
    }
}

module outerpostholes(depth){
    for (x = [-postRangeX:spacing:postRangeX]) {
        for (y = [-postRangeY:spacing:postRangeY]) {
            posthole(x,y,depth);
        }
    }
}

module top_middle(depth){
  difference(){
	 union() {
        tubeplatform();
        tubePlatformStrong(); 
        outerposts();
	  }
      tubeholes();
	  outerpostholes(depth);
	}
}

module top(){
	top_middle(floor_depth);
}

module middle(){
	// No floor to postholes
	top_middle(-0.1);
}

//top();
middle();
