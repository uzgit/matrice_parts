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

//length=20;
base_length=12.5;
//theta=65;
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

module vv_track_outer(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1, base_height=2, base_width=20, qr_mechanism=false)
{
    difference()
    {
        union()
        {
//            translate([0, 0, base_height/2])
//            roundedcube([base_width, length, base_height + height], center=true);
            
            translate([-base_width/2, -length/2, -base_height])
           cube([base_width, length, base_height + height]);
        }
        union()
        {
            vv_track_inner(length=length, front_width=front_width, back_width=back_width, theta=theta, height=height, tolerance=-tolerance);
        }
    }
}

module quick_release_bracket_outer(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1, base_height=2, base_width=20, qr_mechanism=false, qr_left=false, qr_x=10, qr_y=2, qr_z=1, pin_screw_diameter=2.9)
{
    difference()
    {
        union()
        {
            vv_track_outer(length=length, front_width=front_width, back_width=back_width, theta=theta, height=height, tolerance=tolerance, base_height=base_height);
        }
        union()
        {
            if( qr_mechanism )
            {
                x_translation = -base_width/2;
                
                if( qr_left )
                {
                    translate([x_translation, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d=pin_screw_diameter, h=qr_x);
                }
                else
                {
                    translate([-x_translation, 0, 0])
                    rotate([0, -90, 0])
                    cylinder(d=pin_screw_diameter, h=qr_x);
                }
            }
        }
    }
}

module quick_release_bracket_inner(length=20, front_width=8, back_width=15, theta=65, height=4, tolerance=0.1, base_height=2, base_width=20, qr_mechanism=false, qr_left=false, qr_x=10, qr_y=2, qr_z=1, pin_screw_diameter=2.9)
{
    difference()
    {
        union()
        {
            vv_track_inner(tolerance=final_tolerance, length=length, theta=theta);
        }
        union()
        {
            if( qr_mechanism )
            {
                x_translation = -base_width/2;
                
                if( qr_left )
                {
                    translate([x_translation, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d=pin_screw_diameter, h=qr_x);
                }
                else
                {
                    translate([-x_translation, 0, 0])
                    rotate([0, -90, 0])
                    cylinder(d=pin_screw_diameter, h=qr_x);
                }
            }
        }
    }
}

final_tolerance = 0;
theta=45;
length = 10;
qr_x = 29;
base_height = 4;
pin_screw_diameter = 2.9;

module skyport_mount()
{
    mount_x  = 56;
    mount_y  = 62;
    
    skyport_screw_x_translation = 50 / 2;
    skyport_screw_y_translation = 56;
    skyport_screw_y_offset = 0;
    
    mount_width  = 10;
    mount_length = 30;
    offset_y = 10;
    minor_offset_y = 2; //for the rounded edges
    
    rotate([0, 0, 180])
    translate([0, 0, -base_height])
    quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=false, theta=theta);
    
    difference()
    {
        union()
        {
            translate([mount_width/2, -length/2, -base_height])
            rotate([0, 0, 180])
            cube([mount_width, mount_y - length/2 - 1, base_height]);
            
            translate([0, -62 + 6, -base_height/2])
            cube([mount_x, mount_width, base_height], center=true);
            
//            translate([0, -mount_width/2, -base_height])
//            roundedcube([mount_x/2, mount_width, base_height]);
            
            translate([-skyport_screw_x_translation, -skyport_screw_y_translation, 0])
            cylinder(d=4.5, h=4);
            translate([skyport_screw_x_translation, -skyport_screw_y_translation, 0])
            cylinder(d=4.5, h=4);
//            translate([skyport_screw_x_translation, 0, 0])
//            cylinder(d=4.5, h=7);
        }
        union()
        {
            translate([-skyport_screw_x_translation, -skyport_screw_y_translation, -base_height])
            cylinder(d=3.2, h=11);
            translate([skyport_screw_x_translation, -skyport_screw_y_translation, -base_height])
            cylinder(d=3.2, h=11);
//            translate([skyport_screw_x_translation, 0, -base_height])
//            cylinder(d=3.2, h=10);
        }
    }
}

module eport_mount()
{
    mount_x  = 56;
    mount_y  = 62;
    
    skyport_screw_x_translation = 50 / 2;
    skyport_screw_y_translation = 35;
    skyport_screw_y_offset = 0;
    
    mount_width  = 10;
    mount_length = 30;
    offset_y = 10;
    minor_offset_y = 2; //for the rounded edges
    
    translate([0, 0, -base_height])
    rotate([0, 0, 180])
    quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
    
    difference()
    {
        union()
        {
            translate([mount_width/2, -length/2 , -base_height])
            rotate([0, 0, 180])
            cube([mount_width, mount_y - length/2 - 13, base_height]);
            
//            translate([-7, -5, -base_height/2])
//            roundedcube([6, 5, base_height], center=true);
            
            translate([0, -45, -base_height/2])
            cube([mount_x, mount_width, base_height], center=true);
            
//            translate([-mount_x/2, -mount_width/2 - 10, -base_height])
//            cube([mount_x/2, mount_width, base_height]);
            
            translate([-skyport_screw_x_translation, -skyport_screw_y_translation - 10, 0])
            cylinder(d=4.5, h=4);
            translate([skyport_screw_x_translation, -skyport_screw_y_translation - 10, 0])
            cylinder(d=4.5, h=4);
//            translate([-skyport_screw_x_translation, -10, 0])
//            cylinder(d=4.5, h=3);
        }
        union()
        {
            translate([-skyport_screw_x_translation, -skyport_screw_y_translation - 10, -base_height])
            cylinder(d=3.2, h=8);
            translate([skyport_screw_x_translation, -skyport_screw_y_translation - 10, -base_height])
            cylinder(d=3.2, h=8);
        }
    }
}

module rpi_mount(left=true)
{
    mount_y  = 49;
    
