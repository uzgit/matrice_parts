// pin_headers.scad
//
// Model of through-hole and female pin headers. 
// 
// Units are metric
//
// "height" is the total length of the pin. Default is 12mm.
// "upper" is the length of the pin above the stopper for male pins, or the height of
// 		  the plastic shroud for female pins. Default is 7mm.
// "lower" is only used for female headers, sets length of pin below shroud. Default is 3mm.
// "rows" is the number of rows. Default is 3.
// "cols" is the number of columns. Default is 2.
// "male" sets whether you produce male or female pin headers. 1 is male, anything else
//			  is female. Default is 1.
//
// Examples:
// pin_header( rows=5 cols=1 );
//		Produces a 1 column wide, 5 pin long, otherwise default male header.
// pin_header( rows=5 cols=1 male=0);
//		Produces the equivalent female pin header with 1 column and 5 pins.
//
// Original by Paul McGovern - Updated to include female headers by Stephen Baird

module pin_header( height=12, upper=7, lower=3, rows=3, cols=2, male = 1, hole_size=0.64 ) {

	cl = 2.54;

	translate( [ -(rows  * cl/2 ) + cl /2, -(cols  * cl/2 ) + cl /2, 0 ] ) {

		for( col = [0: cols -1 ] ) {	//column loop
			for( row = [0 : rows -1 ] ) {	//rows loop
	//***********************************************//
	// 			Code for male header below				 //
	//***********************************************//

				if (male == 1){	
					translate( [ cl * row , cl * col, 0] ) {
							//stopper
							color( "gray" )
							translate( [0,0, cl / 2]) {
								intersection() {
									cube( [ cl, cl, cl ], center=true );
									rotate( [0, 0, 45] ) cube( [ 2.8, 2.8, cl ], center=true );
							}
						}
					//pins
					color( "silver" ) {
						translate( [0,0, (upper - ( height/2 )) + cl ] ) {
							union() {
								cube( [hole_size,hole_size,height], center=true );
								translate( [0,0, height/2 ] ) scale( 0.64 ) _pin_point();
								translate( [0,0, -height/2 ] ) scale( 0.64 )	rotate([180,0,0] )_pin_point();
							}
						}
					}
					}
				}
	//***********************************************//
	// 			Code for female header below			 //
	//***********************************************//

				if (male != 1){
				translate( [ cl * row , cl * col, 0] ) {
						//upper shroud
						color( "gray" )
							translate( [0,0, upper/2 ]) {
								difference(){	
									cube( [ cl, cl, upper ], center=true );
								cube( [hole_size,hole_size,height], center=true );
									translate( [0,0,.01+upper/2] ) rotate([180,0,0] ) _pin_point();
								}

							}
					//pins
					color( "silver" ) {
						translate( [0,0, -lower/2 ] ) {
							union() {
								cube( [hole_size,hole_size,lower], center=true );
								translate( [0,0, -lower/2 ] ) scale( 0.64 )	rotate([180,0,0] )_pin_point();
							}
						}
					}
					}
				}
		}
	}
}
}

module _pin_point() {
	translate( [-0.5,-0.5, 0])
		polyhedron( 
			points=[[0,0,0],[0,1,0],[1,1,0],[1,0,0],[0.5,0.5,0.5]], 
			faces=[[0,1,2],[0,2,3],[0,1,4],[1,2,4],[2,3,4],[3,0,4]],
			convexity = 20);
}