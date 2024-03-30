include <../library/boxes.scad>
include <../library/regular_shapes.scad>
include <../library/roundedcube.scad>

$fn=120;

module isosceles_triangle(base_length, theta, tolerance)
{
    h = base_length * tan(theta) / 2;
    scalar = tolerance/(h/3) + 1;
    
    p1 = [0, h*2/3*scalar];
    p2 = [-base_length/2*scalar, -h/3*scalar];
    p3 = [base_length/2*scalar, -h/3*scalar];
    
    polygon([p1, p2, p3]);
}

module tolerant_isosceles_triangle(base_length, theta, tolerance)
{
    h = base_length * tan(theta) / 2;
    x_translation = 0;
    y_translation = h/3;
    z_translation = 0;
    
    if( tolerance > 0 )
    {
        translate([x_translation, y_translation, z_translation])
            isosceles_triangle(base_length, theta, tolerance);
    }
    else if( tolerance < 0 )
    {
        translate([x_translation, y_translation, z_translation])
            isosceles_triangle(base_length, theta, tolerance);
    }
    else
    {
        translate([x_translation, y_translation, z_translation])
        isosceles_triangle(base_length, theta);
    }
}

module v_track_male_cross_section(base_length=15, theta=75, depth=3, tolerance=0.1)
{
    // do not multiply tolerance
    tolerance = -tolerance / 2;
    
    h = base_length * tan(theta) / 2;
    difference()
    {
        translate([0, tolerance/2, 0])
        tolerant_isosceles_triangle(base_length, theta, tolerance=tolerance);
        translate([0, depth + (h-depth)/2, 0])
        square([base_length, h-depth], center=true);
    }
}

module v_track_female_cross_section(width=6, height=4, base_length=15, theta=75, depth=3, tolerance=0.1)
{
    difference()
    {
        translate([0, -height/2 + depth, 0])
        square([width, height], center=true);
        
        v_track_male_cross_section(base_length, theta, depth, -tolerance);
    }
}

module v_track_male_extrusion(length=20, base_length=15, theta=75, depth=3, tolerance=0.1)
{
    translate([0, length/2, 0])
    rotate([90, 0, 0])
    linear_extrude(length)
    v_track_male_cross_section(base_length=base_length, theta=theta, depth=depth, tolerance=tolerance);
}

module v_track_female_extrusion(length=20, base_length=15, theta=75, depth=3, tolerance=0.1, height=5, width=20)
{
    translate([0, length/2, 0])
    rotate([90, 0, 0])
    linear_extrude(length)
    v_track_female_cross_section(height=height, width=width, base_length=base_length, theta=theta, depth=depth, tolerance=tolerance);
}

length=20;
base_length=12.5;
theta=65;
depth=3;
tolerance=0.1;
height=5;
width=20;

quick_release_slot_x = 7;
quick_release_slot_y = 5;

// vertical print for this one
module quick_release_outer_v4()
{
    difference()
    {
        union()
        {
            v_track_female_extrusion(length=length, base_length=base_length, theta=theta, depth=depth, tolerance=tolerance, height=height, width=width);
        }
        union()
        {
            translate([0, 0, -depth/2])
            cube([quick_release_slot_x, quick_release_slot_y, depth], center=true);
        }
    }
}

// horizontal print for this one
module quick_release_inner_v4()
{
    difference()
    {
        union()
        {
            v_track_male_extrusion(length=length, base_length=base_length, theta=theta, depth=depth, tolerance=tolerance, height=height, width=width);
        }
        union()
        {
            translate([0, 0, height/2])
            cube([quick_release_slot_x, quick_release_slot_y, height], center=true);
        }
    }
}

//module vv_track_inner(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1)
//{
//    base_forward_x = front_width / 2 - tolerance;
//    base_aft_x     = back_width  / 2 - tolerance;
//    y = length/2;
//    
//    upper_forward_x = base_forward_x - cos(theta) * height;
//    upper_aft_x     = base_aft_x     - cos(theta) * height;
//    
//    p1 = [-base_forward_x, -y];
//    p2 = [ base_forward_x, -y];
//    p3 = [ base_aft_x, y];
//    p4 = [-base_aft_x, y];
//    
//    p5 = [-upper_forward_x, -y];
//    p6 = [ upper_forward_x, -y];
//    p7 = [ upper_aft_x, y];
//    p8 = [-upper_aft_x, y];
//
//    difference()
//    {
//        hull()
//        {
//            translate([0, 0, -0.1])
//            linear_extrude(0.1)
//            polygon([p1, p2, p3, p4]);
//
//            linear_extrude(height)
//            polygon([p5, p6, p7, p8]);
//        }
//        union()
//        {
//            translate([0, 0, -500])
//            cube([1000, 1000, 1000], center=true);
//        }
//    }
//}

module vv_track_inner(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1)
{
    base_forward_x = front_width / 2 - tolerance;
    base_aft_x     = back_width  / 2 - tolerance;
    y = length/2;
    
    upper_forward_x = base_forward_x - cos(theta) * height;
    upper_aft_x     = base_aft_x     - cos(theta) * height;
    
    p1 = [-base_forward_x, -y];
    p2 = [ base_forward_x, -y];
    p3 = [ base_aft_x, y];
    p4 = [-base_aft_x, y];
    
    p5 = [-upper_forward_x, -y];
    p6 = [ upper_forward_x, -y];
    p7 = [ upper_aft_x, y];
    p8 = [-upper_aft_x, y];

    difference()
    {
        hull()
        {
            translate([0, 0, -0.1])
            linear_extrude(0.1)
            polygon([p1, p2, p3, p4]);

            linear_extrude(height)
            polygon([p5, p6, p7, p8]);
        }
        union()
        {
            translate([0, 0, -500])
            cube([1000, 1000, 1000], center=true);
        }
    }
}

module vv_track_outer(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1, base_height=2, base_width=20)
{
    difference()
    {
        translate([0, 0, base_height/2])
        roundedcube([base_width, length, base_height + height], center=true);
        
        vv_track_inner(length=length, front_width=front_width, back_width=back_width, theta=theta, height=height, tolerance=-tolerance);
    }
}

module quick_release_bracket_outer(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1, base_height=2, base_width=20)
{
    vv_track_outer(length=length, front_width=front_width, back_width=back_width, theta=theta, height=height, tolerance=tolerance);
}

final_tolerance = 0.01;
length = 10;

translate([30, 0, 0])
quick_release_bracket_outer(tolerance=final_tolerance, length=length);

translate([0, 0, length/2])
rotate([-90, 0, 0])
vv_track_inner(tolerance=final_tolerance, length=length);
translate([0, 0, -2])
cylinder(d=30, h=2);

//translate([30, 0, 0])
//vv_track_outer(tolerance=final_tolerance);

//translate([40, 0, 0])
//rotate([90, 0, 0])
//quick_release_outer_v4();
//
//quick_release_inner_v4();