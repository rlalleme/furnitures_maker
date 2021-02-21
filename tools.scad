unit="cm";

//Draw reference axis
module drawAxis(s=1){
	rotate([0, 90, 0]) color("Crimson") cylinder(h=s, r1=s/20, r2=s/20, $fn=10);
	rotate([-90, 0, 0]) color("LimeGreen") cylinder(h=s, r1=s/20, r2=s/20, $fn=10);
	color("DodgerBlue") cylinder(h=s, r1=s/20, r2=s/20, $fn=10);
}

// drawAxis(1);
// 
// translate([2, 0, 0]) rotate([0, -45, 0]) drawAxis(1);
// 
// rotate([0, -45, 0]) translate([2, 0, 0]) drawAxis(1);
