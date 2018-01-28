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

# variables globaux, déclarées ici temporairement
#LIGS: .word 10
#COLS: .word 10
#grilleUser: .space 400
#grilleOrdi: .space 400
#coupsUser: .word 0
#coupsOrdi: .word 0
#dernierCoupUser: .word 0
#dernierCoupOrdi: .word 0

# tableau pour les étiquettes du switch
switch_tab: .word case0, case1, case2, case3

.globl fctJouerCoupOrdi

.text

fctJouerCoupOrdi: # ARGUMENTS : -
    pro_t

    # t0 = @grilleUser
    la $t0, grilleUser
    # décalage mémoire à cause des .extern
    addi $t0, $t0, 65536
    # t1 = dernierCoupOrdi
    la $t1, dernierCoupOrdi
    # décalage mémoire à cause des .extern
    addi $t1, $t1, 65536
    lw $t1, 0($t1)
    # t2 = coupsOrdi
    la $t2, coupsOrdi
    # décalage mémoire à cause des .extern
    addi $t2, $t2, 65536
    lw $t2, 0($t2)

    # if (grilleUser[dernierCoupOrdi] == 3 || coupsOrdi == 0)
    if_exterieur:
        # t3 = 4 * dernierCoupOrdi
        ori $t3, $0, 4
        mult $t3, $t1
        mflo $t3

        # t3 = grilleUser[dernierCoupOrdi]
        add $t3, $t0, $t3
        lw $t3, 0($t3)

        # grilleUser[dernierCoupOrdi] == 3
        ori $t4, $0, 3
        beq $t3, $t4, if_exterieur_suite

        # t4 = coupsOrdi
        la $t4, coupsOrdi
        # décalage mémoire à cause des .extern
        addi $t4, $t4, 65536
        lw $t4, 0($t4)

        # coupsOrdi == 0
        beq $t4, $0, if_exterieur_suite

        j else_exterieur

    if_exterieur_suite:
        # dernier coup pas réussi
        # trouver une case pas déjà touchée

        do_while_random:
            # préparer l'appel de random()
            # a0 = min = 0
            ori $a0, $0, 0
            # a1 = max = LIGS * COLS
            la $a1, LIGS
            # décalage mémoire à cause des .extern
            addi $a1, $a1, 65536
            lw $a1, 0($a1)
            la $a2, COLS
            # décalage mémoire à cause des .extern
            addi $a2, $a2, 65536
            lw $a2, 0($a2)
            mult $a1, $a2
            mflo $a1

            jal random

            # v0 = résultat
            # t3 = v0
            or $t3, $0, $v0

            # t7 = hit
            or $t7, $0, $t3

            # t4 = 4 * t3 = 4 * hit
            ori $t4, $0, 4
            mult $t4, $t3
            mflo $t4

            # t4 = grilleUser[hit]
            add $t4, $t4, $t0
            lw $t4, 0($t4)

            # les 2 conditions du while
            # grilleUser[hit] == 2
            ori $t5, $0, 2
            beq $t4, $t5, do_while_random
            # grilleUser[hit] == 3
            ori $t5, $0, 3
            beq $t4, $t5, do_while_random

        j fin_if_exterieur

    else_exterieur:
        # dernier coup réussi
        # trouver une case pas déjà touchée, près du dernier coup

        # t1 = dernierCoupOrdi
        la $t1, dernierCoupOrdi
        # décalage mémoire à cause des .extern
        addi $t1, $t1, 65536
        lw $t1, 0($t1)

        # t3 = dernierCoupOrdi + 1
        addi $t3, $t1, 1
        # t4 = COLS
        la $t4, COLS
        # décalage mémoire à cause des .extern
        addi $t4, $t4, 65536
        lw $t4, 0($t4)
        # t3 = (dernierCoupOrdi + 1) % COLS
        div $t3, $t4
        mfhi $t3
        # if ((dernierCoupOrdi + 1) % COLS == 0)
        beq $t3, $0, if_droite


        # t3 = dernierCoupOrdi - COLS
        sub $t3, $t1, $t4
        # if ((dernierCoupOrdi - COLS) < 0)
        blt $t3, $0, if_haut


        # t3 = dernierCoupOrdi % COLS
        div $t1, $t4
        mfhi $t3
        # if ((dernierCoupOrdi % COLS) == 0)
        beq $t3, $0, if_gauche


        # t5 = LIGS
        la $t5, LIGS
        # décalage mémoire à cause des .extern
        addi $t5, $t5, 65536
        lw $t5, 0($t5)
        # t5 = COLS * LIGS
        mult $t4, $t5
        mflo $t5
        # t3 = dernierCoupOrdi + COLS
        add $t3, $t1, $t4
        # if ((dernierCoupOrdi + COLS) > COLS * LIGS)
        bgt $t3, $t5, if_bas

        # else
        j else_interieur


        if_droite:
            # la case est sur la frontière droite de la grille
            # hit = t7 = dernierCoupOrdi - 1
            subi $t7, $t1, 1
            # tirer à gauche
            j fin_if_interieur

        if_haut:
            # la case est sur la frontière haute de la grille
            # rappel: t4 = COLS
            # hit = t7 = dernierCoupOrdi + COLS
            add $t7, $t1, $t4
            # tirer en bas
            j fin_if_interieur

        if_gauche:
            # la case est sur la frontière gauche de la grille
            # hit = t7 = dernierCoupOrdi + 1
            addi $t7, $t1, 1
            # tirer à droite
            j fin_if_interieur

        if_bas:
            # la case est sur la frontière basse de la grille
            # rappel: t4 = COLS
            # hit = t7 = dernierCoupOrdi - COLS
            sub $t7, $t1, $t4
            # tirer en haut
            j fin_if_interieur

        else_interieur:
            # la case est à l'intérieur de la grille
            # choisir une direction au hasard
            # préparation pour l'appel de random()
            # a0 = min = 0, a1 = max = 3
            ori $a0, $0, 0
            ori $a1, $0, 3
            jal random
            # t6 = v0 = r = résultat du random
            or $t6, $0, $v0


            # PREPARATION POUR LE SWITCH

            # t7 = dernierCoupOrdi
            la $t7, dernierCoupOrdi
            # décalage mémoire à cause des .extern
            addi $t7, $t7, 65536
            lw $t7, 0($t7)
            # t3 = COLS
            la $t3, COLS
            # décalage mémoire à cause des .extern
            addi $t3, $t3, 65536
            lw $t3, 0($t3)

            # switch
            switch:
                sll $t6, $t6, 2
                la $t5, switch_tab
                add $t4, $t6, $t5
                lw $t4, 0($t4)
                jr $t4

            case0: # droite
                # t7 = hit = dernierCoupOrdi + 1
                addi $t7, $t7, 1
                j fin_switch

            case1: # haut
                # t7 = hit = dernierCoupOrdi - COLS
                sub $t7, $t7, $t3
                j fin_switch

            case2: # gauche
                # t7 = hit = dernierCoupOrdi - 1
                subi $t7, $t7, 1
                j fin_switch

            case3: # bas
                # t7 = hit = dernierCoupOrdi + COLS
                add $t7, $t7, $t3
                j fin_switch

            fin_switch:

            j fin_if_interieur


        fin_if_interieur:

            # verifier que la case choisie n'est pas déjà touchée

            # t6 = hit * 4
            sll $t6, $t7, 2
            # t6 = grilleUser[hit]
            add $t6, $t0, $t6
            lw $t6, 0($t6)
            # t5 = 2
            ori $t5, $0, 2
            # grilleUser[hit] == 2
            beq $t6, $t5, else_exterieur
            # t5 = 3
            ori $t5, $0, 3
            # grilleUser[hit] == 3
            beq $t6, $t5, else_exterieur



        j fin_if_exterieur


    fin_if_exterieur:

    # mettre hit dans v0
    or $v0, $0, $t7

    # t6 = @grilleUser
    la $t6, grilleUser
    # décalage mémoire à cause des .extern
    addi $t6, $t6, 65536
    # t5 = 4
    ori $t5, $0, 4
    # t7 = t7 * 4 = hit * 4
    mult $t7, $t5
    mflo $t7
    # t7 = @grilleUser + hit*4 = @grilleUser[hit]
    add $t7, $t6, $t7
    # t4 = grilleUser[hit]
    lw $t4, 0($t7)

    # if (grilleUser[hit] == 0)
    beq $t4, $0, if_tir
    # else
    j else_tir

    if_tir:
        # coup manqué
        # grilleUser[hit] = 3
        ori $t2, $0, 3
        sw $t2, 0($t7)
        j fin_if_tir

    else_tir:
        # coup réussi
        # grilleUser[hit] = 2
        ori $t2, $0, 2
        sw $t2, 0($t7)

    fin_if_tir:

    # return hit
    # hit est dans v0

    epi_t

    jr $ra
