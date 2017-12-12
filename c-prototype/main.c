#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "main.h"
#include "battleshipsIO.h"
#include "battleshipsJeu.h"

int *grilleUser;
int *grilleOrdi;
int coupsUser;
int coupsOrdi;
int dernierCoupUser;
int dernierCoupOrdi;

int main (int argc, char *argv[])
{
    srand(time(NULL));
    char *verdict = malloc(7 * sizeof(char));

    // allouer de la mémoire pour les grilles
    grilleUser = malloc(sizeof(int) * LIGS * COLS);
    grilleOrdi = malloc(sizeof(int) * LIGS * COLS);

    // initialisation
    initJeu();

    afficherJeu();
    printf("Nouvelle partie, à vous de jouer !\n");

    dernierCoupUser = jouerCoupUser();

    afficherJeu();
    if (grilleOrdi[dernierCoupUser] == 2) {
        verdict = "réussi";
        coupsUser++;
    } else {
        verdict = "manqué";
    }
    printf("Vous avez tiré sur %s : coup %s !\n", caseToLisible(dernierCoupUser), verdict);

    dernierCoupOrdi = jouerCoupOrdi();

    afficherJeu();
    if (grilleUser[dernierCoupOrdi] == 2) {
        verdict = "réussi";
        coupsOrdi++;
    } else {
        verdict = "manqué";
    }
    printf("L'ordinateur à tiré sur %s : coup %s !\n", caseToLisible(dernierCoupOrdi), verdict);

    // libérer la mémoire des grilles
    free(grilleOrdi);
    free(grilleUser);

    return 0;
}