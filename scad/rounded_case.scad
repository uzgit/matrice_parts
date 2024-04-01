/****
 ** Rounded case and lid module
 ** 
 **  X,Y,Z = INSIDE dimensions of case
 **  thick = thickness of case walls (and lid lip)
 **
 ** optional parameters:
 ** LID = true   to create LID
 ** LID_OFFSET = size difference between box ID and lip of lid
 ****/

module rounded_case(X, Y, Z, thick, LID=true, LID_OFFSET=.15)
{
  // X,Y,Z = INSIDE dimensions of case
  // thick = thickness of walls
  translate([thick, thick, 0])
    difference() {
      minkowski() {
          cube([X, Y, Z + thick]);
          cylinder(r=thick, h=.01, $fn=100);
      }
      translate([0,0,thick]) cube([X,Y,Z+.02]);
  }
  if (LID) {
  translate([X+5, 0, 0])
    lid(X, Y, thick, thick, LID_OFFSET);
  }
}

module lid(X, Y, Z, thick, LID_OFFSET)
{
  // X,Y,Z = INSIDE dimensions of lid
  // thick = thickness of case walls
  translate([thick, thick, 0])
    union() {
      minkowski() {
        cube([X, Y, Z]);
        cylinder(r=thick, h=.01, $fn=100);
      }
      difference() 
      {
        translate([LID_OFFSET/2, LID_OFFSET/2, 0]) 
          cube([X - LID_OFFSET, Y - LID_OFFSET, Z * 2]);
        translate([thick, thick, Z])
          cube([X-(thick*2), Y-(thick*2), Z+.02]);
      }
  }
}

// Example - a 20 x 20 x 10 rounded box with 2mm thick walls & lid:
//rounded_case(20, 20, 10, 2);
