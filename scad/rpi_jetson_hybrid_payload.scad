include <../library/roundedcube.scad>

$fn=120;

m3_screwhole_diameter = 3.1;
m3_standoff_diameter = 6;
m3_threaded_insert_diameter = 4;
m3_threaded_insert_height = 6;

raspberrypi_screwhole_spacing_y = 58;
raspberrypi_screwhole_spacing_x = 49;
raspberrypi_standoff_height = 3;

a203_screwhole_spacing_y = 81.30;
a203_screwhole_spacing_x = 46.5;
a203_standoff_height = 7;

joint_mount_x = raspberrypi_screwhole_spacing_x + 20;
joint_mount_thickness = m3_standoff_diameter;
joint_mount_height = 10;
joint_mount_forward_lower_y = 30;
joint_mount_forward_lower_secondary_support_y = 2;
joint_mount_forward_lower_secondary_support_offset_y = -3;
raspberrypi_screwhole_offset_x = 5;

joint_mount_intermediate_space_offset = 7;

module raspberrypi_jetson_mount_aft()
{
    difference()
    {
        union()
        {
            // raspberry pi standoffs
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            for(x_translation = [0, raspberrypi_screwhole_spacing_x] )
                translate([x_translation, 0, 0])
                cylinder(d=m3_standoff_diameter, h=raspberrypi_standoff_height);
            
            // intermediate space
            translate([raspberrypi_screwhole_spacing_x/2 + m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, raspberrypi_standoff_height])
            translate([0, 0, joint_mount_height/2])
            cube([joint_mount_x, m3_standoff_diameter, joint_mount_height], center=true);
            
            // a203 jetson nano standoffs
            translate([0, 0, raspberrypi_standoff_height + joint_mount_height])
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            for(x_translation = [0, a203_screwhole_spacing_x] )
            {
                translate([x_translation, 0, 0])
                difference()
                {
                    cylinder(d=m3_standoff_diameter, h=a203_standoff_height);
                    translate([0, 0, a203_standoff_height-m3_threaded_insert_height])
                    cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
                }
            }
        }
        union()
        {
            // raspberry pi standoff holes (have to go through the standoffs and the intermediate space)
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            for(x_translation = [0, raspberrypi_screwhole_spacing_x] )
                translate([x_translation, 0, 0])
                cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
        }
    }
}

module raspberrypi_jetson_mount_forward_lower()
{
    difference()
    {
        union()
        {
            // raspberry pi standoffs
            translate([0, raspberrypi_screwhole_spacing_y, 0])
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            translate([0, 0, 0])
            cylinder(d=m3_standoff_diameter, h=raspberrypi_standoff_height);
            
            // intermediate space
            translate([0 + m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            translate([0, (raspberrypi_screwhole_spacing_y + a203_screwhole_spacing_y)/2, 0])
            translate([0, 0, raspberrypi_standoff_height + joint_mount_height/2 - joint_mount_intermediate_space_offset/2])
            union()
            {
                cube([m3_standoff_diameter, joint_mount_forward_lower_y, joint_mount_height - joint_mount_intermediate_space_offset], center=true);
                
                translate([0, joint_mount_forward_lower_y/2 - joint_mount_forward_lower_secondary_support_y/2, -raspberrypi_standoff_height/2 - joint_mount_height/2])
                translate([0, joint_mount_forward_lower_secondary_support_offset_y, joint_mount_intermediate_space_offset/2])
                cube([m3_standoff_diameter, joint_mount_forward_lower_secondary_support_y, raspberrypi_standoff_height], center=true);
            }
            
            // a203 jetson nano standoffs
            translate([0, a203_screwhole_spacing_y, 0])
            translate([0, 0, raspberrypi_standoff_height + joint_mount_height - joint_mount_intermediate_space_offset])
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            translate([0, 0, 0])
            difference()
            {
                cylinder(d=m3_standoff_diameter, h=a203_standoff_height + joint_mount_intermediate_space_offset);
                translate([0, 0, a203_standoff_height + joint_mount_intermediate_space_offset -m3_threaded_insert_height])
                cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
            }
        }
        union()
        {
            // raspberry pi standoff holes (have to go through the standoffs and the intermediate space)
            translate([0, raspberrypi_screwhole_spacing_y, 0])
            translate([m3_standoff_diameter/2 + raspberrypi_screwhole_offset_x, 0, 0])
            translate([0, 0, 0])
            cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
        }
    }
}

raspberrypi_jetson_mount_forward_lower();
raspberrypi_jetson_mount_aft();