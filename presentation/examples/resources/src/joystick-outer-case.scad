/* open with OpenSCAD; F6 to render; export to STL
   stl2pov to generate the "inc" file */

$fn=256;

module roundCornersCube(x,y,z,r) {
        translate([r, r, r])
        minkowski() {
                cube([x - 2 * r, y - 2 * r, z - 2 * r]);
                //~ cylinder(r=r, h=0.1);
                sphere(r=r);
        }
}

module round4CornersCube(x,y,z,r) {
	translate([r, r, 0])
        minkowski() {
			cube([x - 2 * r, y - 2 * r, z]);
			cylinder(r=r, h=0.1);
        }
}

difference() {
	translate([-50, -50, 0])
	roundCornersCube(100, 100, 50, 8);
	translate([0, 0, 30])
	hull() {
		translate([-35, -35, 20])
			round4CornersCube(70, 70, 0.1, 10);
		cylinder(d=10, h=0.1);
	}
}
