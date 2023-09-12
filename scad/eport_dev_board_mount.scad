$fn = 120;

module eport_dev_board_mount()
{
    screw_distance = 16;
    screw_y_offset = 10;
    height = 3;

    difference
    ()
    {
        union()
        {
            translate([0, 0, height/2])
            cube([40, 60, 3], center=true);
        }
        union()
        {
            for( x_translation = [-screw_distance, screw_distance] )
            {
                for( y_translation = [-screw_distance, screw_distance] )
                {
                    translate([x_translation, y_translation - screw_y_offset, 0])
                    cylinder(d=4, h=height);
                }
            }
        }
    }
}

eport_dev_board_mount();