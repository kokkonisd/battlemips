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
#variables externes
#.extern grilleUser 400
#.extern grilleOrdi 400
#variables internes
#LIGS: .word 10
#COLS: .word 10
MSGERRF:	.asciiz "Erreur dans le format, respectez xy avec A <= x <= J et 1 <= y <= 10"
MSGENTC:	.asciiz "Entrez la case à jouer en respectant le format xy avec A <= x <= J et 1 <= y <= 10"
MSGTOUCHE:	.asciiz "Vous avez tiré sur une case déjà touchée, reessayez"
CASEUSR:	.asciiz "    "

.globl joueCoupUser
	.text
###############################################################################################################
###############################################################################################################
###############################################################################################################
entrezCoup:			#Elle renvoi un message en fonction de la ligne tappé par l'utilisateur désignant la case jouée $a0 = adresse message, elle renvoi l'adresse de la case en int
	pro_t
fausseRec_entrezCoup:		#ceci nous évite de faire une vraie reccurence et agrandir la pile en cas d'erreur, $a0 = adresse nouveau message
	ori $t1, $a0, 0		#on stock le $a0 temporairement pour pouvoir l'utiliser
	ori $a0, $0, 10		#on veut faire un saut à la ligne pour des questions esthetiques
	ori $v0, $0, 11		#code système pour imprimer un char
	syscall
	ori $a0, $t1, 0		#on reprend notre $a0 de départ
	ori $v0, $0, 4		#On veut imprimer le message entré
	syscall
	ori $a0, $0, 10		#on veut faire un saut à la ligne
	ori $v0, $0, 11		#code système pour imprimer un char
	syscall
	la $a0, CASEUSR		#on veut stocker la case jouée a cette adresse (case user)
	ori $a1, $0, 4		#la longueur doit etre de 3 pour considerer le cas ou on a X10, sur mips il faut $a1 = longueur + 1
	ori $v0, $0, 8		#on va lire la case jouée
	syscall			#pas besoin de vider l'input sur le buffer de mars
	lb $t0, 2($a0)		#on veut voir le dernier caractère de la chaîne pour savoir si c'est un nombre à 2 chiffres ou un nombre a 1
	beq $t0, 10, if_entrezCoup2	#si $t0 = '\n' alors 2 caractères
	beq $t0, 48, if_entrezCoup3	#si $t0 = '0' alors on a 3 caractères, si non on a pas un 10 à la fin ce qu'est interdit, erreur
	la $a0, MSGERRF		#on veut afficher un message d'erreur dans le format
	j fausseRec_entrezCoup	#on refait la fonction sans empiler
if_entrezCoup2:
	lb $t0, ($a0)		#on veut effectuer des test de format sur le premier caractère
	blt $t0, 65, erreur_if_entrezCoup2	#si message[0] < 65 alors il n'est pas compris entre A et J, erreur
	ori $t1, $0, 74		#besoin pour le test suivant car pas de bht 
	blt $t1, $t0, erreur_if_entrezCoup2	#si 74 < message[0] alors il n'est pas compris entre A et V, erreur
	lb $t2 1($a0)		#on veut maintenant controler le chiffre
	blt $t2, 49, erreur_if_entrezCoup2	#si message[1] < 49 alors il n'est pas compris entre 1 et 9, erreur
	ori $t1, $0, 57		#besoin pour le test suivant car pas de bht 
	blt $t1, $t2, erreur_if_entrezCoup2	#si 57 < message[1] alors il n'est pas compris entre 1 et 9, erreur
	addi $v0, $t2, -49	#v0 = (int) message[1]
	lw $t3, COLS 		#on en a besoin pour les lignes
	mult $v0, $t3		#on fait message[1]*COLS pour obtenir la case correspondante à la ligne
	mflo $v0		#$v0 = ((int) message[1])*COLS
	add $v0, $v0, $t0	#$v0 = ((int) message[i])*COLS + message[0]
	addi $v0, $v0, -65	#$v0 = ((int) message[i])*COLS + message[0] - 65, ceci permet d'associer donc A à la case 0 et J à la case 9 horizontalement
	epi_t
	jr $ra
