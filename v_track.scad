module isosceles_triangle(base_length, theta, tolerance)
{
    h = base_length * tan(theta) / 2;
    scalar = tolerance/(h/3) + 1;
    
    p1 = [0, h*2/3*scalar];
    p2 = [-base_length/2*scalar, -h/3*scalar];
    p3 = [base_length/2*scalar, -h/3*scalar];
    
    polygon([p1, p2, p3]);
}

module tolerant_isosceles_triangle(base_length, theta, tolerance)
{
    h = base_length * tan(theta) / 2;
    x_translation = 0;
    y_translation = h/3;
    z_translation = 0;
    
    if( tolerance > 0 )
    {
        translate([x_translation, y_translation, z_translation])
            isosceles_triangle(base_length, theta, tolerance);
    }
    else if( tolerance < 0 )
    {
        translate([x_translation, y_translation, z_translation])
            isosceles_triangle(base_length, theta, tolerance);
    }
    else
    {
        translate([x_translation, y_translation, z_translation])
        isosceles_triangle(base_length, theta);
    }
}


module v_track_male_cross_section(base_length=15, theta=75, depth=3, tolerance=0.1)
{
    // do not multiply tolerance
    tolerance = -tolerance / 2;
    
    h = base_length * tan(theta) / 2;
    difference()
    {
        translate([0, tolerance/2, 0])
        tolerant_isosceles_triangle(base_length, theta, tolerance=tolerance);
        translate([0, depth + (h-depth)/2, 0])
        square([base_length, h-depth], center=true);
    }
}

module v_track_female_cross_section(width=6, height=4, base_length=15, theta=75, depth=3, tolerance=0.1)
{
    difference()
    {
        translate([0, -height/2 + depth, 0])
        square([width, height], center=true);
        
        v_track_male_cross_section(base_length, theta, depth, -tolerance);
    }
}

module v_track_male_extrusion(length=20, base_length=15, theta=75, depth=3, tolerance=0.1)
{
    translate([0, length/2, 0])
    rotate([90, 0, 0])
    linear_extrude(length)
    v_track_male_cross_section(base_length=base_length, theta=theta, depth=depth, tolerance=tolerance);
}

module v_track_female_extrusion(length=20, base_length=15, theta=75, depth=3, tolerance=0.1, height=5, width=20)
{
    translate([0, length/2, 0])
    rotate([90, 0, 0])
    linear_extrude(length)
    v_track_female_cross_section(height=height, width=width, base_length=base_length, theta=theta, depth=depth, tolerance=tolerance);
}

//length=55;
//tolerance=0.1;
//base_length=15;
//theta=65;
//width=20;
//height=5;
//depth=3;
//
//v_track_male_extrusion(length=length, base_length=base_length, tolerance=tolerance, theta=theta, width=width, height=height, depth=depth);
//
//v_track_female_extrusion(height=height, width=width, length=length, base_length=base_length, tolerance=tolerance, theta=theta, depth=depth);

//linear_extrude(length)
//v_track_male_cross_section(width=width, height=height, base_length=base_length, theta=theta, tolerance=tolerance);

//linear_extrude(length)
//v_track_female_cross_section(width=width, height=height, base_length=base_length, theta=theta, tolerance=tolerance);