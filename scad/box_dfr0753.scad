include <rounded_case.scad>
include <quick_release_bracket_v4.scad>

width = 22;
length = 27;
base_height = 10;
dfr0753_height = 5;

extra_wire_space = 0.5;

module dfr0753(extra_height=1)
{
    width = 20;
    length = 24.75;
    pokey_side_length = 14;
    height = 5;
    
    translate([-width/2, -length/2, 0])
    union()
    {
        cube([width + extra_wire_space, length, height]);
        cube([pokey_side_length, pokey_side_length, 8]);
    }
    
    translate([-width/2, length/2, 0])
    rotate([180, 0, 0])
    cube([width + extra_wire_space, length, extra_height]);
}

module base()
{
    translate([-width/2, -length/2, 0])
    cube([width, length, base_height]);
}

module box()
{
    difference()
    {
        union()
        {
            base();
        }
        
        union()
        {
            translate([0, 0, 9])
            rotate([180, 0, 0])
            dfr0753(extra_height=base_height-dfr0753_height);
        }
    }
}

//module lid()
//{
//    difference()
//    {
//        cube([
//    }
//}

//box();
//dfr0753(extra_height=3);

thickness = 1;
difference()
{
    rounded_case(21, 24.75, 9, thickness);
    
    union()
    {
        translate([thickness, thickness, 0])
        cube([7, 16, thickness], center=false);
    }
}

final_tolerance = 0;
theta=45;
length = 10;
qr_x = 29;
base_height = 4;
pin_screw_diameter = 2.9;

translate([-5, 13, 4])
rotate([0, 180, -90])
quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, theta=theta);