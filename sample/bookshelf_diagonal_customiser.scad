include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_diagonal.scad>

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

// Defines the horizontal distance inside the diagonal
diagonal_width=50;

// Angle for the diagonal, positive to tilt it to the left, negative for the right
diagonal_angle=20;

// Between 0 and 1 will be interprated as percentage (e.g. 0.3 = 30%) of the available space, any value above one will be interprated as a dimension (from left side)
diagonal_position=0.5;

bookshelf_diagonal(shelves_height, bookshelf_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, diagonal_width, diagonal_angle, diagonal_position);
