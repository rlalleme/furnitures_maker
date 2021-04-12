include <tools.scad>
use <sample_wood.scad>
include <sample_book.scad>
use <cabinet.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
//Dispaly book to help at visualisation
ADD_BOOKS=true;

//Defines a bookshelf with a diagonal inside (with shelves).
// shelves_height - List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
// bookshelf_width \_Define the bookshelf dimensions (the height is computed from the shelves height and foot height)
// bookshelf_depth /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness /
// diagonal_width - Defines the horizontal distance inside the diagonal
// diagonal_angle - Angle for the diagonal, positive to tilt it to the left, negative for the right
// diagonal_position - Between 0 and 1 will be interprated as percentage (e.g. 0.3 = 30%) of the available space, any value above one will be interprated as a dimension (from left side)

module bookshelf_diagonal(shelves_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, diagonal_width, diagonal_angle, diagonal_position) {
	available_depth=bookshelf_depth-back_thickness;
	shelf_depth=available_depth;
	shelf_length=bookshelf_width-2*side_thickness;
	
	//Validate input content
	assert(diagonal_angle<=89 && diagonal_angle>=-89, "ERROR: Diagonal angle is invalid");
	
	//Functions used to compute distance between ground and a given shelf
	function Compute_height_bottom_shelf() = foot_height+side_thickness;
	function Compute_sum_shelves_thickness(level) = (level-1)*shelf_thickness;
	function Compute_sum_shelves_height(level) = (level==0 ? 0 : (level==1 ? shelves_height[level-1] : Compute_sum_shelves_height(level-1)+shelves_height[level-1]));
	function Compute_shelf_height(level) = Compute_height_bottom_shelf()+Compute_sum_shelves_thickness(level)+Compute_sum_shelves_height(level);

	//The bookshelf total height is computed from the sum of all the shelves, with top shelf height and top board
	bookshelf_height=Compute_shelf_height(len(shelves_height))+side_thickness;

	echo(str("<b>The bookshelf will be ",bookshelf_height," ",unit," high, with a width of ",bookshelf_width," ",unit," and a depth of ",bookshelf_depth," ",unit,"</b>"));
	
	//Build diagonal sides
	diag_extra=shelf_thickness*tan(abs(diagonal_angle)); //Add a bit of extra to allow angled cut
	diag_length=(bookshelf_height-foot_height-2*side_thickness)/cos(diagonal_angle) + diag_extra;
	
	//Compute diagonal sides position
	diag_horizontal_offset=(bookshelf_height-foot_height-2*side_thickness)/tan(90-abs(diagonal_angle)); //Offset due to the diag angle
	cut_length=shelf_thickness/cos(diagonal_angle);//Length of the cut in the wood
	diag_total_width=(bookshelf_height-foot_height-2*side_thickness)*tan(abs(diagonal_angle))+2*cut_length+diagonal_width;
	position_left_side=(diagonal_position > 1.0)?diagonal_position:(shelf_length-diag_total_width)*diagonal_position+ //Move according the position required by user
		((diagonal_angle>0)?diag_horizontal_offset:0); //Move the left side if tilted to the left so the top is inside the cabinet
	position_right_side=position_left_side+diagonal_width+cut_length;
	
	//Verify the validity of the input values
	ERROR="ERROR: Diagonal does not fit inside piece of furniture, change one of: diagonal angle, position or width, or bookshelf width";
	assert(diag_total_width<=shelf_length, ERROR);
	if(diagonal_angle>0){
		assert((position_left_side-diag_horizontal_offset)>=0, ERROR);
		assert((position_right_side+cut_length)<=shelf_length*1.001, ERROR);
	}else{
		assert(position_left_side>=0, ERROR);
		assert(position_right_side+diag_horizontal_offset+cut_length<=shelf_length*1.001, ERROR);
	}
// 	assert(position_right_side+cut_length<=shelf_length, "ERROR: Diagonal does not fit inside piece of furniture, change one of: diagonal angle, position or width, or bookshelf width");
	
	//Compute diagonal shelves length
	diag_shelf_length=diagonal_width*cos(diagonal_angle);
	//Compute offest for the lowered side (equivalent to vertical_offset taking into account the shelf_thickness) - no need for additional esthetic offset, included by construction
	vertical_shelf_offset=sin(diagonal_angle)*(diag_shelf_length+shelf_thickness);
	
	function Compute_left_shelf_height(level)=Compute_shelf_height(level)-(diagonal_angle>0?vertical_shelf_offset:0);
	function Compute_left_shelf_length(level)=tan(-diagonal_angle)*(Compute_left_shelf_height(level)-foot_height-side_thickness)+position_left_side+(diagonal_angle<0?diag_extra:0);
	function Compute_right_shelf_height(level)=Compute_shelf_height(level)+(diagonal_angle<0?vertical_shelf_offset:0);
	function Compute_right_shelf_length(level)=tan(diagonal_angle)*(Compute_right_shelf_height(level)-foot_height-side_thickness)+shelf_length-position_right_side-cut_length+(diagonal_angle>0?diag_extra:0);

