include <../library/roundedcube.scad>
include <../library/pin_headers.scad>

translate([3.81, 2.54, 0])
pin_header( height=13, upper=13, lower=0, rows=3, cols=2, male = 0, hole_size=1.0 );

height = 1.5;

translate([0, 0, -height])
{
    cube([12, 5.08, height]);
    
    y = 10;
    translate([6, - y, 0])
    cube([6, y, height]);
    
    
    difference()
    {
        translate([6, -y, 0])
        cube([12.5, 6, height]);
        
        translate([15, -y + 3, 0])
        cylinder(d=3, h=height);
    }
//    difference()
//    {
//
//        
//        translate([16.5, -6.5, 0])
//        cylinder(d=3, h=height);
//    }
    
//    translate([13, -10, 0])
//    {
//        difference()
//        {
//            cube([7, 7, height]);
//            
//            translate([3.5, 3.5, 0])
//            cylinder(d=3, h=height);
//        }
//    }
}