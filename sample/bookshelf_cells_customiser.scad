include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_cells.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
//Dispaly book to help at visualisation
ADD_BOOKS=true;

// List of shelves height, from bottom to top, (e.g. shelves_height=[30, 20, 10] defines a bookshelf with 3 shelves, of decreasing height a we go up)
shelves_height=[10, 20, 30, 40, 50];

// List of shelves width, defines the bookshelf_width
shelves_width=[10, 20, 30, 40, 50];

// Define the bookshelf depth (the height is computed from the shelves height and foot height, the width is computed from the shelves width)
bookshelf_depth=37;

// Defines the height of the foot: along the length of the cabinet, under the bottom shelf a bar help stabilise and strengthen the cabinet
foot_height=5;

// Defines the wood thickness for the sides
side_thickness=2;

// Defines the wood thickness for the back
back_thickness=1.5;

// Defines the wood thickness for the shelves
shelf_thickness=2;

// (Optional) Place a border in front of each cell (vertically and horizontally), 0 will remove the border. Borders are centered vertically, bottom aligned horizonyally.
border_height=4;

bookshelf_cells(shelves_height, shelves_width, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height);
