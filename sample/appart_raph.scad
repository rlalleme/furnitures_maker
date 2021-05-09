include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_straight.scad>
use <../bookshelf_diagonal.scad>
use <../room.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
// Dispaly book to help at visualisation
// ADD_BOOKS=true;

//Global variable used to demonstrate the swept_volume
draw_swept_volume=false;


//======================================================================
// Living Room
//======================================================================

walls_living_room=[[376.5, 0, 0], [174+98+273, -90, 33], [375, -90, 33], [83.5, -90, 20], [83.5, -180, 0], [20, -90, 20], [215, 0, 33], [415+66.5, -90, 20], [233.5, -90, 5], [130-66.5, 90, 5]];
walls_angle_living_room = Build_walls_angle(walls_living_room);
walls_origin_living_room = Build_walls_origin(walls_living_room, walls_angle_living_room);
walls_end_living_room = Build_walls_end(walls_living_room, walls_angle_living_room, walls_origin_living_room);

translate([450+5+354+5, 233.5, 0]){
	//Room walls and opening
// 	create_panel_opening(walls_living_room, walls_angle_living_room, walls_origin_living_room, wall_id=0, offset=[0, 0], shape=[89, 200], draw_swept_volume=draw_swept_volume) - declared in entrance
	create_panel_opening(walls_living_room, walls_angle_living_room, walls_origin_living_room, wall_id=1, offset=[174, 0], shape=[98, 200], draw_swept_volume=draw_swept_volume)
	create_double_panel_opening(walls_living_room, walls_angle_living_room, walls_origin_living_room, wall_id=2, offset=[72, 0], shape=[186, 200], draw_swept_volume=draw_swept_volume, left_panel_width=0.5)
	create_fixed_opening(walls_living_room, walls_angle_living_room, walls_origin_living_room, wall_id=2, offset=[258, 0], shape=[93, 200])
	create_panel_opening(walls_living_room, walls_angle_living_room, walls_origin_living_room, wall_id=6, offset=[40, 0], shape=[98, 200], swept_side_left=false, draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_living_room, walls_angle_living_room, walls_origin_living_room, default_walls_height=250);

	//Heaters
	translate_on_wall_end(walls_angle_living_room, walls_end_living_room, wall_id=1){
		translate([3, -85-11, 14]) color("White") cube([10, 85, 70]);
	}

	translate_on_wall(walls_angle_living_room, walls_origin_living_room, wall_id=3){
		translate([3, 11, 14]) color("White") cube([10, 58, 70]);
	}

	//Closet
	translate_on_wall(walls_angle_living_room, walls_origin_living_room, wall_id=8){
		translate([0, 233.5-5, 0]) color("Gray") cube([65, 5, 250]);
		translate([0, 68, 0]) color("Gray", alpha=0.5) cube([65, 233.5-68-5, 250]);
	}

	// Tech duct
	translate_on_wall(walls_angle_living_room, walls_origin_living_room, wall_id=8){
		color("Gray") cube([65, 68, 250]);
	}


	bookshelf_depth=33.5;

// 	//First bookshelf
// 	translate_on_wall(walls_angle_living_room, walls_origin_living_room, wall_id=0){
// 		translate([bookshelf_depth, 109, 0])
// 		rotate([0, 0, 90])
// 		bookshelf_diagonal(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=bookshelf_depth, foot_height=3.6, side_thickness=2.2, back_thickness=1.5, shelf_thickness=2.2, diagonal_width=30, diagonal_angle=24.4, diagonal_position=0);
// 	}
// 
// 	//Second bookshelf
// 	translate_on_wall(walls_angle_living_room, walls_origin_living_room, wall_id=1){
// 		translate([bookshelf_depth, 24, 0])
// 		rotate([0, 0, 90])
// 		bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=150, bookshelf_depth=bookshelf_depth, foot_height=3.6, side_thickness=2.2, back_thickness=1.5, shelf_thickness=2.2, niche=[2,4], niche_width=50, niche_angle=0, niche_position=0.75, add_doors=true, door_covering=3, door_recess=3);
// 	}
}




//======================================================================
// Room 3
//======================================================================

walls_room_3 =[[260, 0, 5], [354, -90, 33], [260, -90, 5], [354, -90, 5]];
walls_angle_room_3 = Build_walls_angle(walls_room_3);
walls_origin_room_3 = Build_walls_origin(walls_room_3, walls_angle_room_3);
walls_end_room_3 = Build_walls_end(walls_room_3, walls_angle_room_3, walls_origin_room_3);

