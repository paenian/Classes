use <Thread_Library.scad>

pull_rad = 15;
pull_oval = 1.25;
pull_wall = 4;
hook_rad = 2;
hook_oval = 2;
height = 5;
hook_extend = 10;

screw_tol = .2;

hook_angle = -10;

part = 10;

if(part == 0){
    rotate([0,0,90]) pull_hook_2(height=5);
}
if(part == 1){
    rotate([0,0,90]) pull_ring_2_flat(height=5);
}
if(part == 2){
    band_holder_2();
}

if(part == 10){
    printing();
}

$fn=60;

wall = 4;
cup_rad = 64/2;
cup_hole_rad = 19;
knife_rad = 22;
cup_indent = 2.25;
cup_slope_outer_rad = 45/2;
cup_slope_inner_rad = 30/2;
cup_slope_height = 3;

center_bump = 2.5;

$fn=90;

module printing(){
    translate([0,44,0]) rotate([0,0,90]) pull_hook_2(height=5);
    translate([-15,44,0]) rotate([0,0,90]) pull_ring_2_flat(height=5);

    band_holder_2();
}

module band_holder_2(){
    band_indent = wall*1.25;
    
    difference(){
        union(){
            //outside
            intersection(){
                cylinder(r=cup_rad+wall, h=height);
                scale([1,.666,1]) cylinder(r=cup_rad+wall, h=height*3, $fn=24);
            }
        }
        
        //hollow out the cup recess, and center hole
        difference(){
            translate([0,0,height/2]) cylinder(r=cup_rad, h=height*2);
            
            translate([0,0,height/2-.1]) cylinder(r1=cup_slope_outer_rad, r2=cup_slope_inner_rad, h=cup_slope_height);
            //%cylinder(r=knife_rad, h=height);
        }
        
        //the vortex hole
        difference(){
            cylinder(r=cup_hole_rad, h=height*3, center=true);
            
            //some side-hooks to attach the rubber bands
            for(i=[0,1]) mirror([i,0,0]) translate([cup_hole_rad,0,0]) {
                translate([0,0,cup_indent/2+height/4]) cube([band_indent*2-1,wall,cup_indent+height/2], center=true);
                difference(){
                    translate([cup_hole_rad-band_indent,0,0]) cylinder(r=cup_hole_rad, h=cup_indent+height/2);
                    translate([cup_hole_rad-band_indent,0,-.5]) cylinder(r=cup_hole_rad-wall/2, h=cup_indent+height/2+1);
                    //open up the ends
                    difference(){
                        translate([-cup_hole_rad,0,-.5]) cylinder(r=cup_hole_rad, h=cup_indent+height/2+1);
                        translate([-cup_hole_rad,0,-.5]) cylinder(r=cup_hole_rad-1, h=cup_indent+height/2+1);
                    }
                }
            }
        }
        
        //there's a bump on the sides
        for(i=[0,1]) mirror([i,0,0]) translate([cup_rad,0,wall/2]){
            cylinder(r=center_bump, h=10);
        }
        
        //flatten the base
        translate([0,0,-100]) cube([200,200,200], center=true);
        
        //save some plastic
        *for(i=[0,1]) mirror([0,i,0]) translate([0,cup_hole_rad*2+wall,0]) scale([2,1,1]) cylinder(r=cup_hole_rad, h=height*3, center=true);
    }
}

module band_holder(){
    difference(){
        union(){
            //outside
            intersection(){
                cylinder(r=cup_rad+wall/2, h=height*2);
                scale([1,.666,1]) cylinder(r=cup_rad+wall, h=height*3);
            }
            
            //hooks for the rubber bands on the side
            for(i=[0,1]) mirror([i,0,0]) translate([cup_rad+wall*.9,0,wall/2]) {
                translate([0,0,1]) minkowski(){
                    sphere(r=1);
                    hull(){
                        cube([wall,wall,wall], center=true);
                        translate([wall*2,0,0]) cube([1,wall*3,wall], center=true);
                    }
                }
            }
        }
        
        //hollow out the cup recess, and center hole
        difference(){
            translate([0,0,height/2]) cylinder(r=cup_rad, h=height*2);
            translate([0,0,height/2-.1]) cylinder(r1=cup_rad-wall, r2=cup_hole_rad+wall/4, h=cup_indent);
        }
        
        //the hole
        cylinder(r=cup_hole_rad, h=height*3, center=true);
        
        //there's a bump on the sides
        for(i=[0,1]) mirror([i,0,0]) translate([cup_rad,0,wall/2]){
            cylinder(r=center_bump, h=10);
        }
        
        //flatten the base
        translate([0,0,-100]) cube([200,200,200], center=true);
        
        //save some plastic
        *for(i=[0,1]) mirror([0,i,0]) translate([0,cup_hole_rad*2+wall,0]) scale([2,1,1]) cylinder(r=cup_hole_rad, h=height*3, center=true);
    }
}

