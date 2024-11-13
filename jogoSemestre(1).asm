jmp main																									

;mensagem: string "";

Letra: var #1

boneco: string "-" ; Para desenhar o personagem 
obstaculo: string "o"	; Para desenhar o obstaculo 
placar : string "SCORE: " ; String do placar

posperso: var #490 ; Posicao padrao do personagem
pontos: var #1	; seta 1 para funcionar pontuacao

delay1: var #1000	; Variaveis para usar como parametro para o delay
delay2: var #1000

Rand : var #30			; Tabela de nrs. Randomicos entre 1 - 3	
	static Rand + #0, #3
	static Rand + #1, #2
	static Rand + #2, #2
	static Rand + #3, #3
	static Rand + #4, #3
	static Rand + #5, #2
	static Rand + #6, #1
	static Rand + #7, #2
	static Rand + #8, #1
	static Rand + #9, #3
	static Rand + #10, #2
	static Rand + #11, #1
	static Rand + #12, #3
	static Rand + #13, #3
	static Rand + #14, #2
	static Rand + #15, #1
	static Rand + #16, #2
	static Rand + #17, #3
	static Rand + #18, #1
	static Rand + #19, #2
	static Rand + #20, #1
	static Rand + #20, #2
	static Rand + #21, #3
	static Rand + #22, #2
	static Rand + #23, #2
	static Rand + #24, #1
	static Rand + #25, #1
	static Rand + #26, #3
	static Rand + #27, #2
	static Rand + #28, #3
	static Rand + #29, #2

	
