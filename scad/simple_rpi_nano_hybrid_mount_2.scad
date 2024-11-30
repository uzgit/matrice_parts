include <../library/roundedcube.scad>

$fn=120;

m2_screwhole_diameter = 2.4;
m2_standoff_diameter = 5.5;
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

a203_screwhole_spacing_x = 46;
a203_screwhole_spacing_y = 81;

rpi_nano_mount_thickness = 7;
rpi_nano_space_offset = 15;

main_plate_x = raspberrypi_screwhole_spacing_x + rpi_nano_space_offset;
main_plate_y = raspberrypi_screwhole_spacing_y + rpi_nano_space_offset + 14;

// psdk port dev board mount
psdk_port_dev_board_offset_x = 10;
psdk_port_dev_board_mount_length = 56;
psdk_port_dev_board_mount_side_length = 47;

module simple_hybrid_mount()
{
    difference()
    {
        union()
        {
            cube([main_plate_x, main_plate_y, rpi_nano_mount_thickness]);
            
            translate([rpi_nano_space_offset/2, rpi_nano_space_offset/2, rpi_nano_mount_thickness])
            for(x_translation = [0, raspberrypi_screwhole_spacing_x])
            for(y_translation = [0, raspberrypi_screwhole_spacing_y])
            translate([x_translation, y_translation, 0])
            cylinder(d=m3_standoff_diameter, h=raspberrypi_standoff_height);
            
            union()
            {
                translate([psdk_port_dev_board_offset_x, 0, 0])
                linear_extrude(height=rpi_nano_mount_thickness)
                polygon([[psdk_port_dev_board_mount_side_length,0], [0, -psdk_port_dev_board_mount_side_length], [0, 0]]);
                
                linear_extrude(height=rpi_nano_mount_thickness)
                polygon([[0, 0], [psdk_port_dev_board_offset_x, 0], [psdk_port_dev_board_offset_x, -psdk_port_dev_board_mount_side_length], [0, -psdk_port_dev_board_mount_side_length]]);
            }
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
            spacing = 30;
            translate([0, main_plate_y/2, 0])
            for(y_translation = [-spacing, 0, spacing])
            translate([0, y_translation, rpi_nano_mount_thickness/2])
            rotate([0, 90, 0])
            cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
            
            translate([main_plate_x - 6, main_plate_y, rpi_nano_mount_thickness/2])
            union()
            {
                rotate([90, 0, 0])
                cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
                
                translate([-28, 0, 0])
                rotate([90, 0, 0])
                cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height);
            }
            
            union()
            {
                translate([psdk_port_dev_board_mount_side_length + psdk_port_dev_board_offset_x, 0, rpi_nano_mount_thickness/2])
                rotate([90, 0, -135])
                translate([5, 0, -1])
                union()
                {
                    cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height + 1);
                    translate([56, 0, 0])
                    cylinder(d=m3_threaded_insert_diameter, h=m3_threaded_insert_height + 1);
                }
            }
        }
    }
    
    difference()
    {
    }
}

module eport_dev_board_a203_mount()
{
    
}

module eport_usb_mount()
{
    difference()
    {
        union()
        {
            translate([-6.5, 0, 0])
            import("/home/joshua/Downloads/Double_USB_plug.stl");
            translate([0, 2.5, -2.5])
            cube([60, 5, 5], center=true);
            
            translate([0, 15/2, -2.5])
            cube([13, 14., 5], center=true);
            
        }
        union()
        {
            translate([0, 2.5, -5])
            for(x_translation = [-25, 25])
            translate([x_translation, 0, 0])
            cylinder(d=m2_screwhole_diameter, h=5+3);
        }
    }
}

module m3_standoff()
{
    difference()
    {
        cylinder(d=m3_standoff_diameter, h=3);
        cylinder(d=m3_screwhole_diameter, h=3);
    }
}

module eport_usb_mount_standoffs()
{
    for(x_translation = [-25, 25])
    translate([x_translation, 0, 0])
    difference()
    {
        cylinder(d=m2_standoff_diameter, h=3);
        cylinder(d=m2_screwhole_diameter, h=3);
    }
}

module jetson_heatsink_standoffs()
{
    for(x_translation = [-jetson_nano_heatsink_screwhole_spacing_x/2, jetson_nano_heatsink_screwhole_spacing_x/2])
    for(y_translation = [-jetson_nano_heatsink_screwhole_spacing_y/2, jetson_nano_heatsink_screwhole_spacing_y/2])
    translate([x_translation, y_translation, 0])
    difference()
    {
        cylinder(d=m3_standoff_diameter, h=5);
        cylinder(d=m3_screwhole_diameter, h=5);
    }
}

module jetson_heatsink_standoff()
{
    difference()
    {
        cylinder(d=m3_standoff_diameter, h=5);
        cylinder(d=m3_screwhole_diameter, h=5);
    }
}

eport_dev_board_a203_mount();
//simple_hybrid_mount();
//m3_standoff();
//jetson_heatsink_standoffs();
//jetson_heatsink_standoff();
//eport_usb_mount();
//eport_usb_mount_standoffs();