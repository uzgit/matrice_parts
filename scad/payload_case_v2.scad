include <../library/boxes.scad>
include <../library/roundedcube.scad>
include <../library/honeycomb.scad>

$fn=60;

radius = 145/2;
top_radius = radius / 1.2;

wall_thickness = 3;
wall_height = 5;
edge_thickness = 1.8;
edge_height=9;
canopy_height = 90;
locking_screws = true;
num_lock_blocks = 3;
locking_screw_angles = [ 0 : 360/num_lock_blocks : 359 ];
lock_block_x = 10;
lock_block_y = 10;
lock_block_z = 6;
//lock_block_translation_x = radius - 
canopy_height = 65;
canopy_top_thickness = 3;
ventilation = true;
ventilation_height = 4;
ventilation_width  = 20;
ventilation_depth  = radius;
ventilation_honeycomb_depth = 42;
ventilation_honeycomb_center_translation = 18;

screw_spacing_x = 78;
screw_spacing_y = 66;

fan_side   = 40;
fan_screw_xy  = 32;
fan_screw_diameter = 4.5;
fan_height = 20;
fan_honeycomb_thickness = 2;
fan_diameter = 38;
fan_cage_height = 25; // height from bottom of case, not bottom of fan
fan_cage_side = 50;
fan_cage_wall_thickness = 5;
fan_cage_honeycomb_diameter = 5;
fan_cage_honeycomb_thickness = 0.75;
fan_cage_top_support_thickness = 3;

alignment_peg_spacing_y = 50;
alignment_peg_depth     = 10;
alignment_peg_diameter  =  6;

vertical_structural_support_x = 10;
vertical_structural_support_y = screw_spacing_y + 20;
horizontal_structural_support_y = 55;

vent_honeycomb_height = 15;
vent_honeycomb_side = 35;
vent_honeycomb_depth = 10;
vent_honeycomb_diameter = 1;
vent_honeycomb_thickness = 0.2;

module fan()
{
    roundedCube([fan_side, fan_side, fan_height], center=true, 3, "z");
}

module alignment_peg()
{
    cylinder(h=alignment_peg_depth, d=alignment_peg_diameter, center=true);
}

module regular_polygon(sides, apothem)
{
  phi = 90 - 90*(sides-2)/sides;
  radius = apothem / cos(phi);

  function dia(r) = sqrt(pow(r*2,2)/2);  //sqrt((r*2^2)/2) if only we had an exponention op
  if(sides<2) square([radius,0]);
  if(sides==3) triangle(radius);
  if(sides==4) square([dia(radius),dia(radius)],center=true);
  if(sides>4) {
    angles=[ for (i = [0:sides-1]) i*(360/sides) ];
    coords=[ for (th=angles) [radius*cos(th), radius*sin(th)] ];
    
    angle = 90*(sides-2)/sides;
    rotate([0, 0, phi])
    polygon(coords);
  }
}

module dodecagon_prism(height, radius)
{
    linear_extrude(height)
    {
        regular_polygon(12, radius);
    }
}

module everything()
{
    cube([10000, 10000, 10000], center=true);
}

