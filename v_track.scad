module v_track(height=5, width=10, width_track_top=5, width_track_bottom=8, depth_track=3, length=50)
{
    translate([-width/2, 0, 0])
    linear_extrude(length)
    difference()
    {
        square([width, height]);
        polygon(points = [[width/2 - width_track_bottom/2, height - depth_track],
                          [width/2 - width_track_top/2, height],
                          [width/2 + width_track_top/2, height],
                          [width/2 + width_track_bottom/2, height - depth_track]]);
    }
}

v_track(length=20);