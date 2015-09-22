//_______________________________________________
//                                         CONFIG
// Platform
well_size = 70;
well_depth = 0;
wall_width=1;
floor_depth=1;

// Tube holes
upperHoleDiameter=19.5;
//upperHoleSpacing=6;
spacing=24; // center to center

//_______________________________________________
//                                     CALCULATED
// Platform
block_size = well_size + wall_width*2;
block_height = well_depth + floor_depth ;


module tubeplatform(){
  union() {
    for (x = [-spacing:spacing:spacing]) {
	  for (y = [-spacing:spacing:spacing]) {
		translate(v=[x,y,-block_height/2]) 
//			cylinder(r=upperHoleDiameter/2+1,h=block_height);
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

module top_middle(depth){
  difference(){
	 union() {
		tubeplatform();
	  }
	  tubeholes();
	}
}

module fencing() {
  r=5;
  union() {
    for (x = [-spacing*1.2:r:spacing*1.2+r]) {
	  for (y = [-spacing:r:spacing+r]) {
		translate(v=[0,x,y]) 
			rotate([45,0,0])
				cube([well_size*2, r/2, r/2], true);
	  }
    }

    for (x = [-spacing*1.2:r:spacing*1.2+r]) {
	  for (y = [-spacing:r:spacing+r]) {
		translate(v=[x,0,y]) 
			rotate([0,45,0])
				cube([r/2, well_size*2, r/2], true);
	  }
    }
  }
}

module top(){
	top_middle(floor_depth);
}


difference() {
   top();
//   fencing();
}