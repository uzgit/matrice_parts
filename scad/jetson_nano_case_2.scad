include <../library/roundedcube.scad>

length = 180;
front_length = 120;

width = 150;
height = 95; // max is 105
rounding_radius = 5;
vertical_divide = 20;

bottom_height = height - vertical_divide;

plug_void_width = 45;
plug_void_height = 50;
plug_void_extra = 1;
back_length = length - front_length;
back_height = height - plug_void_height;

thickness = 3;

screw_x_offset = 30;
screw_spacing_x = 66;
screw_spacing_y = 78;

jetson_screw_x_offset = 45;
jetson_screw_y_offset = 15;
jetson_screw_spacing_y = 86;
jetson_screw_spacing_x = 58;

lid_screw_support_diameter = 8;

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

module shell(_length, _front_length, _back_length, _width, _height, _plug_void_width, _rounding_radius, _back_height) {
    difference() {
        union()
        {
            // Main front positive space
            translate([_length/2 - _front_length/2, 0, 0])
            roundedcube([_front_length, _width, _height], radius=_rounding_radius, center=true);

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

//
//module shell()
//{
//    difference()
//    {
//        union()
//        {
//            // main front positive space
//            translate([length/2 - front_length/2, 0, 0])
//            roundedcube([front_length, width, height], radius=rounding_radius, center=true);
//            
//            // main back positive space
//            translate([-(length/2 - back_length/2), 0, 0])
//            union()
//            {
//                roundedcube([back_length, width - plug_void_width*2, height], radius=rounding_radius, center=true);
//                
//                translate([10, 0, 0])
//                roundedcube([back_length, width - plug_void_width*2, height], radius=rounding_radius, center=true);
//            }
//            
//            // side back positive space
//            translate([-length/2 + back_length/2, 0, height/2 - back_height/2])
//            union()
//            {
//                roundedcube([back_length, width, back_height], radius=rounding_radius, center=true);
//                translate([10, 0, 0])
//                roundedcube([back_length, width, back_height], radius=rounding_radius, center=true);
//            }
//        }
//        union()
//        {
//            
//        }
//    }
//}

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
                        cylinder(d=10, h=6);
                    }
                }
            }
            
            lid_mount_supports();
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
                        cylinder(d=4, h=10);
                    }
                }
            }
            bottom_lid_mount_holes();
            
            // plug holes
            translate([-55, plug_void_width/2 + (width-plug_void_width)/4, 0])
            cylinder(h=height, d=15, center=true);
            
            translate([-55, -plug_void_width/2 - (width-plug_void_width)/4, 0])
            cylinder(h=height, d=15, center=true);
        }
    }
    
    jetson_nano_mount();
    
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

//bottom();

translate([0, 0, 50])
top();

//lip();

//bottom_lid_mount_holes();

//roundedcube([3, 3, 3], radius=rounding_radius, center=true);