module base_plate( thickness=6, bottom_thickness=3, wall_thickness=3, edge_thickness=1.3, locking_screws=true )
{
    difference()
    {
        // primary positive space
        union()
        {
            // bottom
            dodecagon_prism(height=bottom_thickness, radius=radius);
            
            // wall
            translate([0, 0, bottom_thickness])
            difference()
            {
                dodecagon_prism(height=thickness+wall_height, radius=radius);
                dodecagon_prism(height=thickness+wall_height, radius=radius-wall_thickness);
            }
            
            // edge
            translate([0, 0, thickness+wall_height])
            difference()
            {
                dodecagon_prism(height=edge_height, radius=radius-wall_thickness+edge_thickness);
                dodecagon_prism(height=edge_height, radius=radius-wall_thickness);
            }
            
            // structural supports
            for( x_translation = [-screw_spacing_x/2, screw_spacing_x/2] )
            {
                translate([x_translation, 0, bottom_thickness + (thickness-bottom_thickness)/2])
                cube([vertical_structural_support_x, vertical_structural_support_y, thickness-bottom_thickness], center=true);
            }
            
            translate([0, 0, bottom_thickness + (thickness-bottom_thickness)/2])
            cube([screw_spacing_x, horizontal_structural_support_y, thickness-bottom_thickness], center=true);
            
            if( locking_screws )
            {
//                for( angle = locking_screw_angles )
//                {   
//                    rotate([0, 0, angle])
//                    translate([radius - lock_block_y, 0, lock_block_z/2])
//                    cube([lock_block_x, lock_block_y, lock_block_z], center=true);
//                }
            }
        }
        // negative space
        union()
        {
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        cylinder(d=3.75, h=6);
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
            
            // e port cable slot
            translate([0, -radius, bottom_thickness + 13])
            roundedCube([4, 20, 14], 2, center=true);
            
            if( locking_screws )
            {
//                num = 3;
//                
//                lock_x = 35;
//                lock_y = 7;
//                lock_z = 25;
//                
//                for( angle = [ 0 : 360/num : 360 ] )
//                {
//                    rotate([0, 0, angle])
//                    translate([0, radius, 22])
//                    cube([36, 30, 15], center=true);
//                }
            }
            
            // fan void
            translate([0, 0, fan_height/2 + fan_honeycomb_thickness])
            roundedCube([fan_side, fan_side, fan_height], center=true, 3, "z");
            
            // fan exhaust void
            cylinder(d=fan_diameter, h=bottom_thickness);
            
            for( x_translation = [-fan_screw_xy/2, fan_screw_xy/2] )
            {
                for( y_translation = [-fan_screw_xy/2, fan_screw_xy/2] )
                {
                    translate([x_translation, y_translation, 0])
                    cylinder(d=fan_screw_diameter, h=bottom_thickness);
                }
            }
        }
    }
    // secondary positive space
    union()
    {
        // fan honeycomb without intersecting fan screw holes
        difference()
        {
            // fan honeycomb
            translate([-fan_side/2, -fan_side/2, 0])
            linear_extrude(fan_honeycomb_thickness) {
                honeycomb(fan_side, fan_side, 5, 0.5);
            }
            
            // remove everything outside of the fan exhaust void
            difference()
            {
                everything();
                // fan exhaust void
                cylinder(d=fan_diameter, h=bottom_thickness);
            }
        }
        
        // fan honeycomb cage
        translate([0, 0, fan_cage_height/2 + thickness])
        union()
        {
            // left vertical wall
            translate([-fan_cage_side/2, 0, 0])
            rotate([0, 90, 0])
            translate([-fan_cage_height/2, -fan_cage_side/2, -fan_cage_wall_thickness/2])
            linear_extrude(fan_cage_wall_thickness) {
                honeycomb(fan_cage_height, fan_cage_side, fan_cage_honeycomb_diameter, fan_cage_honeycomb_thickness);
            }
            
            // right vertical wall
            translate([fan_cage_side/2, 0, 0])
            rotate([0, 90, 0])
            translate([-fan_cage_height/2, -fan_cage_side/2, -fan_cage_wall_thickness/2])
            linear_extrude(fan_cage_wall_thickness) {
                honeycomb(fan_cage_height, fan_cage_side, fan_cage_honeycomb_diameter, fan_cage_honeycomb_thickness);
            }
            
            // top horizontal wall
            translate([0, fan_cage_side/2, 0])
            rotate([0, 90, 90])
            translate([-fan_cage_height/2, -fan_cage_side/2, -fan_cage_wall_thickness/2])
            linear_extrude(fan_cage_wall_thickness) {
                honeycomb(fan_cage_height, fan_cage_side, fan_cage_honeycomb_diameter, fan_cage_honeycomb_thickness);
            }
            
            // bottom horizontal wall
            translate([0, -fan_cage_side/2, 0])
            rotate([0, 90, 90])
            translate([-fan_cage_height/2, -fan_cage_side/2, -fan_cage_wall_thickness/2])
            linear_extrude(fan_cage_wall_thickness) {
                honeycomb(fan_cage_height, fan_cage_side, fan_cage_honeycomb_diameter, fan_cage_honeycomb_thickness);
            }
            
            // corner posts
            for( x_translation = [-fan_cage_side/2, fan_cage_side/2] )
            {
                for( y_translation = [-fan_cage_side/2, fan_cage_side/2] )
                {
                    translate([x_translation, y_translation, 0])
                    cylinder(d=fan_cage_wall_thickness, h=fan_cage_height, center=true);
                }
            }
            
            // top braces
            for( x_translation = [-fan_cage_side/2, fan_cage_side/2] )
            {
                translate([x_translation, 0, fan_cage_height/2 - fan_cage_top_support_thickness/2])
                cube([fan_cage_wall_thickness, fan_cage_side, fan_cage_top_support_thickness], center=true);
            }
            for( y_translation = [-fan_cage_side/2, fan_cage_side/2] )
            {
                translate([0, y_translation, fan_cage_height/2 - fan_cage_top_support_thickness/2])
                cube([fan_cage_side, fan_cage_wall_thickness, fan_cage_top_support_thickness], center=true);
            }
        }
        
//        translate([0, 0, fan_height/2 + bottom_thickness])
//        fan();
    }
    
