 .data
	tab: 		.space 400		#rezerwacja miejsca dla tablicy (tutaj pomieœci 100 elementow) - macierz 10x10
	wymiarW: 	.asciiz "\nIle wierszy (max 10)?\n"
	wymiarK: 	.asciiz "\nIle kolumn (max 10)?\n"
	wartosc: 	.asciiz "\nWartosc: "
	wiersz: 		.asciiz ", wiersz: "
	kolumna: 	.asciiz ", kolumna: "

	podajLiczbe: 		.asciiz "\nPodaj liczbe dla A["
	podajLiczbeKolumna: 	.asciiz "]["
	podajLiczbeZamknij:	.asciiz "] = "
	czyJeszczeRaz: 		.asciiz "\nCzy podmienic wartosc jeszcze raz? 1 - tak, 0 - nie"
	
	spacja: 	.asciiz " "
	enter: 	.asciiz "\n"

	nieWZakresie:	.asciiz "Podaj cyfrê z przedzialu 1 - 3\n"
	nieWZakresie3:	.asciiz "Podaj cyfrê 1 (tak) lub 0 (nie)\n"
	
	wyswietlMenu: 	.asciiz "\n1 - Czytaj dane i utworz macierz w pamieci\n2 - Drukuj macierz\n3 - Zamien wartosc na wskazanej pozycji\n"
	getWiersz: 		.asciiz "Podaj wiersz\n"
	getKolumna: 		.asciiz "Podaj kolumne\n"
	getWartosc: 		.asciiz "Na jaka wartosc chcesz zamienic?\n"
	
	
	
