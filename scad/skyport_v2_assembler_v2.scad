include <../library/roundedcube.scad>

$fn=60;

skyport_v2_droneside_diameter = 31;
skyport_v2_droneside_radius = skyport_v2_droneside_diameter / 2;
tab_radius = 1.5;
tab_width = 3.5;
tab_offset_from_center = 0.5;

skyport_v2_droneside_underside_diameter = 28.25;
skyport_v2_droneside_underside_radius = skyport_v2_droneside_underside_diameter / 2;
skyport_v2_droneside_underside_thickness = 1;
assembly_2_thickness = 4;

assembly_3_thickness = 2.5;
through_cylinder = 1.65;
through_hole_diameter = 2.25;

assembly_4b_diameter  = 35;
assembly_4b_standoff_diameter = 4;
assembly_4b_thickness = 6;

assembly_5_thickness = 2;

ring_thickness = 5;
ring_height = 2;

screw_tab_diameter = 4;
screw_hole_diameter = 3.2;
standoff_diameter = 6;
standoff_height = 1.25;

screw_angles_1_2 = [60, 120, 240, 300];

module assembly_1()
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
                    
                    for( angle = screw_angles_1_2 )
                    {
                        rotate([0, 0, angle])
                        translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                        cylinder(d=standoff_diameter, ring_height + skyport_v2_droneside_underside_thickness);
                    }
                }
                cylinder(d = skyport_v2_droneside_underside_diameter, h = ring_height + skyport_v2_droneside_underside_thickness);
            }
            
            linear_extrude(skyport_v2_droneside_underside_thickness)
            polygon([[-15, skyport_v2_droneside_underside_radius - 5], [0, skyport_v2_droneside_underside_radius + 2], [15, skyport_v2_droneside_underside_radius - 5]]);
        }
        union()
        {
            for( angle = screw_angles_1_2 )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                cylinder(d=screw_hole_diameter, ring_height + skyport_v2_droneside_underside_thickness);
            }
        }
    }
}

module assembly_2()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    cylinder(d = skyport_v2_droneside_diameter + ring_thickness, h=assembly_2_thickness);
                    
                    for( angle = screw_angles_1_2 )
                    {
                        rotate([0, 0, angle])
                        translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                        cylinder(d=standoff_diameter, h=assembly_2_thickness);
                    }
                }
                cylinder(d = skyport_v2_droneside_diameter, h = assembly_2_thickness);
            }
            for( angle = screw_angles_1_2 )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, - standoff_height])
                difference()
                {
                    cylinder(d=standoff_diameter, assembly_2_thickness);
                    cylinder(d=screw_hole_diameter, assembly_2_thickness);
                }
            }
        }
        union()
        {
            rotate([0, 0, 30])
            translate([0, skyport_v2_droneside_radius + tab_offset_from_center, assembly_2_thickness/2])
            roundedcube([tab_width, tab_radius, assembly_2_thickness], center=true, apply_to="z");
            
            for( angle = screw_angles_1_2 )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                cylinder(d=screw_hole_diameter, assembly_2_thickness);
            }
        }
    }
}

module assembly_3()
{
    difference()
    {
        union()
        {
            cylinder(d = skyport_v2_droneside_diameter, h=assembly_3_thickness);
            
            translate([0, 0, assembly_3_thickness])
            for( x_translation = [-9.5, 9.5] )
            {
                for( y_translation = [-9, 9] )
                {
                    translate( [x_translation, y_translation, 0])
                    cylinder(d=through_cylinder, h=5);
                }
            }
        }
        union()
        {
//            cylinder(d = skyport_v2_droneside_diameter, h = assembly_2_thickness);
            translate([0, 0, assembly_3_thickness/2])
            cube([27, 8.5, assembly_3_thickness], center=true);
            
            for( y_translation = [-11, 11] )
            {
                translate([0, y_translation, 0])
                cylinder(d=3.75, h=assembly_3_thickness);
            }
        }
    }
}

