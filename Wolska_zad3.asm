
	#komunikaty
.data
	wyswietlMenu: 			.asciiz "\nMENU\n1 - Wprowadz parametry a i b (inaczej ustawione na 0)\n2 - Sprawdz ile na biezaco podanych punktow lezy pomiedzy prostymi\n3 - Sprawdz ile na biezaco podawanych punktow lezy na zewnatrz prostych\n4 - Koniec programu\n"
	nieWZakresie:	.asciiz "Podaj cyfre z przedzialu 1 - 4\n"

	
	pytajA:			.asciiz "Podaj wartosc a\n"
	pytajB:			.asciiz "Podaj wartosc b\n"
	pytajX:			.asciiz "Podaj wartosc x\n"
	pytajY:			.asciiz "Podaj wartosc y\n"
	

	odpX:		.asciiz "\nPunkt x = "
	odpY:		.asciiz ", y = "
	odp1Tak:		.asciiz " lezy pomiedzy prostymi"
	odp1Nie:		.asciiz " NIE lezy pomiedzy prostymi"
	odp2Tak:		.asciiz " lezy na zewnatrz wyznaczonego obszaru\n"
	odp2Nie:		.asciiz " NIE lezy na zewnatrz wyznaczonego obszaru\n"
	odpNaLinii:	.asciiz " lezy na prostej\n"
	
	odpIloscPoza:	.asciiz "\nIlosc punktow poza obszarem: "
	odpIloscW:		.asciiz "\nIlosc punktow w obszarze: "

	

