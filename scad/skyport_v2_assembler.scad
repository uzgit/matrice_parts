include <../library/roundedcube.scad>

$fn=120;

skyport_v2_droneside_diameter = 31;
skyport_v2_droneside_radius = skyport_v2_droneside_diameter / 2;
tab_radius = 1.5;
tab_width = 3.5;
tab_offset_from_center = 0.5;

skyport_v2_droneside_underside_diameter = 28.25;
skyport_v2_droneside_underside_radius = skyport_v2_droneside_underside_diameter / 2;
skyport_v2_droneside_underside_thickness = 1;

ring_thickness = 5;
ring_height = 2;

screw_tab_diameter = 6;
screw_hole_diameter = 3.2;
standoff_diameter = 6;
standoff_height = 0.75;

module inner_ring()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    cylinder(d = skyport_v2_droneside_diameter + ring_thickness, h = ring_height);
                    
                    for( angle = [0, 120, 240] )
                    {
                        rotate([0, 0, angle])
                        translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                        cylinder(d=screw_tab_diameter, ring_height);
                    }
                }
                cylinder(d = skyport_v2_droneside_diameter, h = ring_height);
            }
            for( angle = [0, 120, 240] )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, - standoff_height])
                difference()
                {
                    cylinder(d=standoff_diameter, standoff_height);
                    cylinder(d=screw_hole_diameter, standoff_height);
                }
            }
        }
        union()
        {
            rotate([0, 0, 30])
            translate([0, skyport_v2_droneside_radius + tab_offset_from_center, ring_height/2])
            roundedcube([tab_width, tab_radius, ring_height], center=true, apply_to="z");
            
            for( angle = [0, 120, 240] )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                cylinder(d=screw_hole_diameter, ring_height);
            }
        }
    }
}

module outer_ring()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    cylinder(d = skyport_v2_droneside_diameter + ring_thickness, h = ring_height + skyport_v2_droneside_underside_thickness);
                    
                    for( angle = [0, 120, 240] )
                    {
                        rotate([0, 0, angle])
                        translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                        cylinder(d=screw_tab_diameter, ring_height + skyport_v2_droneside_underside_thickness);
                    }
                }
                cylinder(d = skyport_v2_droneside_underside_diameter, h = ring_height + skyport_v2_droneside_underside_thickness);
            }
            
            linear_extrude(skyport_v2_droneside_underside_thickness)
            polygon([[-15, skyport_v2_droneside_underside_radius - 5], [0, skyport_v2_droneside_underside_radius + 5], [15, skyport_v2_droneside_underside_radius - 5]]);
        }
        union()
        {
            for( angle = [0, 120, 240] )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                cylinder(d=screw_hole_diameter, ring_height + skyport_v2_droneside_underside_thickness);
            }
        }
    }
}

//module intermediate_connector()
//{
//    difference()
//    {
//        union()
//        {
//            roundedcube([33, 23, 3], radius=1, center=true, apply_to="z");
//            
//            for( x_translation = [-9.5, 9.5] )
//            {
//                for( y_translation = [-9, 9] )
//                {
//                    translate([x_translation, y_translation, 1.5])
//                    difference()
//                    {
//                        cylinder(d=5, h=2);
//                        cylinder(d=2.7, h=2);
//                    }
//                }
//            }
//        }
//        union()
//        {
//            roundedcube([23, 13, 3], radius=1, center=true, apply_to="z");
//            for( x_translation = [-13.25, 13.25] )
//            {
//                for( y_translation = [-5.5, 5.5] )
//                {
//                    translate([x_translation, y_translation, -1.5])
//                    cylinder(d=2.7, h=3);
//                }
//            }
//            for( x_translation = [-9.5, 9.5] )
//            {
//                for( y_translation = [-9, 9] )
//                {
//                    translate([x_translation, y_translation, -1.5])
//                    {
//                        cylinder(d=2.7, h=3);
//                    }
//                }
//            }
//            translate([0, 0, 0])
//            cube([14, 25, 3], center=true);
//        }
//    }
//}

module intermediate_connector()
{
    height = 3;
    x_length = 4;
    y_length = 21.25;
    tab_y_length = 3;
    tab_x_length = 6;
    standoff_diameter = 4;
    standoff_height = 3;

    difference()
    {
        union()
        {
            roundedcube([x_length, y_length, 3], radius=1, center=true, apply_to="z");
            
            translate([0, y_length/2 - tab_y_length / 2, 0])
            hull()
            {
                roundedcube([3.5, tab_y_length, height], radius=1, center=true, apply_to="z");
                translate([tab_x_length - standoff_diameter/2, 0, 0])
                cylinder(d=standoff_diameter, h=height, center=true);
            }
            
            translate([0, -y_length/2 + tab_y_length / 2, 0])
            hull()
            {
                roundedcube([x_length, tab_y_length, height], radius=1, center=true, apply_to="z");
                translate([tab_x_length - standoff_diameter/2, 0, 0])
                cylinder(d=standoff_diameter, h=height, center=true);
            }
            
            x_translation = tab_x_length - standoff_diameter/2;
            for( y_translation = [-(y_length/2 - tab_y_length / 2), (y_length/2 - tab_y_length / 2)] )
            {
                translate([x_translation, y_translation, height/2])
                cylinder(d=standoff_diameter, h=standoff_height, center=false);
            }
        }
        union()
        {
            for( y_translation = [-5.5, 5.5] )
            {
                translate([0, y_translation, 0])
                cylinder(d=2.7, h=height, center=true);
            }
            
            x_translation = tab_x_length - standoff_diameter/2;
            for( y_translation = [-9, 9] )
            {
                translate([x_translation, y_translation, -height/2])
                cylinder(d=2.7, h=height + standoff_height, center=false);
            }
        }
    }
}

//translate([0, 0, 20])
//inner_ring();
//outer_ring();

intermediate_connector();