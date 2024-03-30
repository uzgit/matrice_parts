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

screw_spacing_x = 78;
screw_spacing_y = 66;
alignment_peg_spacing_y = 50;
height_forward  = 6;
height_aft      = 2;
height_bracket  = 6;
diameter_standoff = 7;
diameter_screw_hole = 3.2;

width_bracket_x = screw_spacing_x + diameter_standoff + 5;
width_bracket_y = screw_spacing_y + diameter_standoff + 12.5;

text_depth = 0.5;

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

// for sinking the non-sinking screw heads
module screw_head_cylinder()
{
    screw_head_depth = 3.5;
    screw_head_diameter = 6;
    
    translate([0, 0, 0])
    cylinder(h=screw_head_depth, d=screw_head_diameter);
}

module large_screw_head_cylinder()
{
    screw_head_depth = 3.5;
    screw_head_diameter = 6;
    
    translate([0, 0, 0])
    cylinder(h=screw_head_depth, d=screw_head_diameter);
}

alignment_peg_depth    = 10;
alignment_peg_diameter =  6;
module alignment_peg()
{
    cylinder(h=alignment_peg_depth, d=alignment_peg_diameter, center=true);
}

length=77.5;
track_length  = 20;
slider_length = 20;
//length=87.5;
tolerance=0.1;
base_length=12.5;
theta=65;
width=10;
height=4;
depth=3;
width_backstop_y = 10;

spacing_track_x = 40;
threaded_insert_translation_y = -30;

topside_bracket_extension_height = 6;
topside_bracket_extra_height = 4;
topside_bracket_width = 27.5;

clip_width = 1.5;
clip_spacing_x = 0.5;
clip_spacing_y = 0.5;
clip_attachment_length = 10;
clip_overhang_x = 1.5;

font_size = 3;

mount_screw_x_translation = 9;
attachment_point_width = topside_bracket_width;
attachment_point_depth = 6;
attachment_point_height = 10;