.text
main:
	menu:
		# zapytanie o wybór zadania
		li $v0, 4
		la $a0, wyswietlMenu
		syscall
		
		# wczytanie liczby do rejestru $t0
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
		
		# wczytanie liczby do rejestru $t0		
		li $v0, 5
		syscall
		move $t0, $v0
		
		j sprawdzZakres


	wyb1:
			#komunikat pytaj¹cy o dlugosc wiersza
			li $v0, 4
			la $a0, wymiarW
			syscall
		
			#zapisanie dlugosci wiersza w $t1
			li $v0, 5
			syscall
			move $t1, $v0
			
			#komunikat pytaj¹cy o dlugosc kolumny
			li $v0, 4
			la $a0, wymiarK
			syscall
		
			#zapisanie dlugosci kolumny w $t2
			li $v0, 5
			syscall
			move $t2, $v0
		
			jal funkcja1		#skok do funkcji
			j menu
		
				
	wyb2:
		la $a1, tab			#wczytaj tablice do druku
		la $s1, ($t1) 		#wczytaj dlugosc wiersza jako licznik
		la $s2, ($t2)		#wczytaj dlugosc kolumny jako licznik
	
		jal funkcja2		#skok do funkcji
		
		j menu
		
	
	wyb3:
		jal funkcja3			#skok do funkcji
		
		li $v0, 4
		la $a0, enter
		syscall
		
		j menu
		
		
	exit:
		#koniec programu
		li $v0, 10
		syscall
		
	
	#-------------------------------------------------------------------------------------	
				
		
		funkcja1:
		
			la $a1, tab			#za³adowanie tablicy do rejestru $a1
			li $t6, 1			#wiersz counter w rejestrze $t6
			
			loopWiersz:	
				li $t7, 1		#kolumna counter w rejestrze $t7, zerujemy w kazym wierszu
			
				loopKolumna:
					#prosba o nowy wyraz
					li $v0, 4
					la $a0, podajLiczbe
					syscall
				
					#licznik petli wiersza
					li $v0, 1			
					move $a0, $t6
					syscall
				
					li $v0, 4
					la $a0, podajLiczbeKolumna
					syscall
				
					#licznik petli kolumny
					li $v0, 1			
					move $a0, $t7
					syscall
				
					li $v0, 4
					la $a0, podajLiczbeZamknij
					syscall
				
					#pobranie liczby
					li $v0, 5
					syscall
					
					#zapisanie w tablicy			
					sw $v0, 0($a1)
					addi $a1, $a1, -4
			
					addi $t7, $t7, 1		#inkrementuj kolumna counter
					ble $t7, $t2, loopKolumna		#dopoki counter nie ejst wiekszy od dlugosci
				
				addi $t6, $t6, 1		#inkrementuj wiersz counter
				ble $t6, $t1, loopWiersz		#dopoki counter nie ejst wiekszy od dlugosc
				
			jr $ra		#powrot do funkcji
		
		
		funkcja2:		
			loopWiersz2:
				
				li $v0, 4
				la $a0, enter
				syscall
				
				la $s2, ($t2) 		#"zerowanie" licznika kolumn do d³ugiosci wiersza
				
				
				loopKolumna2:
					#za³aduj wartoœæ z tablicy
					lw $a0, 0($a1)
					addi $a1, $a1, -4
		
					#wydrukuj wartoœæ
					li $v0, 1
					syscall
				
					li $v0, 4
					la $a0, spacja
					syscall
		
					addi $s2, $s2, -1		#dekrementuj counter
					bnez $s2, loopKolumna2 	 #jeœli counter nie rowna sie zero
					
				addi $s1, $s1, -1  			 #dekrementuj counter
				bnez $s1, loopWiersz2  		 #jeœli counter nie rowna sie zero
				
				jr $ra
				
					
	funkcja3:
		#zapytanie o wiersz
		li $v0, 4
		la $a0, getWiersz
		syscall
		
		# wczytanie liczby do rejestru $t8
		li $v0, 5
		syscall
		move $t8, $v0
		
		#zapytanie o kolumne
		li $v0, 4
		la $a0, getKolumna
		syscall
		
		# wczytanie liczby do rejestru $t7
		li $v0, 5
		syscall
		move $t7, $v0
		
		#zapytanie o wartosc do podstawienia
		li $v0, 4
		la $a0, getWartosc
		syscall
		
		# wczytanie liczby do rejestru $t9
		li $v0, 5
		syscall
		move $t9, $v0
		
		la $a1, tab			#wczytaj tablice
		
		#wzor na pozycjê  [ iloscKolumn * (wybranyWiersz - 1) + wybranaKolumna -1 ]
		li $s1, 0
		addi $s1, $t8, -1
		mul $s1, $s1, $t1		#pozycja pocztku wiersza (do pozniejszego druku w $s1)
		
		add $s2, $s1, $t7
		mul $s2, $s2, -4			#pozycja danego miejsca do zamiany (w $s2)
		add $a1, $a1, $s2		#ustawiamy pointer na szukana pozycje macierzy
		sw $t9, 4($a1)			#zapisz na tej pozycji
		
		
		la $a1, tab			#ponownie wczytaj tablice (zerowanie pointera)
		mul $s1, $s1, -4		#oblicz wartosc do wskaznika
		add $a1, $a1, $s1	
		
		la $s2, ($t1) 		#counter dla wiersza
		
		li $v0, 4
		la $a0, enter
		syscall
		
		loop3:	#do drukowania wiersza
			
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
					addi $s2, $s2, -1
					#jeœli counter nie rowna sie zero
					bnez $s2, loop3
		

			
					# zapytanie czy powtorzyc
					li $v0, 4
					la $a0, czyJeszczeRaz
					syscall
		
					# wczytanie liczby do rejestru $t0			$t0 - wybor
					li $v0, 5
					syscall
					move $t0, $v0
		
					sprawdzZakres3:
				
						beq $t0, 1, funkcja3
						beq $t0, 0, wroc
					
						li $v0, 4
						la $a0, nieWZakresie3
						syscall
		
						# wczytanie liczby do rejestru $t0			$t0 - wybor
						li $v0, 5
						syscall
						move $t0, $v0
		
						j sprawdzZakres3
				
						wroc:
							jr $ra		#powrot do funkcji
	
 
 
 
 
 
