include <tools.scad>

//Draw a board and displays its dimensions
module board(length, width, thickness, quiet=true, name=""){
	cube([length, width, thickness]);
	
	if(!quiet){
		board=(name!="")?str("Board - ",name,":"):"Board:";
		echo(str(board,length,"x",width,"x",thickness," ",unit));
	}
}

board(10, 10, 1, false);

translate([15, 0, 0]) board(10, 10, 1, false, "left side");
