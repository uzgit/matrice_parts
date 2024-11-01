include <honeycomb.scad>
include <../library/roundedcube.scad>

length = 180;
width = 150;
height = 105;
rounding_radius = 5;

thickness = 3;

vertical_divide = 40;

screw_x_offset = 30;
screw_spacing_x = 66;
screw_spacing_y = 78;

jetson_screw_x_offset = 45;
jetson_screw_y_offset = 15;
jetson_screw_spacing_y = 86;
jetson_screw_spacing_x = 58;

module main_hollow_cube()
{
    difference()
    {
        union()
        {
            roundedcube([length, width, height], radius=rounding_radius, center=true);
        }
        union()
        {
            roundedcube([length-2*thickness, width-2*thickness, height-2*thickness], radius=rounding_radius, center=true);
        }
    }
}

module top()
{
    difference()
    {
        union()
        {
            main_hollow_cube();
        }
        union()
        {
            translate([0, 0, -(5000/2 + vertical_divide)])
            cube([5000, 5000, 5000], center=true);
        }
    }
}

module jetson_nano_mount()
{
    translate([jetson_screw_x_offset, jetson_screw_y_offset, 0])
    for( x_translation=[-jetson_screw_spacing_x/2, jetson_screw_spacing_x/2] )
    {
        for( y_translation=[-jetson_screw_spacing_y/2, jetson_screw_spacing_y/2] )
        {
            translate([x_translation, y_translation, 0])
            {
                translate([0, 0, -height/2 + thickness])
                difference()
                {
                    cylinder(d=7.5, h=6);
                    cylinder(d=3.5, h=6);
                }
            }
        }
    }
}

module bottom()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    main_hollow_cube();
                }
                union()
                {
                    translate([0, 0, (5000/2 - vertical_divide)])
                    cube([5000, 5000, 5000], center=true);
                }
            }
            
            translate([screw_x_offset, 0, 0])
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        translate([0, 0, -height/2 + 0.1]) // no idea where the 0.1 comes from
                        cylinder(d=10, h=6);
                    }
                }
            }
            
            jetson_nano_mount();
        }
        union()
        {
            translate([screw_x_offset, 0, 0])
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        translate([0, 0, -height/2])
                        cylinder(d=4, h=10);
                    }
                }
            }
        }
    }
//    intersection()
//    {
//        hull()
//        {
//            main_hollow_cube();
//        }
//        
//        translate([0, 0, -height/2 + 3])
//        cube([length, width, 6], center=true);
//    }
}

//translate([0, 0, 150])
//top();
bottom();