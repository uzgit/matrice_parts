include <../library/roundedcube.scad>

$fn=60;

length = 180;
front_length = 120;

width = 150;
height = 90; // max is 105
rounding_radius = 5;
vertical_divide = 20;

bottom_height = height - vertical_divide;

plug_void_width = 40;
plug_void_height = 50;
plug_void_extra = 1;
back_length = length - front_length;
back_height = height - plug_void_height;

thickness = 3;

screw_x_offset = 30;
screw_spacing_x = 66;
screw_spacing_y = 78;

//jetson_nano_translation = [45, -17.5, 0];
jetson_nano_translation = [45, -75, 0];
jetson_nano_rotation = [0, 0, 90];
jetson_screw_x_offset = 45;
jetson_screw_y_offset = 15;
jetson_screw_spacing_y = 86;
jetson_screw_spacing_x = 58;
jetson_heatsink_screwhole_spacing = 32;

a203_translation = [-23, -45, 0];
a203_rotation = [0, 0, 90];
a203_screw_x_offset = 45;
a203_screw_y_offset = 15;
a203_screw_spacing_y = 81;
a203_screw_spacing_x = 46;
a203_standoff_diameter = 6;

lid_screw_support_diameter = 8;

plug_hole_diameter = 17.5;

fan_rotation = [180, 0, 0];
fan_x_clearance_from_a203 = 3;
fan_translation = [24.5 + fan_x_clearance_from_a203, 0, 0];
fan_diameter = 38;
fan_screw_spacing = 32;

m2_threaded_insert_diameter = 3.05;
m2_threaded_insert_height = 6;
m25_threaded_insert_diameter = 3.4;
m25_threaded_insert_height = 6;
m3_threaded_insert_diameter = 4;
m3_threaded_insert_height = 6;

rpi_screw_spacing_x = 49;
rpi_screw_spacing_y = 58;
rpi_mount_translation = [length/2 - thickness - 0, -6, -49];
rpi_mount_rotation = [0, -90, 0];

eport_dev_board_screw_spacing_y = 50;
eport_dev_board_screw_spacing_x = 35;
eport_dev_board_translation = [-22, -53, -44 - 10 + 7];
eport_dev_board_rotation = [0, -90, 90];

psdk_dev_board_screw_spacing_x = 56;
psdk_dev_board_screw_spacing_y = 50;
psdk_dev_board_translation = [43, 65, -53];
psdk_dev_board_rotation = [0, -90, -90];

