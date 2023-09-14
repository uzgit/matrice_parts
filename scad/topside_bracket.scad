include <../library/boxes.scad>
include <../library/regular_shapes.scad>
include <./v_track.scad>

$fn=20;

screw_spacing_x = 78;
screw_spacing_y = 66;
height_forward  = 6;
height_aft      = 2;
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
threaded_insert_translation_y = -30;

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
                v_track_female_extrusion(height=height, width=width, length=length-width_backstop_y*2, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
            }
        }
        
//        translate([0, threaded_insert_translation_y, 0])
//        union()
//        {
//            // threaded insert hole
//            cylinder(d=3.2, h=6);
//            translate([0, 0, 1.5]) // to reverse the direction without the rotation command
//            cylinder(d=4, h=4.5);
//        }
    }

    for( x_translation = [-spacing_track_x/2, spacing_track_x/2] )
    {
        translate([x_translation, 0, 0])
        hull()
        v_track_male_extrusion(height=height, width=width, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
    }
}

topside_bracket_extension_height = 6;
module topside_bracket(include_locking_mechanism=true)
{
    difference()
    {
        union()
        {
            // this is redunant but I'm leaving it for robustness in changes
            translate([0, 0, -(height-depth)/2])
            cube([width_bracket_x, width_bracket_y, height-depth], center=true);
            for( x_translation = [-spacing_track_x/2, spacing_track_x/2] )
            {
                translate([x_translation, -width_backstop_y, 0])
                v_track_female_extrusion(height=height, width=width-tolerance/2, length=length-width_backstop_y*2, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);
            }
            
            translate([0, 0, -topside_bracket_extension_height/2])
            cube([width_bracket_x, width_bracket_y, topside_bracket_extension_height], center=true);
        }
        union()
        {
            for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    rotate([0, 180, 0])
                    base_plate_screw_head_cone();
                    
                    translate([x_translation, y_translation, -topside_bracket_extension_height])
                    cylinder(d=diameter_screw_hole,h=topside_bracket_extension_height);
                }
            }
            
        // threaded insert screw hole
//        translate([0, threaded_insert_translation_y, -topside_bracket_extension_height])
//        union()
//        {
            // threaded insert hole
//            cylinder(d=3.2, h=topside_bracket_extension_height);
//            translate([0, 0, 1.5]) // to reverse the direction without the rotation command
//            cylinder(d=4, h=4.5);
//            base_plate_screw_head_cone();
//        }
        
        }
    }
    
    if( include_locking_mechanism )
    {
        lock_x = 105;
        lock_y = 90;
        lock_z = topside_bracket_extension_height * 2;
        
        lock_overhang_x = 4;
        
        gap_x = 0.5;
        gap_y_aft = 0.5;
        
        difference()
        {
            union()
            {
                // starboard lock
                translate([-lock_x/2, lock_y/2 - 10, 0])
                rotate([0, 0, 45])
                cube([30, 30, lock_z], center=true);
                
                // portside lock
                translate([lock_x/2, lock_y/2 - 10, 0])
                rotate([0, 0, 45])
                cube([30, 30, lock_z], center=true);
                
                translate([-lock_x/2, -lock_y/2, -topside_bracket_extension_height])
                cube([lock_x, lock_y, lock_z]);
            }
            union()
            {
                // main negative space to preserve the bracket itself
                translate([-width_bracket_x/2 - gap_x, -width_bracket_y/2, -topside_bracket_extension_height])
                cube([width_bracket_x + 2*gap_x, width_bracket_y + gap_y_aft, lock_z]);
                
                // negative space for lock aft
                translate([-width_bracket_x/2 - gap_x + lock_overhang_x, -width_bracket_y/2, -topside_bracket_extension_height])
                cube([width_bracket_x + 2*gap_x - lock_overhang_x*2, width_bracket_y + gap_y_aft + 50, lock_z]);
            }
            
            // outer negative space for trimming
            difference()
            {
                outer = 1000;
                translate([-outer/2, -outer/2, -topside_bracket_extension_height])
                cube([outer, outer, lock_z]);
                
                translate([-lock_x/2, -lock_y/2, -topside_bracket_extension_height])
                cube([lock_x, lock_y + 7.5, lock_z]);
            }
        }
    }
    
    guidance_tab_x = 30;
    guidance_tab_y = 30;
    guidance_tab_z = height_bracket;
    translate([-guidance_tab_x/2, width_bracket_y/2, -guidance_tab_z])
    cube([guidance_tab_x, guidance_tab_y, guidance_tab_z]);
}

translate([0, 0, 20])
droneside_bracket();

translate([0, 0, -20])
topside_bracket();
