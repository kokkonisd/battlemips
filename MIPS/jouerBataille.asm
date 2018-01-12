data

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

# variables globaux, déclarées ici temporairement
LIGS: .word 10
COLS: .word 10
grilleUser: .space 400
grilleOrdi: .space 400
coupsUser: .word 0
coupsOrdi: .word 0
dernierCoupUser: .word 0
dernierCoupOrdi: .word 0
MAX_COUPS: .word 17

# variable pour afficher le résultat du jeu
verdict: .space 7
.align 2

chaineNouvellePartie: .asciiz "Nouvelle partie, à vous de jouer !\n"

.align 2

chaineScore1: .asciiz "Joueur : "
chaineScore2: .asciiz " | Ordinateur : "
chaineScore3: .asciiz "\n"

.text

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
    ori $t0, 0($t0)
    # t1 = coupsUser
    la $t1, coupsUser
    ori $t1, 0($t1)
    # t2 = MAX_COUPS
    la $t2, MAX_COUPS
    ori $t2, 0($t2)

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

        # appel de la fonction jouerCoupUser
        jal jouerCoupUser

        # dernierCoupUser = jouerCoupUser();
        or $t3, $0, $v0

        

        j while_condition_1

    while_fin:

    epi_t

    jr $ra