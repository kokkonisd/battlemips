#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "battleshipsIO.h"
#include "main.h"

void vide_input (){
	char c;

	c = getchar();
	while ( c != '\n')
		c = getchar ();
}

void entrezEntier(char message[], int *case_coup){
	char coup[5];

	printf("%s\n", message);
	fgets (coup, 5, stdin);
	// on vide l'input pur eviter toute erreur
	if (coup [strlen (coup) - 1] != '\n')
		vide_input();
	//on a alors un chiffre compris entre 1 et 9
	if (strlen (coup) == 3){
		if(coup [0] < 65 || coup [0] > 74 || coup [1] < 48 || coup [1] > 57)
			entrezEntier ("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
		else
			*case_coup = (coup[1] - 49)*COLS + (coup[0] - 65);// traitement cas ou formats indésirés
	}
	//on a 10 et une lettre
	else if (strlen (coup) == 4){
		if(coup [1] != 49 || coup [2] != 48 || coup [0] < 65 || coup [0] > 74)
			entrezEntier ("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
		else 
			*case_coup = 9*COLS + (coup[0] - 65);//traitements formats indésirés
	}
	else
		entrezEntier ("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
}

void coupJoueur(){
	int *case_coup = malloc (sizeof (int));
	int doubleTir = 0;

	entrezEntier("Entrez la case à jouer en respectant le format xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);

	do {
	//test
	if ( grilleOrdi [*case_coup] == 0){
		grilleOrdi [*case_coup] = 3;
		doubleTir = 0;
	}
	else if (grilleOrdi [*case_coup] == 1){
		grilleOrdi [*case_coup] = 2;
		doubleTir = 0;
	}
	else{
		doubleTir = 1;
		entrezEntier("Vous avez tiré sur une case déjà touchée, reessayez\n", case_coup);
	}
	} while (doubleTir == 1);

}