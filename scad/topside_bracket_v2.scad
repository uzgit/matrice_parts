include <../library/boxes.scad>
include <../library/regular_shapes.scad>
include <./v_track.scad>

$fn=120;

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

//module alignment_peg_hole()
//{
//    cylinder(h=alignment_peg_depth/2, d=alignment_peg_diameter, center=true);
//}

length=77.5;
//length=87.5;
tolerance=0.1;
base_length=17.5;
theta=65;
width=20;
height=6;
depth=3;
width_backstop_y = 10;

spacing_track_x = 40;
threaded_insert_translation_y = -30;

topside_bracket_extension_height = 6;
topside_bracket_extra_height = 9;
topside_bracket_width = 30;

clip_width = 7;
clip_spacing_x = 0.5;
clip_spacing_y = 0.5;
clip_attachment_length = 10;
clip_overhang_x = 4;

module half_droneside_bracket_v2(tolerance=tolerance)
{
    difference()
    {
        union()
        {
            // v track
            translate([0, 0, -tolerance/4])
            v_track_male_extrusion(height=height, width=width, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=height);
            
            // back stop
            p1 = [ base_length/2 + clip_overhang_x,     length/2 - width_backstop_y];
            p2 = [topside_bracket_width/2,             length/2 - width_backstop_y/2];
            p3 = [ topside_bracket_width/2,             length/2];
            p4 = [-topside_bracket_width/2,             length/2];
            p5 = [-topside_bracket_width/2,             length/2 - width_backstop_y/2];
            p6 = [-base_length/2 - clip_overhang_x,     length/2 - width_backstop_y];
            linear_extrude(height - tolerance/4)
            polygon([p1, p2, p3, p4, p5, p6]);
            
            // forward standoff
            translate([0, -screw_spacing_y/2, height])
            difference()
            {
                hull()
                {
                    translate([0, 0, -height_forward])
                    cylinder(d=11,h=height_forward - tolerance/4);
                    cylinder(d=diameter_standoff,h=height_forward - tolerance/4);
                }
                cylinder(d=diameter_screw_hole,h=height_forward);
            }
            
            // aft standoff
            translate([0, screw_spacing_y/2, height - tolerance/4])
            difference()
            {
                hull()
                {
                    translate([0, 0, -height_aft])
                    cylinder(d=11,h=height_aft);
                    cylinder(d=diameter_standoff,h=height_aft);
                }
                cylinder(d=diameter_screw_hole,h=height_aft);
            }
        }
        union()
        {
            // forward screw void
            translate([0, -screw_spacing_y/2, height])
            rotate([0, 180, 0])
                cylinder(d=diameter_screw_hole,h=height_bracket);
            
            // aft screw void
            translate([0, screw_spacing_y/2, height])
            rotate([0, 180, 0])
                cylinder(d=diameter_screw_hole,h=height_bracket);
            
            // screw head cones
            for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
            {
                translate([0, y_translation, 0])
//                base_plate_screw_head_cone();
                screw_head_cylinder();
            }
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
            v_track_female_extrusion(height=height, width=topside_bracket_width, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=height);
            
            // back stop
            translate([0, 0, -topside_bracket_extra_height/2])
            cube([topside_bracket_width, length, topside_bracket_extra_height], true);

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
                        cube([topside_bracket_width + 2*clip_width + 2*clip_spacing_x, length + clip_overhang_y + clip_spacing_y, total_height], true);
                    }

                    // negative space for arms
                    union()
                    {
                        // negative space for main bracket
                        cube([topside_bracket_width + 2*clip_spacing_x, length + clip_spacing_y, total_height], true);
                        
                        // clip tabs
                        p1 = [ topside_bracket_width/2 - clip_overhang_x, length/2];
                        p2 = [-topside_bracket_width/2 + clip_overhang_x, length/2];
                        p3 = [-topside_bracket_width/2 - 2, length/2 + clip_overhang_y + clip_spacing_y];
                        p4 = [ topside_bracket_width/2 + 2, length/2 + clip_overhang_y + clip_spacing_y];
                        translate([0, 0, -total_height/2])
                        linear_extrude(total_height)
                        polygon([p1, p2, p3, p4]);
                        
                        // remove clips if they are not wanted
                        x_translation = topside_bracket_width/2 + clip_spacing_x + clip_width/2;
                        // remove portside clip
                        if( ! portside_clip )
                        {
                            translate([x_translation, 0, 0])
                            cube([clip_width, length, total_height], true);
                            
                            translate([x_translation, length/2 + clip_overhang_y/2 + clip_spacing_y/2, 0])
                            cube([2*clip_width + clip_overhang_x, clip_overhang_y + clip_spacing_y, total_height], true);
                        }
                        // remove starboard clip
                        if( ! starboard_clip )
                        {
                            translate([-x_translation, 0, 0])
                            cube([clip_width, length, total_height], true);
                            
                            translate([-x_translation, length/2 + clip_overhang_y/2 + clip_spacing_y/2, 0])
                            cube([2*clip_width + clip_overhang_x, clip_overhang_y + clip_spacing_y, total_height], true);
                        }
                    }
                }
                