    if( locking_screws )
    {
//        num = 3;
//        
//        lock_x = 35;
//        lock_y = 7;
//        lock_z = 29;
//        
//        for( angle = [ 0 : 360/num : 360 ] )
//        {
//            rotate([0, 0, angle])
//            translate([0, radius, 0])
//            difference()
//            {
//                translate([-lock_x/2, 0, 0])
//                cube([lock_x, lock_y, lock_z]);
//                for(x_translation = [-10, 10])
//                {
//                    translate([x_translation, -10, 20])
//                    rotate([90, 0, 180])
//                    cylinder(d=4, h=20);
//                }
//            }
//        }
    }
}

//module top()
//{
//    dodecagon_prism(height=wall_thickness, radius=top_radius);
//
//    num = 12;
//    for( angle = [ 0 : 360/num : 360 ] )
//    {
//        rotate([0, 0, angle])
//        difference()
//        {
//            translate([0, 0, wall_thickness/2 + vent_honeycomb_height/2])
//            rotate([0, 90, 90])
//            translate([-vent_honeycomb_height/2, -vent_honeycomb_side/2, top_radius - vent_honeycomb_depth/2])
//            linear_extrude(vent_honeycomb_depth) {
//                honeycomb(vent_honeycomb_height, vent_honeycomb_side, vent_honeycomb_diameter, vent_honeycomb_thickness);
//            }
//        }
//    }
//}

//module top(wall_thickness=3, wall_height=5, edge_thickness=1.8, edge_height=7, locking_clips=false, locking_screws=true, ventilation=false )
module top()
{
    difference()
    {
        // primary positive space
        union()
        {
            // bottom edge
            difference()
            {
                dodecagon_prism(height=edge_height, radius=radius);
                dodecagon_prism(height=edge_height, radius=radius-(wall_thickness-edge_thickness));
            }
            
            // main canopy
            difference()
            {
                hull()
                {
                    // wall
                    translate([0, 0, edge_height])
                    dodecagon_prism(height=wall_height, radius=radius);
                    
                    translate([0, 0, edge_height - wall_height + canopy_height])
                    dodecagon_prism(height=wall_height, radius=top_radius);
                }
                hull()
                {
                    // wall
                    translate([0, 0, edge_height])
                    dodecagon_prism(height=wall_height, radius=radius-wall_thickness);
                    
                    translate([0, 0, edge_height - wall_height + canopy_height - canopy_top_thickness])
                    dodecagon_prism(height=wall_height-wall_thickness, radius=top_radius-wall_thickness);
                }
            }
        }
        union()
        {
            if( ventilation )
            {
                num = 6;
                
                for( angle = [ 0 : 360/num : 359 ] )
                {
                    rotate([0, 0, angle])
                    translate([0, top_radius/2, canopy_height + canopy_top_thickness + edge_height - 6])
                    union()
                    {
                        rotate([90, 0, 180])
                        roundedCube([ventilation_width, ventilation_height, ventilation_depth], 1, "xy", center=true);
                    }
                }
                
                translate([0, 0, canopy_height + edge_height - 7])
                cylinder(d=30, h=5, center=true);
            }
            
            if( locking_screws )
            {
//                num = 3;
//                
//                lock_x = 35;
//                lock_y = 7;
//                lock_z = 25;
//                
//                for( angle = [ 0 : 360/num : 359 ] )
//                {
//                    rotate([0, 0, angle])
//                    translate([0, radius, 6])
//                    difference()
//                    {
//                        for(x_translation = [-10, 10])
//                        {
//                            translate([x_translation, 0, 0])
//                            rotate([90, 0, 180])
//                            cylinder(d=3.2, h=wall_thickness, center=true);
//                        }
//                    }
//                }
            }
        }
    }
    
    if( ventilation )
    {
        num = 6;
        
        for( angle = [ 0 : 360/num : 359 ] )
        {
            rotate([0, 0, angle])
            translate([0, ventilation_honeycomb_center_translation, canopy_height + canopy_top_thickness + edge_height - 6])
            union()
            {
                rotate([0, 90, 90])
                translate([-ventilation_height/2, -ventilation_width/2, 0])
                linear_extrude(ventilation_honeycomb_depth) {
                    honeycomb(ventilation_height, ventilation_width, vent_honeycomb_diameter, vent_honeycomb_thickness);
                }
            }
        }
    }
}

//rotate([0, 0, 15])
//my_regular_polygon(12, 100);

base_plate();

translate([0, 200, 0])
//translate([0, 0, 14])
//top(radius=75, height=60);
top();
