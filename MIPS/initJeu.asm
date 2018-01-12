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

# la fonction est globale
.globl fctInitJeu

.text

fctInitJeu:
	# prologue
	pro_t
	
	# initialisation de l'indexe (i = t0)
	ori $t0, $0, 0
	
	# charger LIGS dans t1, COLS dans t2
	la $t1, LIGS
	lw $t1, 0($t1)
	la $t2, COLS
	lw $t2, 0($t2)
	
	# stocket LIGS * COLS dans t1
	mult $t1, $t2
	mflo $t1
	
	for_initialisation:
		# for loop
		# mettre i * 4 dans t3
		ori $t3, $0, 4
		mult $t3, $t0
		mflo $t3
		
		# initialiser t4 à 0 pour le stocker dans les grilles
		ori $t4, $0, 0
		# charger l'addresse de grilleUser
		la $t5, grilleUser
		# t5 = @grilleUser + 4 * i = grilleUser[i]
		add $t5, $t5, $t3
		# grilleUser[i] = 0
		sw $t4, 0($t5)
		
		# charger l'addresse de grilleOrdi
		la $t5, grilleOrdi
		# t5 = @grilleOrdi + 4 * i = grilleOrdi[i]
		add $t5, $t5, $t3
		# grilleOrdi[i] = 0
		sw $t4, 0($t5)
		
		# i++
		addi $t0, $t0, 1
		
		# condition i < LIGS * COLS 
		blt $t0, $t1, for_initialisation
	fin_for_initialisation:

	# inialisation des variables globaux
	ori $t0, $0, 0
	la $t1, coupsUser
	sw $t0, 0($t1)

	la $t1, coupsOrdi
	sw $t0, 0($t1)

	la $t1, dernierCoupUser
	sw $t0, 0($t1)

	la $t1, dernierCoupOrdi
	sw $t0, 0($t1)

	# appel des fonctions placeBateaux
	la $a0, grilleUser
	jal placeBateaux
	la $a0, grilleOrdi
	jal placeBateaux
	
	# epilogue
	epi_t
	
	jr $ra