module edge_pyramidal_prism(_length=length, _width=thickness, _height=2)
{
    translate([_length/2, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(height=_length)
    polygon(points=[[0, -thickness/3], [0, thickness/3], [_height, 0]]);
}

module lip()
{
    lip_height = 2;
    
    length_width_tolerance = 2;
    
    translate([0, 0, height/2 - vertical_divide])
    union()
    {    
        translate([0, width/2 - thickness/2, 0])
        edge_pyramidal_prism(_length=length-2*lid_screw_support_diameter-length_width_tolerance);
        
        translate([0, -width/2 + thickness/2, 0])
        edge_pyramidal_prism(_length=length-2*lid_screw_support_diameter-length_width_tolerance);
        
        translate([length/2-thickness/2, 0, 0])
        rotate([0, 0, 90])
        edge_pyramidal_prism(_length=width-2*lid_screw_support_diameter-length_width_tolerance);
        
        translate([-length/2+thickness/2, 0, 0])
        rotate([0, 0, 90])
        edge_pyramidal_prism(_length=width-2*lid_screw_support_diameter-length_width_tolerance);
    }
}

module lid_mount_support()
{
    support_height = height - thickness; // put it right in the center of the thickness
//    support_hole_height = vertical_divide - thickness/2 + 6;
    threaded_insert_height = 6;
    
    difference()
    {
        union()
        {
            translate([0, 0, -support_height/2])
            cylinder(h=support_height, d=lid_screw_support_diameter);
            
            translate([-lid_screw_support_diameter/2, 0, 0])
            cube([lid_screw_support_diameter, lid_screw_support_diameter, support_height], center=true);
        }
        union()
        {
            translate([0, 0, height/2 - vertical_divide - threaded_insert_height])
            cylinder(d=4, h=threaded_insert_height);
            
            translate([0, 0, height/2 - vertical_divide])
            cylinder(d=3.1, h=vertical_divide);
        }
    }
}

module lid_mount_supports()
{   
    // corners
    translate([length/2 -lid_screw_support_diameter/2, width/2 -lid_screw_support_diameter/2, 0])
    union()
    {
        rotate([0, 0, 180 + 90])
        lid_mount_support();
        
        rotate([0, 0, 180])
        lid_mount_support();
    }
    
    translate([length/2 -lid_screw_support_diameter/2, -width/2 +lid_screw_support_diameter/2, 0])
    union()
    {
        rotate([0, 0, 90 + 90])
        lid_mount_support();
        
        rotate([0, 0, 90])
        lid_mount_support();
    }
    
    translate([-length/2 + lid_screw_support_diameter/2, -width/2 +lid_screw_support_diameter/2, 0])
    union()
    {
        rotate([0, 0, 0 + 90])
        lid_mount_support();
        
        rotate([0, 0, 0])
        lid_mount_support();
    }
    
    translate([-length/2 + lid_screw_support_diameter/2, width/2 -lid_screw_support_diameter/2, 0])
    union()
    {
        rotate([0, 0, -90 + 90])
        lid_mount_support();
        
        rotate([0, 0, -90])
        lid_mount_support();
    }
    
    // cross
    translate([length/2 - lid_screw_support_diameter/2, 0, 0])
    rotate([0, 0, 180])
    lid_mount_support();
    
    translate([-length/2 + lid_screw_support_diameter/2, 0, 0])
    rotate([0, 0, 0])
    lid_mount_support();
    
    translate([0, width/2 - lid_screw_support_diameter/2, 0])
    rotate([0, 0, -90])
    lid_mount_support();
    
    translate([0, - width/2 + lid_screw_support_diameter/2, 0])
    rotate([0, 0, 90])
    lid_mount_support();
}

module top_lid_mount_holes()
{
    m3_hole_radius = 3.1;
    lid_screw_head_height = 4;
    lid_screw_head_radius = 6;
    
    offset_x = length/2 - lid_screw_support_diameter/2;
    offset_y = width/2 -lid_screw_support_diameter/2;
    
    translate([0, 0, height/2])
    union()
    {
        // corners
        translate([offset_x, offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
        
        translate([offset_x, -offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }

        translate([-offset_x, offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
        
        translate([-offset_x, -offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
        
        translate([0, offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
        
        translate([0, -offset_y, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }

        translate([offset_x, 0, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
        
        translate([-offset_x, 0, 0])
        union()
        {
            translate([0, 0, -vertical_divide])
            cylinder(h=vertical_divide, d=m3_hole_radius);
            translate([0, 0, -lid_screw_head_height])
            cylinder(h=lid_screw_head_height, d=lid_screw_head_radius);
        }
    }
}

module bottom_lid_mount_holes()
{
    bottom_lid_mount_hole_height = 10;

    m3_hole_radius = 3.1;
    lid_screw_head_height = 4;
    lid_screw_head_radius = 6;
    
    offset_x = length/2 - lid_screw_support_diameter/2;
    offset_y = width/2 -lid_screw_support_diameter/2;
    
    translate([0, 0, height/2 - vertical_divide - 6])
    union()
    {
        // corners
        translate([offset_x, offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
        
        translate([offset_x, -offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);

        translate([-offset_x, offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
        
        translate([-offset_x, -offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
        
        translate([0, offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
        
        translate([0, -offset_y, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);

        translate([offset_x, 0, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
        
        translate([-offset_x, 0, 0])
        cylinder(h=bottom_lid_mount_hole_height, d=4);
    }
}

module a203_mount()
{
    translate([a203_screw_x_offset, a203_screw_y_offset, -height/2 + thickness/2])
    union()
    {
        for( x_translation=[-a203_screw_spacing_x/2, a203_screw_spacing_x/2] )
        {
            for( y_translation=[-a203_screw_spacing_y/2, a203_screw_spacing_y/2] )
            {
                translate([x_translation, y_translation, 0])
                {
//                    translate([0, 0, -height/2 + thickness])
                    difference()
                    {
                        cylinder(d=a203_standoff_diameter, h=6 + 19);  // originally just h=6
                        translate([0, 0, 19])
                        cylinder(d=4, h=6);  // originally just h=6
                    }
                }
            }
        }
        
//        for( x_translation=[-a203_screw_spacing_x/2, a203_screw_spacing_x/2] )
//        {
//            translate([x_translation, 0, 10/2])
//            cube([7.5, a203_screw_spacing_y, 10], center=true);
//        }
//        
        for( y_translation=[-a203_screw_spacing_y/2, a203_screw_spacing_y/2] )
        {
            translate([0, y_translation, 10/2])
            cube([a203_screw_spacing_x, a203_standoff_diameter, 10], center=true);
        }
    }
}

module shell(_length, _front_length, _back_length, _width, _height, _plug_void_width, _rounding_radius, _back_height) {
    difference() {
        union()
        {
            // Main front positive space
            translate([_length/2 - _front_length/2, 0, 0])
            roundedcube([_front_length, _width, _height], radius=_rounding_radius, center=true);

            hull()
            {
                // Main back positive space
                translate([-_length/2 + _back_length/2, 0, 0])
                union()
                {
                    roundedcube([_back_length, _width - _plug_void_width * 2, _height], radius=_rounding_radius, center=true);

                    translate([10, 0, 0])
                    roundedcube([_back_length, _width - _plug_void_width * 2, _height], radius=_rounding_radius, center=true);
                }

                // Side back positive space
                translate([-_length/2 + _back_length/2, 0, _height/2 - _back_height/2])
                union()
                {
                    roundedcube([_back_length, _width, _back_height], radius=_rounding_radius, center=true);

                    translate([10, 0, 0])
                    roundedcube([_back_length, _width, _back_height], radius=_rounding_radius, center=true);
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
                shell(
                    _length = length,
                    _front_length = front_length,
                    _back_length = back_length,
                    _width = width,
                    _height = height,
                    _plug_void_width = plug_void_width,
                    _rounding_radius = rounding_radius,
                    _back_height = back_height
                );
                
                shell(
                    _length = length - 2*thickness,
                    _front_length = front_length - 2*thickness,
                    _back_length = back_length,
                    _width = width - 2*thickness,
                    _height = height - thickness,
                    _plug_void_width = plug_void_width + 2*thickness,
                    _rounding_radius = rounding_radius,
                    _back_height = back_height - 2*thickness
                );
            }
        
            translate([screw_x_offset, 0, 0])
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        translate([0, 0, -height/2 + 0.1]) // no idea where the 0.1 comes from
                        cylinder(d=10, h=7);
                    }
                }
            }
            
            lid_mount_supports();
            
//            // vertical mount for dev boards
//            translate([-55, 0, -height/2 + bottom_height/2 - 2.5])
//            roundedcube([60, 3, bottom_height + 5], radius=2, center=true);

    
            translate(a203_translation)
            rotate(a203_rotation)
            a203_mount();
            
            // rpi mount
            translate(rpi_mount_translation)
            rotate(rpi_mount_rotation)
            vertical_mount(screw_spacing_x=rpi_screw_spacing_x, screw_spacing_y=rpi_screw_spacing_y, rail_bottom_extra=20, rail_width=6, rail_height=m25_threaded_insert_height, screw_hole_diameter=m25_threaded_insert_diameter);
            
            // eport dev board mount
            translate(eport_dev_board_translation)
            rotate(eport_dev_board_rotation)
            vertical_mount(screw_spacing_x=eport_dev_board_screw_spacing_x, screw_spacing_y=eport_dev_board_screw_spacing_y, rail_bottom_extra=30, rail_width=6, rail_height=19, screw_hole_diameter=m2_threaded_insert_diameter);

            // psdk port dev board mount
            translate(psdk_dev_board_translation)
            rotate(psdk_dev_board_rotation)
            vertical_mount(screw_spacing_x=psdk_dev_board_screw_spacing_x, screw_spacing_y=psdk_dev_board_screw_spacing_y, rail_bottom_extra=20, rail_width=6, rail_height=10, screw_hole_diameter=m3_threaded_insert_diameter);
        }
        union()
        {
            difference()
            {
                cube([10000, 10000, 10000], center=true);
                shell(
                        _length = length,
                        _front_length = front_length,
                        _back_length = back_length,
                        _width = width,
                        _height = height,
                        _plug_void_width = plug_void_width,
                        _rounding_radius = rounding_radius,
                        _back_height = back_height
                    );
            }
            
            translate([0, 0, height/2 - vertical_divide])
            translate([0, 0, 5000])
            cube([10000, 10000, 10000], center=true);
            
            translate([screw_x_offset, 0, 0])
            for( x_translation=[-screw_spacing_x/2, screw_spacing_x/2] )
            {
                for( y_translation=[-screw_spacing_y/2, screw_spacing_y/2] )
                {
                    translate([x_translation, y_translation, 0])
                    {
                        translate([0, 0, -height/2])
                        union()
                        {
                            translate([0, 0, 1])
                            cylinder(d=4, h=20);
                            
                            cylinder(d=3.1, h=10);
                        }
                    }
                }
            }
            bottom_lid_mount_holes();
            
            // plug holes
            translate([-45, plug_void_width/2 + (width-plug_void_width)/4, 0])
            cylinder(h=height, d=plug_hole_diameter, center=true);
            
            translate([-45, -plug_void_width/2 - (width-plug_void_width)/4, 0])
            cylinder(h=height, d=plug_hole_diameter, center=true);
            
            translate(fan_translation)
            rotate(fan_rotation)
            union()
            {
                cylinder(d=fan_diameter, h=100);
                for(x_translation = [-fan_screw_spacing/2, fan_screw_spacing/2])
                for(y_translation = [-fan_screw_spacing/2, fan_screw_spacing/2])
                    translate([x_translation, y_translation, 0])
                    cylinder(d=3.1, h=100);
            }
        }
    }
    
    difference()
    {
        lip();
        bottom_lid_mount_holes();
    }
}

module top()
{
    difference()
    {
        union()
        {
            difference()
            {
                shell(
                    _length = length,
                    _front_length = front_length,
                    _back_length = back_length,
                    _width = width,
                    _height = height,
                    _plug_void_width = plug_void_width,
                    _rounding_radius = rounding_radius,
                    _back_height = back_height
                );
                
                shell(
                    _length = length - 2*thickness,
                    _front_length = front_length - 2*thickness,
                    _back_length = back_length,
                    _width = width - 2*thickness,
                    _height = height - thickness,
                    _plug_void_width = plug_void_width + 2*thickness,
                    _rounding_radius = rounding_radius,
                    _back_height = back_height - 2*thickness
                );
            }
            
            lid_mount_supports();
        }
        union()
        {
            translate([0, 0, height/2 - vertical_divide])
            translate([0, 0, -5000])
            cube([10000, 10000, 10000], center=true);
            
            difference()
            {
                cube([10000, 10000, 10000], center=true);
                shell(
                        _length = length,
                        _front_length = front_length,
                        _back_length = back_length,
                        _width = width,
                        _height = height,
                        _plug_void_width = plug_void_width,
                        _rounding_radius = rounding_radius,
                        _back_height = back_height
                    );
            }
            
            top_lid_mount_holes();
            lip();
        }
    }
}

module rpi_vertical_mount()
{
    // m2.5 screws
    // need separate standoffs
    m25_threaded_insert_diameter = 3.4;
    m25_threaded_insert_height = 6;
    
    rpi_screw_spacing_x = 49;
    rpi_screw_spacing_y = 58;
    
    rail_bottom_extra = 18;
    rail_width = 6;
    rail_length = rpi_screw_spacing_x + rail_bottom_extra;
    
    translate([0, 0, m25_threaded_insert_height/2])
    for(y_translation = [-rpi_screw_spacing_y/2, rpi_screw_spacing_y/2])
    translate([0, y_translation, 0])
    difference()
    {
        union()
        {
            translate([-rail_bottom_extra/2, 0, 0])
            roundedcube([rail_length, rail_width, m25_threaded_insert_height], center=true, apply_to="z", radius=1);
            
            translate([-rail_length/2 + rail_width/2, 0, 0])
            cube([rail_width, rail_width, m25_threaded_insert_height], center=true);
        }
        union()
        {
            for(x_translation = [-rpi_screw_spacing_x/2, rpi_screw_spacing_x/2])
            translate([x_translation, 0, 0])
            cylinder(d=m25_threaded_insert_diameter, h=m25_threaded_insert_height, center=true);
        }
    }
}

module vertical_mount(screw_spacing_x=49, screw_spacing_y=58, rail_bottom_extra=18, rail_width=6, rail_height=6, screw_hole_diameter=3.4)
{
    rail_length = screw_spacing_x + rail_bottom_extra;

    for(y_translation=[0, -screw_spacing_y])
    translate([0, y_translation, 0])
    difference()
    {
        translate([0, -rail_width/2, 0])
        union()
        {
            roundedcube([rail_length, rail_width, rail_height], apply_to="z");
            cube([rail_width, rail_width, rail_height]);
        }
        union()
        {
            translate([rail_length - rail_width/2, 0, 0])
            union()
            {
                cylinder(d=screw_hole_diameter, h=rail_height);
                translate([-screw_spacing_x, 0, 0])
                cylinder(d=screw_hole_diameter, h=rail_height);
            }
        }
    }
}

module psdk_adapter_mount()
{
    psdk_adapter_mount_thickness = 2;
    psdk_adapter_mount_leg_width = 8;
    forward_base_extension_x = 13.5;
    psdk_adapter_diameter = 31.5;
    psdk_adapter_insert_support_x = psdk_adapter_diameter + 5;
    psdk_adapter_insert_support_y = psdk_adapter_diameter + 10;

    difference()
    {
        translate([0, 0, psdk_adapter_mount_thickness/2])
        union()
        {
            for( y_translation = [-jetson_heatsink_screwhole_spacing/2, jetson_heatsink_screwhole_spacing/2] )
            translate([0, y_translation, 0])
            roundedcube([jetson_heatsink_screwhole_spacing + psdk_adapter_mount_leg_width, psdk_adapter_mount_leg_width, psdk_adapter_mount_thickness], center=true, apply_to="z", radius=1);
            
            hull()
            {
                translate([jetson_heatsink_screwhole_spacing/2 + forward_base_extension_x/2, 0, 0])
                roundedcube([forward_base_extension_x, jetson_heatsink_screwhole_spacing + psdk_adapter_mount_leg_width, psdk_adapter_mount_thickness], center=true, apply_to="z", radius=1);
                
                translate([jetson_heatsink_screwhole_spacing/2 + forward_base_extension_x + psdk_adapter_insert_support_x/2, 0, 0])
                roundedcube([psdk_adapter_insert_support_x, psdk_adapter_insert_support_y, psdk_adapter_mount_thickness], center=true, apply_to="z", radius=1);
            }
        }
        union()
        {
            for( x_translation = [-jetson_heatsink_screwhole_spacing/2, jetson_heatsink_screwhole_spacing/2] )
            for( y_translation = [-jetson_heatsink_screwhole_spacing/2, jetson_heatsink_screwhole_spacing/2] )
            translate([x_translation, y_translation, 0])
            cylinder(d=3.1, h=psdk_adapter_mount_thickness);
            
            translate([jetson_heatsink_screwhole_spacing/2 + forward_base_extension_x + psdk_adapter_diameter/2 + 1, 0, 0])
            union()
            {
                cylinder(d=psdk_adapter_diameter, h=psdk_adapter_mount_thickness);
                
                translate([0, psdk_adapter_diameter/2, psdk_adapter_mount_thickness/2])
                roundedcube([12.5, 4, psdk_adapter_mount_thickness], center=true, apply_to="z", radius=1);
            }
        }

    }
}

//bottom();

psdk_adapter_mount();

//
//translate([length/2 - thickness, 0, 0])
//rotate([0, -90, 0])
//rpi_vertical_mount();

//translate([0, 0, 50])
//top();

//lip();

//bottom_lid_mount_holes();

//roundedcube([3, 3, 3], radius=rounding_radius, center=true);