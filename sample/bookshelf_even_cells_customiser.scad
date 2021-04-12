include <../tools.scad>
use <../sample_wood.scad>
include <../sample_book.scad>
use <../cabinet.scad>
use <../bookshelf_cells.scad>

//In order to draw books and visualise them, inside sample_books.scad, change the variable value
//Dispaly book to help at visualisation
ADD_BOOKS=true;

// Number of shelves (lowest level included)
number_shelves=5;

// Number of inner-wall to place
number_inner_walls=5;

// Define the bookshelf width
bookshelf_width=150;

// Define the bookshelf height
bookshelf_height=200;

// Define the bookshelf depth
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

bookshelf_even_cells(number_shelves, number_inner_walls, bookshelf_width, bookshelf_height, bookshelf_depth, foot_height, side_thickness, back_thickness, shelf_thickness, border_height);
