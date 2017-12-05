#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "battleshipsIO.h"
#include "battleshipsJeu.h"
#include "coups.h"
#include "placeBateaux.h"

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
    // on affiche les grilles
    afficherJeu("Voici un message test");
    // libérer la mémoire des grilles
    placeBateaux (grilleOrdi);
    placeBateaux (grilleUser);
    afficherJeu("Voici un message test");
    coupJoueur ();
    afficherJeu("Voici un message test");
    coupJoueur ();
    afficherJeu("Voici un message test");
    free(grilleOrdi);
    free(grilleUser);

    return 0;
}