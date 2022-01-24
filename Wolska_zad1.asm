# Cwiczenie 1, Architektura Komputerow laboratorium, Aleksandra Wolska

.data
	# komunikaty do uzytkownika:
	komunikat_start: .asciiz "\nSprawdzanie czy punkt (x, y) nalezy do krzywej y = ax^2 + bx + c"
	komunikat_a: .asciiz "\nPodaj parametr a: \n"
	komunikat_b: .asciiz "\nPodaj parametr b: \n"
	komunikat_c: .asciiz "\nPodaj parametr c: \n"
	komunikat_x: .asciiz "\nPodaj wartosc x: \n"
	komunikat_y: .asciiz "\nPodaj wartosc y: \n"
	
	komunikat_wynik: .asciiz "\n Czy punkt nalezy: "
	komunikat_wynikTak: .asciiz " TAK"
	komunikat_wynikNie: .asciiz " NIE"
	
	komunikat_powtorz: .asciiz  "\nCzy chcesz podac inny punkt? (0 - nie, 1 - tak)\n"
	komunikat_powtorzABC: .asciiz  "\nCzy chcesz podac inne parametry funkcji? (0 - nie, 1 - tak)\n"
	
	
	# tymaczasowe rejestry i ich uzycie; a-$t0, b-$t1, c-$t2, x-$t3, y-$t4
	
.text
	main:
		# wyswietl wprowadzenie
		li $v0, 4
		la $a0, komunikat_start
		syscall
					
	wczytajDaneRownania:
		
		# zapytaj o a 
		li $v0, 4
		la $a0, komunikat_a
		syscall
		
		# wprowadz wartosc a od uzytkownika i umiesc w $t0
		li $v0, 5
		syscall
		move $t0, $v0
		
		# zapytaj o b 
		li $v0, 4
		la $a0, komunikat_b
		syscall
		
		# wprowadz wartosc b od uzytkownika i umiesc w $t1
		li $v0, 5
		syscall
		move $t1, $v0
		
		# zapytaj o c
		li $v0, 4
		la $a0, komunikat_c
		syscall
		
		# wprowadz wartosc c od uzytkownika i umiesc w $t2
		li $v0, 5
		syscall
		move $t2, $v0
		
	wczytajPunktIOblicz:
		
		# zapytaj o x 
		li $v0, 4
		la $a0, komunikat_x
		syscall
		
		# wprowadz wartosc x od uzytkownika i umiesc w $t3
		li $v0, 5
		syscall
		move $t3, $v0
		
		# zapytaj o y 
		li $v0, 4
		la $a0, komunikat_y
		syscall
		
		# wprowadz wartosc x od uzytkownika i umiesc w $t4
		li $v0, 5
		syscall
		move $t4, $v0
		
		#skocz do obliczenia funkcji
		jal obliczFunkcje
		
		#pierwsza czesc komunikatu o wyniku
		li $v0, 4
		la $a0, komunikat_wynik
		syscall
		
		#sprawdzam czy obliczona wartosc funkcji zgadza siê z wartosci¹ y (bne porownuje)
		bne $v0, $t4, nieSaRowne
		
		#jesli beda rowne, wyswietl TAK
		saRowne:
			li $v0, 4
			la $a0, komunikat_wynikTak
			j jeszczeRaz
		#jesli nie beda rowne, wyswietl NIE
		nieSaRowne:
			li $v0, 4
			la $a0, komunikat_wynikNie
			syscall
			
		jeszczeRaz:
		# pytanie czy chce podac inny punkt
			li $v0, 4
			la $a0, komunikat_powtorz
			syscall
		#wczytaj wartosc
				li $v0, 5
			syscall
		#jesli nierowna zero (1- jeszcze raz,) wykonaj funkcjê jeszcze raz dla innych x, y 
			bnez $v0, wczytajPunktIOblicz
				
		#jesli rowna zero, zapytaj czy dla innych wartosci a, b, c

			li $v0, 4
			la $a0, komunikat_powtorzABC
			syscall
		
			li $v0, 5
			syscall
			
		#jeœli nierowana zero, to skocz do pocz¹tku (1 - jeszcze raz)
			bnez $v0, wczytajDaneRownania
		
		#zakoncz program
			li $v0, 10
			syscall
			
	obliczFunkcje:
		# pomnoz a * x * x (ax^2) - wartosc x wczytaj do $a0
		move $a0, $t3
		mul $v0, $a0, $a0
		mul $v0, $v0, $t0
		
		# pomnoz b * x (bx)
		mul $t5, $a0, $t1
		
		# dodaj do siebie ax^2 i bx
		add $v0, $v0, $t5
		
		# dodaj c
		add $v0, $v0, $t2
		
		# wroc do wywolania funkcji
		jr $ra
		
