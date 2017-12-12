#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "battleshipsJeu.h"
#include "main.h"

// on test pour savoir si le bateau peut être placé et on retourne 1 si ou 0 si non
int controleDePlacement (int point0, int orientation, int taille_bateau, int tableau[])
{
    int i;
    // cas ou il est placé horizontalement
    if (orientation == 0) {
        for (i = 0; i < taille_bateau; i++){
            // (taille_bateau + point0) % COLS < taille_bateau, nous permet de savoir si on a dépassé le tableau
            if (tableau[i + point0] != 0 || (taille_bateau + point0) % COLS < taille_bateau ){
                return 0;           
            }
        }
    } else {
        for (i = 0; i < taille_bateau; i++) {
            if (tableau[i*COLS + point0] != 0 || i*COLS + point0 >= COLS*LIGS - 1){
                return 0;
            }
        }
    }

    return 1;
}


void creeBateau (int point0, int taille, int orientation, int tableau[])
{
    int i;
    // cas ou il est placé horizontalement
    if (orientation == 0)
        for (i = 0; i < taille; i++)
            tableau[point0 + i] = 1;
    // cas ou il est placé verticalement
    else
        for (i = 0; i < taille; i++)
            tableau[point0 + i*COLS] = 1;
}


void placeBateaux (int *grille)
{  
    int orientation, taille_bateau, point0; // premier point du bateau

    for (taille_bateau = 5; taille_bateau > 1; taille_bateau--) {
        orientation = rand() % 2;
        // on place aléatoirement le point de départ
        point0 = rand() % (COLS * LIGS - 1);

        // on va controler si le bateau peut être placé, si non on augmente la case de un
        while (controleDePlacement (point0, orientation, taille_bateau, grille) == 0) {
            if (point0 >= LIGS*COLS - 1)
                point0 = 0;
            else
                point0 ++;
        }
        creeBateau(point0, taille_bateau, orientation, grille);
    }
    // comme il doit y avoir 2 bateaux 3 on refait la même chose 
    orientation = rand() % 2;
    // on place aléatoirement le point de départ
    point0 = rand() % (COLS * LIGS - 1);

    // on va controler si le bateau peut être placé, si non on augmente la case de un
    while (controleDePlacement (point0, orientation, 3, grille) == 0) {
        if (point0 >= LIGS*COLS - 1)
            point0 = 0;
        else
            point0 ++;
    }

    creeBateau(point0, 3, orientation, grille);
}


void vide_input ()
{
    char c;

    c = getchar();
    while (c != '\n')
        c = getchar ();
}

void entrezEntier (char message[], int *case_coup)
{
    char coup[5];

    printf("%s\n", message);
    fgets (coup, 5, stdin);
    // on vide l'input pur eviter toute erreur
    if (coup[strlen (coup) - 1] != '\n')
        vide_input();
    // on a alors un chiffre compris entre 1 et 9
    if (strlen (coup) == 3) {
        if (coup [0] < 65 || coup [0] > 74 || coup [1] < 48 || coup [1] > 57)
            entrezEntier("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
        else
            *case_coup = (coup[1] - 49) * COLS + (coup[0] - 65); // traitement cas ou formats indésirés
    
    // on a 10 et une lettre
    } else if (strlen (coup) == 4) {
        if (coup [1] != 49 || coup [2] != 48 || coup [0] < 65 || coup [0] > 74)
            entrezEntier("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
        else 
            *case_coup = 9 * COLS + (coup[0] - 65); // traitements formats indésirés
    } else {
        entrezEntier("Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);
    }
}

int jouerCoupUser ()
{
    int *case_coup = malloc(sizeof(int));
    int doubleTir = 0;
    int retour;

    entrezEntier("Entrez la case à jouer en respectant le format xy avec A <= x <= J et 1 <= y <= 9\n", case_coup);

    do {
        // test
        if (grilleOrdi[*case_coup] == 0) {
            grilleOrdi[*case_coup] = 3; // coup manqué
            retour = *case_coup;
            doubleTir = 0;
        } else if (grilleOrdi[*case_coup] == 1) {
            grilleOrdi[*case_coup] = 2; // coup réussi
            retour = *case_coup;
            doubleTir = 0;
        } else {
            doubleTir = 1;
            entrezEntier("Vous avez tiré sur une case déjà touchée, reessayez\n", case_coup);
        }
    } while (doubleTir == 1);

    free(case_coup);

    return retour;
}

int jouerCoupOrdi (void)
{
    int r, hit;

    if (grilleUser[dernierCoupOrdi] == 3 || coupsOrdi == 0) {
        // dernier coup pas réussi
        // trouver une case pas déjà touchée
        do {
            hit = rand() % (LIGS * COLS);
        } while (grilleUser[hit] == 2 || grilleUser[hit] == 3);
    } else {
        // dernier coup réussi
        
        // trouver une case pas déjà touchée, près du dernier coup
        if ((dernierCoupOrdi + 1) % COLS == 0) {
            // la case est sur la frontière droite de la grille
            hit = dernierCoupOrdi - 1; // tirer à gauche
        } else if ((dernierCoupOrdi - COLS) < 0) {
            // la case est sur la frontière haute de la grille
            hit = dernierCoupOrdi + COLS; // tirer en bas
        } else if (dernierCoupOrdi % COLS) {
            // la case est sur la frontière gauche de la grille
            hit = dernierCoupOrdi + 1; // tirer à droite
        } else if ((dernierCoupOrdi + COLS) > COLS * LIGS) {
            // la case est sur la frontière basse de la grille
            hit = dernierCoupOrdi - COLS; // tirer en haut
        } else {
            // la case est à l'intérieur de la grille
            do {
                // choisir une direction au hasard
                r = rand() % 4; // rand() % (max - min + 1) + min

                switch (r) {
                    case 0: // droite
                        hit = dernierCoupOrdi + 1;
                        break;
                    case 1: // haut
                        hit = dernierCoupOrdi - COLS;
                        break;
                    case 2: // gauche
                        hit = dernierCoupOrdi - 1;
                        break;
                    case 3: // bas
                        hit = dernierCoupOrdi + COLS;
                        break;
                }
            } while (grilleUser[hit] == 2 || grilleUser[hit] == 3);
        }
    }

    if (grilleUser[hit] == 0) {
        // coup manqué
        grilleUser[hit] = 3;
    } else {
        // coup réussi
        grilleUser[hit] = 2;
    }

    return hit;
}

void initJeu (void)
{
    // initialisation de tous les éléments des deux grilles à 0
    for (int i = 0; i < (LIGS * COLS); i++) {
        grilleUser[i] = 0;
        grilleOrdi[i] = 0;
    }

    // initialisation des coupsUser & coupsOrdi à 0
    coupsUser = 0;
    coupsOrdi = 0;
    // initialisation des derniers coups à 0
    dernierCoupUser = 0;
    dernierCoupOrdi = 0;

    // placement des bateaux des joueurs
    placeBateaux(grilleOrdi);
    placeBateaux(grilleUser);
}

