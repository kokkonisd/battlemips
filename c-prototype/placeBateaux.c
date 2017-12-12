#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "battleshipsIO.h"
#include "main.h"

//on test pour savoir si le bateau peut être placé et on retourne 1 si ou 0 si non
int controleDePlacement (int point0, int orientation, int taille_bateau, int tableau[]){
	int i;

	//cas ou il est placé horizontalement
	if (orientation == 0 )
		for (i = 0; i < taille_bateau; i++){
			//(taille_bateau + point0) % COLS < taille_bateau, nous permet de savoir si on a dépassé le tableau
			if (tableau[i + point0] != 0 || (taille_bateau + point0) % COLS < taille_bateau ){
				return 0;			
			}
		}
	else
		for (i = 0; i < taille_bateau; i++){
		if (tableau[i*COLS + point0] != 0 || i*COLS + point0 >= COLS*LIGS - 1){
				return 0;
			}
		}

	return 1;
}


void creeBateau (int point0, int taille, int orientation, int tableau[]){
	int i;
	//cas ou il est placé horizontalement
	if (orientation == 0 )
		for (i = 0; i < taille; i++)
			tableau[point0 + i] = 1;
	//cas ou il est placé verticalement
	else
		for (i = 0; i < taille; i++)
			tableau[point0 + i*COLS] = 1;
}


void placeBateaux (int *grille){
	srand(time(NULL));	
	int orientation, taille_bateau, point0;//premier point du bateau

	for ( taille_bateau = 5; taille_bateau > 1; taille_bateau--){

		orientation = rand() % 2;
		//on place aléatoirement le point de départ
		point0 = rand() % (COLS*LIGS - 1);

		//on va controler si le bateau peut être placé, si non on augmente la case de un
		while (controleDePlacement (point0, orientation, taille_bateau, grille) == 0){
			if (point0 >= LIGS*COLS - 1)
				point0 = 0;
			else
				point0 ++;
		}
		creeBateau(point0, taille_bateau, orientation, grille);
	}
		//comme il doit y avoir 2 bateaux 3 on refait la même chose	
	orientation = rand() % 2;
		//on place aléatoirement le point de départ
	point0 = rand() % (COLS*LIGS - 1);

		//on va controler si le bateau peut être placé, si non on augmente la case de un
		while (controleDePlacement (point0, orientation, 3, grille) == 0){
			if (point0 >= LIGS*COLS - 1)
				point0 = 0;
			else
				point0 ++;
		}
		creeBateau(point0, 3, orientation, grille);
}