include <../library/regular_shapes.scad>
include <../library/boxes.scad>

$fn=120;

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

module tarot_680_base_plate_void_holes(void_thickness)
{
    // holes around the center for side arms
    for ( x_offset = [-92, -36, 36, 92] )
    {
        for ( y_offset = [-11, 11] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=7, h=void_thickness);
        }
    }
    
    for ( x_offset = [-21, 21] )
    {
        for ( y_offset = [-36.5, 36.5] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=7, h=void_thickness);
        }
    }
    
    for ( x_offset = [-81, 81] )
    {
        for ( y_offset = [-29.25, -20.25, 20.25, 29.25] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=7, h=void_thickness);
        }
    }
    
    for ( x_offset = [-30, 30] )
    {
        for ( y_offset = [-88.5, 88.5] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=7, h=void_thickness);
        }
    }
    
        for ( x_offset = [-38, 38] )
    {
        for ( y_offset = [-84, 84] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=7, h=void_thickness);
        }
    }
}

module tarot_680_base_plate_screw_holes(void_thickness)
{
    for ( x_offset = [-37, -23, 23, 37] )
    {
        for ( y_offset = [-73, 73] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=3.2, h=void_thickness);
        }
    }
    
    for ( x_offset = [-74, 74] )
    {
        for ( y_offset = [-11, 11] )
        {
            translate([x_offset, y_offset, 0])
            cylinder(d=3.2, h=void_thickness);
        }
    }
}

module supports()
{
    width = 10;
    height = 6;
    _x_translation = 58/2;
    _y_translation = 81/2;
    x_offset = 12;
    
    translate([x_offset, 0, 0])
    for( x_translation = [-_x_translation, _x_translation] )
    {
        for( y_translation = [-_y_translation, _y_translation] )
        {
            translate([x_translation - width/2, y_translation -width/2, 0])
            difference()
            {
                cube([width, width, height]);
                
                translate([width/2, width/2, height-6])
                cylinder(d=4, h=6);
            }
        }
    }
}

module base_plate( thickness=4.5, bottom_thickness=4, radius=205/2, wall_height=35, wall_thickness=3, edge_thickness=1.3, edge_height=5 )
{
    difference()
    {
        union()
        {
            // bottom base
//            difference()
//            {
//                dodecagon_prism_rotated(height=bottom_thickness, radius=radius);
//                tarot_680_base_plate_void_holes(thickness);
//            }
            
            // top base
//            translate([0, 0, bottom_thickness])
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
//        union()
//        {
//            through_hole_diameter = 20;
//            
//            tarot_680_base_plate_screw_holes(thickness);
//            
//            dodecagon_prism_rotated(height=edge_height, radius=50);
//            
//            for(angle = [0 : 60 : 359])
//                rotate([0, 0, angle])
//                translate([0, -63, 0])
//                cylinder(d=through_hole_diameter, h=thickness);
//        }
    }
}

//module top(radius=198/2, height=70, wall_thickness=3, wall_height=5, edge_thickness=1.5, edge_height=1.5 )
//{
//    // edge
//    difference()
//    {
//        dodecagon_prism_rotated(height=edge_height, radius=radius);
//        dodecagon_prism_rotated(height=edge_height, radius=radius-(wall_thickness-edge_thickness));
//    }
//    
//    // wall
//    translate([0, 0, edge_height])
//    difference()
//    {
//        dodecagon_prism_rotated(height=wall_height, radius=radius);
//        dodecagon_prism_rotated(height=wall_height, radius=radius-wall_thickness);
//    }
//}

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
//            translate([0, 0, edge_height - wall_thickness + height])
////            cylinder(d=21, h=wall_thickness);
//            {
//                cylinder(d=10, h=wall_thickness);
//                for( x_translation = [-10, 10] )
//                for( y_translation = [-10, 10] )
//                {
//                    translate([x_translation, y_translation, 0])
//                    cylinder(d=3.2, h=wall_thickness);
//                }
//            }
        }
    }
}

//base_plate(radius=75, wall_height=5);

translate([0, 0, 50])
top(radius=75, height=60);
