include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_straight.scad>
use <../bookshelf_diagonal.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
// Dispaly book to help at visualisation
ADD_BOOKS=true;

/* [Hidden] */

//Walls and chimney
color("LightYellow") cube([448, 2, 253]);

translate([448, 1, 0])
difference(){
	union(){
		color("LightYellow") cylinder(h=104, r=91);
		translate([0, 0, 104]) color("LightYellow") cylinder(h=149, r1=76, r2=61);
	}
	
	union(){
		translate([-95, 0, -5]) cube([190, 95, 260]);
		translate([0, -92, -5]) cube([95, 100, 260]);
	}
}

bookshelf_depth=33.5;

//First bookshelf
translate([0, -bookshelf_depth, 0]) bookshelf_diagonal(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth=bookshelf_depth, foot_height=3.6, side_thickness=2.2, back_thickness=1.5, shelf_thickness=2.2, diagonal_width=30, diagonal_angle=24.4, diagonal_position=0);

//Second bookshelf
// translate([170, -bookshelf_depth, 0]) bookshelf_diagonal(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=170, bookshelf_depth, bookshelf_depth=37, foot_height=5, side_thickness=2, back_thickness=1.5, shelf_thickness=2, diagonal_width=50, diagonal_angle=20, diagonal_position=0.5);
translate([170, -bookshelf_depth, 0]) bookshelf_straight(shelves_height=[40, 36, 32, 32, 32, 32], bookshelf_width=150, bookshelf_depth=bookshelf_depth, foot_height=3.6, side_thickness=2.2, back_thickness=1.5, shelf_thickness=2.2, niche=[2,4], niche_width=50, niche_angle=0, niche_position=0.75, add_doors=true, door_covering=3, door_recess=3);
