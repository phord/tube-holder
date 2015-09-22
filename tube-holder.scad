//_______________________________________________
//                                         CONFIG
// Platform
well_size = 70;
well_depth = 6;
wall_width=1;
floor_depth=1;

// Tube holes
upperHoleDiameter=19.5;
//upperHoleSpacing=6;
spacing=24; // center to center

// Posts
postHole=3.5;
postDiameter=postHole+2;

//_______________________________________________
//                                     CALCULATED
// Platform
block_size = well_size + wall_width*2;
block_height = well_depth + floor_depth ;

//Outer posts
postSpacing = (block_size - postDiameter)/2;


module tubeplatform(){
  difference(){
    union() {
	  // platform
	  translate(v=[-block_size/2,-block_size/2,-block_height/2])
			cube(size = [ block_size,block_size,block_height]);
	  }

	 // well
    translate(v=[-well_size/2,-well_size/2,-(block_height-well_depth)]) 
		cube(size = [well_size,well_size,well_depth]);
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

module posthole(distance,depth) {
  union() {
    for (x = [-distance:distance*2:distance]) {
   		 for (y = [-distance:distance*2:distance]) {
			translate(v=[x,y,-block_height/2+depth]) 
				cylinder(r=postHole/2,h=block_height*2, $fn=30);
		 }
    }
  }
}

module post(distance) {
  union() {
    for (x = [-distance:distance*2:distance]) {
   		 for (y = [-distance:distance*2:distance]) {
			translate(v=[x,y,-block_height/2]) 
				cylinder(r=postDiameter/2,h=block_height, $fn=30);
        }
     }
	}
}

module outerposts(){
	post(postSpacing);
}

module innerposts(){
	post(spacing/2);
}

module outerpostholes(depth){
	posthole(postSpacing,depth);
}

module innerpostholes(depth){
	posthole(spacing/2,depth);
}

module top_middle(depth){
  difference(){
	 union() {
		tubeplatform();
	   outerposts();
	   innerposts();
	  }
	  tubeholes();
	  outerpostholes(depth);
	  innerpostholes(depth);
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