translate([450+5, 330+20, 0]){
	//Room walls and opening
	create_panel_opening(walls_room_3, walls_angle_room_3, walls_origin_room_3, wall_id=1, offset=[354-172-98, 0], shape=[98, 200], draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_room_3, walls_angle_room_3, walls_origin_room_3, wall_id=3, offset=[354-90-3, 0], shape=[90, 200], swept_side_left=false, draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_room_3, walls_angle_room_3, walls_origin_room_3, default_walls_height=250);

	//Heaters
	translate_on_wall_end(walls_angle_room_3, walls_end_room_3, wall_id=1){
		translate([3, -172+19, 14]) color("White") cube([10, 88, 70]);
	}

	//Closet
	translate_on_wall(walls_angle_room_3, walls_origin_room_3, wall_id=0){
		translate([0, 120, 0]){
			color("Gray") cube([66, 5, 250]);
			translate([0, 5, 0]) color("Gray", alpha=0.5) cube([66, 140, 250]);
		}
	}
}





//======================================================================
// Room 2
//======================================================================

walls_room_2 =[[260, 0, 33], [450, -90, 33], [260, -90, 5], [450, -90, 5]];
walls_angle_room_2 = Build_walls_angle(walls_room_2);
walls_origin_room_2 = Build_walls_origin(walls_room_2, walls_angle_room_2);
walls_end_room_2 = Build_walls_end(walls_room_2, walls_angle_room_2, walls_origin_room_2);

translate([0, 330+20, 0]){
	//Room walls and opening
	create_panel_opening(walls_room_2, walls_angle_room_2, walls_origin_room_2, wall_id=0, offset=[0, 0], shape=[98, 200], draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_room_2, walls_angle_room_2, walls_origin_room_2, wall_id=3, offset=[0, 0], shape=[90, 200], draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_room_2, walls_angle_room_2, walls_origin_room_2, default_walls_height=250);

	//Heaters
	translate_on_wall(walls_angle_room_2, walls_origin_room_2, wall_id=0){
		translate([3, 98+74, 14]) color("White") cube([10, 76, 70]);
	}

	//Closet
	translate_on_wall(walls_angle_room_2, walls_origin_room_2, wall_id=2){
		translate([0, 141-5, 0]) color("Gray") cube([64, 5, 250]);
		color("Gray", alpha=0.5) cube([64, 141-5, 250]);
	}
}


//======================================================================
// Room 1
//======================================================================

walls_room_1 =[[330, 0, 33], [355, -90, 20], [330, -90, 5], [355, -90, 20]];
walls_angle_room_1 = Build_walls_angle(walls_room_1);
walls_origin_room_1 = Build_walls_origin(walls_room_1, walls_angle_room_1);
walls_end_room_1 = Build_walls_end(walls_room_1, walls_angle_room_1, walls_origin_room_1);

translate([0, 0, 0]){
	//Room walls and opening
	create_panel_opening(walls_room_1, walls_angle_room_1, walls_origin_room_1, wall_id=0, offset=[330-61-98, 0], shape=[98, 200], draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_room_1, walls_angle_room_1, walls_origin_room_1, wall_id=2, offset=[0, 0], shape=[90, 200], draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_room_1, walls_angle_room_1, walls_origin_room_1, default_walls_height=250);
	
	//Heaters
	translate_on_wall(walls_angle_room_1, walls_origin_room_1, wall_id=0){
		translate([3, 10, 14]) color("White") cube([10, 99, 70]);
	}
	
	//Closet
	//...
}



//======================================================================
// Bathroom
//======================================================================

walls_bathroom =[[215, 0, 5], [222, -90, 5], [215, -90, 5], [222, -90, 20]];
walls_angle_bathroom = Build_walls_angle(walls_bathroom);
walls_origin_bathroom = Build_walls_origin(walls_bathroom, walls_angle_bathroom);
walls_end_bathroom = Build_walls_end(walls_bathroom, walls_angle_bathroom, walls_origin_bathroom);

translate([355+5, 0, 0]){
	//Room walls and opening
	create_panel_opening(walls_bathroom, walls_angle_bathroom, walls_origin_bathroom, wall_id=1, offset=[0, 0], shape=[90, 200], swept_direction_inside=false, draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_bathroom, walls_angle_bathroom, walls_origin_bathroom, default_walls_height=250);
	
	//Heaters
	translate_on_wall(walls_angle_bathroom, walls_origin_bathroom, wall_id=0){
		translate([3, 0, 14]) color("White") cube([10, 69, 70]);
	}
	
	//Tech duct
	translate_on_wall(walls_angle_bathroom, walls_origin_bathroom, wall_id=3){
		color("Gray") cube([215-170, 69, 250]);
	}
	
	//Bathtub
	//...
}