module half_droneside_bracket_v2(tolerance=tolerance, attachment_screw_spacing=49, attachment_screw_hole_diameter=2.9, attachment_standoff_height=3.5, attachment_standoff_diameter=4.5, angle=0, attachment_screw_y_translation=0, eport=false, skyport=false, rpi=false, y_offset=0)
{
    difference()
    {
        union()
        {
            // v track
            translate([0, 0, -tolerance/4])
            v_track_male_extrusion(height=height, width=width, length=slider_length, base_length=base_length, tolerance=tolerance, theta=theta, depth=height);
            
            // back stop
            p1 = [ base_length/2 + clip_overhang_x,     slider_length/2 - width_backstop_y];
            p2 = [topside_bracket_width/2,             slider_length/2 - width_backstop_y/2];
            p3 = [ topside_bracket_width/2,             slider_length/2];
            p4 = [-topside_bracket_width/2,             slider_length/2];
            p5 = [-topside_bracket_width/2,             slider_length/2 - width_backstop_y/2];
            p6 = [-base_length/2 - clip_overhang_x,     slider_length/2 - width_backstop_y];
            linear_extrude(height - tolerance/4)
            polygon([p1, p2, p3, p4, p5, p6]);
            
            if(eport)
            {
                mount_x = 58;
                mount_y = 41;
                
                cavity_x = 40;
                cavity_y = 30;
                
                eport_screw_x_translation = 50 / 2;
                eport_screw_y_translation = 35 / 2;
                
                translate([0, -width_backstop_y + y_offset, height/2 - tolerance/8])
                difference()
                {
                    // outer arms and top
                    translate([0, mount_y/2, 0])
                    roundedcube([mount_x, mount_y, height - tolerance/4], center=true);
                    
                    // cavity negative space
                    translate([0, cavity_y/2, 0])
                    cube([cavity_x, cavity_y, height], center=true);
                    
                    for( x_translation = [-eport_screw_x_translation, eport_screw_x_translation] )
                    {
                        for( y_translation = [-eport_screw_y_translation, eport_screw_y_translation] )
                        {
                            translate([x_translation, 3 + eport_screw_y_translation + y_translation, -height/2])
                            {
                                cylinder(d=2.9, h=height);
                                cylinder(d=4.5, h=3);
                            }
                        }
                    }
                }
                
                translate([0, -width_backstop_y + y_offset, -tolerance/4 + height/2])
                for( x_translation = [-eport_screw_x_translation, eport_screw_x_translation] )
                {
                    for( y_translation = [-eport_screw_y_translation, eport_screw_y_translation] )
                    {
                        translate([x_translation, 3 + eport_screw_y_translation + y_translation, -height/2])
                        {
                            translate([0, 0, height])
                            difference()
                            {
                                cylinder(d=4.5, h=4);
                                cylinder(d=2.9, h=4);
                            }
                        }
                    }
                }
                
                translate([0, mount_y/2, height/2 - tolerance/8])
                cube([width, mount_y , height - tolerance/4], center=true);
            }
            else if( skyport )
            {
                mount_x = 56;
                mount_y = 62;
                
                cavity_x = 40;
                cavity_y = 50;
                
                eport_screw_x_translation = 50 / 2;
                eport_screw_y_translation = 56 / 2;
                
                translate([0, -width_backstop_y, height/2 - tolerance/8])
                difference()
                {
                    translate([0, mount_y/2, 0])
                    roundedcube([mount_x, mount_y, height - tolerance/4], center=true);
                    
                    translate([0, cavity_y/2, 0])
                    cube([cavity_x, cavity_y, height], center=true);
                    
                    for( x_translation = [-eport_screw_x_translation, eport_screw_x_translation] )
                    {
                        for( y_translation = [-eport_screw_y_translation, eport_screw_y_translation] )
                        {
                            translate([x_translation, 3 + eport_screw_y_translation + y_translation, -height/2])
                            {
                                cylinder(d=2.9, h=height);
                                cylinder(d=4.5, h=3);
                            }
                        }
                    }
                }
                
                translate([0, -width_backstop_y, -tolerance/4 + height/2])
                for( x_translation = [-eport_screw_x_translation, eport_screw_x_translation] )
                {
                    for( y_translation = [-eport_screw_y_translation, eport_screw_y_translation] )
                    {
                        translate([x_translation, 3 + eport_screw_y_translation + y_translation, -height/2])
                        {
                            translate([0, 0, height])
                            difference()
                            {
                                cylinder(d=4.5, h=4);
                                cylinder(d=2.9, h=4);
                            }
                        }
                    }
                }
                
                translate([0, mount_y/2 - 10, height/2 - tolerance/8])
                cube([width, mount_y - 22, height - tolerance/4], center=true);
            }
            else if( rpi )
            {
                // positive area for mounting
                translate([-width/2, 0, 0])
                cube([width, attachment_screw_spacing, height - 0.25*tolerance]);
            
                // standoffs
                translate([0, -width_backstop_y/2, height])
                for( y_translation = [0, attachment_screw_spacing] )
                {
                    translate([0, y_translation, 0])
                    difference()
                    {
                        cylinder(d=attachment_standoff_diameter, h=attachment_standoff_height);
                        cylinder(d=attachment_screw_hole_diameter, h=attachment_standoff_height);
                    }
                }
                
//                translate([0, attachment_screw_spacing, 0])
//                {
//                    cylinder(d=attachment_screw_hole_diameter, h=height + 2);
//                    cylinder(d=4.5, h=2);
//                }
            }
//            // forward standoff
//            translate([0, -screw_spacing_y/2, height])
//            difference()
//            {
//                hull()
//                {
//                    translate([0, 0, -height_forward])
//                    cylinder(d=11,h=height_forward - tolerance/4);
//                    cylinder(d=diameter_standoff,h=height_forward - tolerance/4);
//                }
//                cylinder(d=diameter_screw_hole,h=height_forward);
//            }
//            
//            // aft standoff
//            translate([0, screw_spacing_y/2, height - tolerance/4])
//            difference()
//            {
//                hull()
//                {
//                    translate([0, 0, -height_aft])
//                    cylinder(d=11,h=height_aft);
//                    cylinder(d=diameter_standoff,h=height_aft);
//                }
//                cylinder(d=diameter_screw_hole,h=height_aft);
//            }
        }
        union()
        {
            if(eport)
            {
                
            }
            else if( rpi )
            {
                if( angle != 90 )
                {
                    translate([0, -width_backstop_y/2, 0])
                    {
                        cylinder(d=attachment_screw_hole_diameter, h=height + 2); // screw main void
                        cylinder(d=4.5, h=3); // screw head void
                        
                        translate([0, attachment_screw_spacing, 0])
                        {
                            cylinder(d=attachment_screw_hole_diameter, h=height + 2);
                            cylinder(d=4.5, h=3);
                        }
                    }
                }
                else
                {
                    
                }
            }
            
            translate([0, 0, height-text_depth])
            rotate([0, 0, 90])
            linear_extrude(height=text_depth)
            rotate([0, 0, -90])
            text(str(final_tolerance), size=font_size, valign="center", halign="center");
        }
    }
}

