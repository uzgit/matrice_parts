include <quick_release_bracket_v4.scad>

$fn=60;

main_radius = 150/2;             // main radius at the bottom of the payload
top_radius = main_radius / 1.15; // radius at the top of the payload

thickness = 10;         // thickness of the whole base
bottom_thickness = 3;   // thickness of the bottom-most surface
edge_thickness = 1.2;   // thickness of the edge between the top and bottom
edge_height = 5;        // height of the edge between the top and bottom
wall_thickness = 3;     // total wall thickness
canopy_top_wall_thickness = 2; //
intended_wall_height = 1;
//wall_height = max(thickness+edge_height+1, intended_wall_height);  // primary control for the z-distance extrusion of the bottom wall
wall_height = thickness + edge_height + 1;
eport_cable_clearance_x = 4;
eport_cable_clearance_y = 20;
eport_cable_clearance_z = 2*(3.5 + edge_height); // below the edge, so eport_cable_clearance_z < bottom_thickness + (thickness - edge_height)
eport_cable_clearance_r = 2;
eport_wall_angle = 30;
skyport_wall_angle = -30;

lock_screws = true; // screws to attach the top to the bottom
threaded_insert_diameter = 4; // threaded inserts for attaching the top to the bottom and the bottom to the sliding tracks
num_lock_blocks = 3;   // how many screws to connect the top to the bottom
lock_screw_radius = main_radius - 5; // distance from the payload center to the lock screws
canopy_height = 80;
canopy_top_thickness = 2;

// for the screws to connect the base to the sliding brackets
screw_spacing_x = 78;
screw_spacing_y = 66;

//**********************************************************************************
/**
 * Honeycomb library
 * License: Creative Commons - Attribution
 * Copyright: Gael Lafond 2017
 * URL: https://www.thingiverse.com/thing:2484395
 *
 * Inspired from:
 *   https://www.thingiverse.com/thing:1763704
 */

// a single filled hexagon
//module hexagon(l)  {
//	circle(d=l, $fn=6);
//}

// parametric honeycomb  
module honeycomb(x, y, dia, wall)  {
	// Diagram
	//          ______     ___
	//         /     /\     |
	//        / dia /  \    | smallDia
	//       /     /    \  _|_
	//       \          /   ____ 
	//        \        /   / 
	//     ___ \______/   / 
	// wall |            /
	//     _|_  ______   \
	//         /      \   \
	//        /        \   \
	//                 |---|
	//                   projWall
	//
	smallDia = dia * cos(30);
	projWall = wall * cos(30);

	yStep = smallDia + wall;
	xStep = dia*3/2 + projWall*2;

	difference()  {
		square([x, y]);

		// Note, number of step+1 to ensure the whole surface is covered
		for (yOffset = [0:yStep:y+yStep], xOffset = [0:xStep:x+xStep]) {
			translate([xOffset, yOffset]) {
				hexagon(dia);
			}
			translate([xOffset + dia*3/4 + projWall, yOffset + (smallDia+wall)/2]) {
				hexagon(dia);
			}
		}
	}
}
//**********************************************************************************

//**********************************************************************************
// roundedcube.scad
// Higher definition curves
$fs = 0.01;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}
//**********************************************************************************

module regular_polygon(sides, apothem)
{
    phi = 90 - 90*(sides-2)/sides;
    main_radius = apothem / cos(phi);

