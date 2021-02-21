include <tools.scad>
use <sample_wood.scad>
use <cabinet.scad>

//Defines a bookshelf with straight shelves and (optionnal) sliding doors on the lowest level
// shelves_height - List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
// bookshelf_width \_Define the bookshelf dimensions (the height is computed from the shelves height and foot height
// bookshelf_depth /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness /
// add_doors (def: false)
// door_covering - Define the length that the door share: the front door, when closed will cover the back one from this distance
// door_recess - Define how much the front door is recessed inside the bookshelf, the back door is considered touching the front one (no gap is considered here)
module bibliotheque_droite(shelves_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, add_doors=false, door_covering=0, door_recess=0) {
	available_depth=bookshelf_depth-back_thickness;
	shelf_depth=available_depth;
	shelf_length=bookshelf_width-2*side_thickness;
	
	//Functions used to compute distance between ground and a given shelf
	function Compute_height_bottom_shelf() = foot_height+side_thickness;
	function Compute_sum_shelves_thickness(level) = (level-1)*shelf_thickness;
	function Compute_sum_shelves_height(level) = (level==1 ? shelves_height[level-1] : Compute_sum_shelves_height(level-1)+shelves_height[level-1]);
	function Compute_shelf_height(level) = Compute_height_bottom_shelf()+Compute_sum_shelves_thickness(level)+Compute_sum_shelves_height(level);
	
	//The bookshelf total height is computed from the sum of all the shelves, with top shelf height and top board
	bookshelf_height=Compute_shelf_height(len(shelves_height))+side_thickness;
	
	echo(str("<b>The bookshelf will be ",bookshelf_height," ",unit," high, with a width of ",bookshelf_width," ",unit," and a depth of ",bookshelf_depth," ",unit,"</b>"));
	
	
	
	translate([side_thickness, 0, 0]){
		//Use cabinet structure
		cabinet(bookshelf_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness);
		
		//Automatically place the shelves from the list of height
		for(level=[1:len(shelves_height)-1]){
			ground_distance=Compute_shelf_height(level);
			echo(str("The shelf at level ",level," will be ",ground_distance," ",unit," from ground"));
			translate([0, 0, ground_distance]) board_lightWood(shelf_length, shelf_depth, shelf_thickness, str("shelf level ",level));
		}
		
		if(add_doors){
			//If options is selected, add sliding doors
			translate([0, shelf_thickness+door_recess, foot_height+side_thickness]) rotate([90, 0, 0]) board_lightWood(shelf_length/2+door_covering, shelves_height[0], shelf_thickness);
			translate([shelf_length/2-door_covering, 2*shelf_thickness+door_recess, foot_height+side_thickness]) rotate([90, 0, 0]) board_lightWood(shelf_length/2+door_covering, shelves_height[0], shelf_thickness);
		}
		
	}
}


bibliotheque_droite(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, add_doors=true, door_covering=3, door_recess=3);

translate([190, 0, 0]) bibliotheque_droite(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, add_doors=false);

translate([380, 0, 70]) bibliotheque_droite(shelves_height=[20, 20, 20, 20], bookshelf_width=60, bookshelf_depth=20, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2, add_doors=false);
