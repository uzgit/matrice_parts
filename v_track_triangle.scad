module isosceles_triangle(base_length, theta, tolerance=0)
{
    h = base_length * tan(theta) / 2;
    scalar = tolerance/(h/3) + 1;
    
    p1 = [0, h*2/3*scalar];
    p2 = [-base_length/2*scalar, -h/3*scalar];
    p3 = [base_length/2*scalar, -h/3*scalar];
    
    polygon([p1, p2, p3]);
}

module tolerant_isosceles_triangles(base_length, theta, tolerance)
{
    if( tolerance > 0 ) // expand base_length
    {
        difference()
        {
            isosceles_triangle(base_length, theta, tolerance);
            isosceles_triangle(base_length, theta);
        }
    }
}

tolerant_isosceles_triangles(3, 60, tolerance=0.25);