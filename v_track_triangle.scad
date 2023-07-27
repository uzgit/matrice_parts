module isosceles_triangle(base_length, theta, tolerance=0)
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


module v_track_male(base_length=15, theta=75, depth=3, tolerance=0.1)
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

module v_track_female(width=6, height=4, base_length=15, theta=75, depth=3, tolerance=0.1)
{
    difference()
    {
        translate([0, -height/2 + depth, 0])
        square([width, height], center=true);
        
        v_track_male(base_length, theta, depth, -tolerance);
    }
}

length=20;
tolerance=0.1;
base_length=8;
theta=65;
width=10;
height=5;

linear_extrude(length)
v_track_male(width=width, height=height, base_length=base_length, theta=theta, tolerance=tolerance);

linear_extrude(length)
v_track_female(width=width, height=height, base_length=base_length, theta=theta, tolerance=tolerance);