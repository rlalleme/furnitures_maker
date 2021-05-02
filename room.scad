include <tools.scad>

//Global variable used to demonstrate the swept_volume
draw_swept_volume=true;

//The walls module work using data structures that need to be built from your wall description.
//The aim is to build the data structures only once (expensive in OpenSCAD langauge), and rely on them in the different modules.
//First fill the variable walls with tuples:
//  - the first element is the measurements of length of the inner face of the wall,
//  - the second element is the angle relative to previous wall (positive means turn to the left)
//  - [optional] the third element is the current-wall thickness, a value of 0 hides the given wall
//  - [optional] the fourth element is the current-wall height
//The description is assumed to specify the inner dimension of the wall, and all placement are relative to the bottom left corner.

//Then build the data structures with the following utilites
function Compute_wall_angle(walls, i) = ((i==0) ? walls[i][1] : walls[i][1] + Compute_wall_angle(walls, i-1));
function Compute_wall_origin(walls, walls_angle, i) = ((i==0) ? [0, 0] : [Compute_wall_origin(walls, walls_angle, i-1)[0] + sin(-walls_angle[i-1]) * walls[i-1][0], Compute_wall_origin(walls, walls_angle, i-1)[1] + cos(-walls_angle[i-1]) * walls[i-1][0]]);
function Compute_wall_end(walls, walls_angle, walls_origin, i) = [ walls_origin[i][0] + sin(-walls_angle[i]) * walls[i][0], walls_origin[i][1] + cos(-walls_angle[i]) * walls[i][0] ];

function Build_walls_angle(walls) = [ for(i = [0:len(walls)-1]) Compute_wall_angle(walls, i) ];
function Build_walls_origin(walls, walls_angle) = [ for(i = [0:len(walls)-1]) Compute_wall_origin(walls, walls_angle, i) ];
function Build_walls_end(walls, walls_angle, walls_origin) = [ for(i = [0:len(walls)-1]) Compute_wall_end(walls, walls_angle, walls_origin, i) ];

//See at the bottom of this file to get an example on how to build the data structures and use the modules

//Draw walls, help visualise the organisation of a room with the furnitures from the other modules
// walls - The tuple list of wall description
// walls_thickness - The default wall thickness (used when the thickness of a given wall is not specified, can be omitted if all the walls are defined)
// walls_height - The default wall height (used when the height of a given wall is not specified, can be omitted if all the walls are defined)
module walls(walls, walls_angle, walls_origin, default_walls_height){
	number_walls=len(walls);
	assert(number_walls>=1, "ERROR: Invalid number of walls");
	assert(len(walls_angle)==number_walls && len(walls_origin)==number_walls, "ERROR: walls_angle or walls_origin is invalid. Please build them using Compute_wall_angles or Compute_wall_origin.");

	for(i=[0:number_walls-1]){
		assert(len(walls[i])>=3 && len(walls[i])<=4, str("ERROR: Invalid wall description. walls[", i, "]=", walls[i], " is not of the form [length, angle, thickness]"));
		
		wall_thickness=walls[i][2];
		
		if(wall_thickness >0){
			previous_wall_thickness=(i==0)? walls[number_walls-1][2] : walls[i-1][2];
			extra_length=(walls[i][1]<=0)? previous_wall_thickness : 0;
			wall_length=walls[i][0] + extra_length;
			wall_height=(len(walls[i])>=4)? walls[i][3] : default_walls_height;
			
			translate(walls_origin[i]) rotate(walls_angle[i]) translate([-wall_thickness, -extra_length]) cube([wall_thickness, wall_length, wall_height]);
		}
	}
}

//Allow to simplify the placement of an object in a room: allow to specify a wall and a transalation relative to this wall origin (bottom left corner)
// walls_angle - Data structure build from walls description, see top of this file
// walls_origin - Data structure build from walls description, see top of this file
// wall_id - The id (or index) of the wall in the walls description (must be in the range [0, len(walls)])
//Usage: this module expects a scope with one or several objects to move to the origin of the wall. To use it properly you should invoke it with the follwoing sequence:
// translate/rotate the room
//   build room (see walls module)
//   translate_on_wall
//     translate/rotate to move the furniture
//       furniture
//See example for room 2 bellow
module translate_on_wall(walls_angle, walls_origin, wall_id){
	assert(len(walls_angle)==len(walls_origin), "ERROR: walls_angle or walls_origin is invalid. Please build them using Compute_wall_angles or Compute_wall_origin.");
	assert(wall_id>=0 && wall_id<len(walls_angle), str("ERROR: invalid wall_id, must be in the range [0, ", (len(walls_angle)-1), "]."));
	
