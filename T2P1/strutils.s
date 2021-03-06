@ Descricao: 	Conjunto de funcoes para manipulacão de vetores de caracteres
@		e conversão de bases.
@ Author:	André Lannoy Tavares
@ Data:		11 de maio de 2013
@
.globl my_strlen

.text
@ Implementacao da funcão strlen
@ Parametros:
@	- Ponteiro para uma cadeia de caracteres terminada em \0
@ Saída:
@	- Número de caracteres diferentes de \0 na cadeia de caracteres
@
my_strlen:
	push {lr}

	mov r2, r0
head:
	ldrb r1, [r0], #0x1
	cmp r1, #0x0
	bne head
	
	sub r0, r0, r2
	sub r0, r0, #0x1

	pop {pc}


	@ ###### Valor Absoluto -> Complemento de Dois ######


.text
@ Cálculo do Complemento de dois de um número absoluto
@ Parametros:
@ 	- Número inteiro de 32 bits
@ Saída:
@	- Número inteiro de 32 bits (convertido)

para_comp_dois:
	push {lr}
	mvn r0, r0
	add r0, r0, #1	
	pop {pc}


	@ ###### Complemento de Dois -> Valor Absoluto ######


.text
@ Cálculo de um valor absoluto a partir de um número em Complemento de dois
@ Parametros:
@ 	- Número inteiro de 32 bits
@ Saída:
@	- Número inteiro de 32 bits (convertido)

de_comp_dois:
	push {lr}
	sub r0, r0, #1		
	mvn r0, r0
	pop {pc}	


	@ ###### Valor ASCII -> Valor Numérico ######


.globl my_ctoi

.text
@ Cálculo de um valor numérico a partir de um caracter ASCII
@ Parametros:
@ 	- Endereço para um número inteiro de 32 bits (Valor ASCII)
@ Saída:
@	- Número inteiro de 32 bits

my_ctoi:
	push {lr}

	ldrb r0, [r0]					@ acessa o conteudo do endereço
	mov r1, #0x61					@ 0x61: valor ASCII do 'a'
	cmp r0, r1
	bcc ctoi_not_a 					@ se r0 igual a ou maior que 'a'	
	sub r0, r0, #0x57				@ subtrai um valor tal que 'a'->10, 'b'->11 e assim por diante
	pop {pc}

ctoi_not_a:
	mov r1, #0x41					@ 0x41: valor ASCII do 'A'
	cmp r0, r1
	bcc ctoi_not_A					@ se r0 igual a ou maior que 'A'
	sub r0, r0, #0x37				@ subtrai um valor tal que 'A'->10, 'B'->11 e assim por diante
	pop {pc}	

ctoi_not_A:						@ se o caracter em r0 é válido e é menor que 'A', está entre 0 e 9 
	sub r0, r0, #0x30				@ subtraimos um valor tal que '0'->0, '1'->1 e assim por diante
	pop {pc}


	@ ###### Valor Numérico -> Valor ASCII ######


.text
@ Cálculo de um caracter ASCII partir de um valor numérico 
@ Parametros:
@ 	- Número inteiro de 32 bits 
@ Saída:
@	- Número inteiro de 32 bits (Valor ASCII)

my_itoc:
	push {lr}

	mov r1, #0x09	
	cmp r0, r1
	bcc ctoi_not_a 					@ se r0 igual a ou maior que 10->'A'	
	add r0, r0, #0x57				@ adicionamos um valor tal que 10->'A', 11->'B' e assim por diante
	pop {pc}

itoc_not_a:
	add r0, r0, #0x30				@ adicionamos um valor tal que '0'<-0, '1'<-1 e assim por diante
	pop {pc}	


	@ ###### Cadeia de Hexadecimais -> Inteiro ######


.globl my_ahtoi

.text
@ Implementação da função ahtoi
@ Parametros:
@ 	- Ponteiro para uma cadeia de caracteres com digitos hexadecimais terminada em \0
@ Saída:
@	- Número inteiro de 32 bits (conversão dos caracteres)

my_ahtoi:
	push {lr}
	push {r4, r5}					@ constante da base numérica (16) e flag de negativos 
	mov r4, #0x10
	mov r5, #0

	ldrb r1, [r0]
	mov r2, #0x2D					@ r2 recebe o valor de '-' na tabela ASCII
	cmp r1, r2
	bne ahtoi_count					@ se o primeiro digito for um número, começa o cálculo 
	add r0, r0, #1					@ calcula o próximo endereço
	mov r5, #1					@ marca que o número é negativo

ahtoi_count:
	mov r3, #0					@ inicializa o acumulador
ahtoi_loop:						@ faça
	push {r0, r2, r3}
	bl my_ctoi					@ converte o valor ASCII de r1 para o valor numérico
	mov r1, r0
	pop {r0, r2, r3}
	mul r2, r3, r4					@ multiplica o valor acumulado pela base (16)
	add r3, r2, r1					@ soma o valor recem lido
	add r0, r0, #1					@ calcula o novo endereço
	ldrb r1, [r0]					@ r1 recebe o próximo digito
	cmp r1, #0
	bne ahtoi_loop					@ enquanto str for diferente de '\0'
	mov r0, r3					@ posiciona o resultado no registrador correto

	cmp r5, #0
	beq ahtoi_end
	bl para_comp_dois				@ calcula o complemtento de dois do valor acumulado (transforma em negativo)
	
ahtoi_end:
	pop {r4, r5}		
	pop {pc}


	@ ###### Cadeia de Decimais -> Inteiro ######


.globl my_atoi

.text
@ Implementação da função atoi
@ Parametros:
@ 	- Ponteiro para uma cadeia de caracteres com digitos decimais terminada em \0
@ Saída:
@	- Número inteiro de 32 bits (conversão dos caracteres)

