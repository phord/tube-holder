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

// Printer Nozzle: Used to calculate post sleeves
extrudeWidth=0.3;

/* Experimentally
  post0 (3.67) fit inside post5 (4.75)
  post1 (3.92) fit inside post5-post6 (4.87?)
  post2 fit inside post7
  post3 fit inside post8
  post4 fit inside post9
  post5 fit inside post9-post10
  post6 fit inside post10 (with room)
  post7 fit inside post10

          Calculated          Measured
  post0:  id=3.50  od=3.67    id=2.79        od=3.96
  post1:  id=3.75  od=3.92    id=3.21        od=4.2
  post2:  id=4.00  od=4.17    id=3.51        od=4.6
  post3:  id=4.25  od=4.42    id=3.69         4.77
  post4:  id=4.50  od=4.67    id=3.83         5.00
  post5:  id=4.75  od=4.92    id=4.25     od=5.2
  post6:  id=5.00  od=5.17    id=4.36         5.43
  post7:  id=5.25  od=5.42    id=4.59         5.70
  post8:  id=5.50  od=5.67    id=4.83         6.14
  post9:  id=5.75  od=5.92    id=5.29         6.20
  post10: id=6.00  od=6.17    id=5.67      od=6.27
  
*/
//_______________________________________________
//                                     CALCULATED
// Platform
block_size = well_size + wall_width*2;
block_height = well_depth + floor_depth ;

//Outer posts
postSpacing = (block_size - postDiameter)/2;


module tubeplatform(){
	  // platform
	  translate(v=[-postDiameter,-postDiameter,-block_height/2])
			cube(size = [ postSpacing*3,postDiameter*2,block_height-well_depth]);
}

module peg(radius,height) {
  union() {
		translate(v=[0,0,height-radius]) 
				sphere(radius,$fn=30);
        cylinder(r=radius,h=height-radius, $fn=30);
		translate(v=[0,0,-radius]) 
            sphere(radius+0.5, $fn=30);
  }
}

module posthole(distance) {
  union() {
    for (x = [10:1:10]) {
        radius=postHole/2+x/8.;
 		translate(v=[x*distance,0,-block_height/2+depth]) 
				peg(radius,block_height);
    }
  }
}

module post(distance) {
      union() {
        for (x = [10:1:10]) {
            radius=postDiameter/2+x/8.;
            // Barrel (bottom)
            translate(v=[x*distance,0,-block_height/2]) 
                cylinder(r=radius,h=block_height+1, $fn=30);
            
            // Barrel flange
            difference() {
                translate(v=[x*distance,0,-block_height/2]) 
                       sphere(radius+0.5, $fn=30);
                translate(v=[x*distance,0,-block_height/2-radius-0.5]) 
                       cylinder(r=radius*2,h=radius+0.5,$fn=30);
            }

            // Peg (top)
            translate(v=[x*distance,0,block_height/2+1]) 
                cylinder(r=postDiameter/3+x/8.,h=block_height+1, $fn=30);            
        }
        
    }
}

module outerposts(){
	post(postSpacing/4);
}

module outerpostholes(depth){
	posthole(postSpacing/4,depth);
}

module top_middle(depth){
  difference(){
	 union() {
//		tubeplatform();
	   outerposts();
	  }
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
//outerpostholes(-0.1);