	translate([walls_origin[wall_id][0], walls_origin[wall_id][1], 0]) rotate([0, 0, walls_angle[wall_id]]) children();
}

//Allow to simplify the placement of an object in a room: allow to specify a wall and a transalation relative to this wall end (bottom right corner)
// walls_angle - Data structure build from walls description, see top of this file
// walls_end - Data structure build from walls description, see top of this file
// wall_id - The id (or index) of the wall in the walls description (must be in the range [0, len(walls)])
//See translate_on_wall
module translate_on_wall_end(walls_angle, walls_end, wall_id){
	assert(len(walls_angle)==len(walls_end), "ERROR: walls_angle or walls_end is invalid. Please build them using Compute_wall_angles or Compute_wall_origin.");
	assert(wall_id>=0 && wall_id<len(walls_angle), str("ERROR: invalid wall_id, must be in the range [0, ", (len(walls_angle)-1), "]."));
	
	translate([walls_end[wall_id][0], walls_end[wall_id][1], 0]) rotate([0, 0, walls_angle[wall_id]]) children();
}

//Create a fixed opening (door/window)
// walls - The tuple list of wall description
// walls_angle - Data structure build from walls description, see top of this file
// walls_origin - Data structure build from walls description, see top of this file
// wall_id - The id (or index) of the wall in the walls description (must be in the range [0, len(walls)])
// offset - Translation on the wall for the opening, must be expressed as a position on the wall (from its left bottom corner) (vec2)
// shape - Dimensions of the opening expressed as [width, height]
module create_fixed_opening(walls, walls_angle, walls_origin, wall_id, offset, shape){
	assert(len(shape)==2, "ERROR: the shape is expected as a pair [width, height].");

	wall_thickness=walls[wall_id][2];
	
	create_custom_opening(walls, walls_angle, walls_origin, wall_id, offset){
		children();
		
		cube([3*wall_thickness, shape[0], shape[1]]);
	}
}

//Create a single panel opening (door/window), with its swept volume
// walls - The tuple list of wall description
// walls_angle - Data structure build from walls description, see top of this file
// walls_origin - Data structure build from walls description, see top of this file
// wall_id - The id (or index) of the wall in the walls description (must be in the range [0, len(walls)])
// offset - Translation on the wall for the opening, must be expressed as a position on the wall (from its left bottom corner) (vec2)
// shape - Dimensions of the opening expressed as [width, height]
// draw_swept_volume - [optional] Draw the volume swept by the opening panel (door panel, window panel, ...)
//   swept_direction_inside - The direction of the panel, true=the panel moves toward the inside, false=the panel moves toward the outside
//   swept_side_left - The side for the panel hinges (seen from the inside of the room), true=hinges on the left side, false=hinges on the right side
//    swept_angle - Angle swept by the panel
module create_panel_opening(walls, walls_angle, walls_origin, wall_id, offset, shape, draw_swept_volume=true, swept_direction_inside=true, swept_side_left=true, swept_angle=90){
	assert(len(shape)==2, "ERROR: the shape is expected as a pair [width, height].");
	
	wall_thickness=walls[wall_id][2];
	
	create_custom_opening(walls, walls_angle, walls_origin, wall_id, offset){
		children();
		
		cube([3*wall_thickness, shape[0], shape[1]]);
		
		if(draw_swept_volume==true){
			swept_offset_direction=(swept_direction_inside==true)?1.5*wall_thickness:0.5*wall_thickness;
			swept_offest_side=(swept_side_left==true)?0:shape[0];
			# translate([swept_offset_direction, swept_offest_side, 0]) difference(){
			cylinder(r=shape[0], h=shape[1]);
			//Remove appropriate side
			translate([(swept_direction_inside==true)?-2*shape[0]:0, -2*shape[0], -0.5*shape[1]]) cube([2*shape[0], 4*shape[0], 2*shape[1]]);
			//Remove back (depending of swept_angle)
			rotate([0, 0, (swept_side_left==true && swept_direction_inside==true || swept_side_left==false && swept_direction_inside==false)?-swept_angle:swept_angle])
			translate([(swept_direction_inside==true)?0:-2*shape[0], -2*shape[0], -0.5*shape[1]])
			cube([2*shape[0], 4*shape[0], 2*shape[1]]);
			}
		}
	}
}