//======================================================================
// WC
//======================================================================

walls_wc =[[150, 0, 0], [153, -90, 5], [150, -90, 5], [153, -90, 20]];
walls_angle_wc = Build_walls_angle(walls_wc);
walls_origin_wc = Build_walls_origin(walls_wc, walls_angle_wc);
walls_end_wc = Build_walls_end(walls_wc, walls_angle_wc, walls_origin_wc);

translate([355+5+222+5+127+5, 0, 0]){
	//Room walls and opening
// 	create_panel_opening(walls_wc, walls_angle_wc, walls_origin_wc, wall_id=0, offset=[60, 0], shape=[90, 200], swept_direction_inside=false, draw_swept_volume=draw_swept_volume) - decalred in entrance
	create_panel_opening(walls_wc, walls_angle_wc, walls_origin_wc, wall_id=1, offset=[93, 0], shape=[60, 200], draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_wc, walls_angle_wc, walls_origin_wc, default_walls_height=250);
	
	//Closet (door placed as opening above)
	translate_on_wall(walls_angle_wc, walls_origin_wc, wall_id=1){
		translate([-(233.5-5-150), 93, 0]) color("Gray", alpha=0.5) cube([233.5-5-5-150, 60, 250]);
	}
	
	//Toilet
	//...
}




//======================================================================
// Entrance
//======================================================================

walls_entrance =[[345, 0, 5], [222, -90, 5], [124, -90, 5], [222-127, -90, 5], [345-124, 90, 5], [127, -90, 20]];
walls_angle_entrance = Build_walls_angle(walls_entrance);
walls_origin_entrance = Build_walls_origin(walls_entrance, walls_angle_entrance);
walls_end_entrance = Build_walls_end(walls_entrance, walls_angle_entrance, walls_origin_entrance);

translate([355+5+222+5, 0, 0]){
	//Room walls and opening
	create_panel_opening(walls_entrance, walls_angle_entrance, walls_origin_entrance, wall_id=0, offset=[236, 0], shape=[90, 200], swept_direction_inside=false, draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_entrance, walls_angle_entrance, walls_origin_entrance, wall_id=2, offset=[21, 0], shape=[90, 200], swept_side_left=false, swept_direction_inside=false, draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_entrance, walls_angle_entrance, walls_origin_entrance, wall_id=3, offset=[0, 0], shape=[64, 249.5], swept_side_left=false, draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_entrance, walls_angle_entrance, walls_origin_entrance, wall_id=4, offset=[221-60-90, 0], shape=[90, 200], swept_side_left=false, draw_swept_volume=draw_swept_volume)
	create_panel_opening(walls_entrance, walls_angle_entrance, walls_origin_entrance, wall_id=5, offset=[127-92-5, 0], shape=[92, 200], swept_side_left=false, draw_swept_volume=draw_swept_volume)
	color("Gray") walls(walls_entrance, walls_angle_entrance, walls_origin_entrance, default_walls_height=250);
	
	//Closet (door placed as opening above)
	translate_on_wall(walls_angle_entrance, walls_origin_entrance, wall_id=3){
		translate([-61-5, 0, 0]) color("Gray", alpha=0.5) cube([61, 64, 250]);
		translate([-66, -5, 0]) color("Gray") cube([66, 5, 250]); //Fake wall to complete walls
		
	}
	
	//Tech duct
	translate_on_wall(walls_angle_entrance, walls_origin_entrance, wall_id=3){
		translate([-66, 64, 0]) color("Gray") cube([66, 222-127-64, 250]);
	}
	
	//Toilet
	//...
}





//======================================================================
// Corridor
//======================================================================

walls_corridor =[[376.5, 0, 5], [174+98+273, -90, 20], [375, -90, 20], [83.5, -90, 20], [83.5, -180, 0], [20, -90, 20], [215, 0, 20], [415, -90, 20], [233.5, -90, 5], [130, 90, 5]];
walls_angle_corridor = Build_walls_angle(walls_corridor);
walls_origin_corridor = Build_walls_origin(walls_corridor, walls_angle_corridor);
walls_end_corridor = Build_walls_end(walls_corridor, walls_angle_corridor, walls_origin_corridor);







//======================================================================
// Balcony
//======================================================================