module pull_hook_2(){
    band_thick = 1;
    screw_rad = height*.8-screw_tol;
    screw_len = 37;
    
    flat_rad = height+wall/2;
    union(){       
        //the pull ring - maybe round this up a bit
        difference(){
            union(){
                scale([1,pull_oval,1]) {
                    //cylinder(r=pull_rad+pull_wall, h=height);
                    translate([0,0,height/2]) scale([1,1,1.3]) rotate_extrude(){
                        translate([pull_rad+1,0,0]) circle(height/2);
                    }
                }
                
                //a flat on the pull ring for the hook to hit
                translate([0,0,height/2]) scale([1,pull_oval,1]) hull(){
                    translate([0,pull_rad+pull_wall,0]) rotate([-90,0,0])
                        rotate_extrude(){
                            translate([flat_rad,0,0]) circle(r=1);
                        }
                        
                    rotate([-90,0,0])
                        rotate_extrude(){
                            translate([pull_rad,0,0]) circle(r=1);
                        }
                    
                    //rotate([-90,0,0]) cylinder(r=flat_rad, h = pull_rad+pull_wall);
                }
            }
            
            //center hole
            translate([0,0,-.5]) scale([1,pull_oval,1]) cylinder(r=pull_rad, h=height+1);
            
            //flatten the top and bottom
            for(i=[0:1]) translate([0,0,height/2]) mirror([0,0,i]) translate([0,0,50+height/2]) cube([100,100,100], center=true);
        }
        
        
        
        //the rubber band hook - now we just have threads on the front of the hook.
        difference(){
            translate([0,0,height/2]) 
            intersection(){
                rotate([-90,0,0]) rotate([0,0,90]) trapezoidThread(
                    length=screw_len, 				// axial length of the threaded rod
                    pitch=3,				 // axial distance from crest to crest
                    pitchRadius=height*.6-screw_tol, 			// radial distance from center to mid-profile
                    threadHeightToPitch=0.5, 	// ratio between the height of the profile and the pitch
                            // std value for Acme or metric lead screw is 0.5
                    profileRatio=0.5,			 // ratio between the lengths of the raised part of the profile and the pitch
                            // std value for Acme or metric lead screw is 0.5
                    threadAngle=35, 			// angle between the two faces of the thread
                            // std value for Acme is 29 or for metric lead screw is 30
                    RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
                    clearance=screw_tol, 			// radial clearance, normalized to thread height
                    backlash=0.1, 			// axial clearance, normalized to pitch
                    stepsPerTurn=24 			// number of slices to create per turn
                );
            }
            
            //flatten the top and bottom
            for(i=[0:1]) translate([0,0,height/2]) mirror([0,0,i]) translate([0,0,50+height/2]) cube([100,100,100], center=true);
                
            //center hollow
            translate([0,0,-.5]) scale([1,pull_oval,1]) cylinder(r=pull_rad, h=height+1);
            
            //flat end
            translate([0,60.65,0]) cube([50,50,50], center=true);
        }
    }
}


module pull_ring_2_flat(height = 5){
    thread_height = 25;
    thread_inset = 5;
    
    hole_rad = 3;
    
    flat = .5;
    
    angle = 5;
    
    difference(){
        translate([0,0,height-flat]) rotate([90,0,0]) rotate([angle,0,0])
        hull(){
            cylinder(r1=height+1,r2=height, h=thread_height-thread_inset/2);
            
            translate([0,0,thread_height]) rotate([90,0,0]) hull(){
                cylinder(r=hole_rad+wall/2, h=height*2-flat, center=true);
                //translate([0,(hole_rad+wall/2)/2,0]) cube([hole_rad+wall/2,hole_rad+wall/2, height], center=true);
            }
        }
        
        //top hole
        translate([0,0,height-flat]) rotate([90,0,0]) rotate([angle,0,0])
        translate([0,0,thread_height]) rotate([90,0,0]) {
            hull(){
                cylinder(r=hole_rad, h=height*2, center=true);
                //translate([0,hole_rad/2,0]) cube([hole_rad,hole_rad, height], center=true);
            }
            for(i=[0,1]) mirror([0,0,i]) translate([0,0,1]) cylinder(r1=hole_rad, r2=hole_rad*3, h = hole_rad*2);
        }
        
        //threads
        translate([0,0,height-flat]) rotate([90,0,0]) rotate([angle,0,0])
        translate([0,0,-thread_inset]) 
        //%translate([0,21,height/2]) rotate([-90,0,0])   //uncomment this to check thread fit
        rotate([0,0,0]) translate([0,0,screw_tol]) trapezoidThread(
            length=19, 				// axial length of the threaded rod
            pitch=3,				 // axial distance from crest to crest
            pitchRadius=height*.6+screw_tol, 			// radial distance from center to mid-profile
            threadHeightToPitch=0.5, 	// ratio between the height of the profile and the pitch
                        // std value for Acme or metric lead screw is 0.5
            profileRatio=0.5,			 // ratio between the lengths of the raised part of the profile and the pitch
                         // std value for Acme or metric lead screw is 0.5
            threadAngle=35, 			// angle between the two faces of the thread
                            // std value for Acme is 29 or for metric lead screw is 30
            RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
            clearance=-screw_tol, 			// radial clearance, normalized to thread height
            backlash=0.1, 			// axial clearance, normalized to pitch
            stepsPerTurn=24 			// number of slices to create per turn
        );
        
        //flat bottom and top
        translate([0,0,-50]) cube([100,100,100], center=true);
        rotate([angle*2,0,0]) translate([0,0,50+height*2-flat*2]) cube([100,100,100], center=true);
    }
}

