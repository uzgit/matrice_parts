include <../library/regular_shapes.scad>
include <../library/boxes.scad>
include <../library/roundedcube.scad>

$fn=20;
screw_spacing_x = 78;
screw_spacing_y = 66;

alignment_peg_spacing_y = 50;
alignment_peg_depth     = 10;
alignment_peg_diameter  =  6;
module alignment_peg()
{
    cylinder(h=alignment_peg_depth, d=alignment_peg_diameter, center=true);
}

module dodecagon_rotated(radius, rotation=15)
{
    rotate([0, 0, rotation])
    dodecagon(radius);
}

module dodecagon_prism_rotated(height, radius, rotation=15)
{
    rotate([0, 0, rotation])
    dodecagon_prism(height, radius);
}

module supports(height=6, holes=true)
{
    width = 10;
//    height = 6;
    _x_translation = 55/2;
    _y_translation = 55/2;
    x_offset = 0;
    
    translate([x_offset, 0, 0])
    for( x_translation = [-_x_translation, _x_translation] )
    {
        for( y_translation = [-_y_translation, _y_translation] )
        {
            translate([x_translation - width/2, y_translation -width/2, 0])
            difference()
            {
                cube([width, width, height]);
                
                if(holes)
                {
                    translate([width/2, width/2, height-6])
                    cylinder(d=4, h=6);
                }
            }
        }
    }
}

module base_plate( thickness=6, bottom_thickness=4, radius=205/2, wall_height=35, wall_thickness=3, edge_thickness=1.3, edge_height=7, locking_screws=true )
{
    difference()
    {
        union()
        {
            dodecagon_prism_rotated(height=thickness, radius=radius);
            
            // wall
            translate([0, 0, thickness])
            difference()
            {
                dodecagon_prism_rotated(height=wall_height, radius=radius);
                dodecagon_prism_rotated(height=wall_height, radius=radius-wall_thickness);
            }
            
            translate([0, 0, thickness])
            supports();
            
            // edge
            translate([0, 0, thickness+wall_height])
            difference()
            {
                dodecagon_prism_rotated(height=edge_height, radius=radius-wall_thickness+edge_thickness);
                dodecagon_prism_rotated(height=edge_height, radius=radius-wall_thickness);
            }
        }
        union()
        {
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        cylinder(d=3.2, h=6);
                        translate([0, 0, 1.5]) // to reverse the direction without the rotation command
                        cylinder(d=4, h=4.5);
                    }
                }
                
                for( y_translation=[-alignment_peg_spacing_y/2, alignment_peg_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    alignment_peg();
                }
            }
            
            translate([0, -radius + 5, bottom_thickness + 9])
            cube([4, 10, 12], center=true);
            
            if( locking_screws )
            {
                num = 3;
                
                lock_x = 35;
                lock_y = 7;
                lock_z = 25;
                
                for( angle = [ 0 : 360/num : 360 ] )
                {
                    rotate([0, 0, angle])
                    translate([0, radius+0.943, 0])
                    difference()
                    {
                        for(x_translation = [-10, 10])
                        {
                            translate([x_translation, -10, 15])
                            rotate([90, 0, 180])
                            cylinder(d=3.2, h=20);
                        }
                    }
                }
            }
        }
    }
    
    if( locking_screws )
    {
        num = 3;
        
        lock_x = 35;
        lock_y = 7;
        lock_z = 22.5;
        
        for( angle = [ 0 : 360/num : 360 ] )
        {
            rotate([0, 0, angle])
            translate([0, radius+0.943, 0])
            difference()
            {
                translate([-lock_x/2, -lock_y/2, 0])
                cube([lock_x, lock_y, lock_z]);
                for(x_translation = [-10, 10])
                {
                    translate([x_translation, -10, 15])
                    rotate([90, 0, 180])
                    cylinder(d=4, h=20);
                }
            }
        }
    }
}