IncRand: var #1
;
; ----------x--------------x-----------
main:	; Inicio do codigo	
	
	call ApagaTela
	loadn r1, #tela0Linha0		; Imprime a tela inicial
	loadn r2, #2816              ;cor 
	call ImprimeTela
	
	loadn r1, #tela11Linha0		; Imprime a tela inicial
	loadn r2, #2304             ;cor 
	call ImprimeTela2
	
	jmp Loop_Inicio
	
	Loop_Inicio:
		
		call DigLetra 		; Le uma letra
		
		loadn r0, #' '		; Espera que a tecla 'space' seja digitada para iniciar o jogo
		load r1, Letra
		cmp r0, r1
		jne Loop_Inicio
	
	setamento:
		
		push r2
		loadn r2, #0				; Inicializa os pontos
		store pontos, r2
		pop r2
		
		loadn r0, #1200
		store delay1, R0             ; delay meteoro
		
		loadn r0, #80                ; delay pulo
		store delay2, r0
	
	
	
			

	InicioJogo:		; Inicializa variaveis e registradores usados no jogo antes de comecar o loop principal
		
		
		call ApagaTela				;	Imprime a tela basica do jogo
		loadn r1, #tela1Linha0
		loadn r2, #1536
		call ImprimeTela
		
		loadn R1, #tela3Linha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #2816		    ;   cor 
		call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
	
	
		loadn r0, #3
		loadn r1, #placar		; Imprime a tela inicial
		loadn r2, #0
		call ImprimeStr
		
		loadn r7, #' '	; Parametro para saber se a tecla certa foi pressionada
		loadn r6, #490	; Posicao do boneco na tela (fixa no eixo x e variavel no eixo y)
		loadn r2, #519	; Posicao do obstaculo na tela (fixa no eixo x e variavel no eixo y)
		load r4, boneco	; Guardando a string do boneco no registrador r4
		load r1, obstaculo	; Guardando a string do obstaculo no registrador r1
		loadn r5, #0	; Ciclo do pulo (0 = chao, entre 1 e 3 = sobe, maior que 3 = desce)
		
		jmp LoopJogo
	
		LoopJogo:		; Loop principal do jogo
		
			call ChecaColisao	; Checa se houve uma colisao
			
			call AtPontos 		; Atualiza os pontos

			call ApagaPersonagem 	; Desenha o personagem
			call PrintaPersonagem
			
			call AtPosicaoObstaculo 	; Move o obstaculo
			outchar r1, r2 				; Desenha o obstaculo
			
			call DelayChecaPulo		; Todo ciclo principal do jogo, a funcao DelayChecaPulo atrasa a execucao e le uma tecla do teclado (que e' 'w' ou nao)
			call AtPosicaoBoneco	; Todo ciclo principal do jogo, a funcao AtPosicaoBoneco atualiza a posicao do boneco de acordo com a situacao
			
			push r3 			; Checa se pode pular (caso o personagem esteja no chao)
			loadn r3, #0 
			cmp r5, r3
				ceq ChecaPulo ; A funcao checa se o jogador mandou o personagem pular
			pop r3
				
			
		jmp LoopJogo 	; Volta para o loop
	
	
	GameOver:
	
		call ApagaTela				;	Imprime a tela do fim do jogo
		loadn r1, #tela2Linha0
		loadn r2, #3584
		call ImprimeTela
		
		loadn r1, #tela5Linha0
		loadn r2, #2304
		call ImprimeTela2
		
		load r5, pontos
		loadn r6, #865	
		call PrintaNumero
		call DigLetra
		
		;if Letra == ' '		; Espera que a tecla 's' seja digitada para reiniciar o jogo
		loadn r0, #'n'
		load r1, Letra
		cmp r0, r1
		jeq fim_de_jogo
		
		loadn r0, #'s'
		cmp r0, r1
		jne GameOver
		
		call ApagaTela
	
		pop r2
		pop r1
		pop r0

		pop r0	; Da um Pop a mais para acertar o ponteiro da pilha, pois nao vai dar o RTS !!
		jmp setamento	
		
fim_de_jogo:
	call ApagaTela
	halt

;########################################################################
;#														  				#
;#                  			SUBROTINAS						  		#
;#														  				#
;########################################################################

;********************************************************
;                   	Imprimestr
;********************************************************

Imprimestr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor

	
	loadn r3, #'\0'	; Criterio de parada

ImprimestrLoop:	
	loadi r4, r1
	cmp r4, r3
	jeq ImprimestrSai
	add r4, r2, r4
	outchar r4, r0
	inc r0
	inc r1
	jmp ImprimestrLoop
	
ImprimestrSai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                  	     DigLetra
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts
	
;********************************************************
;                       ApagaTela
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	


;********************************************************
;                       ImprimeTela
;********************************************************	

ImprimeTela: 	;  Rotina de Impresao de Cenario na Tela Inteira
				;  r1 = endereco onde comeca a primeira linha do Cenario
				;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r4 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	
;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
   		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;------------------------

;********************************************************
;                   ImprimeStr
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;********************************************************
;                   AtPosicaoBoneco
;********************************************************

;	Funcao que atualiza a posicao do boneco na tela de acordo com a necessidade da situacao

AtPosicaoBoneco:

	push r0
	
	;if r5 = 1		; Caso o ciclo do pulo esteja em 1, 2, 3 ou 4, o boneco sobe
	loadn r0, #1
	cmp r5, r0
		ceq Sobe

	;if r5 = 2
	loadn r0, #2
	cmp r5, r0
		ceq Sobe
		
	;if r5 = 3
	loadn r0, #3
	cmp r5, r0
		ceq Sobe
		
	;if r5 = 4
	loadn r0, #4
	cmp r5, r0
		ceq Sobe
	
	;if r5 = 5		; Caso o ciclo do pulo esteja em 5, 6, 7 ou 8, o boneco desce
	loadn r0, #5
	cmp r5, r0
		ceq Desce
		
	;if r5 = 6
	loadn r0, #6
	cmp r5, r0
		ceq Desce
		
	;if r5 = 7
	loadn r0, #7
	cmp r5, r0
		ceq Desce
		
	;if r5 = 8
	loadn r0, #8
	cmp r5, r0
		ceq Desce
		
	;if r5 != 0
	loadn r0, #0		; Caso o boneco estaja no chao (ciclo = 0), o ciclo nao deve ser alterado aqui
	cmp r5, r0
		cne IncrementaCiclo	; Caso esteja no ar, o ciclo deve continuar sendo incrementado
		
	loadn r0, #9	; Ate que o ciclo chegue em 9, entao se torna 0 novamente (boneco esta no chao novamente)
	cmp r5, r0
		ceq ResetaCiclo
				
		
	pop r0
	rts
	
;********************************************************
;               ATUALIZA POSICAO DO OBSTACULO
;********************************************************

;	Funcao que atualiza a posicao do obstaculo na tela de acordo com a necessidade da situacao

AtPosicaoObstaculo:
	
	push r0
	loadn r0 , #' '
	
	outchar r0, r2
	
	dec r2

	;if posicao do obstaculo = 480 (fim da tela para a esquerda)
	loadn r0, #480
	cmp r2, r0
		ceq ResetaObstaculo
		
	loadn r0, #440
	cmp r2, r0
		ceq ResetaObstaculo
		
	loadn r0, #400
	cmp r2, r0
		ceq ResetaObstaculo
		
	pop r0
	rts

;********************************************************
;                       ResetaObstaculo
;********************************************************

; Funcao que reseta a posicao do obstaculo

ResetaObstaculo:
	push r0
	push r1
	push r3
	
	loadn r2, #519		; Posicao (padrao do obstaculo)
	
	call GeraPosicao	; Gera a nova  posicao para o obstaculo
	
	loadn r1, #1		;  Caso 1
	cmp r3,r1
	ceq AlteraPos1
	
	loadn r1, #2		; Caso 2
	cmp r3,r1
	ceq AlteraPos2
	
	pop r3
	pop r1
	pop r0
	rts

	
;********************************************************
;                       GeraPosicao
;********************************************************

; Funcao que gera uma posicao aleatoria para o obstaculo

GeraPosicao :
	push r0
	push r1
	

						; sorteia nr. randomico entre 0 - 7
	loadn r0, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r0, r0, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r3, r0 		; busca nr. randomico da memoria em R3
						; R3 = Rand(IncRand)
						
	inc r1				; Incremento ++
	loadn r0, #30
	cmp r1, r0			; Compara com o Final da Tabela e re-estarta em 0
	jne ResetaVetor
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  ResetaVetor:
	store IncRand, r1	; Salva incremento ++
	
	
	pop r1
	pop r0
	rts

;********************************************************
;                       ResetaAleatorio
;********************************************************

; Funcao que reseta a semente para a funcao de geracao aleatoria

ResetaAleatorio:	
		
		push r2
		loadn r2,#28
		
		sub r1,r2,r2 
		
		pop r2
		rts

;********************************************************
;     				  AlteraPos1
;********************************************************

; Caso 1 da posicao do obstaculo

AlteraPos1:
		push r1
		
		loadn r1,#40
		sub r2,r2,r1
		

		pop r1
		rts
	
;********************************************************
;     				  AlteraPos2
;********************************************************

; Caso 2 da posicao do obstaculo

AlteraPos2:
		push r1
		
		loadn r1,#80
		sub r2,r2,r1	
		
		pop r1
		rts

;********************************************************
;                     ChecaPulo
;********************************************************	

; Funcao que checa se o jogador pressionou 'space' e, se sim, inicia o ciclo do pulo

ChecaPulo:

	push r3
	load r3, Letra 			; Caso ' space' tenha sido pressionado	
	cmp r7, r3
		ceq IncrementaCiclo		; Inicia o ciclo do pulo
	pop r3 		
	rts

;********************************************************
;                 IncrementaCiclo
;********************************************************

; Incrementa o ciclo do pulo

IncrementaCiclo:

	inc r5
	rts
	
;********************************************************
;                       ResetaCiclo
;********************************************************

; Reseta o ciclo do pulo

ResetaCiclo:

	loadn r5, #0
	rts
	
;********************************************************
;                       SOBE
;********************************************************

; Funcao que sobe o personagem para a linha de cima (-40 em sua posicao)

Sobe:

	push r1
	push r2
	
	call ApagaPersonagem
	
	loadn r1, #40
	sub r6, r6, r1
	
	pop r2
	pop r1
	rts 
	
;********************************************************
;                       Desce
;********************************************************

; Funcao que desce o personagem para a linha de cima (+40 em sua posicao)
	
Desce:

	push r1
	push r2
	
	call ApagaPersonagem
	"                                        "
	loadn r1, #40
	add r6, r6, r1
	
	pop r2
	pop r1
	rts

;********************************************************
;                       IncrementaPontos
;********************************************************

; Funcao que  incrementa os pontos do jogador

IncPontos:

	push r1
	push r2
	
	load r2, pontos
	
	inc r2
	
	load r1, delay1
	dec r1

	store delay1, r1
	
	load r1, delay2
	dec r1
	dec r1

	store delay2, r1
	
	store pontos, r2
	
	pop r2
	pop r1
	rts

;********************************************************
;                AtualizaPontos
;********************************************************

AtPontos:

	push r1
	push r5
	push r6
	
	loadn r1, #490		; Caso o obstaculo tenha passado pela posicao do jogador, incrementa a pontuacao
	cmp r2, r1
		ceq IncPontos
	
	loadn r1, #450		; Idem, porem para o caso do obstaculo estar em  outra linha
	cmp r2, r1
		ceq IncPontos
		
	loadn r1, #410		; Idem, porem para o caso do obstaculo estar em  outra linha
	cmp r2, r1
		ceq IncPontos
		
	load r5, pontos
	
	loadn r6, #11
	
	call PrintaNumero	; Imprime a pontuacao na tela
	
	pop r6
	pop r5
	pop r1
	rts	
	
;********************************************************
;                    DelayChecaPulo
;********************************************************
 
; Funcao que da' o delay de um ciclo do jogo e tambem le uma tecla do teclado

DelayChecaPulo:
	push r0
	push r1
	push r2
	push r3
	
	load r0, delay1
	loadn r3, #255
	store Letra, r3		; Guarda 255 na Letra pro caso de nao apertar nenhuma tecla
	
	loop_delay_1:
		load r1, delay2

; Bloco de ler o Teclado no meio do DelayChecaPulo!!		
			loop_delay_2:
				inchar r2
				cmp r2, r3 
				jeq loop_skip
				store Letra, r2		; Se apertar uma tecla, guarda na variavel Letra
			
	loop_skip:			
		dec r1
		jnz loop_delay_2
		dec r0
		jnz loop_delay_1
		jmp sai_dalay
	
	sai_dalay:
		pop r3
		pop r2
		pop r1
		pop r0
	rts

;********************************************************
;                    PrintaNumero
;********************************************************

; Imprime um numero de 2 digitos na tela

PrintaNumero:	; R5 contem um numero de ate' 2 digitos e R6 a posicao onde vai imprimir na tela

	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #10
	loadn r2, #48
	
	div r1, r5, r0	; Divide o numero por 10 para imprimir a dezena
	
	add r3, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r3, r6
	
	inc r6			; Incrementa a posicao na tela
	
	mul r1, r1, r0	; Multiplica a dezena por 10
	sub r1, r5, r1	; Pra subtrair do numero e pegar o resto
	
	add r1, r1, r2	; Soma 48 ao numero pra dar o Cod.  ASCII do numero
	outchar r1, r6
	
	pop r3
	pop r2
	pop r1
	pop r0

	rts

;********************************************************
;                    PrintaPersonagem
;********************************************************

; Desenha o personagem na tela

PrintaPersonagem:
	push r0
	
	outchar r4, r6 ; Printa o corpo do boneco	
	dec r4
	loadn r0, #40
	sub r6, r6, r0
	outchar r4, r6 ; Printa a cabeca  do boneco
	add r6, r6, r0
	inc r4
	
	pop r0			
	rts
	
;********************************************************
;                    ApagaPersonagem
;********************************************************

; Apaga o personagem da tela

ApagaPersonagem:
	
	push r4
	push r0

	loadn r4, #' '	; Printa um espaco no lugar do personagem, apagando-o
	outchar r4, r6 	
	
	loadn r0, #40
	sub r6, r6, r0
	outchar r4, r6 
	add r6, r6, r0
	
	pop r0
	pop r4
	rts
	
;********************************************************
;                ChecaColisao
;********************************************************
ChecaColisao:
	push r0
	 
	;;compara posicao inferior do personagem com a do obstaculo, se igual finaliza o jogo
	cmp r2, r6 
	jeq GameOver
	
	loadn r0,#40
	sub r6,r6,r0
	
	;;compara posicao superior do personagem com a do obstaculo, se igual finaliza o jogo
	cmp r2, r6
	jeq GameOver
	
	add r6,r6,r0
	
	pop r0
	rts

													   
;---------------------------------------------------------------
; Tela de inicio:
;---------------------------------------------------------------

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "            D I N O  R U N              "
tela0Linha9  : string "                                        "                   
tela0Linha10 : string "                                        "               
tela0Linha11 : string "                 ^^^^^                  "               
tela0Linha12 : string "                ^^^  ^^                 "            
tela0Linha13 : string "                ^^^^^^^                 "                   
tela0Linha14 : string "                ^^^^^                   "                  
tela0Linha15 : string "                 ^^^^^^                 "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "           ESPACO PARA JOGAR            "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

;---------------------------------------------------------------
; Tela padrao do jogo
;---------------------------------------------------------------
;Cenario
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "            *                    *      "
tela1Linha3  : string "                                        "
tela1Linha4  : string "    *                  *                "
tela1Linha5  : string "                                        "
tela1Linha6  : string "                  *                 *   "
tela1Linha7  : string "                                        "
tela1Linha8  : string "    *                                   "
tela1Linha9  : string "                                        "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "										   "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "

;---------------------------------------------------------------
; Tela de fim de jogo
;---------------------------------------------------------------

tela2Linha0  : string "                                        "
tela2Linha1  : string "                                        "
tela2Linha2  : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "                                        "
tela2Linha10 : string "            JOGAR NOVAMENTE             "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "                                   
tela2Linha20 : string "                                        "
tela2Linha21 : string "               SCORE:                   "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres): 
;linha 98
; Cenario 2
tela3Linha0  : string "                                        "
tela3Linha1  : string "                                        "
tela3Linha2  : string "                                        "
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
tela3Linha14 : string "    .                             .     "
tela3Linha15 : string "             .        .                 "
tela3Linha16 : string "       .                     .          "     
tela3Linha17 : string "                                        "
tela3Linha18 : string "                 .                      "
tela3Linha19 : string "     . OOOOOOO            .             "
tela3Linha20 : string "      OOOOOOOOO                   .     "
tela3Linha21 : string "        OOOOOO            OOOOOOO       "
tela3Linha22 : string "         ~~              OOOOOOOOO     O"
tela3Linha23 : string "     .   ~~               OOOOOOO     OO"
tela3Linha24 : string "         ~~   .             ~~         O"
tela3Linha25 : string "         ~~        .        ~~          "
tela3Linha26 : string "OO                          ~~         "
tela3Linha27 : string "OOO  .                      ~~          "
tela3Linha28 : string "OO                 .                    "
tela3Linha29 : string "~          .                            "

