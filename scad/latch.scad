include <../library/boxes.scad>
include <../library/roundedcube.scad>
include <../library/honeycomb.scad>

$fn=30;

plane_x = 10;
plane_y = 15;
plane_z = 3;
plane_r = 0.3;
latch_axis_x = 10;
latch_axis_y = 10;
latch_axis_z = 10;

module catch()
{
    difference()
    {
        union()
        {
            roundedCube([plane_x, plane_y, plane_z], plane_r, center=true);
            
            translate([0, plane_y, 0])
            roundedCube([8, 8, 5], plane_r, center=true);
        }
        
        union()
        {
            translate([0, plane_y/4, 1])
            cylinder(d=6, h=3);
            translate([0, plane_y/4, -plane_z/2])
            cylinder(d=3.2,h=plane_z);
        }
    }
}

module latch()
{
    difference()
    {
        union()
        {
            roundedCube([plane_x, plane_y, plane_z], plane_r, center=true);
        }
        
        union()
        {
            translate([0, -plane_y/4, 1])
            cylinder(d=6, h=3);
            
            translate([0, -plane_y/4, -plane_z/2])
            cylinder(d=3.2,h=plane_z);
        }
    }
}

// ground plane
//translate([0, 0, -2.5])
//cube([100, 100, 5], center=true);

translate([0, -plane_y/2, plane_z/2])
latch();

translate([0, plane_y/2, plane_z/2])
catch();