include <../library/roundedcube.scad>

$fn=120;

m3_screwhole_diameter = 3.1;
m3_screwhead_diameter = 5.5;
m3_standoff_diameter = 6;
m3_threaded_insert_diameter = 4;
m3_threaded_insert_height = 6;

raspberrypi_screwhole_spacing_x = 49;
raspberrypi_screwhole_spacing_y = 58;
raspberrypi_standoff_height = 3;

jetson_nano_heatsink_screwhole_spacing_x = 32;
jetson_nano_heatsink_screwhole_spacing_y = 32;
jetson_nano_screwhole_height = 3;
jetson_nano_screwhead_height = 3;

rpi_nano_mount_thickness = 7;
rpi_nano_space_offset = 15;

module simple_hybrid_mount()
{
    difference()
    {
        union()
        {
            cube([raspberrypi_screwhole_spacing_x + rpi_nano_space_offset, raspberrypi_screwhole_spacing_y + rpi_nano_space_offset, rpi_nano_mount_thickness]);
            
            translate([rpi_nano_space_offset/2, rpi_nano_space_offset/2, rpi_nano_mount_thickness])
            for(x_translation = [0, raspberrypi_screwhole_spacing_x])
            for(y_translation = [0, raspberrypi_screwhole_spacing_y])
            translate([x_translation, y_translation, 0])
            cylinder(d=m3_standoff_diameter, h=raspberrypi_standoff_height);
        }
        union()
        {
            translate([rpi_nano_space_offset/2, rpi_nano_space_offset/2, rpi_nano_mount_thickness + raspberrypi_standoff_height])
            for(x_translation = [0, raspberrypi_screwhole_spacing_x])
            for(y_translation = [0, raspberrypi_screwhole_spacing_y])
            translate([x_translation, y_translation, 0])
            rotate([180, 0, 0])
            cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
            
            translate([2.5, 13, 0])
            translate([rpi_nano_space_offset/2 + raspberrypi_screwhole_spacing_x/2, rpi_nano_space_offset/2 + raspberrypi_screwhole_spacing_y/2, 0])
            for(x_translation = [-jetson_nano_heatsink_screwhole_spacing_x/2, jetson_nano_heatsink_screwhole_spacing_x/2])
            for(y_translation = [-jetson_nano_heatsink_screwhole_spacing_y/2, jetson_nano_heatsink_screwhole_spacing_y/2])
            translate([x_translation, y_translation, 0])
            union()
            {
                cylinder(d=m3_screwhole_diameter, jetson_nano_screwhole_height);
                translate([0, 0, jetson_nano_screwhole_height])
                cylinder(d=m3_screwhead_diameter, rpi_nano_mount_thickness - jetson_nano_screwhole_height);
            }
            
            total_y = raspberrypi_screwhole_spacing_y + rpi_nano_space_offset;
            spacing = 20;
            translate([0, total_y/2, 0])
            for(y_translation = [-spacing, 0, spacing])
            translate([0, y_translation, rpi_nano_mount_thickness/2])
            rotate([0, 90, 0])
            cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
        }
    }
}

simple_hybrid_mount();
