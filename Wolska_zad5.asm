.data
	
	tab: .space 400		#rezerwacja miejsca dla ci¹gu (tutaj pomieœci 100 elementow) - macierz 10x10

	wymiarW: .asciiz "\nIle wierszy (max 10)?\n"
	wymiarK: .asciiz "\nIle kolumn (max 10)?\n"
	wartosc: .asciiz "\nWartosc: "
	wiersz: .asciiz ", wiersz: "
	kolumna: .asciiz ", kolumna: "

	podajLiczbe: .asciiz "\nPodaj liczbe dla A[ "
	podajLiczbeKolumna: .asciiz "]["
	podajLiczbeZamknij: .asciiz "]= "
	
	czyJeszczeRaz: .asciiz "\nCzy wyszukaæ jeszcze raz? 1 - tak, 0 - nie"
	wyszukaj: .asciiz "\n1 - Wyszukaj trzy najwieksze wartosci\n2 - Wyszukaj trzy najmniejsze wartosci  (tylko dla liczb dodatnich)\n"
	
	spacja: .asciiz " "
	enter: .asciiz "\n"

	

	
	nieWZakresie:	.asciiz "Podaj cyfrê z przedzialu 1 - 3\n"
	nieWZakresie3:	.asciiz "Podaj cyfrê 1 (tak) lub 0 (nie)\n"
	nieWZakresieF:	.asciiz "Podaj cyfrê 1 (najmniejsze) lub 2 (najwieksze) bez powtorzen\n"
	
	wyswietlMenu: .asciiz "\n1 - Czytaj dane i utworz macierz w pamieci\n2 - Drukuj macierz\n3 - Wypisz najwieksze/najmniejsze wartosci bez powtórzen\n"
	
	
	
	
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
		
		
		
		funkcja1:
	
			la $t5, tab			#za³adowanie tablicy do rejestru $t5
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
					sw $v0, 0($t5)
					addi $t5, $t5, -4
			
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
				
				la $s2, ($t2) 		#"zerowanie" licznika kolumn do wartoœci ustalonej
				
				
			
			
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
		
					#dekrementuj counter
					addi $s2, $s2, -1
					#jeœli counter nie rowna sie zero
					bnez $s2, loopKolumna2
					
					
				#dekrementuj counter
				addi $s1, $s1, -1
				#jeœli counter nie rowna sie zero
				bnez $s1, loopWiersz2
				
				jr $ra
				
				
				
				
	funkcja3:
	
		li $v0, 4
		la $a0, wyszukaj
		syscall
		
		# wczytanie liczby do rejestru $t0			$t0 - wybor
		li $v0, 5
		syscall
		move $t0, $v0
		
		sprawdzZakresF:
				
			beq $t0, 1, trzyNajwieksze
			beq $t0, 2,	trzyNajmniejsze
					
			li $v0, 4
			la $a0, nieWZakresieF
			syscall
		
			# wczytanie liczby do rejestru $t0			$t0 - wybor
			li $v0, 5
			syscall
			move $t0, $v0
		
			j sprawdzZakres
	
	
	
		
		trzyNajwieksze:
			li $s1, 3 #ile najmw. wart znaleziono
			li $s5, 99999 #ustalam b. duza liczbe
		
		loopDrukujNajwieksze:
		
			la $t5, tab			#za³adowanie tablicy do rejestru $t5
			li $t3, 1			#wiersz counter w rejestrze $t3
			
			#za³aduj wartoœæ z tablicy do s2 - obecna najwieksza
			lw $s2, 0($t5)
			addi $t5, $t5, -4
			
			loopWiersz3:	
				li $t4, 1		#kolumna counter w rejestrze $t4, zerujemy w kazym wierszu
			
				loopKolumna3:
					#za³aduj wartoœæ z tablicy do s3
					lw $s3, 0($t5)
					addi $t5, $t5, -4
					
					bge $s3, $s5	, dalej			#juz wczesniej wypisana najwiksza
					bgt $s2, $s3, dalej		#jesli s2(najwieksza) jest wieksza to dalej
					
					la $s2, ($s3)				#jesli mniejsza to postawiamy wartosc
					
					dalej:
					
						addi $t4, $t4, 1		#inkrementuj kolumna counter
						ble $t4, $t2, loopKolumna3		#dopoki counter nie ejst wiekszy od dlugosci
				
				addi $t3, $t3, 1		#inkrementuj wiersz counter
				ble $t3, $t1, loopWiersz3		#dopoki counter nie ejst wiekszy od dlugosc
				
				
				
				
				la $t5, tab			#za³adowanie tablicy do rejestru $t5
				li $t3, 1
				loopWierszDruk:	
				li $t4, 1		#kolumna counter w rejestrze $t4, zerujemy w kazym wierszu
			
				loopKolumnaDruk:
					#za³aduj wartoœæ z tablicy do s2 - obecna najwieksza
					lw $t9, 0($t5)
					addi $t5, $t5, -4
					beq $t9, $s2, drukuj1			#jesli pobrana jest rowna najwiekszej, drukuj
					addi $t4, $t4, 1		#inkrementuj kolumna counter
					ble $t4, $t2, loopKolumnaDruk		#dopoki counter nie ejst wiekszy od dlugosci
				
				addi $t3, $t3, 1		#inkrementuj wiersz counter
				ble $t3, $t1, loopWierszDruk		#dopoki counter nie ejst wiekszy od dlu
				
				
				drukuj1:
				
					li $v0, 4
					la $a0, wartosc
					syscall
				
					#najwieksza wartosc
					li $v0, 1			
					move $a0, $s2
					syscall
					
					li $v0, 4
					la $a0, wiersz
					syscall
				
					#licznik petli wiersza
					li $v0, 1			
					move $a0, $t3
					syscall
				
					li $v0, 4
					la $a0, kolumna
					syscall
				
					#licznik petli kolumny
					li $v0, 1			
					move $a0, $t4
					syscall
				
					li $v0, 4
					la $a0, enter
					syscall
					
					la $s5, ($s2)
					
					addi $s1, $s1, -1			#znaleziono wartosc, zmniejszam counter
					bnez $s1, loopDrukujNajwieksze 
					
					j koniec
					
					
	trzyNajmniejsze:				#dziala tylko dla dodatnich
			li $s1, 3 #ile najmniejszych. wart znaleziono
			li $s5, 0 #ustalam b. mala liczbe
		
		loopDrukujNajmniejsze:
		
			la $t5, tab			#za³adowanie tablicy do rejestru $t5
			li $t3, 1			#wiersz counter w rejestrze $t3
			
			#za³aduj wartoœæ z tablicy do s2 - obecna najmniejsza
			lw $s2, 0($t5)
			addi $t5, $t5, -4
			
			loopWierszM:	
				li $t4, 1		#kolumna counter w rejestrze $t4, zerujemy w kazym wierszu
			
				loopKolumnaM:
					#za³aduj wartoœæ z tablicy do s3
					lw $s3, 0($t5)
					addi $t5, $t5, -4
					
					ble $s3, $s5	, dalejM			#juz wczesniej wypisana najmniejsza
					blt $s2, $s3, dalejM		#jesli s2(najwieksza) jest wieksza to dalej
					
					la $s2, ($s3)				#jesli mniejsza to postawiamy wartosc
					
					dalejM:
					
						addi $t4, $t4, 1		#inkrementuj kolumna counter
						ble $t4, $t2, loopKolumnaM		#dopoki counter nie ejst wiekszy od dlugosci
				
				addi $t3, $t3, 1		#inkrementuj wiersz counter
				ble $t3, $t1, loopWierszM		#dopoki counter nie ejst wiekszy od dlugosc
				
				
				
				
				la $t5, tab			#za³adowanie tablicy do rejestru $t5
				li $t3, 1
				
				loopWierszDrukM:	
				li $t4, 1		#kolumna counter w rejestrze $t4, zerujemy w kazym wierszu
			
				loopKolumnaDrukM:
					#za³aduj wartoœæ z tablicy do s2 - obecna najmniejsz
					lw $t9, 0($t5)
					addi $t5, $t5, -4
					beq $t9, $s2, drukujM			#jesli pobrana jest rowna najwiekszej, drukuj
					addi $t4, $t4, 1		#inkrementuj kolumna counter
					ble $t4, $t2, loopKolumnaDrukM		#dopoki counter nie ejst wiekszy od dlugosci
				
				addi $t3, $t3, 1		#inkrementuj wiersz counter
				ble $t3, $t1, loopWierszDrukM		#dopoki counter nie ejst wiekszy od dlu
				
				
				drukujM:
				
					li $v0, 4
					la $a0, wartosc
					syscall
				
					#najwieksza wartosc
					li $v0, 1			
					move $a0, $s2
					syscall
					
					li $v0, 4
					la $a0, wiersz
					syscall
				
					#licznik petli wiersza
					li $v0, 1			
					move $a0, $t3
					syscall
				
					li $v0, 4
					la $a0, kolumna
					syscall
				
					#licznik petli kolumny
					li $v0, 1			
					move $a0, $t4
					syscall
				
					li $v0, 4
					la $a0, enter
					syscall
					
					la $s5, ($s2)
					
					addi $s1, $s1, -1			#znaleziono wartosc, zmniejszam counter
					bnez $s1, loopDrukujNajmniejsze
					

					
			koniec:
			
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
				
			

				
					
	
	
