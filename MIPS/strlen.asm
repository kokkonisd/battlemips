.data
.globl strlen
.text

strlen:				#on renvoi la longueur d'une chaîne de caractères passée en argument par $a0, on ignore le caractère '\0', elle doit etre asciiz
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
	ori $v0, $0, 0		#on initialise le compteur q'est aussi la valeur de retour
while_strlen:
	lb $t0, ($a0)		#$t0 = chaine[$v0] car $v0 et $a0 sont incrémentés au même temps
	beq $t0, $0, fin_while_strlen	#dans ce cas on a términé le comptage car $t0 = '\0'
	addi $v0, $v0, 1	#on incremente le compteur de 1
	addi $a0, $a0, 1	#on incremente l'adresse de 1 car le caractère est en 1 octet
	j while_strlen		#boucle
fin_while_strlen:
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
	jr $ra