    skyport_screw_x_translation = 50 / 2;
    skyport_screw_y_translation = 35;
    skyport_screw_y_offset = 0;
    
    mount_width  = 10;
    mount_length = 49;
    offset_y = 10;
    minor_offset_y = 2; //for the rounded edges
    
    difference()
    {
        union()
        {
            translate([0, 0, -base_height])
            rotate([0, 0, 180])
            quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=left, theta=theta);
            
            translate([0, -mount_length/2 - length/2, -base_height/2])
            cube([10, mount_length, base_height], center=true);
            
            for( y_translation = [0, 49] )
            {
                translate([0, -y_translation, 0])
                {
                    cylinder(d=4.5, h=3.5);
                }
            }
        }
        union()
        {
            for( y_translation = [0, 49] )
            {
                translate([0, -y_translation, -base_height])
                {
                    cylinder(d=5.5, h=3.5);
                    cylinder(d=3.0, h=10);
                }
            }
        }
    }
}

module bounding_box_skyport_dev_board(x=90, y=47, z=60)
{
    color("green")
    translate([0, 2, z/2 + 5])
    cube([x, y, z], center=true);
}

module bounding_box_eport_dev_board(x=110, y=20, z=75)
{
    color("green")
    translate([0, 2, z/2 + 5])
    cube([x, y, z], center=true);
}

module bounding_box_rpi_heatsink_case(x=117.5, y=30, z=60)
{
    color("green")
    translate([0, 2, z/2 + 5])
    cube([x, y, z], center=true);
}

module bounding_box_dc_dc_converter(x=23, y=12, z=23)
{
    color("green")
    translate([0, 2, z/2 + 5])
    cube([x, y, z], center=true);
}

module component_mount(base=false, bounding_boxes=false)
{
    // rpi
    translate([9, 0, 0]) // orig
    translate([13, 0, 0])
    {
        rotate([90, 0, 0])
        quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
    
        translate([-58, 0, 0])
        rotate([90, 0, 0])
        quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
        
        if( bounding_boxes )
        {
            translate([-55, -17, 0])
            bounding_box_rpi_heatsink_case();
        }
    }
    
    // eport
    translate([-36, 8, 0])
    {
        rotate([90, 0, 180])
        quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
    
        if( bounding_boxes )
        {
            translate([0, 8, 0])
            bounding_box_eport_dev_board();
        }
    }
    
    
    translate([-34, -42 + 5, 0])
    {
        rotate([90, 0, 0])
        quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
        
        if( bounding_boxes )
        {
            translate([0, -25.5, 0])
            bounding_box_skyport_dev_board();
        }
    }
    
    // dc dc converter
    translate([-34, 40, 0])
    {
        rotate([90, 0, 0])
        quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
        
        if(bounding_boxes)
        {
            bounding_box_dc_dc_converter();
        }
    }
    
    if( base )
    {
        translate([-20, 4, -5.5])
        cube([78, 16, 1], center=true);
        
        translate([-34, 3, -5.5])
        cube([20, 98, 1], center=true);
//        difference()
//        {
//            translate([-20, -17.5, -5.5])
//            cube([80, 60, 1], center=true);
//            
//            translate([-20, -20, -5.5])
//            cube([60, 30, 1], center=true);
//        }
//        
//        difference()
//        {
//            translate([-20, 22, -5.5])
//            cube([80, 40, 1], center=true);
//            
//            translate([-20, 19, -5.5])
//            cube([60, 30, 1], center=true);
//        }
    }
}

//component_mount(base=true, bounding_boxes=true);

//rpi_mount(left=true);

//translate([0, -5, 0])
//skyport_mount();

//translate([0, -5, 0])
//eport_mount();

//quick_release_bracket_outer(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);

//translate([30, 0, 0])
//quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter);

//translate([30, 0, length/2])
//rotate([-90, 0, 0])
//quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter, qr_left=true, theta=theta);
//translate([30, 0, -2])
//cylinder(d=30, h=2);

//translate([30, 0, length/2])
//rotate([-90, 0, 0])
//vv_track_inner(tolerance=final_tolerance, length=length);
//translate([0, 0, -2])
//cylinder(d=30, h=2);

//translate([30, 0, 0])
//vv_track_outer(tolerance=final_tolerance);

//translate([40, 0, 0])
//rotate([90, 0, 0])
//quick_release_outer_v4();
//
//quick_release_inner_v4();

module inner_bracket()
{
    quick_release_bracket_inner(tolerance=final_tolerance, length=length, qr_mechanism=true, qr_x=qr_x, base_height=base_height, pin_screw_diameter=pin_screw_diameter);
}

//inner_bracket();