//Create a two-panel opening (door/window), with their swept volumes
module create_double_panel_opening(walls, walls_angle, walls_origin, wall_id, offset, shape, draw_swept_volume=true, swept_direction_inside=true, left_panel_width=0.5, swept_angle_left=90, swept_angle_right=90){
	left_panel_size=(left_panel_width<=1)?shape[0]*left_panel_width:left_panel_width;
	
	create_panel_opening(walls, walls_angle, walls_origin, wall_id, offset, [left_panel_size, shape[1]], draw_swept_volume, swept_direction_inside, swept_side_left=true, swept_angle=swept_angle_left)
	//The '0.001' in the offset is there only to offer nicer rendering
	create_panel_opening(walls, walls_angle, walls_origin, wall_id, [offset[0]+left_panel_size-0.01, offset[1]], [shape[0]-left_panel_size, shape[1]], draw_swept_volume, swept_direction_inside, swept_side_left=false, swept_angle=swept_angle_right)
	children();
}

//Create custom opening
//Will cut the given volume(s) from the provided walls. Expect at least to children, the first is the set of walls to remove the openings (all the other children). See usage below.
// walls - The tuple list of wall description
// walls_angle - Data structure build from walls description, see top of this file
// walls_origin - Data structure build from walls description, see top of this file
// wall_id - The id (or index) of the wall in the walls description (must be in the range [0, len(walls)])
// offset - Translation on the wall for the opening, must be expressed as a position on the wall (from its left bottom corner) (vec2)
//
//Important: The actual offest applied to the shape is a combination of the offset provided and a recess movement of 1.5*wall_thickness (to ease the opening operation). The opening shape should be 3*wall_thickness.
//
//Usage:
//  create_custom_opening(...){
//    walls()
//    opening_shape(s)
//  }
module create_custom_opening(walls, walls_angle, walls_origin, wall_id, offset){
	assert(len(walls)==len(walls_angle) && len(walls)==len(walls_origin), "ERROR: walls_angle or walls_origin is invalid. Please build them using Compute_wall_angles or Compute_wall_origin.");
	assert(wall_id>=0 && wall_id<len(walls_angle), str("ERROR: invalid wall_id, must be in the range [0, ", (len(walls)-1), "]."));
	assert(len(offset)==2, "ERROR: the offset is expected as a translation along the wall and an height.");
	
	assert($children>=2, "ERROR: this module expects at least two children.");

	wall_thickness=walls[wall_id][2];
	difference(){
		children(0);
		
		translate_on_wall(walls_angle, walls_origin, wall_id){
			translate([-1.5*wall_thickness, offset[0], offset[1]]){
				children([1:$children-1]);
			}
		}
	}
}



//SAMPLE SECTION
//===============================

//Declare the Room1 walls
walls_room1=[[300, 0, 10], [250, -90, 10], [100, -90, 10], [150, 90, 10], [200, -90, 10], [400, -90, 10]];
//Build the data structures
walls_angle_room1 = Build_walls_angle(walls_room1);
walls_origin_room1 = Build_walls_origin(walls_room1, walls_angle_room1);
walls_end_room1 = Build_walls_end(walls_room1, walls_angle_room1, walls_origin_room1);

//Build the room
//Create a door
create_fixed_opening(walls_room1, walls_angle_room1, walls_origin_room1, wall_id=0, offset=[50, 0], shape=[90, 200])
//Create a double-panel window
create_double_panel_opening(walls_room1, walls_angle_room1, walls_origin_room1, wall_id=0, offset=[160, 80], shape=[120, 100], draw_swept_volume=draw_swept_volume, left_panel_width=0.4)
//Create a door
create_panel_opening(walls_room1, walls_angle_room1, walls_origin_room1, wall_id=4, offset=[50, 0], shape=[90, 200], draw_swept_volume=draw_swept_volume)
//Create a double-panel window
create_double_panel_opening(walls_room1, walls_angle_room1, walls_origin_room1, wall_id=5, offset=[150, 80], shape=[120, 100], draw_swept_volume=draw_swept_volume, left_panel_width=70)
//Create an arch between the two rooms
create_custom_opening(walls_room1, walls_angle_room1, walls_origin_room1, wall_id=1, offset=[0, 0]){
	color("Gray") walls(walls_room1, walls_angle_room1, walls_origin_room1, default_walls_height=250);
	intersection(){
		translate([0, 125, 100]) rotate([0, 90, 0]) cylinder(h=30, d=250);
		translate([0, 50, 0]) cube([30, 150, 250]);
	}
}

