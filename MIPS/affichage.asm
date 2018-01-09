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

# variables pour fctAfficherCase
switch_tab: .word CASE0, CASE1, CASE2, CASE3, DEFAULT
case_vide: .asciiz "[ ]"
case_bateau: .asciiz "[B]"
case_manque: .asciiz "[o]"
case_reussie: .asciiz "[x]"
case_bug: .asciiz "[?]"

# variables pour fctAfficherJeu
chaineAffichage1: .asciiz "=======================================================================\n"
chaineAffichage2: .asciiz "              JOUEUR               |             ORDINATEUR            \n"
chaineAffichage3: .asciiz "              ------               |             ----------            \n"
chaineAffichage4: .asciiz "    A  B  C  D  E  F  G  H  I  J   |      A  B  C  D  E  F  G  H  I  J \n"
chaineBarriere: .asciiz "  |  "

.text
j main		 

fctAfficherCase: # ARGUMENTS : a0=contenu, a1=joueur
	pro_t
	
	ori $v0, $0, 4
	ori $t0, $0, 3
	bgt $a0, $t0, DEFAULT
	or $t0, $0, $a0
	switch: sll $t0, $t0, 2
		la $t1, switch_tab
		add $t2, $t0, $t1
		lw $t2, 0($t2)
		jr $t2
	CASE0:	la $a0, case_vide
		syscall
		j switch_suite
	CASE1:
		bnez $a1, ELSE_CASE1
		la $a0, case_bateau
		syscall
		j switch_suite
	ELSE_CASE1:
		la $a0, case_vide
		syscall
		j switch_suite
	CASE2:
		la $a0, case_reussie
		syscall
		j switch_suite
	CASE3:
		la $a0, case_manque
		syscall
		j switch_suite
	DEFAULT:
		la $a0, case_bug
		syscall
		j switch_suite
	switch_suite:
		epi_t
	
		jr $ra
		
		
fctAfficherJeu: # ARGUMENTS : -
	pro_t
	
	# afficher l'entête des grilles
	la $a0, chaineAffichage1
	ori $v0, $0, 4
	syscall
	la $a0, chaineAffichage2
	syscall
	la $a0, chaineAffichage3
	syscall
	la $a0, chaineAffichage4
	syscall
	
	# compteur
	ori $t0, $0, 1
	# indexe 1 (i)
	ori $t1, $0, 0
	# variable-comparateur
	ori $t2, $0, 10
	# variable-fin-de-boucle (t3)
	la $t3, LIGS
	la $t4, COLS
	lw $t3, 0($t3)
	lw $t4, 0($t4)
	mult $t3, $t4
	mflo $t3
	
	# for extérieur
	for_affichage_exterieur:
		# afficher le numéro joueur
		or $a0, $0, $t0
		ori $v0, $0, 1
		syscall
		# afficher le(s) espace(s)
		ori $v0, $0, 11
		ori $a0, $0, ' '
		syscall
		# si il nous faut un seul caractère espace,
		# on saute le deuxième syscall
		bge $t0, $t2, affichage_normal1
		syscall
		affichage_normal1: # sans deuxième ' '
		
		# for intérieur 1
		# indexe 2 (j)
		ori $t4, $0, 0
		# condition fin de boucle
		la $t5, COLS
		lw $t5, 0($t5)
		for_affichage_interieur1:
			# préparation pour l'appel de fctAfficherCase
			la $a0, grilleUser
			# ajouter i * 4 à l'addresse
			ori $t6, $0, 4
			mult $t6, $t1
			mflo $t6
			add $a0, $a0, $t6
			# ajouter j * 4 à l'addresse
			ori $t6, $0, 4
			mult $t6, $t4
			mflo $t6
			add $a0, $a0, $t6
			
			# charger la case
			lw $a0, 0($a0)
			ori $a1, $0, 0
			
			jal fctAfficherCase
			
			# fin de la boucle, màj
			# t4++ (j++)
			addi $t4, $t4, 1
			# condition de la boucle
			blt $t4, $t5, for_affichage_interieur1
			
		
		# afficher la barrière
		la $a0, chaineBarriere
		ori $v0, $0, 4
		syscall
		
		# afficher le numéro ordinateur
		or $a0, $0, $t0
		ori $v0, $0, 1
		syscall
		# afficher le(s) espace(s)
		ori $v0, $0, 11
		ori $a0, $0, ' '
		syscall
		# si il nous faut un seul caractère espace,
		# on saute le deuxième syscall
		bge $t0, $t2, affichage_normal2
		syscall
		affichage_normal2: # sans deuxième ' '

		# for intérieur 2
		# indexe 2 (j)
		ori $t4, $0, 0
		# condition fin de boucle
		la $t5, COLS
		lw $t5, 0($t5)
		for_affichage_interieur2:
    		# préparation pour l'appel de fctAfficherCase
    		la $a0, grilleOrdi
    		# ajouter i * 4 à l'addresse
    		ori $t6, $0, 4
    		mult $t6, $t1
    		mflo $t6
    		add $a0, $a0, $t6
    		# ajouter j * 4 à l'addresse
    		ori $t6, $0, 4
    		mult $t6, $t4
    		mflo $t6
    		add $a0, $a0, $t6
    
    		# charger la case
    		lw $a0, 0($a0)
    		ori $a1, $0, 0
    
    		jal fctAfficherCase
    
    		# fin de la boucle, màj
    		# t4++ (j++)
    		addi $t4, $t4, 1
    		# condition de la boucle
    		blt $t4, $t5, for_affichage_interieur2
		
		
		# fin de la boucle, màj
		ori $a0, $0, '\n'
		ori $v0, $0, 11
		syscall
		# t0++ (compteur++)
		addi $t0, $t0, 1
		# t1 += COLS (i += COLS)
		la $t4, COLS
		lw $t4, 0($t4)
		add $t1, $t1, $t4
		
		# condition de la boucle
		blt $t1, $t3, for_affichage_exterieur
		
		
	# afficher le délimiteur encore une fois (====)
	la $a0, chaineAffichage1
	ori $v0, $0, 4
	syscall
	
	epi_t
	
	jr $ra
		

main:
	jal fctAfficherJeu
	ori $v0, $0, 10
	syscall
