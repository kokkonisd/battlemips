#include <stdio.h>
#include "battleshipsJeu.h"
#include "main.h"

void initJeu (void)
{
    // initialisation de tous les élements des deux grilles à 0
    for (int i = 0; i < (LIGS * COLS); i += LIGS) {
        for (int j = 0; j < COLS; j++) {
            grilleUser[i + j] = 0;
            grilleOrdi[i + j] = 0;
        }
    }

    // initialisation des coupsUser & coupsOrdi à 0
    coupsUser = 0;
    coupsOrdi = 0;
    /* par convention, cela veut dire que le dernier coup ordi
    n'était pas réussi */
    dernierCoupOrdi = -1;
}