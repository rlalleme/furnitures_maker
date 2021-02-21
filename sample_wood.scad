include <tools.scad>
use <wood.scad>

module board_darkWood(length, width, thickness, name=""){
	color("SaddleBrown") board(length, width, thickness);
	
	board=(name!="")?str("Board - ",name):"Board";
	echo(str(board,", dark wood: ",length,"x",width,"x",thickness," ",unit));
}

board_darkWood(10, 10, 1);

module board_greyWood(length, width, thickness, name=""){
	color("OldLace") board(length, width, thickness);
	
	board=(name!="")?str("Board - ",name):"Board";
	echo(str(board,", grey wood: ",length,"x",width,"x",thickness," ",unit));
}

translate([15, 0, 0]) board_greyWood(10, 10, 1);

module board_lightWood(length, width, thickness, name=""){
	color("BlanchedAlmond") board(length, width, thickness);
	
	board=(name!="")?str("Board - ",name):"Board";
	echo(str(board,", light wood: ",length,"x",width,"x",thickness," ",unit));
}

translate([30, 0, 0]) board_lightWood(10, 10, 1, "sample 3");