tela5Linha0  : string "                                        "
tela5Linha1  : string "                                        "
tela5Linha2  : string "                                        "
tela5Linha3  : string "                                        "
tela5Linha4  : string "                                        "
tela5Linha5  : string "               GAME OVER                "
tela5Linha6  : string "                                        "
tela5Linha7  : string "                                        "
tela5Linha8  : string "                                        "
tela5Linha9  : string "                                        "
tela5Linha10 : string "                                        "
tela5Linha11 : string "                                        "
tela5Linha12 : string "                                        "
tela5Linha13 : string "                 S / N                  "
tela5Linha14 : string "                                        "
tela5Linha15 : string "                                        "
tela5Linha16 : string "                                        "
tela5Linha17 : string "                                        "
tela5Linha18 : string "                                        "
tela5Linha19 : string "                                        "
tela5Linha20 : string "                                        "
tela5Linha21 : string "                                        "
tela5Linha22 : string "                                        "
tela5Linha23 : string "                                        "
tela5Linha24 : string "                                        "
tela5Linha25 : string "                                        "
tela5Linha26 : string "                                        "
tela5Linha27 : string "                                        "
tela5Linha28 : string "                                        "
tela5Linha29 : string "                                        "

tela11Linha0  : string "                                        "
tela11Linha1  : string "                                        "
tela11Linha2  : string "                                        "
tela11Linha3  : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela11Linha4  : string "                                        "
tela11Linha5  : string "                                        "
tela11Linha6  : string "                                        "
tela11Linha7  : string "                                        "
tela11Linha8  : string "                                        "
tela11Linha9  : string "                                        "                   
tela11Linha10 : string "                                        "               
tela11Linha11 : string "                                        "               
tela11Linha12 : string "                                        "            
tela11Linha13 : string "                                        "                   
tela11Linha14 : string "                                        "                  
tela11Linha15 : string "                                        "
tela11Linha16 : string "                                        "
tela11Linha17 : string "                                        "
tela11Linha18 : string "                                        "
tela11Linha19 : string "                                        "
tela11Linha20 : string "                                        "
tela11Linha21 : string "                                        "
tela11Linha22 : string "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
tela11Linha23 : string "                                        "
tela11Linha24 : string "                                        "
tela11Linha25 : string "                                        "
tela11Linha26 : string "                                        "
tela11Linha27 : string "                                        "
tela11Linha28 : string "                                        "
tela11Linha29 : string "                                        "


