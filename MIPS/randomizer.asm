.data
.globl random
.text

random: # ARGUMENTS : a0 = min, a1 = max
	
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

	# arguments: a0 = min, a1 = max
	or $t0, $0, $a0
	or $t1, $0, $a1

	# stocker le temps dans a0
	ori $v0, $0, 30
	syscall
	
	# mettre le temps acquis dans a1
	# mettre 0 dans a0 (l'ID du générateur random)
	or $a1, $0, $a0
	ori $a0, $0, 0
	
	# générer un nombre aléatoire et le stocker dans a0
	ori $v0, $0, 41
	syscall
	
	# appliquer la formule : rand() % (max - min + 1) + min
	sub $t2, $t1, $t0 # t2 = max - min
	addi $t2, $t2, 1 # t2++
	divu $a0, $t2
	mfhi $t2 # t2 = rand() % (max - min + 1)
	add $t2, $t2, $t0 # t2 += min
	
	# mettre le résultat dans v0
	or $v0, $0, $t2
	
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
