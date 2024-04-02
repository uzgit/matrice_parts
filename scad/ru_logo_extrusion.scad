// use the single-core version of openscad to render this

$fn=120;

height = 1;

//difference()
//{
//    linear_extrude(height=height)
//    square([100, 100])
//    
////    linear_extrude(height=height)
//    import(file="../library/ru_logo.svg");
//}

difference()
{translate([54, 54, 0])
cylinder(d=100, h=height);
linear_extrude(height=height)
import(file="../library/ru_logo.svg");
}