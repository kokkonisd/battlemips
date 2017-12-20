.data
switch_tab: .word CASE0, CASE1, CASE2, CASE3, DEFAULT
case_vide: .asciiz "[ ]"
case_bateau: .asciiz "[B]"
case_manque: .asciiz "[o]"
case_reussie: .asciiz "[x]"
case_bug: .asciiz "[?]"
.text
j main		 

fctAfficherCase: # a0=contenu, a1=joueur
	addiu $sp, $sp -8	#PRO on ajuste $sp
	sw $ra, 0($sp)		#PRO sauvegarde $ra
	sw $fp, 4($sp)		#PRO sauvegarde $fp
	addiu $fp, $sp, 8	#PRO on ajuste $fp
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
		jr $ra
		

main:
	ori $a0, $0, 10
	jal fctAfficherCase
	ori $v0, $0, 10
	syscall