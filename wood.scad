include <tools.scad>

//Draw a board and displays its dimensions
module board(length, width, thickness, quiet=true){
	cube([length, width, thickness]);
	
	if(!quiet){
		echo(str("Board: ",length,"x",width,"x",thickness," ",unit));
	}
}

board(10, 10, 1, false);
