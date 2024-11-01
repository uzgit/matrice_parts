module coral_insulator_plate()
{
    width = 60;
    length = 25;
    thickness = 0.5;
    corner_diameter = 8;
    
    difference()
    {
        union()
        {
            translate([-width/2, -length/2, 0])
            cube([60, 25, 0.5]);
        }
        union()
        {
            for( x_translation = [-width/2, width/2] )
            {
                for( y_translation = [-length/2, length/2] )
                {
                    translate([x_translation, y_translation, 0])
                    cylinder(h=thickness, d=corner_diameter);
                }
            }
        }
    }
}

coral_insulator_plate();