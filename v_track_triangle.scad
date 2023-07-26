//module isosceles_triangle(base_length, theta)
//{
//    h = base_length * tan(theta) / 2;
//    
//    p1 = [0, 0];
//    p2 = [-base_length/2, -h];
//    p3 = [base_length/2, -h];
//    
//    translate([0, h, 0])
//    polygon([p1, p2, p3]);
//}
//
//module tolerant_isosceles_triangles(base_length, theta, tolerance)
//{
//    if( tolerance > 0 ) // second triangle is bigger
//    {
//        h = base_length * tan(theta) / 2 + tolerance*(1+sin(theta));
//        difference()
//        {
//            isosceles_triangle(2*h*tan(theta), theta);
//            
//            translate([0, tolerance*(1+sin(theta))/2.5, 0])
//            isosceles_triangle(base_length, theta);
//        }
//    }
//    
//    
//}

module isosceles_triangle(base_length, theta)
{
    h = base_length * tan(theta) / 2;
    
    p1 = [0, h];
    p2 = [-base_length/2, 0];
    p3 = [base_length/2, 0];
    
    translate([0, -h/2.5, 0])
    polygon([p1, p2, p3]);
    
    echo([p1, p2, p3]);
}

module tolerant_isosceles_triangles(base_length, theta, tolerance)
{
    if( tolerance > 0 ) // expand base_length
    {
        
        h = base_length * tan(theta) / 2 + tolerance*(1+sin(theta));
        translate([0, base_length * tan(theta)/2/2.5, 0])
        difference()
        {
            isosceles_triangle((h+tolerance)/(tan(theta)/2), theta);
            isosceles_triangle(base_length, theta);
        }
    }
    
    
}
//
tolerant_isosceles_triangles(2, 45, 0.5);