my_atoi:
	push {lr}
	push {r4, r5}					@ constante da base numérica (10) e flag de negativos 
	mov r4, #0x0A
	mov r5, #0

	ldrb r1, [r0]
	mov r2, #0x2D					@ r2 recebe o valor de '-' na tabela ASCII
	cmp r1, r2
	bne atoi_count					@ se o primeiro digito for um número, começa o cálculo 
	add r0, r0, #1					@ calcula o próximo endereço
	mov r5, #1					@ marca que o número é negativo

atoi_count:
	mov r3, #0					@ inicializa o acumulador
atoi_loop:						@ faça
	push {r0, r2, r3}
	bl my_ctoi					@ converte o valor ASCII de r1 para o valor numérico
	mov r1, r0
	pop {r0, r2, r3}
	mul r2, r3, r4					@ multiplica o valor acumulado pela base (16)
	add r3, r2, r1					@ soma o valor recem lido
	add r0, r0, #1					@ calcula o novo endereço
	ldrb r1, [r0]					@ r1 recebe o próximo digito
	cmp r1, #0
	bne atoi_loop					@ enquanto str for diferente de '\0'
	mov r0, r3					@ posiciona o resultado no registrador correto

	cmp r5, #0
	beq atoi_end
	bl para_comp_dois				@ calcula o complemtento de dois do valor acumulado (transforma em negativo)
	
atoi_end:
	pop {r4, r5}		
	pop {pc}


	@ ###### Inteiro -> Cadeia de Hexadecimais ######


.globl my_itoah

.text
@ Implementação da função itoah
@ Parametros:
@ 	- Número inteiro
@	- Endereço de memória a partir do qual uma cadeia de caracteres hexadecimais terminada em \0 deve ser escrita

my_itoah:
	push {lr}
	
	@ >>>>>>>>>>>>>> Copiar my_itoa quando estiver pronta, mudar base de d10 para d16

	pop {pc}


	@ ###### Inteiro -> Cadeia de Decimais ######


.globl my_itoa

.bss 
	result:			.space 100 		@ definimos a string máxima como tendo 100 unidades de comprimento

.text
@ Implementação da função itoa
@ Parametros:
@ 	- Número inteiro
@	- Endereço de memória a partir do qual uma cadeia de caracteres decimais terminada em \0 deve ser escrita
@ Comentário: O algoritmo original incluia duas pilhas: uma na qual colocamos as potências da base (1, 10, 100...) e outra na qual colocamos os algarismos do resultado. Para diminuir a complexidade da implementação, coloquei os algarismos em um vetor de tamanho 100.

my_itoa:
	push {lr}

	push {r4, r5}		@ empilhamos os registradores >= r4

	@ testamos o primeiro bit para saber se o número e negativo
	@ se for, calculamos a volta do complemento de dois
	@ setamos a flag de negativos

	mov r4, #0x0A					@ base 10
	ldr r5, =result					@ r5 será nosso apontador pra "pilha" de resultados
	mov r2, #1					@ pot = 1

itoa_get_pot:						@ enquanto pot for menor que número da entrada
	push {r2} @ str r2, [sp, #-4]!					@ colocamos pot na pilha
	mul r3, r2, r4						
	mov r2, r3						@ pot = pot * base
	cmp r2, r0
	bcc itoa_get_pot

itoa_out_loop:						@ enquanto o número da entrada for diferente que zero
	pop {r2} @ldr r2, [sp], #-4 					@ desempilhamos a próxima potência
	mov r3, #0						@ zeramos o contador de unidades

itoa_in_loop:							@ enquanto o número da entrada for maior que ou igual à potência
	sub r0, r0, r2							@ subtraimos a potência da entrada
	add r3, r3, #1							@ aumentamos o contador de unidades
	cmp r0, r2
	bcs itoa_in_loop
	
	str r3, [r1]						@ adionamos o contador de unidades à lista de resultados
	add r1, r1, #1						@ corrige o apontador da lista de resultados
	cmp r0, #0
	bne itoa_out_loop
	
	
							@ se a flag dos negativos estiver setada
								@ escreve '-' no primeiro digito
								@ aponta para o próximo digito


	mov r3, #0
	str r3, [r1]					@ insere o '\0' no digito atual 

	pop {r4, r5} 		@ desempilhamos os registradores >= r4
  
	pop {pc}


	@ ###### Comparação de Duas Cadeias ######


.globl my_strcmp

.text
@ Implementação da função strcmp
@ Parametros:
@	- Endereço de memória de uma cadeia de caracteres terminada em \0 (em r0)
@	- Endereço de memória de uma cadeia de caracteres terminada em \0 (em r1)
@ Saída:
@ 	- 0 se as cadeias forem iguais, -1 se a primeira for for lexicograficamente menor, 1 se a segunda for lexograficamente menor

my_strcmp:
	push {lr}

comp_loop:						@ faça
	ldrb r2, [r0], #1				@ carrega o próximo caracter da primeira string, atualiza o apontador
	ldrb r3, [r1], #1				@ carrega o próximo caracter da segunda string, atualiza o apontador
	cmp r2, r3
	bne comp					@ sai do loop se str1 não for igual a str2
	cmp r2, #0					@ se r2 == r3 == 0 == '\0', chegamos ao fim, e as strings são iguais
	bne comp_loop					@ se não, repete o loop
	mov r0, #0
	pop {pc}

comp:
	cmp r2, r3					
	bcs comp_1					@ se r2 > r3m retorna 1
	mov r0, #-1 					@ se não, retorna -1
	pop {pc}	

comp_1:
	mov r0, #1
	pop {pc}

