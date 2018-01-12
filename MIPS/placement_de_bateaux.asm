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
#variables internes
LIGS: .word 10
COLS: .word 10

.globl placeBateaux
	.text
main:
	la $a0, grilleOrdi
	jal placeBateaux
	ori $v0, $0, 10
	syscall
#####################################################################
#####################################################################
#####################################################################	
controleDePlacement:		#on controle si le bateau peut etre placé, on retourne 1 si ou 0 si non, $a0 = pointDeDepart $a1 = orientation (0 = horizontal, 1 = vertical
				# $a2 = taille du bateau, $a3 = adresse grille
	pro_t
	lw $t0, COLS		#on importe les colonnes et lignes utiles plus tard
	lw $t1, LIGS
	ori $t2, $0, 0		#on initialise le compteur "i" des for
	beq $a1, $0, else_controleDePlacement	#on effectue des controles differents en fonction de l'orientation
	addi $t3, $a2, -1	#$t3 = dernier indice du bateau (taille bateau - 1)
	mult $t0, $t3		#on veut obtenir ainsi (taille du bateau - 1)*COLS
	mflo $t3		#maintenant $t3 = (taille du bateau - 1)*COLS
	add $t3, $t3, $a0	#maintenant $t3 = (taille du bateau - 1)*COLS + point de depart
	mult $t0, $t1		#lo = COLS*LIGS qu'est la taille de la grille
	mflo $t4		#$t4 = COLS*LIGS
	addi $t4, $t4, -1	#$t4 = COLS*LIGS - 1
	ble $t3, $t4, for_controleDePlacement1	#si COLS*LIGS - 1 >= (taille du bateau - 1)*COLS + point de depart on peut continuer, 
						#on fait ca pcq si c'est le cas on a dépassé le tableau et le placement est mauvais
	ori $v0, $0, 0		#on renvoi 0 car le placement a échoué
	epi_t
	jr $ra 
for_controleDePlacement1:	#le bateau est vertical
	beq $t2, $a2, fin_controleDePlacement	#quand le compteur est égal a la taille du tableau on peut alors renvoyer 1
	mult $t0, $t2		#on veut obtenir ainsi i*COLS
	mflo $t3		#maintenant $t3 = i*COLS
	add $t3, $t3, $a0	#maintenant $t3 = i*COLS + point de depart
	
	sll $t3, $t3, 2		#$t3 = 4*$t3 pour mettre l'indice a la taille du mot
	add $t3, $t3, $a3	#on ajoute $a3 a $t3 pour avoir l'adresse du mot voulu dans la grille
	lw $t3, ($t3)		#$t3 = grille [COLS*i + point0]
	beq $t3, $0, else_for_controleDePlacement1 	# grille [COLS*i + point0] != 0 car si c'est non null, alors un bateau est déjà placé sur la case
	ori $v0, $0, 0		#on renvoi 0 car le placement a échoué
	epi_t
	jr $ra
else_for_controleDePlacement1:	#pas de problème dans cette case donc on reboucle
	addi $t2, $t2, 1
	j for_controleDePlacement1
else_controleDePlacement:	#le bateau est horizontal
	add $t4, $a2, $a0	#$t4 = taille du bateau + point de depart
	addi $t4, $t4, -1	#$t4 = taille du bateau + point de depart - 1
	div $t4, $t0		#(taille du bateau + point de depart - 1) / COLS
	mfhi $t4		#$t4 = (taille du bateau + point de depart - 1) % COLS
	addi $t5, $a2, -1
	ble $t5, $t4, for_controleDePlacement2		#if (taille du bateau + point de depart - 1) % COLS >= taille du bateau - 1, 
							#alors on ne dépasse pas le tableau horizontalement, on peut continuer
	ori $v0, $0, 0		#on renvoi 0 car le placement a échoué
	epi_t
	jr $ra
for_controleDePlacement2:
	beq $t2, $a2, fin_controleDePlacement	#quand le compteur est égal a la taille du tableau on peut alors renvoyer 1
	add $t3, $t2, $a0	#maintenant $t3 = i + point de depart
	sll $t3, $t3, 2		#$t3 = 4*$t3 pour mettre l'indice a la taille du mot
	add $t3, $t3, $a3	#on ajoute $a3 a $t3 pour avoir l'adresse du mot voulu dans la grille
	lw $t3, ($t3)		#$t3 = grille [i + point0]
	beq $t3, $0, else_for_controleDePlacement2	#si grille [i + point0] != 0 on envoi 0 car si c'est non null, alors un bateau est déjà placé sur la case
	ori $v0, $0, 0		#on renvoi 0 car le placement a échoué
	epi_t
	jr $ra
else_for_controleDePlacement2:	#pas de problème dans cette case donc on reboucle
	addi $t2, $t2, 1
	j for_controleDePlacement2
fin_controleDePlacement:	#le bateau peut être placé, on renvoi donc 1
	ori $v0, $0, 1
	epi_t
	jr $ra
#####################################################################
#####################################################################
#####################################################################	
creeBateau:			#On met le bateau sur la grille ( les valeures se mettent à 1 du coup ) $a0 = point de départ, $a1 = orientation bateau, $a2 = taille bateau, $a3 = adresse grille
	pro_t
	ori $t0, $0, 0		#on initialise le compteur "i" du for
	ori $t1,$0, 1		#la valeur q'on veut stocker sur le tableau quand il y a une case bateau
	beqz $a1, else_creeBateau	#controle sur l'orientation, si 0 alors on va au else, si 1 on continue
	lw $t2, COLS		#on a besoin des colonnes si le bateau est placé verticalement
