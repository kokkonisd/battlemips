#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "battleshipsIO.h"
#include "main.h"

/* convention sur le contenu de la case :
0 : vide
1 : bateau
2 : coup réussi
3 : coup manqué

Joueur indique le numéro du joueur dont on
affiche la grille.
Par convention,
0 : utilisateur
1 : ordi
*/
void afficherCase (int contenu, int joueur)
{
    switch (contenu) {
        case 0:
            printf("[%c]", CASE_VIDE);
            break;
        case 1:
            // si c'est l'utilisateur, afficher les bateaux
            // si c'est l'ordi, les bateux sont invisibles
            if (joueur == 0) {
                printf("[%c]", CASE_BATEAU);
            } else {
                printf("[%c]", CASE_VIDE);
            }
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


void afficherJeu (void)
{
    printf("=======================================================================\n");
    printf("              JOUEUR               |             ORDINATEUR            \n");
    printf("              ------               |             ----------            \n");
    printf("    A  B  C  D  E  F  G  H  I  J   |      A  B  C  D  E  F  G  H  I  J \n");
    
    // compteur des lignes
    int compt = 1;

    for (int i = 0; i < (LIGS * COLS); i += COLS) {
        // numéro de ligne User
        if (compt < 10) {
            printf("%d  ", compt);
        } else {
            printf("%d ", compt);
        }
        // grille User
        for (int j = 0; j < COLS; j++) {
            afficherCase(grilleUser[i + j], 0);
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
            afficherCase(grilleOrdi[i + j], 1);
        }

        printf("\n");
        // mettre à jour le compteur des lignes
        compt++;
    }

    printf("=======================================================================\n");
}

char *caseToLisible (int num_case)
{
    int ligne, colonne;
    int next = 0;
    char *resultat;

    ligne = num_case / COLS + 1;
    colonne = num_case % COLS + 1;

    resultat = malloc(5 * sizeof(char));

    switch (colonne) {
        case 1:
            resultat[next] = 'A';
            break;
        case 2:
            resultat[next] = 'B';
            break;
        case 3:
            resultat[next] = 'C';
            break;
        case 4:
            resultat[next] = 'D';
            break;
        case 5:
            resultat[next] = 'E';
            break;
        case 6:
            resultat[next] = 'F';
            break;
        case 7:
            resultat[next] = 'G';
            break;
        case 8:
            resultat[next] = 'H';
            break;
        case 9:
            resultat[next] = 'I';
            break;
        case 10:
            resultat[next] = 'J';
            break;
    }

    next++;

    switch (ligne) {
        case 1:
            resultat[next] = '1';
            break;
        case 2:
            resultat[next] = '2';
            break;
        case 3:
            resultat[next] = '3';
            break;
        case 4:
            resultat[next] = '4';
            break;
        case 5:
            resultat[next] = '5';
            break;
        case 6:
            resultat[next] = '6';
            break;
        case 7:
            resultat[next] = '7';
            break;
        case 8:
            resultat[next] = '8';
            break;
        case 9:
            resultat[next] = '9';
            break;
        case 10:
            resultat[next] = '1';
            next++;
            resultat[next] = '0';
            break;
    }

    next++;

    resultat[next] = '\0';

    return resultat;
}