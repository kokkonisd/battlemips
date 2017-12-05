#include <stdio.h>
#include "battleshipsJeu.h"
#include "main.h"

void initJeu (void)
{
    // initialisation de tous les élements des deux grilles à 0
    for (int i = 0; i < (LIGS * COLS); i++) {
        grilleUser[i] = 0;
        grilleOrdi[i] = 0;
    }

    // initialisation des coupsUser & coupsOrdi à 0
    coupsUser = 0;
    coupsOrdi = 0;
    /* par convention, cela veut dire que le dernier coup ordi
    n'était pas réussi */
    dernierCoupOrdi = -1;
}