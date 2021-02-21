use <sample_wood.scad>
use <tools.scad>

//Defines a cabinet
// cabinet_height \
// cabinet_width   > Define the cabinet dimensions (outer)
// cabinet_depth  /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness \_ Define the wood thickness for the sides and back
// back_thickness /
module cabinet(cabinet_height, cabinet_width, cabinet_depth, foot_height, side_thickness, back_thickness) {
	shelves_length=cabinet_width-2*side_thickness;
	
	//Left
	translate([0, 0, 0]) rotate([0, -90, 0]) board_lightWood(cabinet_height, cabinet_depth, side_thickness, "left side");
	
	//Right
	translate([cabinet_width-side_thickness, 0, 0]) rotate([0, -90, 0]) board_lightWood(cabinet_height, cabinet_depth, side_thickness, "right side");
	
	//Bottom
	translate([0, 0, foot_height]) board_lightWood(shelves_length, cabinet_depth, side_thickness, "bottom");
	
	//Top
	translate([0, 0, cabinet_height-side_thickness]) board_lightWood(shelves_length, cabinet_depth, side_thickness, "top");
	
	//Back
	bevel=side_thickness-0.5;
	translate([-bevel, cabinet_depth, foot_height+side_thickness-bevel]) rotate([90, 0, 0]) board_darkWood(shelves_length+2*bevel, cabinet_height-foot_height-2*side_thickness+2*bevel, back_thickness, "back");
	
	//Foot reinforcement
	if(foot_height!=0){
		translate([0, side_thickness, 0]) rotate([90, 0, 0]) board_lightWood(shelves_length, foot_height, side_thickness, "font front");
		translate([0, cabinet_depth, 0]) rotate([90, 0, 0]) board_lightWood(shelves_length, foot_height, side_thickness, "foot back");
	}
}

cabinet(cabinet_height=230, cabinet_width=150, cabinet_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5);