                x_translation = topside_bracket_width/2 + clip_spacing_x/2;
                if( portside_clip )
                {
                    translate([0, -length/2 + clip_attachment_length/2, 0])
                    translate([x_translation, 0, 0])
                    cube([clip_spacing_x, clip_attachment_length, total_height], true);
                }
                if( starboard_clip )
                {
                    translate([0, -length/2 + clip_attachment_length/2, 0])
                    translate([-x_translation, 0, 0])
                    cube([clip_spacing_x, clip_attachment_length, total_height], true);
                }
                
//                // reattach arms to main bracket
//                _x_translation = topside_bracket_width/2 + clip_spacing_x/2;
//                translate([0, -length/2 + clip_attachment_length/2, 0])
//                for( x_translation = [-_x_translation, _x_translation] )
//                {
//                    translate([x_translation, 0, 0])
//                    cube([clip_spacing_x, clip_attachment_length, total_height], true);
//                }
            }

        }
        union()
        {
            for( y_translation = [-screw_spacing_y/2, screw_spacing_y/2] )
            {
                // screw head cones
                translate([0, y_translation, 0])
                rotate([0, 180, 0])
//                base_plate_screw_head_cone();
                large_screw_head_cylinder();
                
                // screw hole voids
                translate([0, y_translation, -topside_bracket_extra_height + 0])
                cylinder(d=diameter_screw_hole,h=topside_bracket_extension_height);
            }       
            
            // alignment pegs
            for( y_translation = [-alignment_peg_spacing_y/2, alignment_peg_spacing_y/2] )
            {
                translate([0, y_translation, -topside_bracket_extra_height + 0])
                rotate([0, 180, 0])
                alignment_peg();
            }     
            
            // back stop void
            translate([0, length/2 - width_backstop_y/2, height/2])
            cube([topside_bracket_width, width_backstop_y, height], true);
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




final_tolerance = 0.5;
//translate([0, 0, 0])
//droneside_bracket_v2(tolerance=final_tolerance);
//
//translate([0, 0, 0])
//topside_bracket_v2(tolerance=final_tolerance);

// all parts for printing:
translate([0, 0, 0])
half_droneside_bracket_v2(tolerance=final_tolerance);

translate([33, 0, 0])
half_droneside_bracket_v2(tolerance=final_tolerance);

translate([74, 0, topside_bracket_extra_height])
half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=false, starboard_clip=true);

translate([108, 0, topside_bracket_extra_height])
half_topside_bracket_v2(tolerance=final_tolerance, portside_clip=true, starboard_clip=false);

translate([40, -50, 0])
for( translation = [0, 10, 20, 30] )
{
    translate([translation, 0, alignment_peg_depth/2])
    alignment_peg();
}

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