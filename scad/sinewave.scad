amplitude = 3; //y-height of the "curve"
samrat = 100; //resolution of sin wave
freq = 1; // # bumps
scale = 1/10; // scale factor for how long the feature is
height = 10; // z-height of the feature
av = 360*freq/samrat;

// smooth "cap" for the bumps
linear_extrude(height)for (i=[0:samrat-1])
{
    hull()
    {
        translate([i*scale,amplitude*(1+cos(-90+i*av)),0]) circle(0.1);
        translate([(i+1)*scale,amplitude*(1+cos(-90+(i+1)*av)),0]) circle(0.1);
    }
}

//// fill the area under the cap
//linear_extrude(height)for (i=[0:samrat-1])
//{
//    {
//        translate([i*scale,-0.1,0])
//        square([0.1,0.1+amplitude*(1+sin(-90+i*av))]);
//    }
//}