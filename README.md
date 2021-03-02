List of files
-------------

|----------------------|-------------------------------------------------|
| Name                 | Description                                     |
|----------------------|-------------------------------------------------|
| tools                | Set of common definitions and tools             |
| wood                 | Define a wood board (improve 'cube')            |
| sample_wood          | Sample for wood colors                          |
| sample_book          | Generate random books, for better visualisation |
| cabinet              | Define the outer 'shell' of a cabinet           |
| bookshelf_straight   | Bookshelf, straight shelves, optional doors     |
|----------------------|-------------------------------------------------|

**If you open a file in openscad, it displays some examples, showcasing the capabilities of the file.**


Functionnalities
----------------

The 'sample_book' file allows to draw book on the shelves. Thanks to its definition it should appear in the openscad customiser (from version 2019.05 and later).

If you want to have customise/create your own file and want to have the same option, you should define the following variable at the top of your main file (before any module line):
```openscad
	include <sample_book.scad>
	//... other include/use ...
	
	//In order to draw books and visualise them, inside sample_books.scad, change the variable value
	//Dispaly book to help at visualisation
	ADD_BOOKS=false;
	
	//... rest of the code ...
```