for_creeBateau1:
	beq $t0, $a2, fin_creeBateau	#le bateau a été crée
	mult $t2, $t0		#i*COLS
	mflo $t3		#$t3 = i*COLS
	add $t3, $t3, $a0	#$t3 = i*COLS + point de départ, ceci est lindice de la case sur la quelle on va changer la valeur à 1
	sll $t3, $t3, 2		#$t3 = 4*$t3, pour mettre la valeure en multiple de 4 octets qui est la taille de word
	add $t3, $t3, $a3	#on obteint ainsi l'adresse mémoire qu'on veut changer
	sw $t1, ($t3)		#grille[i*COLS + point de départ] = 1
	addi $t0, $t0, 1	#on implemente i
	j for_creeBateau1
else_creeBateau:
for_creeBateau0:
	beq $t0, $a2, fin_creeBateau	#le bateau a été crée
	add $t2, $t0, $a0	#$t2 = i + point de départ, ceci est lindice de la case sur la quelle on va changer la valeur à 1
	sll $t2, $t2, 2		#$t2 = 4*$t2, pour mettre la valeure en multiple de 4 octets qui est la taille de word
	add $t2, $t2, $a3	#on obteint ainsi l'adresse mémoire qu'on veut changer
	sw $t1, ($t2)		#grille[i + point de départ] = 1
	addi $t0, $t0, 1	#on implemente i
	j for_creeBateau0
fin_creeBateau:
	epi_t
	jr $ra
#####################################################################
#####################################################################
#####################################################################	
placeBateaux:			#ceci est la fonction "main" du placement de bateaux, $a0 = adresse grille
	pro_t
	ori $a2, $0, 5		#c'est la taille du bateau, on commence a 5 pour être plus rapides
	lw $t1, COLS		#$t1 = colonnes
	lw $t2, LIGS		#$t2 = lignes
	mult $t1, $t2		#COLS*LIGS
	mflo $t3		#$t3 = COLS*LIGS
	addi $t3, $t3, -1	#$t3 = COLS*LIGS - 1, c'est l'inice de la derniere case du tableau, ceci va nous servir pour revenir au début du tableau dans les test
	or $a3, $a0, $0		#on initialise d'une fois l'adresse de la grille pour éviter de le faire à chaque tour de boucle, comme on fait appel au controle de placement, on en a besoin
for_placeBateaux:
	beq $a2, 1, fin_for_placeBateaux	#le dernier bateau est long de 2 cases
	ori $a0, $0, 0
	ori $a1, $0, 98		#on peut pas avoir un bateau qui commence à 99
	jal random
	or $t0, $v0, $0
	ori $a0, $0, 0
	ori $a1, $0, 1		#on peut pas avoir un bateau qui commence à 99
	jal random
	ori $a0, $t0, 0		#$a0 = point de départ du bateau
	ori $a1, $v0, 0		#$a1 = orientation du bateau
while_for_placeBateaux:		#on va controler si le bateau peut être placé, si non augmente le point0 de 1 j'usqu'à pouvoir placer le bateau
	jal controleDePlacement
	beq $v0, 1, suite_while_for_placeBateaux	#si on a 1 alors le bateau peut être placé et on peut continuer notre fonction
	blt $a0, $t3, else_while_for_placeBateaux	#si point de départ < COLS*LIGS - 1, alors on peut implementer le point de départ, si non on le remet à 0
	ori $a0, $0, 0		#on initialise le point de départ a 0
	j while_for_placeBateaux
else_while_for_placeBateaux:
	addi $a0, $a0, 1	#on implemente le point de départ de 1 pour tester cette nouvelle position
	j while_for_placeBateaux
suite_while_for_placeBateaux:
	jal creeBateau		#comme on a fais en sorte que les variables d'entrée soient les mêmes pour les 2 fonctions, on peut appeller directement la foncion, pas besoin de $t3
	addi $a2, $a2, -1	#on décremente la taille du bateau
	j for_placeBateaux	
fin_for_placeBateaux:		#on doit refaire un bateau de 3 cases car il y en a 2, j'ai pas trouvé de moyen plus efficace que de recopier le code pour taille = 3
	ori $a2, $0, 3		#taille bateau = 3
	ori $a0, $0, 0
	ori $a1, $0, 98		#on peut pas avoir un bateau qui commence à 99
	jal random
	or $t0, $v0, $0
	ori $a0, $0, 0
	ori $a1, $0, 1		#on peut pas avoir un bateau qui commence à 99
	jal random
	ori $a0, $t0, 0		#$a0 = point de départ du bateau
	ori $a1, $v0, 0		#$a1 = orientation du bateau
while_for_placeBateaux3:		#on va controler si le bateau peut être placé, si non augmente le point0 de 1 j'usqu'à pouvoir placer le bateau
	jal controleDePlacement
	beq $v0, 1, suite_while_for_placeBateaux3	#si on a 1 alors le bateau peut être placé et on peut continuer notre fonction
	blt $a0, $t3, else_while_for_placeBateaux3	#si point de départ < COLS*LIGS - 1, alors on peut implementer le point de départ, si non on le remet à 0
	ori $a0, $0, 0		#on initialise le point de départ a 0
	j while_for_placeBateaux3
else_while_for_placeBateaux3:
	addi $a0, $a0, 1	#on implemente le point de départ de 1 pour tester cette nouvelle position
	j while_for_placeBateaux3
suite_while_for_placeBateaux3:
	jal creeBateau		#comme on a fais en sorte que les variables d'entrée soient les mêmes pour les 2 fonctions, on peut appeller directement la foncion	
	epi_t
	jr $ra