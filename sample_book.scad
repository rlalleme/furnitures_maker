//Global variable used to display books, helping visualise the furniture usage
ADD_BOOKS=true;
//Benefit from the openscad customiser: all the files including the sammple_book should overwrite this value to allow control from the customiser

module book(width, height, thickness){
	couleur=rands(0, 0.6, 3);
	
	translate([0, -width, 0]) color(couleur, 1) cube([thickness, width, height]);
}

//Recursive funtion that places books
module add_books(offset, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur){
	if(offset+min_epaisseur<largeur_etagere){
		//Ajoute un livre
		width=rands(min_largeur, max_largeur, 1)[0];
		height=rands(min_hauteur, max_hauteur, 1)[0];
		thickness=min(rands(min_epaisseur, max_epaisseur, 1)[0], largeur_etagere-offset);
		translate([offset, 0, 0]) book(width, height, thickness);
		
		//Appelle pour en ajouter un autre
		add_books(offset+thickness, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur);
	}
}

//Wrapper function calling the recursive one above
module books(largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur){
// 	//Global variable used to display books, helping visualise the furniture usage
// 	ADD_BOOKS=true;
	
	if(ADD_BOOKS==true){
		add_books(0, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur);
	}
}