module top(radius=205/2, height=90, wall_thickness=3, wall_height=5, edge_thickness=1.8, edge_height=7, locking_clips=false, locking_screws=true, ventilation=false )
{
    difference()
    {
        union()
        {
            // edge
            difference()
            {
                dodecagon_prism_rotated(height=edge_height, radius=radius);
                dodecagon_prism_rotated(height=edge_height, radius=radius-(wall_thickness-edge_thickness));
            }
            
            // main canopy
            difference()
            {
                union()
                {
                    hull()
                    {
                        // wall
                        translate([0, 0, edge_height])
                        dodecagon_prism_rotated(height=wall_height, radius=radius);
                        
                        translate([0, 0, edge_height - wall_height + height])
                        dodecagon_prism_rotated(height=wall_height, radius=radius/1.2);
                    }
                    if( ventilation )
                    {
                        num_vents = 6;
                        vent_side_length = 30;
                        vent_height = 50;
                        _z_translation = 38;
                        
                        for( angle = [ 0 : 360/num_vents : 360 ] )
                        {
                            rotate([0, 0, angle])
                            translate([0, radius - 15, _z_translation])
                            rotate([36, 0, 0])
                            difference()
                            {
                                roundedcube([vent_side_length, vent_side_length, vent_height], 0.6);
                                translate([0, 0, -1])
                                roundedcube([vent_side_length-2, vent_side_length-2, vent_height-1], 0.6);
                            }
                        }        
                    }
                }
                
                union()
                {
                    hull()
                    {
                        // wall
                        translate([0, 0, edge_height])
                        dodecagon_prism_rotated(height=wall_height, radius=radius-wall_thickness);
                        
                        translate([0, 0, edge_height - wall_height + height])
                        dodecagon_prism_rotated(height=wall_height-wall_thickness, radius=(radius/1.2)-wall_thickness);
                                                
                    }
                    if( ventilation )
                    {
                        num_vents = 6;
                        vent_side_length = 30;
                        vent_height = 50;
//                        _z_translation = 38;
                        
                        for( angle = [ 0 : 360/num_vents : 360 ] )
                        {
                            rotate([0, 0, angle])
                            translate([0, radius - 10, 40])
                            rotate([15, 0, 0])
                            for( x_translation = [-13 : 2 : 13] )
                            {
                                for( z_translation = [-11 : 2 : 17] )
                                {
                                    translate([x_translation, 0, z_translation])
                                    cube([1.5, 5, 1.5], center=true);
                                }
                            }                            
                        }        
                    }                    
//                    if( ventilation )
//                    {
//                        num_vents = 6;
//                        
//                        for( angle = [ 0 : 360/num_vents : 360 ] )
//                        {
//                            rotate([0, 0, angle])
//                            translate([0, radius - 20, 30])
//                            for( x_translation = [-13 : 2 : 13] )
//                            {
//                                for( z_translation = [-15 : 2 : 17] )
//                                {
//                                    translate([x_translation, 0, z_translation + 10])
//                                    cube([1.5, 20, 1.5], center=true);
//                                }
//                            }
//                        }        
//                    }
                }
            }
        }
        
        if( locking_screws )
        {
            num = 3;
            
            lock_x = 35;
            lock_y = 7;
            lock_z = 25;
            
            for( angle = [ 0 : 360/num : 360 ] )
            {
                rotate([0, 0, angle])
                translate([0, radius+0.943, 0])
                difference()
                {
                    for(x_translation = [-10, 10])
                    {
                        translate([x_translation, -10, 4])
                        rotate([90, 0, 180])
                        cylinder(d=3.2, h=20);
                    }
                }
            }
        }
    }
    
    

    
    if( locking_clips )
    {
        num_clips = 3;
        
        for( angle = [ 0 : 360/num_clips : 360 ] )
        {
            angle = angle + 90;
            
            // thickness of the bottom plate that the top mounts onto
            base_plate_thickness = 11;
            
            clip_x = 2;
            clip_y = 20;
            clip_z = edge_height*2 + base_plate_thickness;
            
            clip_overhang_radial = 3;
            clip_overhang_z = 10;
            
            rotate([0, 0, angle])
//            translate([radius-0.59, 0, 0])
            translate([radius-0.56, 0, 0])
            translate([-clip_x, clip_y/2, edge_height*2]) // i cannot derive the x offset sadly
            rotate([180, 0, 0])
            union()
            {
                union()
                {
                    cube([clip_x, clip_y, clip_z]);
                }
                
                translate([0, 0, clip_z + clip_overhang_z])
                rotate([0, 180, 0])
                difference()
                {
                    union()
                    {
                        translate([-2, 0, 0])
                        cube([clip_overhang_radial*2, clip_y, clip_overhang_z]);
                    }
                    translate([-2, 0, -0.5])
                    rotate([0, 45, 0])
                    cube([10, clip_y, 10]);
                }
            }
        }
    }
}