module droneside_bracket_v2(tolerance=tolerance)
{
    for( x_translation = [- spacing_track_x, spacing_track_x] )
    {
        translate([x_translation, 0, 0])
        half_droneside_bracket_v2(tolerance);
    }
}

module half_topside_bracket_v2(tolerance=tolerance, portside_clip=true, starboard_clip=true)
{
    clip_overhang_y = 10;

    height_offset = (height - topside_bracket_extra_height)/2;
    total_height = height + topside_bracket_extra_height;
    
    difference()
    {
        union()
        {
            // v track
            v_track_female_extrusion(height=height, width=topside_bracket_width, length=track_length, base_length=base_length, tolerance=tolerance, theta=theta, depth=height);
            
            // back stop
            translate([0, 0, -topside_bracket_extra_height/2])
            cube([topside_bracket_width, track_length, topside_bracket_extra_height], true);

            // clips
            translate([0, 0, height_offset])
            union()
            {
                difference()
                {
                    // positive space for arms
                    union()
                    {
                        translate([0, clip_overhang_y/2 + clip_spacing_y/2, 0])
                        cube([topside_bracket_width + 2*clip_width + 2*clip_spacing_x, track_length + clip_overhang_y + clip_spacing_y, total_height], true);
                    }

                    // negative space for arms
                    union()
                    {
                        // negative space for main bracket
                        cube([topside_bracket_width + 2*clip_spacing_x, track_length + clip_spacing_y, total_height], true);
                        
                        // clip tabs
                        p1 = [ topside_bracket_width/2 - clip_overhang_x, track_length/2];
                        p2 = [-topside_bracket_width/2 + clip_overhang_x, track_length/2];
                        p3 = [-topside_bracket_width/2 - 1, track_length/2 + clip_overhang_y + clip_spacing_y];
                        p4 = [ topside_bracket_width/2 + 2, track_length/2 + clip_overhang_y + clip_spacing_y];
                        translate([0, 0, -total_height/2])
                        linear_extrude(total_height)
                        polygon([p1, p2, p3, p4]);
                        
                        // remove clips if they are not wanted
                        x_translation = topside_bracket_width/2 + clip_spacing_x + clip_width/2;
                        x_translation_cutoff = topside_bracket_width/2 + clip_spacing_x - 90;
                        // remove portside clip
                        if( ! portside_clip )
                        {
                            translate([x_translation, 0, 0])
                            cube([clip_width, track_length, total_height], true);
                            
                            translate([x_translation - 1, track_length/2 + clip_overhang_y/2 + clip_spacing_y/2, 0])
                            cube([2*clip_width + clip_overhang_x, clip_overhang_y + clip_spacing_y, total_height], true);
                            
                            translate([x_translation_cutoff, -track_length/2, 0])
                            rotate([0, 0, 45])
                            cube(80, true);
                        }
                        // remove starboard clip
                        if( ! starboard_clip )
                        {
                            translate([-x_translation, 0, 0])
                            cube([clip_width, track_length, total_height], true);
                            
                            translate([-x_translation + 1, track_length/2 + clip_overhang_y/2 + clip_spacing_y/2, 0])
                            cube([2*clip_width + clip_overhang_x, clip_overhang_y + clip_spacing_y, total_height], true);

                            translate([-x_translation_cutoff, -track_length/2, 0])
                            rotate([0, 0, 45])
                            cube(80, true);
                        }
                    }
                }
                
                x_translation = topside_bracket_width/2 + clip_spacing_x/2;
                if( portside_clip )
                {
                    translate([0, -track_length/2 + clip_attachment_length/2, 0])
                    translate([x_translation, 0, 0])
                    cube([clip_spacing_x, clip_attachment_length, total_height], true);

                }
                if( starboard_clip )
                {
                    translate([0, -track_length/2 + clip_attachment_length/2, 0])
                    translate([-x_translation, 0, 0])
                    cube([clip_spacing_x, clip_attachment_length, total_height], true);
                }
            }
        }
        union()
        {
            translate([0, 0, -text_depth])
            rotate([0, 0, 90])
            linear_extrude(height=text_depth)
            rotate([0, 0, -90])
            text(str(final_tolerance), size=3, valign="center", halign="center");
            
            // back stop void
            translate([0, track_length/2 - width_backstop_y/2, height/2])
            cube([topside_bracket_width, width_backstop_y, height], true);

            translate([0, -width_backstop_y/2, 0])
            for( x_translation = [-mount_screw_x_translation, mount_screw_x_translation] )
            {
                translate([x_translation, 0, -topside_bracket_extra_height])
                cylinder(d=3.2, h=total_height);
                
                translate([x_translation, 0, height - 3.5])
                cylinder(d=5.5, h=3.5);
            }
        }
    }
}

