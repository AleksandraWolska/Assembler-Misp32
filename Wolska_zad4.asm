.data
	
	tab: .space 128		#rezerwacja miejsca dla ci¹gu (tutaj pomieœci 128/4 elementów)

	podajLiczbe: .asciiz "\nPodaj liczbe "
	ileLiczbPodac: .asciiz "\nIle liczb chcesz podac?\n"
	spacja: .asciiz " "
	enter: .asciiz "\n"
	
	komCiagU:		.asciiz "\nCiag jest uporzadkowany"
	komCiagNU: .asciiz "\nCiag nie jest uporzadkowany!"
	
	nieWZakresie:	.asciiz "Podaj cyfrê z przedzialu 1 - 3\n"
	
	wyswietlMenu: .asciiz "\n1- Czytaj dane i utworz ciag w pamieci\n2 - Drukuj ciag\n3 - Sprawdz uporzadkowanie\n"
	
	
	
	
.text
	main:
		 menu:

		# zapytanie o wybór zadania
		li $v0, 4
		la $a0, wyswietlMenu
		syscall
		
		# wczytanie liczby do rejestru $t0			$t0 - wybor
		li $v0, 5
		syscall
		move $t0, $v0
		
		
	sprawdzZakres:
		
		beq $t0, 1, wyb1
		beq $t0, 2, wyb2
		beq $t0, 3, wyb3
		beq $t0, 4, exit
		
		li $v0, 4
		la $a0, nieWZakresie
		syscall
		
		# wczytanie liczby do rejestru $t0			$t0 - wybor
		li $v0, 5
		syscall
		move $t0, $v0
		
		j sprawdzZakres

	
	wyb1:
	
			#komunikat pytaj¹cy o dlugosc ciagu
			li $v0, 4
			la $a0, ileLiczbPodac
			syscall
		
			#zapisanie dlugosci ciagu w t2
			li $v0, 5
			syscall
			move $t2, $v0
		
			jal funkcja1		#skok do funkcji
		
			j menu
			
			
		
	
	
	wyb2:
	
		la $a1, tab			#wczytaj tablice do druku
		la $s1, ($t2) 		#wczytaj dlugosc tablicy (jako licznik)
		jal funkcja2		#skok do funkcji
		
		j menu
		
	
	
	wyb3:
	
		
		la $a1, tab			#wczytaj tablice do $a1
		la $s1, ($t2) 		#wczytaj dlugosc tablicy (jako licznik)
		
		jal funkcja3			#skok do funkcji
		
		li $v0, 4
		la $a0, enter
		syscall
		
		
		j menu
		
		
	
		exit:
			#koniec programu
			li $v0, 10
			syscall
		
		
		
		funkcja1:
	
			#za³adowanie tablicy do rejestru $t5
			la $t5, tab
			#loop counter w rejestrze $t0
			li $t0, 1
			
			loop1:	
				
				#prosba o nowy wyraz
				li $v0, 4
				la $a0, podajLiczbe
				syscall
				
				
			
				#licznik petli
				li $v0, 1			
				move $a0, $t0
				syscall
				
				li $v0, 4
				la $a0, enter
				syscall
				
				#pobranie liczby
				li $v0, 5
				syscall
					
				#zapisanie w tablicy			
				sw $v0, 0($t5)
				addi $t5, $t5, -4
			
				addi $t0, $t0, 1		#inkrementuj loop counter
				
				ble $t0, $t2, loop1		#dopoki counter nie ejst wiekszy od dlugosci
		
			
				jr $ra		#powrot do funkcji
		
		
		funkcja2:
			loop2:
				#za³aduj wartoœæ z tablicy
				lw $a0, 0($a1)
				addi $a1, $a1, -4
		
				#wydrukuj wartoœæ
				li $v0, 1
				syscall
				
				li $v0, 4
				la $a0, spacja
				syscall
		
				#dekrementuj counter
				addi $s1, $s1, -1
				#jeœli counter nie rowna sie zero
				bnez $s1, loop2
				
				jr $ra
				
				
				
				
		funkcja3:
			
			lw $t3, 0($a1)		#pierwsze pobranie z tablicy
			addi $a1, $a1, -4
			
			addi $s1, $s1, -1 #dekrementuje licznik raz
			beqz $s1, ciagUporzadkowany		#jednowyrazowe s¹ uporzadkowane
			
			
			loop3:
			
				move $t4, $t3		#przenosze wartoœc poprzednio pobran¹ do nowego rejestru
				
				lw $t3, 0($a1)		#pobieram now¹ wartoœæ
				addi $a1, $a1, -4
		
				bgt $t4, $t3, ciagNieuporzadkowany   #skocz jesli wczesniejsza wartoœc byla wieksza
			
				addi $s1, $s1, -1 	#dekrementuj licznik pêtli
				
				bnez $s1, loop3		#jesli licznik nie wynosi zero
		
		
				#ciag jest uporzadkowany, wyswietla komunikat
				ciagUporzadkowany:
					li $v0, 4
					la $a0, komCiagU
					syscall
					j koniec
				
				
				ciagNieuporzadkowany:
					#wyswietla komunikat
					li $v0, 4
					la $a0, komCiagNU
					syscall
				
				koniec: 
				
					jr $ra
	
	