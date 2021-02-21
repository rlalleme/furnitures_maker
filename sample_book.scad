//Global variable used to display books, helping visualise the furniture usage
ADD_BOOKS=true;
//Benefit from the openscad customiser: all the files including the sammple_book should overwrite this value to allow control from the customiser

module book(width, height, thickness){
	couleur=rands(0, 0.6, 3);
	
	translate([0, -width, 0]) color(couleur, 1) cube([thickness, width, height]);
}

//Recursive funtion that places books
module Ajouter_Livre(offset, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur){
	if(offset+min_epaisseur<largeur_etagere){
		//Ajoute un livre
		width=rands(min_largeur, max_largeur, 1)[0];
		height=rands(min_hauteur, max_hauteur, 1)[0];
		thickness=min(rands(min_epaisseur, max_epaisseur, 1)[0], largeur_etagere-offset);
		translate([offset, 0, 0]) book(width, height, thickness);
		
		//Appelle pour en ajouter un autre
		Ajouter_Livre(offset+thickness, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur);
	}
}

//Wrapper function calling the recursive one above
module Livres(largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur){
// 	//Global variable used to display books, helping visualise the furniture usage
// 	ADD_BOOKS=true;
	
	if(ADD_BOOKS==true){
		Ajouter_Livre(0, largeur_etagere, min_largeur, max_largeur, min_hauteur, max_hauteur,  min_epaisseur, max_epaisseur);
	}
}
