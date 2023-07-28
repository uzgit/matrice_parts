pi = 3.141592653589793;

module v_track(height=5, width=10, width_track_top=5, width_track_bottom=8, depth_track=3, length=50, runner=false, both=false, tolerance=0.5)
{
    x1a = -width_track_top/2;
    y1a = 0;
    x2a = width_track_top/2;
    y2a = 0;
    x3a = width_track_bottom/2;
    y3a = -depth_track;
    x4a = -width_track_bottom/2;
    y4a = -depth_track;
    
    theta = atan2( y1a - y4a, x1a - x4a);
    
    if( ! runner || both )
    {
        echo("start");
        echo( theta );
        echo( tolerance*cos(theta + 90) )
        echo("finish");
        
        x1 = x1a + tolerance*cos(theta + 90);
        y1 = y1a + tolerance*sin(theta + 90);
        x4 = x4a + tolerance*cos(theta + 90);
        y4 = y4a - tolerance*sin(theta + 90);
        
        x2 = x2a - tolerance*cos(theta + 90);
        y2 = y2a + tolerance*sin(theta + 90);
        x3 = x3a - tolerance*cos(theta + 90);
        y3 = y3a - tolerance*sin(theta + 90);
        
        difference()
        {
            translate([0, -height/2, 0])
            square( [width, height], center=true );
            polygon(points = [[x1, y1], [x2, y2], [x3, y3], [x4, y4]]);
        }
    }
    
    if( runner || both )
    {
        x1 = x1a;// + tolerance*cos(theta + 90);
        y1 = y1a;// + tolerance*sin(theta + 90);
        x4 = x4a;// + tolerance*cos(theta + 90);
        y4 = y4a;// - tolerance*sin(theta + 90);
        
        x2 = x2a;// - tolerance*cos(theta + 90);
        y2 = y2a;// + tolerance*sin(theta + 90);
        x3 = x3a;// - tolerance*cos(theta + 90);
        y3 = y3a;// - tolerance*sin(theta + 90);
        
//        square( [width, height], center=true );
        polygon(points = [[x1, y1],
                      [x2, y2],
                      [x3, y3],
                      [x4, y4]]);
    }
}

v_track(length=20, runner=true, both=true, tolerance=0.5);