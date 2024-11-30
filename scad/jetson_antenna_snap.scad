include <../library/roundedcube.scad>

$fn=120;

antenna_diameter = 9.5;

block_width = 0;
block_depth  = 8;
block_height = 7;
top_cylinder_diameter = antenna_diameter + 3;
top_cylinder_offset_z = 7;
bottom_cylinder_diameter = 1.5;
bottom_cylinder_offset_x = top_cylinder_diameter/2 - bottom_cylinder_diameter/2;
bottom_cylinder_offset_z = bottom_cylinder_diameter/2;

module antenna_snap()
{
    difference()
    {
        hull()
        {
    //        translate([0, 0, block_height/2])
    //        roundedcube([block_width, block_depth, block_height], radius=3, apply_to="y", center=true);
            
            for(x_translation = [-bottom_cylinder_offset_x, bottom_cylinder_offset_x])
            {
                translate([x_translation, 0, bottom_cylinder_offset_z])
                rotate([90, 0, 0])
                cylinder(h=block_depth, d=bottom_cylinder_diameter, center=true);
            }
            
            translate([0, 0, top_cylinder_offset_z])
            rotate([90, 0, 0])
            cylinder(h=block_depth, d=top_cylinder_diameter, center=true);
        }

        union()
        {
            translate([0, 0, top_cylinder_offset_z])
            rotate([90, 0, 0])
            cylinder(h=block_depth, d=antenna_diameter, center=true);
            
            translate([0, 0, top_cylinder_diameter/2 + top_cylinder_offset_z])
            rotate([0, 45, 0])
            cube([top_cylinder_diameter, block_depth, top_cylinder_diameter], center=true);
        }
    }
}

antenna_snap();