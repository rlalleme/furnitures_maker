include <tools.scad>
use <sample_wood.scad>
include <sample_book.scad>
use <cabinet.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
//Dispaly book to help at visualisation
ADD_BOOKS=true;

//Defines a bookshelf with straight shelves and (optionnal) sliding doors on the lowest level
// shelves_height - List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
// bookshelf_width \_Define the bookshelf dimensions (the height is computed from the shelves height and foot height)
// bookshelf_depth /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness /
// niche - defines the first and last level for a niche, no niche if empty, 0 means bottom of bookshelf, and can be equal to the number of shelves for the niche to touch the top (e.g. [1, 3] means from the first to the third shelves (reaching the bottom of the fourth shelf))
// niche_width - defines the horizontal distance inside the niche
// niche_angle - angle for the niche, positive to tilt it to the left, negative for the right
// niche_position - between 0 and 1 will be interprated as percentage (e.g. 0.3 = 30%) of the available space, any value above one will be interprated as a dimension
// add_doors (def: false) - Trigger the option for sliding doors on bottom level
// door_covering - Define the length that the door share: the front door, when closed will cover the back one from this distance
// door_recess - Define how much the front door is recessed inside the bookshelf, the back door is considered touching the front one (no gap is considered here)

module bookshelf_straight(shelves_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, niche=[], niche_width=0, niche_angle=0, niche_position=0, add_doors=false, door_covering=0, door_recess=0) {
	available_depth=bookshelf_depth-back_thickness;
	shelf_depth=available_depth;
	shelf_length=bookshelf_width-2*side_thickness;
	
	//Validate input content
	assert(niche_angle<=89 && niche_angle>=-89, "ERROR: Niche angle is invalid");
	assert(add_doors == false || add_doors==true && niche[0]!=0, "ERROR: Niche starts on the lowest level, while doors are also added");
	assert(len(niche)==0 || len(niche)==2 && (niche[0]>=0 && niche[0]<=len(shelves_height)-1) && (niche[1]>=1 && niche[1]<=len(shelves_height)), "ERROR: Invlaid niche definition");
	
	//Functions used to compute distance between ground and a given shelf
	function Compute_height_bottom_shelf() = foot_height+side_thickness;
	function Compute_sum_shelves_thickness(level) = (level-1)*shelf_thickness;
	function Compute_sum_shelves_height(level) = (level==0 ? 0 : (level==1 ? shelves_height[level-1] : Compute_sum_shelves_height(level-1)+shelves_height[level-1]));
	function Compute_shelf_height(level) = Compute_height_bottom_shelf()+Compute_sum_shelves_thickness(level)+Compute_sum_shelves_height(level);
	
	//The bookshelf total height is computed from the sum of all the shelves, with top shelf height and top board
	bookshelf_height=Compute_shelf_height(len(shelves_height))+side_thickness;
	
	echo(str("<b>The bookshelf will be ",bookshelf_height," ",unit," high, with a width of ",bookshelf_width," ",unit," and a depth of ",bookshelf_depth," ",unit,"</b>"));
	
	//Functions to compute niche sides
	function Compute_niche_height(niche) = Compute_shelf_height(niche[1])-Compute_shelf_height(niche[0])-shelf_thickness;
	function Compute_niche_shelves_height(level) = is_undef(niche[1])?0 : Compute_shelf_height(level) - Compute_shelf_height(niche[0]);
	
	//Position of niche sides
	cut_length=shelf_thickness/cos(niche_angle); //Length of the cut in the wood
	niche_horizontal_offest=(len(niche)!=2)?0:Compute_niche_height(niche)*tan(abs(niche_angle));
	niche_horizontal_width=niche_horizontal_offest+2*cut_length+niche_width;
	position_niche_left=(niche_position > 1.0)?niche_position:(shelf_length-niche_horizontal_width)*niche_position+((niche_angle>0)?niche_horizontal_offest:0);
	position_niche_right=position_niche_left+niche_width+cut_length;
	
	ERROR="ERROR: Niche does not fit inside piece of furniture, change one of: niche angle, position or width, or bookshelf width";
	assert(niche_horizontal_width<=shelf_length, ERROR);
	if(niche_angle>0){
		assert(position_niche_left-niche_horizontal_offest>=0, ERROR);
		assert(position_niche_right+cut_length<=shelf_length*1.0001, ERROR);
	}else{
		assert(position_niche_left>=0, ERROR);
		assert(position_niche_left+niche_horizontal_width<=shelf_length*1.001, ERROR);
	}
	
	shelf_extra_length=shelf_thickness*tan(niche_angle); //Add a bit of extra to allow the angled cut
	function Compute_niche_left_shelf(level) = position_niche_left-Compute_niche_shelves_height(level)*tan(niche_angle)+(niche_angle<0?0:shelf_extra_length);
	function Compute_niche_right_shelf(level) = shelf_length-position_niche_right-cut_length+Compute_niche_shelves_height(level)*tan(niche_angle)+((niche_angle<0)?-shelf_extra_length:0);
	
