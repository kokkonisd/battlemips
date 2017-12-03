#include <stdio.h>
#include "battleshipsIO.h"
#include "main.h"

/* convention sur le contenu de la case :
0 : vide
1 : bateau
2 : coup réussi
3 : coup manqué
*/
void afficherCase (int contenu)
{
    switch (contenu) {
        case 0:
            printf("[%c]", CASE_VIDE);
            break;
        case 1:
            printf("[%c]", CASE_BATEAU);
            break;
        case 2:
            printf("[%c]", CASE_REUSSI);
            break;
        case 3:
            printf("[%c]", CASE_MANQUE);
            break;
        default:
            printf("[%c]", CASE_BUG);
            break;
    }
}


void afficherJeu (char *message)
{
    printf("=======================================================================\n");
    printf("              JOUEUR               |             ORDINATEUR            \n");
    printf("              ------               |             ----------            \n");
    printf("    A  B  C  D  E  F  G  H  I  J   |      A  B  C  D  E  F  G  H  I  J \n");
    
    // compteur des lignes
    int compt = 1;

    for (int i = 0; i < (LIGS * COLS); i += LIGS) {
        // numéro de ligne User
        if (compt < 10) {
            printf("%d  ", compt);
        } else {
            printf("%d ", compt);
        }
        // grille User
        for (int j = 0; j < COLS; j++) {
            afficherCase(grilleUser[i + j]);
        }

        // barrière
        printf("  |  ");

        // numéro de ligne Ordi
        if (compt < 10) {
            printf("%d  ", compt);
        } else {
            printf("%d ", compt);
        }
        // grille Ordi
        for (int j = 0; j < COLS; j++) {
            afficherCase(grilleOrdi[i + j]);
        }

        printf("\n");
        // mettre à jour le compteur des lignes
        compt++;
    }

    printf("-----------------------------------------------------------------------\n");
    // afficher le message
    printf("%s\n", message);
    printf("=======================================================================\n");
}