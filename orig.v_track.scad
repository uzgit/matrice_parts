//module v_track(height=5, width=10, width_track_top=5, width_track_bottom=8, depth_track=3, length=50, runner=false, both=false, tolerance_vertical=0.25, tolerance_horizontal=0.5)
//{
//    // we don't want to scale the tolerance (we apply it multiple times per dimension)
////    tolerance_vertical = tolerance_vertical / 2;
//    tolerance_horizontal = tolerance_horizontal / 4;
//    
//    if( ! runner || both )
//    {
//        translate([-width/2, 0, 0])
////        linear_extrude(length)
//        difference()
//        {
//            square([width, height]);
//            polygon(points = [[width/2 - width_track_bottom/2 - tolerance_horizontal, height - depth_track],
//                              [width/2 - width_track_top/2 - tolerance_horizontal, height],
//                              [width/2 + width_track_top/2 + tolerance_horizontal, height],
//                              [width/2 + width_track_bottom/2 + tolerance_horizontal, height - depth_track]]);
//        }
//    }
//    
////    translate([0, depth_track, 0])
////                polygon(points = [[width/2 - width_track_bottom/2 + tolerance_horizontal, - depth_track],
////                              [width/2 - width_track_top/2 + tolerance_horizontal, 0],
////                              [width/2 + width_track_top/2 - tolerance_horizontal, 0],
////                              [width/2 + width_track_bottom/2 - tolerance_horizontal, - depth_track]]);
//            
////            square([width, tolerance_vertical]);
//    
//    if( runner || both )
//    {
//        x_translation = -width/2;
//        y_translation = both ? height - depth_track : -(height - depth_track);
//        z_translation = 0;
//        
//        echo("y_translation: ", y_translation);
//        translate([x_translation, y_translation, z_translation])
////        linear_extrude(length)
//        difference()
//        {
//            translate([0, depth_track, 0])
//                polygon(points = [[width/2 - width_track_bottom/2 + tolerance_horizontal, - depth_track],
//                              [width/2 - width_track_top/2 + tolerance_horizontal, 0],
//                              [width/2 + width_track_top/2 - tolerance_horizontal, 0],
//                              [width/2 + width_track_bottom/2 - tolerance_horizontal, - depth_track]]);
//            
//            square([width, tolerance_vertical]);
//        }
//    }
//}

module v_track(height=5, width=10, width_track_top=5, width_track_bottom=8, depth_track=3, length=50, runner=false, both=false, tolerance_vertical=0.25, tolerance_horizontal=0.5)
{
    // we don't want to scale the tolerance (we apply it multiple times per dimension)
//    tolerance_vertical = tolerance_vertical / 2;
    tolerance_horizontal = tolerance_horizontal / 4;
    
    if( ! runner || both )
    {
        translate([-width/2, 0, 0])
//        linear_extrude(length)
        difference()
        {
            square([width, height]);
            polygon(points = [[width/2 - width_track_bottom/2 - tolerance_horizontal, height - depth_track],
                              [width/2 - width_track_top/2 - tolerance_horizontal, height],
                              [width/2 + width_track_top/2 + tolerance_horizontal, height],
                              [width/2 + width_track_bottom/2 + tolerance_horizontal, height - depth_track]]);
        }
    }
    
    if( runner || both )
    {
        x_translation = -width/2;
        y_translation = both ? height - depth_track : -(height - depth_track);
        z_translation = 0;
        
        echo("y_translation: ", y_translation);
        translate([x_translation, y_translation, z_translation])
//        linear_extrude(length)
        difference()
        {
            translate([0, depth_track, 0])
                polygon(points = [[width/2 - width_track_bottom/2 + tolerance_horizontal, - depth_track],
                              [width/2 - width_track_top/2 + tolerance_horizontal, 0],
                              [width/2 + width_track_top/2 - tolerance_horizontal, 0],
                              [width/2 + width_track_bottom/2 - tolerance_horizontal, - depth_track]]);
            
            square([width, tolerance_vertical]);
        }
    }
}

v_track(length=20, runner=true, both=true, tolerance_vertical=0.25, tolerance_horizontal=0.5);