.text

	
	menu:
		# zapytanie o wybór zadania
		li $v0, 4
		la $a0, wyswietlMenu
		syscall
		
		# wczytanie liczby do rejestru $t0			$t0 - wybor
		li $v0, 5
		syscall
		move $t0, $v0
		
		
		sprawdzZakres:		#sprawdza czy znajduje sie w zakresie
	                         
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

		# zapytanie o a
		li $v0, 4
		la $a0, pytajA
		syscall
		
		# wczytanie liczby do rejestru $1				$t1 - a
		li $v0, 5
		syscall
		move $t1, $v0
		
		# zapytanie o b
		li $v0, 4
		la $a0, pytajB
		syscall
		
		# wczytanie liczby do rejestru $2				$t2 - b
		li $v0, 5
		syscall
		move $t2, $v0
		
		abs $t2, $t2		#biore wartosc bezwzgledna b, aby pozniejsze warunki polozenia punktu sie zgadzaly
		
		
		#przy zamianie wartosci a, b zeruje tzw. countery dla ilosci punktow poza i miedzy prostymi 
		li $s1, 0	#counter pomiedzy prostymi
		li $s2, 0	#counter poza prostymi
		
		j menu
		
	
	wyb2:
	
		#upewniam sie ze rejestry do obliczen sa puste
		li $t5, 0
		li $t6, 0
	
		# zapytanie o x
		li $v0, 4
		la $a0, pytajX
		syscall
		
		# wczytanie liczby do rejestru $3				$t3 -x
		li $v0, 5
		syscall
		move $t3, $v0
		
		# zapytanie o y
		li $v0, 4
		la $a0, pytajY
		syscall
		
		# wczytanie liczby do rejestru $4			$t2 - b
		li $v0, 5
		syscall
		move $t4, $v0
			
		
		# pierwsza cz odp 
		li $v0, 4
		la $a0, odpX
		syscall
		
		#drukuj x
		li $v0, 1
		move $a0, $t3
		syscall
		
		# druga cz odp 
		li $v0, 4
		la $a0, odpY
		syscall
		
		#drukuj y
		li $v0, 1
		move $a0, $t4
		syscall
		
		
		#zaczynam obliczac ax+b
	
		
		mul $t5, $t1, $t3	#a*x w rej. t5
		add $t5, $t5, $t2	#ax + b
		
		mul $t6, $t1, $t3	#a*x w rej. t6
		sub $t6, $t6, $t2	#ax - b
		
		bgt $t4, $t5, lezyPoza1		#jesli obliczona funkcja jest wieksza niz y, to lezy poza
		beq $t4, $t5, lezyNa1
		beq $t4, $t6, lezyNa1
		blt $t4, $t6, lezyPoza1
		
	#jesli lezy pomiedzy
	
		li $v0, 4
		la $a0, odp1Tak
		syscall
		
		#inkrementuj ilosc pkt w obszarze
		addi $s1, $s1, 1
		
		#komunikat ile lezy pomiedzy 
		li $v0, 4
		la $a0, odpIloscW
		syscall
		
		#drukuj ilosc
		li $v0, 1
		move $a0, $s1
		syscall
		
		j menu
		
		
		lezyNa1:		#jesli punkt lezy na linii
			
			li $v0, 4
			la $a0, odpNaLinii
			syscall
			
			#komunikat ile lezy pomiedzy 
			li $v0, 4
			la $a0, odpIloscW
			syscall
		
			#drukuj ilosc
			li $v0, 1
			move $a0, $s1
			syscall
		
			j menu
		
		
		lezyPoza1:	#jesli punkt lezy poza obszarem
			
			li $v0, 4
			la $a0, odp1Nie
			syscall
			
			addi $s2, $s2, 1		#inkrementuje counter dla lezacych poza
			
			#komunikat ile lezy pomiedzy 
			li $v0, 4
			la $a0, odpIloscW
			syscall
		
			#drukuj ilosc
			li $v0, 1
			move $a0, $s1
			syscall
			
			j menu
			
	
	wyb3:
		
		#upewniam sie ze rejestry sa puste
		li $t5, 0
		li $t6, 0
	
		# zapytanie o x
		li $v0, 4
		la $a0, pytajX
		syscall
		
		# wczytanie liczby do rejestru $3				$t3 -x
		li $v0, 5
		syscall
		move $t3, $v0
		
		# zapytanie o y
		li $v0, 4
		la $a0, pytajY
		syscall
		
		# wczytanie liczby do rejestru $4			$t2 - b
		li $v0, 5
		syscall
		move $t4, $v0
			
		
		# pierwsza cz odp 
		li $v0, 4
		la $a0, odpX
		syscall
		
		#drukuj x
		li $v0, 1
		move $a0, $t3
		syscall
		
		# druga cz odp 
		li $v0, 4
		la $a0, odpY
		syscall
		
		#drukuj y
		li $v0, 1
		move $a0, $t4
		syscall
		
		
		#zaczynam obliczac ax+b i ax - b
		
		mul $t5, $t1, $t3	#a*x w rej. t5
		add $t5, $t5, $t2	#ax + b
		
		mul $t6, $t1, $t3	#a*x w rej. t6
		sub $t6, $t6, $t2	#ax - b
		
		bgt $t4, $t5, lezyPoza2		#jesli obliczona funkcja jest wieksza niz y, to lezy poza
		beq $t4, $t5, lezyNa1
		beq $t4, $t6, lezyNa1
		blt $t4, $t6, lezyPoza2
		
	#jesli lezy pomiedzy
	
		li $v0, 4
		la $a0, odp2Nie
		syscall
		
		#komunikat ile lezy poza
		li $v0, 4
		la $a0, odpIloscPoza
		syscall
		
		#drukuj ilosc
		li $v0, 1
		move $a0, $s2
		syscall
		
		j menu
		
		
		lezyNa2:		#jesli punkt lezy na linii
			
			li $v0, 4
			la $a0, odpNaLinii
			syscall
			
			#komunikat ile lezy poza
			li $v0, 4
			la $a0, odpIloscPoza
			syscall
		
			#drukuj ilosc
			li $v0, 1
			move $a0, $s2
			syscall
			j menu
		
		lezyPoza2:	#jesli punkt lezy poza obszarem
			
			#wypisz komunikat
			li $v0, 4
			la $a0, odp2Tak
			syscall
			
			#komunikat ile lezy poza
			li $v0, 4
			la $a0, odpIloscPoza
			syscall
		
			#drukuj ilosc
			li $v0, 1
			move $a0, $s2
			syscall
			j menu
			
	exit:
		#koniec programu
		li $v0, 10
		syscall
	