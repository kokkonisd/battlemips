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

    // allouer de la mémoire pour les grilles
    grilleUser = malloc(sizeof(int) * LIGS * COLS);
    grilleOrdi = malloc(sizeof(int) * LIGS * COLS);

    jouerBattaille();

    // libérer la mémoire des grilles
    free(grilleOrdi);
    free(grilleUser);

    return 0;
}