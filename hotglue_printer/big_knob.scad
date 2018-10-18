in = 25.4;

shaft_rad = .25*in/2;
slot = 1;
slot_height = 3;
height = 5;
inset_height = 3;

rad = 23/2;
slop = .2;
num_splines = 18;

spline_shaft();


module spline_shaft(num_points=3){
    min_rad = 1;
    difference(){
        union(){
            //knob
            //minkowski(){
                for(i=[0:360/(num_points*num_points):359/num_points]) rotate([0,0,i]){
                    cylinder(r=shaft_rad+1, h=height+inset_height+min_rad, $fn=num_points);
                    echo(i);
                }
                //sphere(r=min_rad);
            //}
            //pointer
            translate([0,0,min_rad-.1337]) minkowski(){
                translate([2,0,0]) scale([1,.5,1]) difference(){
                    cylinder(r=rad+1, h=height+inset_height, $fn=3);
                    cylinder(r=rad, h=height+inset_height, $fn=3);
                }
                sphere(r=min_rad);
            }
        }
        
        //extend it
        difference(){
            union(){
                translate([0,0,-.15]) cylinder(r1=shaft_rad/2+2, r2=shaft_rad/2+slop, h=inset_height+.2, $fn=num_splines);
                translate([0,0,inset_height]) cylinder(r1=shaft_rad/2+slop, r2=shaft_rad/2+slop/2, h=height, $fn=num_splines);
            }
            
            //key
            translate([0,0,height+inset_height - slot_height/2+.1]) cube([shaft_rad*2, slot-slop, slot_height], center=true);
        }
    }
}