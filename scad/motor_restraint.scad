$fn=120;

bottom_thickness = 7;
top_thickness = 7;
motor_cavity_height = 30;
overall_height = 48;
outer_diameter = 90;
motor_diameter = 67;
width = 55;

bottom_cavity_width = 20;
top_cavity_width = 32;

overall_height = bottom_thickness + top_thickness + motor_cavity_height;

screw_hole_y_translation = motor_diameter/2 + 5;
screw_hole_z_translation1 = bottom_thickness/2;
screw_hole_z_translation2 = bottom_thickness + motor_cavity_height + top_thickness/2;

module restraint()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    translate([0, 0, overall_height/2])
                    cube([width, outer_diameter, overall_height], center=true);
                }
                union()
                {
                    cylinder(d=motor_diameter, h=overall_height);
                }
                // 20 5 10
            }

            bottom_brace_width = width/2 - bottom_cavity_width/2;
            for( scalar = [-1, 1] )
            {
                x_translation = bottom_cavity_width/2 + bottom_brace_width/2;
                
                translate([scalar*x_translation, 0, bottom_thickness/2])
                cube([bottom_brace_width, outer_diameter, bottom_thickness], center=true);
            }

            top_brace_width = width/2 - top_cavity_width/2;
            for( scalar = [-1, 1] )
            {
                x_translation = top_cavity_width/2 + top_brace_width/2;
                
                translate([scalar*x_translation, 0, bottom_thickness + motor_cavity_height + top_thickness/2])
                cube([top_brace_width, outer_diameter, top_thickness], center=true);
            }
        }

        union()
        {
            for(y_translation = [-screw_hole_y_translation, screw_hole_y_translation])
            {
                for(z_translation = [ screw_hole_z_translation1, screw_hole_z_translation2 ])
                {
                    translate([0, y_translation, z_translation])
                    rotate([0, 90, 0])
                    cylinder(d=3.2, h=100, center=true);
                }
            }
            
            _y_translation = motor_diameter/2 + 2;
            for( y_translation = [-_y_translation, _y_translation] )
            {
                translate([0, y_translation, overall_height - 5])
                rotate([0, 180, 0])
                cube([20, 7, 10], center=true);
            }
        }
    }
}

difference()
{
    restraint();
    
    translate([0, -500, 0])
    cube([1000, 1000, 1000]);
}