module assembly_4b()
{
    difference()
    {
        union()
        {
            difference()
            {
                cylinder(d = assembly_4b_diameter, h=assembly_4b_thickness);
                cylinder(d = assembly_4b_diameter - 6, h=assembly_4b_thickness);
            }
            
            for( x_multiplier = [-1, 1] )
            {
                for( y_multiplier = [-1, 1])
                {
                    hull()
                    {
                        translate([x_multiplier*13.5, y_multiplier*5.5, 0])
                        cylinder(d=assembly_4b_standoff_diameter, h=assembly_4b_thickness);
                        
                        translate([x_multiplier*15.5, y_multiplier*5.5, 0])
                        cylinder(d=assembly_4b_standoff_diameter, h=assembly_4b_thickness);
                        
                        translate([x_multiplier*9.5, y_multiplier*9, 0])
                        cylinder(d=assembly_4b_standoff_diameter, h=assembly_4b_thickness);
                        
                        translate([x_multiplier*9.5, y_multiplier*14, 0])
                        cylinder(d=assembly_4b_standoff_diameter, h=assembly_4b_thickness);
                    }
                }
            }
        }
        union()
        {
//            cylinder(d = skyport_v2_droneside_diameter, h = assembly_2_thickness);
//            translate([0, 0, assembly_4b_thickness/2])
//            {
//                roundedcube([30, 7.5, assembly_4b_thickness], center=true, apply_to="z");
//                roundedcube([24, 10, assembly_4b_thickness], center=true, apply_to="z");
//            }
            
            for( x_translation = [-13.5, 13.5] )
            {
                for( y_translation = [-5.5, 5.5] )
                {
                    translate( [x_translation, y_translation, 0])
                    cylinder(d=through_hole_diameter, h=assembly_4b_thickness);
                }
            }
            for( x_translation = [-9.5, 9.5] )
            {
                for( y_translation = [-9, 9] )
                {
                    translate( [x_translation, y_translation, 0])
                    cylinder(d=through_hole_diameter, h=assembly_4b_thickness);
                }
            }
            
            difference()
            {
                cube([1000, 1000, 1000], center=true);
                cylinder(d = assembly_4b_diameter, h=assembly_4b_thickness);
            }
            
            translate([0, 0, assembly_4b_thickness/2])
            {
                roundedcube([23, 14, assembly_4b_thickness], radius=2, center=true, apply_to="z");
                
                translate([0, -10, 0])
                roundedcube([15, 20, assembly_4b_thickness], radius=2, center=true, apply_to="z");
                
                translate([0, -assembly_4b_diameter/2, 0])
                cube([40, 12, assembly_4b_thickness], center=true);
            }
            
            bottom_cavity_thickness = 1.5;
            translate([0, 0, bottom_cavity_thickness/2])
            roundedcube([30, 14, bottom_cavity_thickness], radius=0.5, center=true, apply_to="z");
        }
    }
}

module assembly_4()
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
                cylinder(d=through_hole_diameter, h=height, center=true);
            }
            
            x_translation = tab_x_length - standoff_diameter/2;
            for( y_translation = [-9, 9] )
            {
                translate([x_translation, y_translation, -height/2])
                cylinder(d=through_hole_diameter, h=height + standoff_height, center=false);
            }
        }
    }
}

module assembly_5()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    translate([0, 0, assembly_5_thickness/2])
                    cube([32, 18, assembly_5_thickness], center=true);
                    
                    for( angle = screw_angles_1_2 )
                    {
                        rotate([0, 0, angle])
                        translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                        cylinder(d=standoff_diameter, assembly_5_thickness);
                    }
                }
//                cylinder(d = skyport_v2_droneside_underside_diameter, h = ring_height + skyport_v2_droneside_underside_thickness);
            }
            
            translate([0, 0, assembly_5_thickness])
            for( x_translation = [-13.5, 13.5] )
            {
                for( y_translation = [-5.5, 5.5] )
                {
                    translate( [x_translation, y_translation, 0])
                    cylinder(d=through_cylinder, h=3);
                }
            }
        }
        union()
        {
            for( angle = screw_angles_1_2 )
            {
                rotate([0, 0, angle])
                translate([0, skyport_v2_droneside_radius + screw_tab_diameter, 0])
                cylinder(d=screw_hole_diameter, ring_height + skyport_v2_droneside_underside_thickness);
            }
            
            translate([0, 0, assembly_5_thickness/2])
            roundedcube([20, 15, assembly_5_thickness], radius=1, center=true, apply_to="z");
        }
    }
}

assembly_1();

translate([0, 0, 15])
//rotate([180, 0, 0])
assembly_2();

translate([0, 0, 30])
assembly_3();

translate([0, 0, 45])
assembly_4b();
//{
//    translate([-(4 + 9.5), 0, 0])
//    rotate([180, 0, 0])
//    assembly_4();
//    
//    translate([(4 + 9.5), 0, 0])
//    rotate([180, 0, 180])
//    assembly_4();
//}

translate([0, 0, 60])
rotate([180, 0, 0])
assembly_5();

//assembly_3();

//modules_to_export = [
//    "assembly_1",
//    "assembly_2",
//    "assembly_3",
//    "assembly_4",
//    "assembly_5"
//];
//
//for( module_name = modules_to_export )
//{
//    filename = "../stl/" + str(module_name) + ".stl";
//    module_name();
//    export(filename);
//}