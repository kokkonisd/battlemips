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
LIGS: .word 10
COLS: .word 10
grilleUser: .space 400
grilleOrdi: .space 400

# chaine pour afficher le numéro de la case
resultat: .space 4 
.extern resultat 4

.align 2

# tableaux pour les deux switchs
switch_tab1: .word FLAG_A, FLAG_B, FLAG_C, FLAG_D, FLAG_E, FLAG_F, FLAG_G, FLAG_H, FLAG_I, FLAG_J
switch_tab2: .word FLAG_1, FLAG_2, FLAG_3, FLAG_4, FLAG_5, FLAG_6, FLAG_7, FLAG_8, FLAG_9, FLAG_10
.text

j main

fctCaseLisible: # ARGUMENTS: $a0 = numéro de la case (entre 0 et 100 inclus)
    pro_t
    
    # initialisation des variables
    
    # t0 = ligne, t1 = colonne
    # d'abord on charge COLS dans t0
    la $t0, COLS
    lw $t0, 0($t0)
    
    # puis on fait ligne = numéro_case / COLS
    div $a0, $t0
    mflo $t0
    # et colonne = numéro_case % COLS
    mfhi $t1
    
    # traitement du fin de la chaine resultat
    la $t6, resultat
    ori $t7, $0, '\0'
    # les deux derniers caractères de resultat sont '\0'
    sb $t7, 2($t6)
    sb $t7, 3($t6)
    
    switch_colonne: 
        sll $t1, $t1, 2
        la $t3, switch_tab1
        add $t4, $t1, $t3
        lw $t4, 0($t4)
        jr $t4
        
    FLAG_A: 
        ori $t7, $0, 'A'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_B: 
        ori $t7, $0, 'B'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_C: 
        ori $t7, $0, 'C'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_D: 
        ori $t7, $0, 'D'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_E: 
        ori $t7, $0, 'E'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_F: 
        ori $t7, $0, 'F'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_G: 
        ori $t7, $0, 'G'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_H: 
        ori $t7, $0, 'H'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_I: 
        ori $t7, $0, 'I'
        sb $t7, 0($t6)
        j switchColonne_suite
    FLAG_J: 
        ori $t7, $0, 'J'
        sb $t7, 0($t6)
        j switchColonne_suite
    switchColonne_suite:
    
    switch_ligne: 
        sll $t0, $t0, 2
        la $t3, switch_tab2
        add $t4, $t0, $t3
        lw $t4, 0($t4)
        jr $t4
        
    FLAG_1: 
        ori $t7, $0, '1'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_2: 
        ori $t7, $0, '2'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_3: 
        ori $t7, $0, '3'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_4: 
        ori $t7, $0, '4'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_5: 
        ori $t7, $0, '5'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_6: 
        ori $t7, $0, '6'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_7: 
        ori $t7, $0, '7'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_8: 
        ori $t7, $0, '8'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_9: 
        ori $t7, $0, '9'
        sb $t7, 1($t6)
        j switchLigne_suite
    FLAG_10: 
        ori $t7, $0, '1'
        sb $t7, 1($t6)
        ori $t7, $0, '0'
        sb $t7, 2($t6)
        j switchLigne_suite
    switchLigne_suite:
    
    # mettre l'addresse de résultat dans v0
    or $v0, $0, $t6
    
    epi_t
    
    jr $ra
    
main:
    ori $a0, $0, 99
    jal fctCaseLisible
    or $a0, $0, $v0
    ori $v0, $0, 4
    syscall
    
    ori $v0, $0, 10
    syscall