    function dia(r) = sqrt(pow(r*2,2)/2);  //sqrt((r*2^2)/2) if only we had an exponention op
    if(sides <  2) square([main_radius,0]);
    if(sides == 3) triangle(main_radius);
    if(sides == 4) square([dia(main_radius),dia(main_radius)],center=true);
    if(sides >  4)
    {
        angles=[ for (i = [0:sides-1]) i*(360/sides) ];
        coords=[ for (th=angles) [main_radius*cos(th), main_radius*sin(th)] ];

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

module practically_everything()
{
    cube([10000, 10000, 10000], center=true);
}

module base(component_mounts=false)
{
    edge_height_offset = 0.5;
    difference()
    {
        // primary positive space
        union()
        {
            difference()
            {
                // bottom
                dodecagon_prism(height=bottom_thickness, radius=main_radius);
                
                translate([0, 0, bottom_thickness/2])
                {
                    translate([-1, 0, 0])
                    roundedcube([23, 125, 2*bottom_thickness], radius=3, center=true);
                }
            }
            
            // wall
            difference()
            {
                // main positive space for the base
                dodecagon_prism(height=wall_height, radius=main_radius);
                
                union()
                {
                    // remove positive space within the wall
                    dodecagon_prism(height=wall_height, radius=main_radius-wall_thickness);
                    
                    translate([0, 0, wall_height - edge_height])
                    difference()
                    {
                        union()
                        {
                            dodecagon_prism(height=edge_height, radius=main_radius);
                        }
                        union()
                        {
                            dodecagon_prism(height=edge_height, radius=main_radius-wall_thickness+edge_thickness);
                        }
                    }
                }
                
                translate([0, 0, wall_height - edge_height_offset])
                dodecagon_prism(height=wall_height, radius=main_radius);
            }
            
            // reinforcements for mounting screws
            if( lock_screws )
            {
                for( angle = [ 0 : 360/num_lock_blocks : 359 ] )
                {
                    rotate([0, 0, angle])
                    translate([0, lock_screw_radius, 0])
                    difference()
                    {
                        hull()
                        {
                            cylinder(d=10, h=wall_height - 0.5);
                            
                            translate([0, 2.5, wall_height/2])
                            cube([10, 1, wall_height - 1], center=true);
                        }
                        
                        union()
                        {
                            cylinder(d=threaded_insert_diameter, h=wall_height);
                        
                            translate([0, 4, 0])
                            cube([20, 3, 50], center=true);
                        }
                    }
                }
            }
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        translate([0, 0, 3])
                        roundedcube([10, 10, 6], center=true);
                    }
                }
            }
            
            // honeycomb inner base
            difference()
            {
                union()
                {
                    translate([-200/2, -200/2, 0])
                    translate([1.75, 0, 0]) // set screw for making the honeycomb align better to the cavity
                    linear_extrude( bottom_thickness )
                    {
                        honeycomb(200, 200, 3, 6);
                    }
                }
                difference()
                {
                    practically_everything();
                    union()
                    {
                        cylinder(d=145, h=bottom_thickness);
                    }
                }
            }
        }
        // negative space
        union()
        {
            // holes for threaded inserts for bottom mounts
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        cylinder(d=threaded_insert_diameter, h=thickness);
                    }
                }
            }
        }
        
            // e port cable slot
            rotate([0, 0, eport_wall_angle])
            translate([0, -main_radius, wall_height])
            roundedCube([eport_cable_clearance_x, eport_cable_clearance_y, eport_cable_clearance_z], eport_cable_clearance_r, center=true);
            
            // sky port cable slot
            rotate([0, 0, skyport_wall_angle])
            translate([0, -main_radius, wall_height])
            roundedCube([eport_cable_clearance_x, eport_cable_clearance_y, eport_cable_clearance_z], eport_cable_clearance_r, center=true);
    }
    
    translate([-27, 0, bottom_thickness/2])
    cube([10, 100, bottom_thickness], center=true);
    
    translate([19, 0, bottom_thickness/2])
    cube([17.5, 100, bottom_thickness], center=true);
    
    if( component_mounts )
    {
        translate([15, -34, 5 + bottom_thickness])
        rotate([0, 0, -90])
        component_mount();
    }
}

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
                dodecagon_prism(height=edge_height, radius=main_radius);
                dodecagon_prism(height=edge_height, radius=main_radius-edge_thickness);
            }
            
            // wall
            translate([0, 0, edge_height])
            difference()
            {
                dodecagon_prism(height=wall_height, radius=main_radius);
                dodecagon_prism(height=wall_height, radius=main_radius-wall_thickness);
            }

            // to smoothen the edge
            translate([0, 0, edge_height])
            difference()
            {
                dodecagon_prism(height=50, radius=main_radius);
                dodecagon_prism(height=50, radius=main_radius-wall_thickness);
            }
            
            // main canopy
            translate([0, 0, edge_height + wall_height])
            difference()
            {
                hull()
                {
                    dodecagon_prism(height=1, radius=main_radius);
                    
                    translate([0, 0, canopy_height - edge_height - wall_height])
                    dodecagon_prism(height=1, radius=top_radius);
                }
                
                hull()
                {
                    dodecagon_prism(height=1, radius=main_radius - canopy_top_wall_thickness);
                    
                    translate([0, 0, canopy_height - edge_height - wall_height - canopy_top_thickness])
                    dodecagon_prism(height=1, radius=top_radius - canopy_top_wall_thickness);
                }
            }
            
            // reinforcements for mounting screws
            if( lock_screws )
            {
//                num = 3;
                
                for( angle = [ 0 : 360/num_lock_blocks : 359 ] )
                {
                    rotate([0, 0, angle])
                    translate([0, lock_screw_radius, edge_height])
                    hull()
                    {
                        cylinder(d=10, h=canopy_height - edge_height);
                        
                        translate([0, 4, 25])
                        cube([10, 1, 50], center=true);
                    }
                }
            }
        }
        union()
        {
            difference()
            {
                translate([-5000, -5000, edge_height + wall_height])
                cube([10000, 10000, 10000]);
                
                translate([0, 0, edge_height + wall_height])
                hull()
                {
                    dodecagon_prism(height=1, radius=main_radius);
                    
                    translate([0, 0, canopy_height - edge_height - wall_height])
                    dodecagon_prism(height=1, radius=top_radius);
                }
            }
            
            // screw holes for mounting screws
            if( lock_screws )
            {
                for( angle = [ 0 : 360/num_lock_blocks : 359 ] )
                {
                    rotate([0, 0, angle])
                    union()
                    {
                        translate([0, lock_screw_radius, edge_height])
                        cylinder(d=3.2, h=50);
                        
                        translate([0, lock_screw_radius, edge_height+5])
                        cylinder(d=5.75, h=canopy_height - edge_height);
                    }
                }
            }
        }
    }
}

base(component_mounts=true);

translate([0, 0, 100])
top();
