
base_rad = 37;
upper_rad = 47;

center_rad = 22;    //radius of the knife blades
height = 75;

cup_base_rad = 64/2;
top_rad = 78/2;

knife_length = 9;
knife_thick = 1;
knife_height = 40;

screw_rad = 4/2;
screw_cap_rad = screw_rad*2;
nut_rad = 8/2;
nut_height = 3.5;


mirror([1,0,0]) cup_cutter();

//holds two exacto blades, lets you put a cup in and slice out the base.
module cup_cutter(){
    min_rad = 2;
    difference(){
        translate([0,0,min_rad]) union(){
            minkowski(){
                cylinder(r1=base_rad-min_rad, r2=upper_rad-min_rad, h=height-min_rad*2, $fn=7);
                sphere(r=min_rad, $fn=6); 
            }
        }
        
        
        //center hole
        difference(){
            translate([0,0,-.1]) cylinder(r=center_rad, h=height*2, $fn=72);
            for(i=[0,180]) rotate([0,0,i]) knife_block(solid = 1);
        }
        
        for(i=[0,180]) rotate([0,0,i]) knife_block(solid = 0);
        
        //sloped sides for the cup
        translate([0,0,knife_height]) cylinder(r1=cup_base_rad, r2=top_rad, h=height-knife_height+.1, $fn=108);
    }
}

module knife_block(solid = 1){
    wall = 3;
    screw_offset = wall;
    
    if(solid == 1){
        //this is the block to hold the blade
        translate([center_rad,0,knife_height/2-.1]) cube([knife_thick+wall*2, knife_length*3,knife_height], center=true);
    }
    
    if(solid == 0){
        //this is the knife slot itself
        translate([center_rad,0,knife_height/2]) cube([knife_thick, knife_length,knife_height+1], center=true);
        
        //add an extra tab, and more length so we can secure it
        translate([center_rad,screw_offset+knife_length/2,knife_height/2]) cube([knife_thick, knife_length,knife_height+1], center=true);
        translate([center_rad-knife_length/2,screw_offset+knife_length,knife_height/2]) rotate([0,0,90]) cube([knife_thick, knife_length,knife_height+1], center=true);
        
        //the screws
        for(i=[0,1]) translate([center_rad, screw_offset+knife_length/2, knife_height/2]) mirror([0,0,i]) translate([0,0,knife_height/2-wall-screw_rad]) rotate([0,-90,0]){
            cylinder(r=screw_rad, h=300, center=true);
            translate([0,0,wall]) cylinder(r=screw_cap_rad, h=30);
            
            //nut
            translate([0,0,-wall*2]) hull(){
                rotate([0,0,45]) cylinder(r=nut_rad, h=nut_height, $fn=4);
                translate([knife_height,0,0]) rotate([0,0,45]) cylinder(r=nut_rad+1, h=nut_height, $fn=4);
            }
        }
    }
}