module component_mounting_plate_rpi(side_length=70, height=6)
{
//    side_length = 50;
    
    difference()
    {
        union()
        {
            translate([0, 0, height/2])
            cube([side_length, side_length, height], center=true);
        }
        
        width = 10;
        support_hole_height = 3;
        _x_translation = 55/2;
        _y_translation = 55/2;
        x_offset = 0;
        
        union()
        {
            translate([x_offset, 0, 0])
            for( x_translation = [-_x_translation, _x_translation] )
            {
                for( y_translation = [-_y_translation, _y_translation] )
                {
                    translate([x_translation - width/2, y_translation -width/2, 0])
                    cube([width, width, support_hole_height]);
                }
            }
            
            translate([width/2, width/2, 0])
            for( x_translation = [-_x_translation, _x_translation] )
            {
                for( y_translation = [-_y_translation, _y_translation] )
                {
                    translate([x_translation - width/2, y_translation -width/2, 0])
                    cylinder(d=4,h=20);
//                    cube([width, width, support_hole_height]);
                }
            }
        }
    }
}

module component_mounting_plate_jetson_nano(height=5)
{
    plate_screw_x_offset = 3;
    plate_screw_y_offset = 17;
    plate_screw_translation = 55/2;
    support_hole_width = 10;
    support_hole_height = 3;
    
    jetson_screw_x_translation = 86;
    jetson_screw_y_translation = 58;
    jetson_standoff_height = 3;
    
    tolerance = 4;
    
    difference()
    {
        union()
        {
            translate([-jetson_screw_x_translation/2 - tolerance, -jetson_screw_y_translation/2 - plate_screw_y_offset -tolerance, 0])
            cube([jetson_screw_x_translation + tolerance*2, jetson_screw_y_translation + plate_screw_y_offset + tolerance*2, height]);
            
            
            for(x_translation = [-jetson_screw_x_translation/2, jetson_screw_x_translation/2])
            {
                for(y_translation = [-jetson_screw_y_translation/2, jetson_screw_y_translation/2])
                {
                    translate([x_translation, y_translation, height])
                    difference()
                    {
                        cylinder(d=4,h=jetson_standoff_height);
                        cylinder(d=1.75,h=jetson_standoff_height);
                    }
                }
            }            
        }        
        union()
        {
            for(x_translation = [-plate_screw_translation, plate_screw_translation])
            {
                for(y_translation = [-plate_screw_translation, plate_screw_translation])
                {
                    translate([x_translation + plate_screw_x_offset, y_translation - plate_screw_y_offset, 0])
                    union()
                    {
                        cylinder(d=4,h=20);
                        cube([support_hole_width, support_hole_width, support_hole_height], center=true);
                    }
                }
            }
            
            for(x_translation = [-jetson_screw_x_translation/2, jetson_screw_x_translation/2])
            {
                for(y_translation = [-jetson_screw_y_translation/2, jetson_screw_y_translation/2])
                {
                    translate([x_translation, y_translation, 0])
                    cylinder(d=1.75,h=height);
                }
            }
        }
    }
}

//translate([0, 0, 50])
//component_mounting_plate_rpi();
//component_mounting_plate_jetson_nano();

base_plate(radius=75, wall_height=5);

//translate([0, 0, 60])
//translate([0, 0, 11])
//top(radius=75, height=60);

