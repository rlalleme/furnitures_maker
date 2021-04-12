include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_straight.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
// Dispaly book to help at visualisation
ADD_BOOKS=true;

// List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
shelves_height=[40, 36, 32, 32, 32, 32];

// Define the bookshelf width (the height is computed from the shelves height and foot height)
bookshelf_width=170;

// Define the bookshelf depth (the height is computed from the shelves height and foot height)
bookshelf_depth=37;

// Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
foot_height=5;

// Defines the wood thickness for the sides
side_thickness=2;

// Defines the wood thickness for the back
back_thickness=1.5;

// Defines the wood thickness for the shelves
shelf_thickness=2;

// Defines the first and last level for a niche, no niche if empty, 0 means bottom of bookshelf, and can be equal to the number of shelves for the niche to touch the top (e.g. [1, 3] means from the first to the third shelves (reaching the bottom of the fourth shelf)). If both values are equel, de-activates the niche.
niche=[2,6];

// Defines the horizontal distance inside the niche
niche_width=34;

// Angle for the niche, positive to tilt it to the left, negative for the right
niche_angle=20;

// Between 0 and 1 will be interprated as percentage (e.g. 0.3 = 30%) of the available space, any value above one will be interprated as a dimension
niche_position=0.1;

// Trigger the option for sliding doors on bottom level (def: false)
add_doors=true;

// Define the length that the door share: the front door, when closed will cover the back one from this distance
door_covering=3;

// Define how much the front door is recessed inside the bookshelf, the back door is considered touching the front one (no gap is considered here)
door_recess=3;

bookshelf_straight(shelves_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, niche, niche_width, niche_angle, niche_position, add_doors, door_covering, door_recess);