//Declare the Room2 walls
walls_room2=[[250, 0, 0], [100, -90, 10], [250, -acos(4/5), 10], [100, -acos(3/5), 10], [300, -90, 10]];
//Build the data structures
walls_angle_room2 = Build_walls_angle(walls_room2);
walls_origin_room2 = Build_walls_origin(walls_room2, walls_angle_room2);
walls_end_room2 = Build_walls_end(walls_room2, walls_angle_room2, walls_origin_room2);

//Build the Room2 and place an "object" relative to one of its walls
//Move the new room and all its furnitures, place it next to room 1
translate([250, 300+10, 0]) rotate([0, 0, 90]) {
	color("Gray") walls(walls_room2, walls_angle_room2, walls_origin_room2, default_walls_height=250);

	translate_on_wall(walls_angle_room2, walls_origin_room2, wall_id=2){ //Move the object (and its translate/rotate operations to the appropriate wall
		translate([0, 50, 100]){ //Move the object/piece of furniture relative to the wall origin
			cube([10, 120, 100]);
		}
	}
	
	translate_on_wall_end(walls_angle_room2, walls_end_room2, wall_id=4){ //Move the object (and its translate/rotate operations to the appropriate wall
		translate([0, -120, 0]){ //Move the object/piece of furniture relative to the wall origin
			cube([30, 120, 200]);
		}
	}
}



//Proposed workflow
//
// Step 1 - Create the walls
//--------------------------
// Create a wall list, use the data-structures builder and the 'walls' module to place the walls.
// You can start by a single wall, and add them one by one.
//
// Sample - Step 1
//    walls=[[wall1_length, wall1_angle, wall1_thickness], [wall2... ], ...]
//    walls_angle = Build_walls_angle(walls);
//    walls_origin = Build_walls_origin(walls, walls_angle);
//    walls_end = Build_walls_end(walls, walls_angle, walls_origin);
//
//    walls(walls, walls_angle, walls_origin, default_walls_height=250);
//
// Customise the walls until you are happy.
//
// Step 2 - Place the opening
//---------------------------
// Again, one by one, add line above the 'walls' module to create the different openings
//
// Sample - Step 2
//    walls=... (and walls_angle, walls_origin, walls_end)
//
// +  create_fixed_opening(walls, walls_angle, walls_origin, <wall_id>, [<offset on wall>, <height>], [<width>, <height>])
// +  create_fixed_opening(walls, walls_angle, walls_origin, <wall_id_bis>, [<offset on wall bis>, <height bis>], [<width bis>, <height bis>])
//    walls(walls, walls_angle, walls_origin, default_walls_height=250);
//
//N.B. Please note that the "create_..._opening()" do not have a ';' at the end of the line, since they are meant to stack with the wall.
//
// Step 3 - Place the furniture
//-----------------------------
// Place the furniture in the newly created room.
//
// Sample - Step 3
//    walls=... (and walls_angle, walls_origin, walls_end)
//
//    create_fixed_opening(walls, walls_angle, walls_origin, <wall_id>, [<offset on wall>, <height>], [<width>, <height>])
//    create_fixed_opening(walls, walls_angle, walls_origin, <wall_id_bis>, [<offset on wall bis>, <height bis>], [<width bis>, <height bis>])
//    walls(walls, walls_angle, walls_origin, default_walls_height=250);
//
// +  translate_on_wall(walls_angle, walls_origin, wall_id){
// +     ... The furniture on wall 'wall_id', they can be moved around on the wall with translate operation (relative to the bottom left corner)
// +     translate([...]) rotate([...]) ...piece_of_furniture...
// +     translate([...]) rotate([...]) ...other_piece_of_furniture...
// +  }
//
// +  translate_on_wall(walls_angle, walls_origin, wall_id_bis){
// +     ... Place furniture on wall_id_bis
// +  }
//
// Step 4 - Place the room
//------------------------
// Now that the room is ready, place it relative to other rooms.
//
// Sample - Step 4
//    walls=... (and walls_angle, walls_origin, walls_end)
//
// +  translate([...]) rotate([...]) {
//      create_fixed_opening(walls, walls_angle, walls_origin, <wall_id>, [<offset on wall>, <height>], [<width>, <height>])
//      create_fixed_opening(walls, walls_angle, walls_origin, <wall_id_bis>, [<offset on wall bis>, <height bis>], [<width bis>, <height bis>])
//      walls(walls, walls_angle, walls_origin, default_walls_height=250);
//
//      translate_on_wall(walls_angle, walls_origin, wall_id){
//         ... Place furntiure on wall_id
//      }
//
//      translate_on_wall(walls_angle, walls_origin, wall_id_bis){
//         ... Place furniture on wall_id_bis
//      }
// +  }
//
// Now you can repeat the process for all the other rooms