module topside_bracket_v2(tolerance=tolerance)
{
    for( x_translation = [- spacing_track_x, spacing_track_x] )
    {
        translate([x_translation, 0, 0])
        half_topside_bracket_v2(tolerance);
    }
}

module attachment_point()
{
    translate([0, 0, attachment_point_height])
    rotate([90, 0, 90])
    difference()
    {
        union()
        {
            translate([-topside_bracket_width/2, -width_backstop_y, 0])
            cube([topside_bracket_width, attachment_point_height, attachment_point_depth]);
        }
        union()
        {
            for( x_translation = [-mount_screw_x_translation, mount_screw_x_translation])
            {
                translate([x_translation, -width_backstop_y/2, 0])
                cylinder(d=3.2, h=attachment_point_depth);
            }
        }
    }
}

module test_mounting_plate()
{
    // base
//    translate([
    
//    roundedcube([100, 100, 1], center=true, 0.5, "z");
    coordinates = [ [-36, 14], [-36, -14], [5, -65], [11, -65], [11, 21], [5, 21] ];
    negative_coordinates = [ [5, 15], [5, -6.75], [5, -35], [5, -58], [-30,-15], [-30, 10] ];
    
    translate([0, 0, -1])
    linear_extrude(1)
    difference()
    {
        polygon(coordinates);
        polygon(negative_coordinates);
    }

    // rpi
    translate([5, 7, 0])
    union()
    {
        attachment_point();
        translate([0, -58, 0])
        attachment_point();
    }
    
//    // eport
//    translate([19, 0, 0])
//    attachment_point();
    
    // skyport
    translate([-36, 0, 0])
    attachment_point();
}

final_tolerance = 0.1;

//translate([0, 0, 0])
//droneside_bracket_v2(tolerance=final_tolerance);
//
//translate([0, 0, 0])
//topside_bracket_v2(tolerance=final_tolerance);

// *************************************************************************

test_mounting_plate();

// all parts for printing:
//translate([0, 0, 0])
//half_droneside_bracket_v2(tolerance=final_tolerance, rpi=true);
//
//translate([33, 0, 0])
//half_droneside_bracket_v2(tolerance=final_tolerance, rpi=true);
//
//translate([74, 0, topside_bracket_extra_height])
//translate([33, 0, topside_bracket_extra_height])
//half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=false, starboard_clip=true);
//
//translate([108, 0, topside_bracket_extra_height])
//half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=true, starboard_clip=false);
//
//translate([74, 40, topside_bracket_extra_height])
//half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=false, starboard_clip=true);
//
//translate([108, 40, topside_bracket_extra_height])
//half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=true, starboard_clip=false);

//translate([20, -70, 0])
//half_droneside_bracket_v2(tolerance=final_tolerance, eport=true, y_offset=11);

//translate([90, -70, 0])
//half_droneside_bracket_v2(tolerance=final_tolerance, skyport=true);

// *************************************************************************

//translate([40, -50, 0])
//for( translation = [0, 10, 20, 30] )
//{
//    translate([translation, 0, alignment_peg_depth/2])
//    alignment_peg();
//}

//union()
//{
//    alignment_peg();
//    
//    translate([0, 10, 0])
//    alignment_peg();
//    
//    translate([0, 20, 0])
//    alignment_peg();
//    
//    translate([0, 30, 0])
//    alignment_peg();
//}