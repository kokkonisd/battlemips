.data

# macros
# macro pour le prologue (avec sauvegarde des variables t)
.macro pro_t
addiu $sp, $sp -40 #PRO on ajuste $sp
sw $ra, 0($sp)     #PRO on sauvegarde $ra
sw $fp, 4($sp)     #PRO on sauvegarde $fp
sw $t0, 8($sp)     #PRO on sauvegarde t0
sw $t1, 12($sp)    #PRO on sauvegarde t1
sw $t2, 16($sp)    #PRO on sauvegarde t2
sw $t3, 20($sp)    #PRO on sauvegarde t3
sw $t4, 24($sp)    #PRO on sauvegarde t4
sw $t5, 28($sp)    #PRO on sauvegarde t5
sw $t6, 32($sp)    #PRO on sauvegarde t6
sw $t7, 36($sp)    #PRO on sauvegarde t7
addiu $fp, $sp, 40 #PRO on ajuste $fp
.end_macro
# macro pour l'epilogue (avec chargement des variables t)
.macro epi_t
lw $ra, 0($sp)     #EPI on charge $ra
lw $fp, 4($sp)     #EPI on charge $fp
lw $t0, 8($sp)     #EPI on charge t0
lw $t1, 12($sp)    #EPI on charge t1
lw $t2, 16($sp)    #EPI on charge t2
lw $t3, 20($sp)    #EPI on charge t3
lw $t4, 24($sp)    #EPI on charge t4
lw $t5, 28($sp)    #EPI on charge t5
lw $t6, 32($sp)    #EPI on charge t6
lw $t7, 36($sp)    #EPI on charge t7
addiu $sp, $sp, 40 #EPI on ajuste $sp
.end_macro

# variables globaux
LIGS: .word 10
COLS: .word 10
MAX_COUPS: .word 17
grilleUser: .space 400
grilleOrdi: .space 400
coupsUser: .word 0
coupsOrdi: .word 0
dernierCoupUser: .word 0
dernierCoupOrdi: .word 0

.extern LIGS 4
.extern COLS 4
.extern MAX_COUPS 4
.extern grilleUser 400
.extern grilleOrdi 400
.extern coupsUser 4
.extern coupsOrdi 4
.extern dernierCoupUser 4
.extern dernierCoupOrdi 4

# variables pour l'affichage
chaineNouvellePartie: .asciiz "Nouvelle partie, à vous de jouer !\n"

.align 2

chaineScore1: .asciiz "Joueur : "
chaineScore2: .asciiz " | Ordinateur : "
chaineScore3: .asciiz "\n"

.align 2

chaineReussi: .asciiz "réussi"
chaineManque: .asciiz "manqué"

.align 2

chaineAffichageResultat1_user: .asciiz "Vous avez tiré sur "
chaineAffichageResultat1_ordi: .asciiz "L'ordinateur à tiré sur "
chaineAffichageResultat2: .asciiz " : coup "
chaineAffichageResultat3: .asciiz " !\n"

.align 2

chaineOrdiGagne: .asciiz "L'ordinateur a gagné !\n"
chaineUserGagne: .asciiz "Le joueur a gagné !\n"

.text
 
j main

