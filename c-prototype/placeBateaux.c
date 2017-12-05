#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "battleshipsIO.h"
#include "main.h"

void creeTableauVertical(int temp[], int *nbDeCasesPossibles, int *grille, int taille_bateau){
	int i, j;

	for ( i = 0; i < LIGS*COLS; i++){

			if ( i >= COLS*(LIGS - (taille_bateau - 1)) )
				temp[i] = 0;

			else if (grille[i] == 0){
				temp[i] = 1;
				(*nbDeCasesPossibles)++;
			}

			if ( grille [i] == 1 ){
				for ( j = 0; j < taille_bateau; j++){
					if(i - j*COLS >= 0 && temp[i - j*COLS] == 1){
						temp[i - j*COLS] = 0;
						(*nbDeCasesPossibles)--;
					}
				}
			}
	}
}

void creeTableauHorizontal (int temp[], int *nbDeCasesPossibles, int *grille, int taille_bateau){
	int i, j;

	for ( i = 0; i < LIGS*COLS; i++){
		if ( i % COLS > COLS - taille_bateau )
			temp[i] = 0;

		else if (grille[i] == 0){
			temp[i] = 1;
			(*nbDeCasesPossibles)++;
		}

		if ( grille [i] == 1 ){
			for ( j = 0; j < taille_bateau; j++){
				if (i % COLS - j >= 0 && temp[i - j] == 1){
					temp[i - j] = 0;
					(*nbDeCasesPossibles)--;
				}
			}
		}
	}
}

//Par convention 0 est horizontal, 1 est vertical
void tableauCasesPossibles ( int orientation, int taille_bateau, int tableau_cases_libres[], int *nbDeCasesPossibles, int *grille){
	int i, j;
	int temp[LIGS*COLS];//tableau de valeures temporaires. 0 si on peut pas placer le bateau 1 si oui
	*nbDeCasesPossibles = 0;
	//Par convention on test avec la case 0 du bateau verticalement ou horizontalement
	if (orientation == 1)
		//verticalement
		creeTableauVertical (temp, nbDeCasesPossibles, grille, taille_bateau);
	else
		//horizontalement
		creeTableauHorizontal (temp, nbDeCasesPossibles, grille, taille_bateau);



	j = 0;
	//creer le tableau de cases libres
	for (i = 0; i < LIGS*COLS; i++)
	{
		if( temp[i] == 1){
			tableau_cases_libres[j] = i;
			j++;
		}
	}
	
}


void placeBateaux (int *grille){
	srand(time(NULL));	
	int orientation, taille_bateau, point0, i;//premier point du bateau
	int *tableau_cases_libres;
	//Pour éviter de dépasser le tableau
	int *nbDeCasesPossibles = malloc (sizeof(int));

	for ( taille_bateau = 5; taille_bateau > 1; taille_bateau--){

		tableau_cases_libres = malloc( sizeof(int)*COLS*LIGS );
		orientation = rand() % 2;

		tableauCasesPossibles (orientation, taille_bateau, tableau_cases_libres, nbDeCasesPossibles, grille);
		point0 = tableau_cases_libres [rand() % *nbDeCasesPossibles];

		if(orientation == 1){
			for ( i = 0; i < taille_bateau; i++){
				grille [point0 + i*COLS] = 1;
			}
		}
		else
			for ( i = 0; i < taille_bateau; i++){
				grille [point0 + i] = 1;
			}
		free( tableau_cases_libres );
	}
		tableau_cases_libres = malloc( sizeof(int)*COLS*LIGS );
		orientation = rand() % 2;

		tableauCasesPossibles (orientation, 3, tableau_cases_libres, nbDeCasesPossibles, grille);
		point0 = tableau_cases_libres [rand() % *nbDeCasesPossibles];

		if(orientation == 1){
			for ( i = 0; i < 3; i++){
				grille [point0 + i*COLS] = 1;
			}
		}
		else
			for ( i = 0; i < 3; i++){
				grille [point0 + i] = 1;
			}
		free( tableau_cases_libres );
}