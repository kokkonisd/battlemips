#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "battleshipsIO.h"
#include "battleshipsJeu.h"

int *grilleUser;
int *grilleOrdi;
int coupsUser;
int coupsOrdi;
int dernierCoupOrdi;

int main (int argc, char *argv[])
{
    /* CONFIGURATION POUR TESTER afficherJeu */

    // allouer de la mémoire pour les grilles
    grilleUser = malloc(sizeof(int) * LIGS * COLS);
    grilleOrdi = malloc(sizeof(int) * LIGS * COLS);

    // initialisation
    initJeu();
    // on modifie les grilles pour voir ce que ça donne
    grilleOrdi[32] = 2;
    grilleUser[64] = 1;
    // on affiche les grilles
    afficherJeu("Voici un message test");

    // libérer la mémoire des grilles
    free(grilleOrdi);
    free(grilleUser);

    return 0;
}