fctJouerBataille:
    pro_t

    jal fctInitJeu

    jal fctAfficherJeu

    # afficher la chaine Nouvelle Partie
    la $a0, chaineNouvellePartie
    ori $v0, $0, 4
    syscall

    # t0 = coupsOrdi
    la $t0, coupsOrdi
    lw $t0, 0($t0)
    # t1 = coupsUser
    la $t1, coupsUser
    lw $t1, 0($t1)
    # t2 = MAX_COUPS
    la $t2, MAX_COUPS
    lw $t2, 0($t2)

    while_condition_1:
    # coupsOrdi < MAX_COUPS
    blt $t0, $t2, while_condition_2
    j while_fin

    while_condition_2:
    # coupsUser < MAX_COUPS
    blt $t1, $t2, while_loop
    j while_fin

    while_loop:
        # affichage:
        # printf("Joueur : %d | Ordinateur : %d\n", coupsUser, coupsOrdi)
        la $a0, chaineScore1
        ori $v0, $0, 4
        syscall

        or $a0, $0, $t1
        ori $v0, $0, 1
        syscall

        la $a0, chaineScore2
        ori $v0, $0, 4
        syscall

        or $a0, $0, $t0
        ori $v0, $0, 1
        syscall

        la $a0, chaineScore3
        ori $v0, $0, 4
        syscall


        # -- DEBUT PARTIE UTILISATEUR --

        # appel de la fonction jouerCoupUser
        jal jouerCoupUser

        # t3 = dernierCoupUser = jouerCoupUser();
        or $t3, $0, $v0


        # afficherJeu()
        jal fctAfficherJeu

        if_interieur_1:
            # t4 = @grilleOrdi
            la $t4, grilleOrdi

            # t5 = 4
            ori $t5, $0, 4
            # t5 = 4 * dernierCoupUser = 4 * t3
            mult $t3, $t5
            mflo $t5
            # t4 = grilleOrdi[dernierCoupUser]
            add $t4, $t4, $t5
            lw $t4, 0($t4)

            # t5 = 2
            ori $t5, $0, 2
            # branchement si la condition du if est fausse
            # if (grilleOrdi[dernierCoupUser] == 2)
            bne $t4, $t5, else_interieur_1

            # t6 = @verdict = @"réussi"
            la $t6, chaineReussi

            # rappel: t1 = coupsUser
            # coupsUser++
            addi $t1, $t1, 1
            # enregistrer la nouvelle valeur de coupsUser
            la $a0, coupsUser
            sw $t1, 0($a0)

            j if_interieur_1_fin

        else_interieur_1:
            # t6 = @verdict = @"manqué"
            la $t6, chaineManque

        if_interieur_1_fin:
        # afficher le résultat
        # printf("Vous avez tiré sur %s : coup %s !\n", caseLisible(dernierCoupUser), verdict);
        la $a0, chaineAffichageResultat1_user
        ori $v0, $0, 4
        syscall

        # appel de fctCaseLisible
        or $a0, $0, $t3
        jal fctCaseLisible

        # afficher le résultat de fctCaseLisible
        or $a0, $0, $v0
        ori $v0, $0, 4
        syscall

        la $a0, chaineAffichageResultat2
        syscall

        # afficher le verdict
        or $a0, $0, $t6
        syscall

        la $a0, chaineAffichageResultat3
        syscall

        # -- FIN PARTIE UTILISATEUR --


        # -- DEBUT PARTIE ORDINATEUR --

        # appel de la fonction jouerCoupOrdi
        jal fctJouerCoupOrdi

        # t3 = dernierCoupOrdi = jouerCoupOrdi();
        or $t3, $0, $v0

        # afficherJeu()
        jal fctAfficherJeu

        if_interieur_2:
            # t4 = @grilleUser
            la $t4, grilleUser

            # t5 = 4
            ori $t5, $0, 4
            # t5 = 4 * dernierCoupOrdi = 4 * t3
            mult $t3, $t5
            mflo $t5
            # t4 = grilleUser[dernierCoupOrdi]
            add $t4, $t4, $t5
            lw $t4, 0($t4)

            # t5 = 2
            ori $t5, $0, 2
            # branchement si la condition du if est fausse
            # if (grilleUser[dernierCoupOrdi] == 2)
            bne $t4, $t5, else_interieur_1

            # t6 = @verdict = @"réussi"
            la $t6, chaineReussi

            # rappel: t1 = coupsOrdi
            # coupsOrdi++
            addi $t1, $t1, 1
            # enregistrer la nouvelle valeur de coupsOrdi
            la $a0, coupsOrdi
            sw $t1, 0($a0)

            j if_interieur_2_fin

        else_interieur_2:
            # t6 = @verdict = @"manqué"
            la $t6, chaineManque

        if_interieur_2_fin:
        # afficher le résultat
        # printf("L'ordinateur à tiré sur %s : coup %s !\n", caseLisible(dernierCoupOrdi), verdict);
        la $a0, chaineAffichageResultat1_ordi
        ori $v0, $0, 4
        syscall

        # appel de fctCaseLisible
        or $a0, $0, $t3
        jal fctCaseLisible

        # afficher le résultat de fctCaseLisible
        or $v0, $0, $a0
        ori $v0, $0, 4
        syscall

        la $a0, chaineAffichageResultat2
        syscall

        # afficher le verdict
        or $a0, $0, $t6
        syscall

        la $a0, chaineAffichageResultat3
        syscall
        # -- FIN PARTIE ORDINATEUR --

        j while_condition_1

    while_fin:

    # t0 = coupsOrdi
    la $t0, coupsOrdi
    lw $t0, 0($t0)
    # t1 = MAX_COUPS
    la $t1, MAX_COUPS
    lw $t1, 0($t1)

    if_exterieur:
        # if (coupsOrdi == MAX_COUPS)
        # si la condition n'est pas vraie, branchement vers le else
        bne $t0, $t1, else_exterieur

        # l'ordi a gagné
        la $a0, chaineOrdiGagne
        ori $v0, $0, 4
        syscall

        j if_exterieur_fin

    else_exterieur:
        # l'utilisateur a gagné
        la $a0, chaineUserGagne
        ori $v0, $0, 4
        syscall

    if_exterieur_fin:

    epi_t

    jr $ra



main:
    # lancer le jeu
    jal fctJouerBataille

    # quitter le programme
    ori $v0, $0, 10
    syscall