erreur_if_entrezCoup2:
	la $a0, MSGERRF		#erreur de format, on recommence
	j fausseRec_entrezCoup
if_entrezCoup3:
	lb $t0, ($a0)		#on veut effectuer des test de format sur le premier caractère
	blt $t0, 65, erreur_if_entrezCoup3	#si message[0] < 65 alors il n'est pas compris entre A et J, erreur
	ori $t1, $0, 74		#besoin pour le test suivant car pas de bht 
	blt $t1, $t0, erreur_if_entrezCoup3	#si 74 < message[0] alors il n'est pas compris entre A et V, erreur
	lb $t2 1($a0)		#on veut maintenant controler le premier chiffre
	bne $t2, 49, erreur_if_entrezCoup3	#si message[1] != 49 alors ce n'est pas un 1, erreur
	lb $t3 2($a0)		#on veut maintenant controler le deuxième chiffre
	bne $t3, 48, erreur_if_entrezCoup3	#si message[2] != 48 alors ce n'est pas un 0, erreur
	ori $t1, $0, 9		#on a obligatoirement un 10 du coup on fait 9*COLS pour obtenir l'indice du premier entier de la derniere file
	lb $t2, COLS
	mult $t1, $t2
	mflo $v0		#$v0 = 9*COLS
	add $v0, $v0, $t0	#$v0 = 9*COLS + message[0]
	addi $v0, $v0, -65	#$v0 = 9*COLS + message[0] - 65 pour associer A à 0 et J à 9
	epi_t
	jr $ra
erreur_if_entrezCoup3:
	la $a0, MSGERRF		#erreur de format, on recommence
	j fausseRec_entrezCoup
####################################################################################
####################################################################################
####################################################################################
joueCoupUser:			#on joue le coup de l'utilisateur, et on asigne les valeures à la grille CPU selon si le coup est réussi ou manqué
	pro_t
	la $a0, MSGENTC		#on veut afficher le premier message d'entrée de valeures
	jal entrezCoup		#on demmande le coup à l'utilisateur
	la $t0, grilleOrdi	#ceci nous servira a tester les valeurs des coups pour savoir s'il est réussi ou manqué, ainsi que a changer les valeurs des cases touchées
	addi $t0, $t0, 0x10000	#car c'est dans le .extern
	sll $v0, $v0, 2		#$v0 = 4*$v0 car on manipule des word
	add $t0, $t0, $v0	#$t0 = adresse de GRILLECPU[coup joué], ceci nous sert à faire les modifications
	lw $t1, ($t0)		#$t1 = GRILLECPU[coup joué]
do_joueCoupUser:		#on effectue le tir tant que on a tiré sur une case déjà touchée
	beq $t1, 0, coupManque_joueCoupUser	#le coup est manqué, on touche pas de bateau
	beq $t1, 1, coupReussi_joueCoupUser	#le coup est réussi, on touche un bateau
	la $a0, MSGTOUCHE	#on envoi un nouveau message à enter
	jal entrezCoup
	la $t0, grilleOrdi	#ceci nous servira a tester les valeurs des coups pour savoir s'il est réussi ou manqué, ainsi que a changer les valeurs des cases touchées
	addi $t0, $t0, 0x10000	#car c'est dans le .extern
	sll $v0, $v0, 2		#$v0 = 4*$v0 car on manipule des word
	add $t0, $t0, $v0	#$t0 = adresse de GRILLECPU[coup joué], ceci nous sert à faire les modifications
	lw $t1, ($t0)		#$t1 = GRILLECPU[coup joué]
	j do_joueCoupUser	#on boucle car on avais raté
coupReussi_joueCoupUser:
	ori $t1, $0, 2		#le code du coup réussi
	sb $t1, ($t0)		#on met cette valeur dans le tableau
	epi_t
	jr $ra
coupManque_joueCoupUser:
	ori $t1, $0, 3		#le code du coup manqué
	sb $t1, ($t0)		#on met cette valeur dans le tableau
	epi_t
	jr $ra