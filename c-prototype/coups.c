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
		if(coup [0] < 48 || coup [0] > 57 || coup [1] < 65 || coup [1] > 74)
			entrezEntier ("Erreur dans le format, respectez ab avec 1 <= a <= 9 et A <= b <= J\n", case_coup);
		else
			*case_coup = (coup[0] - 49)*COLS + (coup[1] - 65);// traitement cas ou formats indésirés
	}
	//on a 10 et une lettre
	else if (strlen (coup) == 4){
		if(coup [0] != 49 || coup [1] != 48 || coup [2] < 65 || coup [2] > 74)
			entrezEntier ("Erreur dans le format, respectez ab avec 1 <= a <= 9 et A <= b <= J\n", case_coup);
		else 
			*case_coup = 9*COLS + (coup[2] - 65);//traitements formats indésirés
	}
	else
		entrezEntier ("Erreur dans le format, respectez ab avec 1 <= a <= 9 et A <= b <= J\n", case_coup);
}

void coupJoueur(){
	int *case_coup = malloc (sizeof (int));

	entrezEntier("Entrez la case à jouer en respectant le format ab avec 1 <= a <= 9 et A <= b <= J\n", case_coup);

	//test
	grilleUser[*case_coup] = 3;
}