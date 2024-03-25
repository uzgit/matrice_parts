$fn=60;

cavity_height = 52;
cavity_width  = 25;

fan_diameter  = 23;

screw_translation_y = 45/2;
screw_translation_x = 20/2;
screw_head_height = 2;

base_height = 2;
extension_height = 7.5;

difference()
{
    union()
    {
        translate([0, 0, base_height/2])
        cube([cavity_width, cavity_height, base_height], center=true);

        translate([0, 0, base_height])
        linear_extrude(extension_height)
        difference()
        {
            union()
            {
                square([cavity_width, cavity_height], center=true);
            }

            union()
            {
                hull()
                {
                    translate([0, fan_diameter/2, 0])
                    circle(d=fan_diameter);

                    translate([0, -fan_diameter/2, 0])
                    circle(d=25);
                }
                
                square([cavity_width, 40], center=true);
            }
        }
    }
    union()
    {
        linear_extrude(base_height + extension_height)
        for(x_translation = [-screw_translation_x, screw_translation_x])
        {
            for(y_translation = [-screw_translation_y, screw_translation_y])
            {
                translate([x_translation, y_translation, 0])
                circle(d=2.9);
            }
        }
        
//        linear_extrude(screw_head_height)
//        for(x_translation = [-screw_translation_x, screw_translation_x])
//        {
//            for(y_translation = [-screw_translation_y, screw_translation_y])
//            {
//                translate([x_translation, y_translation, 0])
//                square([5, 5], center=true);
//            }
//        }
    }
}
