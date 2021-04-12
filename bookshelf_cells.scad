include <tools.scad>
use <sample_wood.scad>
include <sample_book.scad>
use <cabinet.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
//Dispaly book to help at visualisation
ADD_BOOKS=true;

//Defines a bookshelf with straight shelves and inner walls
// shelves_height - List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
// shelves_width - List of shelves width, defines the bookshelf_width
// bookshelf_depth - Define the bookshelf dimensions (the height is computed from the shelves height and foot height, the width is computed from the shelves width)
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness / 
// border_height - (Optional) Place a border in front of each cell (vertically and horizontally), 0 will remove the border. Borders are centered vertically, bottom aligned horizonyally.

module bookshelf_cells(shelves_height, shelves_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height){
	available_depth=bookshelf_depth-back_thickness;
	shelf_depth=available_depth;
	
	//Function used to compute distance horizontal distance between bottom inner left corner
	function Compute_sum_shelf_position(level) = (level==0 ? 0 : (level==1 ? shelves_width[level-1] : Compute_sum_shelf_position(level-1)+shelves_width[level-1]));
	function Compute_shelf_position(level) = Compute_sum_shelf_position(level)+(level-1)*shelf_thickness;
	
	bookshelf_width=Compute_shelf_position(len(shelves_width))+2*side_thickness;
	
	//Functions used to compute distance between ground and a given shelf
	function Compute_height_bottom_shelf() = foot_height+side_thickness;
	function Compute_sum_shelves_thickness(level) = (level-1)*shelf_thickness;
	function Compute_sum_shelves_height(level) = (level==0 ? 0 : (level==1 ? shelves_height[level-1] : Compute_sum_shelves_height(level-1)+shelves_height[level-1]));
	function Compute_shelf_height(level) = Compute_height_bottom_shelf()+Compute_sum_shelves_thickness(level)+Compute_sum_shelves_height(level);
	
	//The bookshelf total height is computed from the sum of all the shelves, with top shelf height and top board
	bookshelf_height=Compute_shelf_height(len(shelves_height))+side_thickness;
	
	echo(str("<b>The bookshelf will be ",bookshelf_height," ",unit," high, with a width of ",bookshelf_width," ",unit," and a depth of ",bookshelf_depth," ",unit,"</b>"));
	
	border_thickness=(border_height>0?shelf_thickness:0);
	
	translate([side_thickness, 0, 0]){
		//Use cabinet structure
		cabinet(bookshelf_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness);
		
		wall_height=bookshelf_height-foot_height-2*side_thickness;
		//Automatically place the verticals from the list of width
		if(len(shelves_width)>1){
			for(level=[1:len(shelves_width)-1]){
				horizontal_distance=Compute_shelf_position(level);
				echo(str("The ",level,"-th inner-wall will be ",horizontal_distance," ",unit," from inner left botom corner"));
				
				translate([horizontal_distance+shelf_thickness, border_thickness, foot_height+side_thickness]) rotate([0, -90, 0]) board_lightWood(wall_height, shelf_depth-border_thickness, shelf_thickness, str(level,"-th inner wall"));
				
				if(border_height>0){
					translate([horizontal_distance+shelf_thickness/2+border_height/2, shelf_thickness, foot_height+side_thickness]) rotate([0, 0, 90]) rotate([0, -90, 0]) board_lightWood(wall_height, border_height, shelf_thickness, str("border for ",level,"-th inner wall"));
				}
			}
		}
		
		for(levelV=[1:len(shelves_height)-1]){
			ground_distance=Compute_shelf_height(levelV);
			echo(str("The shelves at level ",levelV," will be ",ground_distance," ",unit," from ground"));
			
			for(levelH=[0:len(shelves_width)-1]){
				horizontal_distance=Compute_shelf_position(levelH);
				
				translate([horizontal_distance+shelf_thickness, border_thickness, ground_distance]) board_lightWood(shelves_width[levelH], shelf_depth-border_thickness, shelf_thickness, str(levelH, "-th shelf at level ", levelV));
				
				//Compute border info
				horizontal_border_offset=(levelH==0)?0:(border_height-shelf_thickness)/2;
				border_length=shelves_width[levelH]-((levelH==0 || levelH==len(shelves_width)-1)?(border_height-shelf_thickness)/2: //First and last border must be a bit longer
					(border_height-shelf_thickness));
				
				if(border_height>0){
					translate([horizontal_distance+shelf_thickness+horizontal_border_offset, border_thickness, ground_distance]) rotate([90, 0, 0]) board_lightWood(border_length, border_height, shelf_thickness, str("border for ",levelH, "-th shelf at level ", levelV));
				}
				
				//Place books
				translate([horizontal_distance+shelf_thickness, shelf_depth, ground_distance+shelf_thickness]) books(shelves_width[levelH], available_depth-8, available_depth-3, shelves_height[levelV]-5, shelves_height[levelV]-1,  1, 3);
			}
		}
		
		//Place books on lowest level
		for(levelH=[0:len(shelves_width)-1]){
			horizontal_distance=Compute_shelf_position(levelH);
			translate([horizontal_distance+shelf_thickness, shelf_depth, foot_height+side_thickness]) books(shelves_width[levelH], available_depth-8, available_depth-3, shelves_height[0]-5, shelves_height[0]-1,  1, 3);
		}
	}
}