module pull_ring_2(height = 5){
    thread_height = 22;
    thread_inset = 5;
    
    hole_rad = 3;
    
    difference(){
        hull(){
            cylinder(r1=height+1,r2=height, h=thread_height-thread_inset/2);
            
            translate([0,0,thread_height]) rotate([90,0,0]) hull(){
                cylinder(r=hole_rad+wall*.6666, h=height/2, center=true);
                translate([0,(hole_rad+wall/2)/2,0]) cube([hole_rad+wall/2,hole_rad+wall/2, height], center=true);
            }
        }
        
        //top hole
        translate([0,0,thread_height]) rotate([90,0,0]) {
            hull(){
                cylinder(r=hole_rad, h=height, center=true);
                translate([0,hole_rad/2,0]) cube([hole_rad,hole_rad, height], center=true);
            }
            for(i=[0,1]) mirror([0,0,i]) translate([0,0,height/2-.75]) cylinder(r1=hole_rad, r2=hole_rad*3, h = hole_rad*2);
        }
        
        //threads
        translate([0,0,-thread_inset]) 
        //%translate([0,21,height/2]) rotate([-90,0,0])   //uncomment this to check thread fit
        rotate([0,0,90]) translate([0,0,screw_tol]) trapezoidThread(
            length=19, 				// axial length of the threaded rod
            pitch=3,				 // axial distance from crest to crest
            pitchRadius=height*.6+screw_tol, 			// radial distance from center to mid-profile
            threadHeightToPitch=0.5, 	// ratio between the height of the profile and the pitch
                        // std value for Acme or metric lead screw is 0.5
            profileRatio=0.5,			 // ratio between the lengths of the raised part of the profile and the pitch
                         // std value for Acme or metric lead screw is 0.5
            threadAngle=35, 			// angle between the two faces of the thread
                            // std value for Acme is 29 or for metric lead screw is 30
            RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
            clearance=-screw_tol, 			// radial clearance, normalized to thread height
            backlash=0.1, 			// axial clearance, normalized to pitch
            stepsPerTurn=24 			// number of slices to create per turn
        );
        
        //flat bottom
        translate([0,0,-25]) cube([50,50,50], center=true);
    }
}

module pull_hook(){
    band_thick = 1;
    union(){
        
        //the pull ring - maybe round this up a bit
        difference(){
            scale([1,pull_oval,1]) cylinder(r=pull_rad+pull_wall, h=height);
            translate([0,0,-.5]) scale([1,pull_oval,1]) cylinder(r=pull_rad, h=height+1);
            
        }
        
        //the rubber band hook
        difference(){
            hull(){
                translate([0,pull_rad+hook_rad+pull_wall+hook_extend,0])  cylinder(r=hook_rad+pull_wall, h=height);
                translate([0,pull_rad+hook_rad+pull_wall,0])  cylinder(r=hook_rad+pull_wall, h=height);
            }
            
            translate([0,0,-.5]) scale([1,pull_oval,1]) cylinder(r=pull_rad, h=height+1);
            
            translate([0,pull_rad+hook_rad+pull_wall+hook_extend,-.5]){
                //center cut
                rotate([0,0,hook_angle]) hull(){
                    translate([0,hook_rad,0]) cylinder(r=band_thick, h=height+1);
                    translate([0,-hook_rad*3.2,0]) cylinder(r=band_thick, h=height+1);
                }
                
                //cut out a slot
                difference(){
                    //square cutout
                    rotate([0,0,180]) intersection(){
                        translate([0,-25,0]) cube([50,50,50]);
                        //rotate([0,0,hook_angle]) 
                        cube([50,50,50]);
                    }
                    
                    //round the tip
                    rotate([0,0,90]) translate([0,hook_rad+pull_wall/2,0]) cylinder(r=pull_wall/2+1, h=height+1);
                }
            }
        }
    }
}