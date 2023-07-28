include <../library/boxes.scad>
include <../library/regular_shapes.scad>
include <./v_track_triangle.scad>

$fn=20;

screw_spacing_x = 78;
screw_spacing_y = 66;
height_forward  = 6;
height_aft      = 1;
height_bracket  = 6;
diameter_standoff = 7;
diameter_screw_hole = 3.2;

width_bracket_x = screw_spacing_x + diameter_standoff + 5;
width_bracket_y = screw_spacing_y + diameter_standoff + 5;

// for sinking the screw heads
module base_plate_screw_head_cone()
{
    screw_head_depth = 2;
    screw_head_radius = 6;

    rotate_extrude()
    {
        translate([0, 0, 0]) polygon(points=[[0,0],[screw_head_radius, 0],[0,screw_head_depth]], paths=[[0,1,2]]);
    }
}

module main_bracket()
{
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
        cube([width_bracket_x, width_bracket_y, height_bracket ], center=true);
        
        union()
        {
//            translate([0, 0, -height_bracket/2])
//            cube([screw_spacing_x - diameter_standoff/1.4, screw_spacing_y - diameter_standoff/1.4, height_bracket ], center=true);
            
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
            
            for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, -height_bracket])
                    base_plate_screw_head_cone();
                }
            }
        }
    }
}

length=width_bracket_y;
tolerance=0.1;
base_length=15;
theta=65;
width=20;
height=5;
depth=3;
width_backstop_y = 3;

spacing_track_x = 40;

module droneside_bracket()
{
    difference()
    {
        union()
        {   translate([0, 0, height_bracket])
            main_bracket();
        }
        union()
        {
    //v_track_male_extrusion(length=length, base_length=base_length, tolerance=tolerance, theta=theta, width=width, height=height, depth=depth);
    //
            for( x_translation = [-spacing_track_x/2, spacing_track_x/2] )
            {
                translate([x_translation, -width_backstop_y, 0])
                hull()
                v_track_female_extrusion(height=height, width=width, length=length-width_backstop_y, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
            }
        }
    }

    for( x_translation = [-spacing_track_x/2, spacing_track_x/2] )
    {
        translate([x_translation, 0, 0])
        hull()
        v_track_male_extrusion(height=height, width=width, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
    }
}

module topside_bracket()
{
    union()
    {
        translate([0, 0, -(height-depth)/2])
        cube([width_bracket_x, width_bracket_y, height-depth], center=true);
        for( x_translation = [-spacing_track_x/2, spacing_track_x/2] )
        {
            translate([x_translation, 0, 0])
            v_track_female_extrusion(height=height, width=width-tolerance/2, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
        }
    }
}

droneside_bracket();

//topside_bracket();