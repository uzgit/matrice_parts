include <../library/boxes.scad>
include <../library/regular_shapes.scad>

$fn=20;

screw_spacing_x = 78;
screw_spacing_y = 66;
height_forward  = 10;
height_aft      = 15;

for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
{
    for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
    {
        translate([x_translation, y_translation, 0])
        difference()
        {
            cylinder(d=8,h=height_forward);
            cylinder(d=3.2,h=height_forward);
        }
    }
}

