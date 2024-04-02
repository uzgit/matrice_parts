include <../library/roundedcube.scad>
include <../library/pin_headers.scad>

translate([3.81, 2.54, 0])
pin_header( height=12, upper=6, lower=0, rows=3, cols=2, male = 0, hole_size=1.1 );

height = 1.5;

translate([0, 0, -height])
{
    cube([30, 7, height]);
    
    translate([23, 6, 0])
    {
        difference()
        {
            cube([7, 7, height]);
            
            translate([3.5, 3.5, 0])
            cylinder(d=3, h=height);
        }
    }
}