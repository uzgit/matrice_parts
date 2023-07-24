include <../library/boxes.scad>
include <../library/regular_shapes.scad>

$fn=120;

screw_spacing_x = 78;
screw_spacing_y = 66;
height_forward  = 7;
height_aft      = 1;
height_bracket  = 3;
diameter_standoff = 7;
diameter_screw_hole = 3.2;

for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
{
    translate([x_translation, 0, 0])
    union()
    {
        translate([0, -screw_spacing_y/2, 0])
        difference()
        {
            cylinder(d=diameter_standoff,h=height_forward);
            cylinder(d=diameter_screw_hole,h=height_forward);
        }

        translate([0, screw_spacing_y/2, 0])
        difference()
        {
            cylinder(d=diameter_standoff,h=height_aft);
            cylinder(d=diameter_screw_hole,h=height_aft);
        }
    }
}


difference()
{
    translate([0, 0, -height_bracket/2])
    cube([screw_spacing_x + diameter_standoff, screw_spacing_y + diameter_standoff, height_bracket ], center=true);
    
    union()
    {
        translate([0, 0, -height_bracket/2])
        cube([screw_spacing_x - diameter_standoff/1.4, screw_spacing_y - diameter_standoff/1.4, height_bracket ], center=true);
        
        for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
        {
            translate([x_translation, 0, 0])
            union()
            {
                translate([0, -screw_spacing_y/2, 0])
                rotate([0, 180, 0])
                    cylinder(d=diameter_screw_hole,h=height_bracket);

                translate([0, screw_spacing_y/2, 0])
                rotate([0, 180, 0])
                    cylinder(d=diameter_screw_hole,h=height_bracket);
            }
        }
    }
}

//difference()
//{
//    translate([0, 0, -height_bracket/2])
//    cube([diameter_standoff, screw_spacing_y + diameter_standoff, height_bracket], center=true);
//    
//    union()
//    {
//        for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
//        {
//            translate([0, y_translation, 0])
//            rotate([0, 180, 0])
//            cylinder(d=diameter_screw_hole, h=height_bracket);
//        }
//    }
//}