bookshelf_cells(shelves_height=[10, 20, 30, 40], shelves_width=[10, 20, 30, 40], bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, border_height=4);

translate([136, 0, 50]) bookshelf_cells(shelves_height=[10, 20, 30], shelves_width=[10, 20, 30], bookshelf_depth=20, foot_height=0, side_thickness=2, back_thickness=1.5, shelf_thickness=2, border_height=4);

//Defines a bookshelf with straight shelves and inner walls (cells all have equal width)
// shelves_height - List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
// number_inner_walls - Number of inner-wall to place
// bookshelf_width \_Define the bookshelf dimensions (the height is computed from the shelves height and foot height)
// bookshelf_depth /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness / 
// border_height - (Optional) Place a border in front of each cell (vertically and horizontally), 0 will remove the border. Borders are centered vertically, bottom aligned horizonyally.

module bookshelf_even_width_cells(shelves_height, number_inner_walls, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height){
	level_length=bookshelf_width-2*side_thickness;
	shelf_width=(number_inner_walls==0)?level_length:(level_length-shelf_thickness*(number_inner_walls-1))/number_inner_walls;
	
	shelves_width=(number_inner_walls==0)?[shelf_width]:[for(i = [0:number_inner_walls-1]) shelf_width];

	bookshelf_cells(shelves_height, shelves_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height);
}

translate([224, 0, 0]) bookshelf_even_width_cells(shelves_height=[10, 20, 30, 40], number_inner_walls=4, bookshelf_width=120, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, border_height=4);

//Defines a bookshelf with straight shelves and inner walls (cells all have equal width and height)
// number_shelves - Number of shelves (lowest level included)
// number_inner_walls - Number of inner-wall to place
// bookshelf_width \
// bookshelf_height > Define the bookshelf dimensions
// bookshelf_depth /
// foot_height - Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
// side_thickness  \
// back_thickness   > Define the wood thickness for the sides, back and shelves
// shelf_thickness / 
// border_height - (Optional) Place a border in front of each cell (vertically and horizontally), 0 will remove the border. Borders are centered vertically, bottom aligned horizonyally.

module bookshelf_even_cells(number_shelves, number_inner_walls, bookshelf_width, bookshelf_height, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height){
	assert(number_shelves>1, "ERROR: At least one shelf is required");
	shelves_height=[for(i = [0:number_shelves-1]) (bookshelf_height-foot_height-side_thickness)/number_shelves];
	
	level_length=bookshelf_width-2*side_thickness;
	shelf_width=(level_length-shelf_thickness*(number_inner_walls-1))/number_inner_walls;
	
	shelves_width=[for(i = [0:number_inner_walls-1]) shelf_width];
	
	bookshelf_cells(shelves_height, shelves_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height);
}

translate([364, 0, 0]) bookshelf_even_cells(number_shelves=5, number_inner_walls=4, bookshelf_width=120, bookshelf_height=115, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, border_height=4);

translate([504, 0, 0]) bookshelf_even_cells(number_shelves=5, number_inner_walls=4, bookshelf_width=120, bookshelf_height=115, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, border_height=0);
