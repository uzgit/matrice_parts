include <../library/regular_shapes.scad>
include <../library/boxes.scad>

$fn=20;
screw_spacing_x = 78;
screw_spacing_y = 66;

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

module base_plate( thickness=6, bottom_thickness=4, radius=205/2, wall_height=35, wall_thickness=3, edge_thickness=1.3, edge_height=5 )
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
            }
        }
    }
}

module top(radius=205/2, height=90, wall_thickness=3, wall_height=5, edge_thickness=1.8, edge_height=5 )
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
                hull()
                {
                    // wall
                    translate([0, 0, edge_height])
                    dodecagon_prism_rotated(height=wall_height, radius=radius);
                    
                    translate([0, 0, edge_height - wall_height + height])
                    dodecagon_prism_rotated(height=wall_height, radius=radius/1.2);
                }
                
                hull()
                {
                    // wall
                    translate([0, 0, edge_height])
                    dodecagon_prism_rotated(height=wall_height, radius=radius-wall_thickness);
                    
                    translate([0, 0, edge_height - wall_height + height])
                    dodecagon_prism_rotated(height=wall_height-wall_thickness, radius=(radius/1.2)-wall_thickness);
                }
            }
        }
        union()
        {

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
        support_hole_height = 4;
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
    plate_screw_y_offset = 17;
    plate_screw_translation = 55/2;
    support_hole_width = 10;
    support_hole_height = 3;
    
    jetson_screw_x_translation = 86;
    jetson_screw_y_translation = 58;
    
    tolerance = 4;
    
    difference()
    {
        union()
        {
            translate([-jetson_screw_x_translation/2 - tolerance, -jetson_screw_y_translation/2 - plate_screw_y_offset -tolerance, 0])
            cube([jetson_screw_x_translation + tolerance*2, jetson_screw_y_translation + plate_screw_y_offset + tolerance*2, height]);
        }        
        union()
        {
            for(x_translation = [-plate_screw_translation, plate_screw_translation])
            {
                for(y_translation = [-plate_screw_translation, plate_screw_translation])
                {
                    translate([x_translation, y_translation - plate_screw_y_offset, 0])
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
                    cylinder(d=2,h=20);
                }
            }
        }
    }
}

//translate([0, 0, 50])
//component_mounting_plate_rpi();
component_mounting_plate_jetson_nano();

//base_plate(radius=75, wall_height=5);

//translate([0, 0, 50])
//top(radius=75, height=60);