	translate([side_thickness, 0, 0]){
		//Use cabinet structure
		cabinet(bookshelf_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness);
		
		//Build niche sides
		if(len(niche)==2){
			//Compute length of the niche sides
			niche_side_extra=shelf_thickness*tan(abs(niche_angle)); //Add a bit of extra to allow angled cut
			niche_side_length=Compute_niche_height(niche)/cos(niche_angle) + niche_side_extra;
			
			if(niche_angle<=0){
				translate([position_niche_left, 0, Compute_shelf_height(niche[0])+shelf_thickness]) rotate([0, -90-niche_angle, 0]) translate([0, 0, -shelf_thickness]) board_lightWood(niche_side_length, shelf_depth, shelf_thickness, "niche left");

				translate([position_niche_right, 0, Compute_shelf_height(niche[0])+shelf_thickness]) rotate([0, -90-niche_angle, 0]) translate([0, 0, -shelf_thickness]) board_lightWood(niche_side_length, shelf_depth, shelf_thickness, "niche right");
			}else{
				translate([position_niche_left+cut_length, 0, Compute_shelf_height(niche[0])+shelf_thickness]) rotate([0, -90-niche_angle, 0]) board_lightWood(niche_side_length, shelf_depth, shelf_thickness, "niche left");

				translate([position_niche_right+cut_length, 0, Compute_shelf_height(niche[0])+shelf_thickness]) rotate([0, -90-niche_angle, 0]) board_lightWood(niche_side_length, shelf_depth, shelf_thickness, "niche right");
			}
		}
		
		//Automatically place the shelves from the list of height
		for(level=[1:len(shelves_height)-1]){
			ground_distance=Compute_shelf_height(level);
			echo(str("The shelf at level ",level," will be ",ground_distance," ",unit," from ground"));
			
			//Compute all values for the niche (if the niche is not triggered, all values will not be considered
			niche_offset=is_undef(niche[1])?0: Compute_niche_shelves_height(level);
			
			//Draw shelves (first case is for shelves cut by niche)
			if(len(niche)==2 && level>niche[0] && level<niche[1]){
				//Left shelf
				translate([0, 0, ground_distance]) board_lightWood(Compute_niche_left_shelf(level), shelf_depth, shelf_thickness, str("shelf level ",level," left side"));
				
				//Right shelf
				translate([Compute_niche_left_shelf(level)+niche_width+2*cut_length+((niche_angle<0)?shelf_extra_length:-shelf_extra_length), -1, ground_distance]) board_lightWood(Compute_niche_right_shelf(level), shelf_depth, shelf_thickness, str("shelf level ",level," left side"));
			}else{
				translate([0, 0, ground_distance]) board_lightWood(shelf_length, shelf_depth, shelf_thickness, str("shelf level ",level));
			}
				
			//Draw books to help visualise
			if(level==niche[0] || len(niche)==2 && level>niche[0] && level<niche[1]){
				//Draw books on left
				left_books_length=(niche_angle<=0)?Compute_niche_left_shelf(level):Compute_niche_left_shelf(level+1);
				translate([0, shelf_depth, ground_distance+shelf_thickness]) books(left_books_length, available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
				
				//Draw books on right
				right_books_length=(niche_angle>=0)?Compute_niche_right_shelf(level):Compute_niche_right_shelf(level+1);
				horizontal_book_offset=Compute_niche_right_shelf(level)-right_books_length;
				translate([Compute_niche_left_shelf(level)+niche_width+2*cut_length+((niche_angle<0)?shelf_extra_length:-shelf_extra_length)+horizontal_book_offset, shelf_depth, ground_distance+shelf_thickness]) books(right_books_length, available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
			}else{
				translate([0, shelf_depth, ground_distance+shelf_thickness]) books(shelf_length, available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
			}
		}
		
		if(add_doors){
			//If options is selected, add sliding doors
			translate([0, shelf_thickness+door_recess, foot_height+side_thickness]) rotate([90, 0, 0]) board_lightWood(shelf_length/2+door_covering, shelves_height[0], shelf_thickness);
			translate([shelf_length/2-door_covering, 2*shelf_thickness+door_recess, foot_height+side_thickness]) rotate([90, 0, 0]) board_lightWood(shelf_length/2+door_covering, shelves_height[0], shelf_thickness);
		}else{
			//Otherwise draw books instead (if function is enabled at top level)
			if(niche[0]==0){
				//Place les livres de gauche
				left_books_length=(niche_angle<=0)?Compute_niche_left_shelf(0):Compute_niche_left_shelf(1);
				translate([0, shelf_depth, Compute_height_bottom_shelf()]) books(left_books_length, available_depth-8, available_depth-3, shelves_height[0]-5, shelves_height[0]-1,  1, 3);
				
				//Place les livres de droite
				right_books_length=(niche_angle>=0)?Compute_niche_right_shelf(0):Compute_niche_right_shelf(1);
				horizontal_book_offset=Compute_niche_right_shelf(0)-right_books_length;
				translate([niche_position+niche_width+2*cut_length+((niche_angle<0)?shelf_extra_length:0)+horizontal_book_offset, shelf_depth, Compute_height_bottom_shelf()]) books(right_books_length, available_depth-8, available_depth-3, shelves_height[0]-5, shelves_height[0]-1,  1, 3);
			}else{
				translate([0, shelf_depth, Compute_height_bottom_shelf()]) books(shelf_length, available_depth-8, available_depth-3, shelves_height[0]-5, shelves_height[0]-1,  1, 3);
			}
		}
	}
}

bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, niche=[2,6], niche_width=34, niche_angle=20, niche_position=0.1, add_doors=true, door_covering=3, door_recess=3);

translate([190, 0, 0]) bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, niche=[0,6], niche_width=34, niche_angle=-25, niche_position=25);

translate([380, 0, 0]) bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, add_doors=true, door_covering=3, door_recess=3);

translate([570, 0, 0]) bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2);

translate([760, 0, 70]) bookshelf_straight(shelves_height=[20, 20, 20, 20], bookshelf_width=60, bookshelf_depth=20, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2);

translate([840, 0, 70]) bookshelf_straight(shelves_height=[20, 20, 20, 20], bookshelf_width=60, bookshelf_depth=20, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2, niche=[1, 3], niche_width=15, niche_angle=0, niche_position=15);