	translate([side_thickness, 0, 0]){
		//Use cabinet structure
		cabinet(bookshelf_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness);
		
		//Place diagonal sides
		if(diagonal_angle<=0){
			translate([position_left_side, 0, foot_height+side_thickness]) rotate([0, -90-diagonal_angle, 0]) translate([0, 0, -shelf_thickness]) board_lightWood(diag_length, shelf_depth, shelf_thickness, "diagonal left side");

			translate([position_right_side, 0, foot_height+side_thickness]) rotate([0, -90-diagonal_angle, 0]) translate([0, 0, -shelf_thickness]) board_lightWood(diag_length, shelf_depth, shelf_thickness, "diagonal right side");
		}else{
			translate([position_left_side+cut_length, 0, foot_height+side_thickness]) rotate([0, -90-diagonal_angle, 0]) board_lightWood(diag_length, shelf_depth, shelf_thickness, "diagonal left side");

			translate([position_right_side+cut_length, 0, foot_height+side_thickness]) rotate([0, -90-diagonal_angle, 0]) board_lightWood(diag_length, shelf_depth, shelf_thickness, "diagonal right side");
		}
		
		//Compute offests
		vertical_offset=sin(diagonal_angle)*diag_shelf_length; //Offset between the left and right side of the diagonal (offest between sides of the shelf for the same level)
		vertical_esthetic_offset=(diag_extra)/2; //Small esthetic offest: the centre line of each side cross at the centre of the diagonal side
		
		//Automatically place the shelves from the list of height
		for(level=[1:len(shelves_height)-1]){
			ground_distance=Compute_shelf_height(level);
			
			//Compute horizontal offset
			diag_horizontal_offset=tan(diagonal_angle)*(ground_distance-foot_height-side_thickness-(diagonal_angle>0?vertical_offset:0));
			diag_horizontal_esthetic_offset=tan(diagonal_angle)*vertical_esthetic_offset;
			
			//Add shelves to the diagonal
			diag_shelf_position=position_left_side-diag_horizontal_offset+diag_horizontal_esthetic_offset; //Horizontal position from the bottom left corner for this level
			diag_shelf_height=ground_distance-(diagonal_angle>0?vertical_offset:0)-vertical_esthetic_offset; //Vertical position from the bottom left corner for this level
			
			//Place diagonal shelf
			translate([diag_shelf_position+cut_length, 0, diag_shelf_height]) rotate([0, -diagonal_angle, 0]) board_lightWood(diag_shelf_length, shelf_depth, shelf_thickness, str("diagonal shelf level ", level));

			//WARNING +0.1 on Y axis just for a nicer drawing
			
			//Place left shelf
			left_shelf_height=Compute_left_shelf_height(level);
			translate([0, 0.1, left_shelf_height]) board_lightWood(Compute_left_shelf_length(level), shelf_depth, shelf_thickness, str("left-side shelf level ", level));
			
			//Place right shelf
			right_shelf_height=Compute_right_shelf_height(level);
			right_shelf_length=Compute_right_shelf_length(level);
			translate([shelf_length-right_shelf_length, 0.1, right_shelf_height]) board_lightWood(right_shelf_length, shelf_depth, shelf_thickness, str("right-side shelf level ", level));
			
			//Display books when enabled
			//Book on first shelf and above
			translate([0, shelf_depth, left_shelf_height+shelf_thickness]) books(Compute_left_shelf_length(level+(diagonal_angle>0?1:0)), available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
			right_books_length=Compute_right_shelf_length(level+(diagonal_angle<0?1:0));
			translate([shelf_length-right_books_length, shelf_depth, right_shelf_height+shelf_thickness]) books(right_books_length, available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
			translate([diag_shelf_position+cut_length, shelf_depth, left_shelf_height+shelf_thickness]) rotate([0, -diagonal_angle, 0]) books(diag_shelf_length, available_depth-8, available_depth-3, shelves_height[level]-5, shelves_height[level]-1,  1, 3);
			
			//Display construction information
			echo(str("The left-side of the shelf at level ",level," will be ",left_shelf_height," ",unit," from ground"));
			echo(str("The center-side of the shelf at level ",level," will be ",(diag_shelf_height-foot_height-side_thickness)/cos(diagonal_angle)," ",unit," from the inner-left corner of the diagonal (measured on the diagonal side, not vertically)"));
			echo(str("The right-side of the shelf at level ",level," will be ",right_shelf_height," ",unit," from ground"));
		}
		
		//Books on lower shelf
		left_books_height=Compute_left_shelf_height(1);
		translate([0, shelf_depth, shelf_thickness]) books(Compute_left_shelf_length(diagonal_angle>0?1:0), available_depth-8, available_depth-3, left_books_height-5, left_books_height-1,  1, 3);
		right_books_length=Compute_right_shelf_length(diagonal_angle<0?1:0);
		right_books_height=Compute_right_shelf_height(1);
		translate([shelf_length-right_books_length, shelf_depth, shelf_thickness]) books(right_books_length, available_depth-8, available_depth-3, right_books_height-5, right_books_height-1,  1, 3);
	}
}

bookshelf_diagonal(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, diagonal_width=50, diagonal_angle=20, diagonal_position=0.5);

translate([190, 0, 50]) bookshelf_diagonal(shelves_height=[32, 32, 32, 32], bookshelf_width=100, bookshelf_depth=37, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2, diagonal_width=20, diagonal_angle=-10, diagonal_position=30);

translate([310, 0, 50]) bookshelf_diagonal(shelves_height=[32, 32, 32, 32], bookshelf_width=100, bookshelf_depth=37, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2, diagonal_width=20, diagonal_angle=0, diagonal_position=0.5);
