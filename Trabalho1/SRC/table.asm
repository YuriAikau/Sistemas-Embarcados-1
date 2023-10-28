global draw_table, draw_position
global proximo_jogador, jogador_anterior, matriz_tabela
global len_campo_input, altura_input
global offset_tabela_x, offset_tabela_y, fim_tabela_x, fim_tabela_y, largura_x, altura_y
extern circle, line, cursor, caracter
extern invalid_player, double_play, invalid_position, position_filled, clear_character, draw_previous_cmd, clear_cmd
extern cor, cyan_claro, magenta_claro, branco_intenso, amarelo
extern n_jogadas
segment code
..start:

; função responsável por desenhar a tabela na tela (senhanhar '#')
draw_table:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    ; desenhando o fundo do jogo da velha
    mov		word[cor],branco_intenso
    mov		ax,offset_tabela_x
    push		ax
    mov		ax,offset_tabela_y+altura_y
    push		ax
    mov		ax,fim_tabela_x
    push		ax
    mov		ax,offset_tabela_y+altura_y
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,offset_tabela_x
    push		ax
    mov		ax,offset_tabela_y+2*altura_y
    push		ax
    mov		ax,fim_tabela_x
    push		ax
    mov		ax,offset_tabela_y+2*altura_y
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,offset_tabela_x+largura_x
    push		ax
    mov		ax,offset_tabela_y
    push		ax
    mov		ax,offset_tabela_x+largura_x
    push		ax
    mov		ax,fim_tabela_y
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,offset_tabela_x+2*largura_x
    push		ax
    mov		ax,offset_tabela_y
    push		ax
    mov		ax,offset_tabela_x+2*largura_x
    push		ax
    mov		ax,fim_tabela_y
    push		ax
    call		line

; escreve a posição das linhas
    mov cx, 3 ; número de linhas
    xor bx,bx
    mov dh,5
    mov dl,0
    mov word[cor], branco_intenso
line_number:
    call	cursor
    mov     al,[bx+n_linhas_colunas]
    call	caracter
    inc     bx			;proximo caracter
    add		dh,	7		;proxima linha
    loop    line_number

; escreve a posição das linhas
    mov cx, 3 ; número de colunas
    xor bx,bx
    mov dh,23
    mov dl,13
    mov word[cor], branco_intenso
column_number:
    call	cursor
    mov     al,[bx+n_linhas_colunas]
    call	caracter
    inc     bx			;proximo caracter
    add		dl,	26		;proxima linha
    loop    column_number

; desenhando o texto do campo de input
    mov cx, len_campo_input ; número de caracteres na mensagem "Campo de comando: "
    xor bx,bx
    mov dh,altura_input
    mov dl,2
    mov word[cor], branco_intenso

draw_input:
    call	cursor
    mov     al,[bx+campo_input]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    draw_input

    mov cx, len_campo_cmd ; número de caracteres na mensagem "Campo de comando: "
    xor bx,bx
    mov dh,altura_cmd
    mov dl,2
    mov word[cor], branco_intenso

; desenhando o texto do campo de comandos anteriores
draw_cmd:
    call	cursor
    mov     al,[bx+campo_cmd]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    draw_cmd

    mov cx, len_campo_msg ; número de caracteres na mensagem "Campo de mensagens: "
    xor bx,bx
    mov dh,altura_msg
    mov dl,2
    mov word[cor], branco_intenso

; desenhando o texto do campo das mensagens de status
draw_msg:
    call	cursor
    mov     al,[bx+campo_msg]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    draw_msg

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

;_____________________________________________________________________________
;   funcao responsável por desenhar 'X' ou 'O' na posição adequada da tabela
;   push symbol; push l; push c; call draw_position; (1<=l<=3) e (1<=c<=3)
draw_position:
    push bp
    mov bp,sp
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di

; limpa o campo de mensagens de status antes de fazer qualquer coisa
    mov ax,len_campo_msg
    push ax
    mov ax,50
    push ax
    mov ax,altura_msg
    push ax
    call clear_character

; verificação dos limites da tabela
    mov ax,[bp+4] ;posicao c da tabela (1-3)
    cmp ax,3
    ja invalid_pos
    cmp ax,1
    jb invalid_pos

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    cmp ax,3
    ja invalid_pos
    cmp ax,1
    jb invalid_pos

; verificação se a posição em questão já não foi ocupada
    mov ax,[bp+6] ; linha da tabela
    dec ax
    and ax,00FFh
    mov bl,3
    mul bl
    xor bx,bx
    mov bx,[bp+4] ; coluna da tabela
    dec bx
    add bx,ax
    cmp byte[bx+matriz_tabela],' '
    jne filled_position
draw_position1:
; verifica se um jogador está tentando jogar duas vezes seguidas
    mov ax,[bp+8] ;caractere ASCII correspondente ao símbolo a ser desenhado
    cmp ax,[jogador_anterior]
    je double_play_jmp

; verifica qual símbolo deve ser desenhado
    cmp ax,'X'
    je draw_ecks1
    cmp ax,'C'
    je draw_circle1

; caso a verificação anterior falhe, significa que o jogador é inválido
    call invalid_player

    jmp draw_position_end

draw_ecks1:
    mov word[cor], magenta_claro
    call draw_previous_cmd
    call clear_cmd
    jmp draw_ecks

draw_circle1:
    mov word[cor], cyan_claro
    call draw_previous_cmd
    call clear_cmd
    jmp draw_circle

double_play_jmp:
    call double_play

    jmp draw_position_end

invalid_pos:
    call invalid_position
    jmp draw_position_end

filled_position:
    call position_filled
    jmp draw_position_end

; desenha o círculo na tabela
draw_circle:
    mov word[cor], cyan_claro
    mov ax,[bp+6] ; linha da tabela
    dec ax
    and ax,00FFh
    mov bl,3
    mul bl
    xor bx,bx
    mov bx,[bp+4] ; coluna da tabela
    dec bx
    add bx,ax
    mov byte[bx+matriz_tabela],'C'

    mov ax,[bp+4] ;posicao c da tabela (1-3)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+(largura_x/2)
    push ax

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    dec ax
    mov bl,altura_y
    mul bl
    add ax,margem_y+(altura_y/2)
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx

    mov ax,(altura_y/2)-offset_quadrado_y
    push ax

    call circle

    mov ax,'C'
    mov word[jogador_anterior],ax
    mov ax,'X'
    mov word[proximo_jogador],ax

    inc word[n_jogadas]

    jmp draw_position_end

; desenha o xis na tabela
draw_ecks:
    mov word[cor], magenta_claro
    mov ax,[bp+6] ; linha da tabela
    dec ax
    and ax,00FFh
    mov bl,3
    mul bl
    xor bx,bx
    mov bx,[bp+4] ; coluna da tabela
    dec bx
    add bx,ax
    mov byte[bx+matriz_tabela],'X'

; desenhando a primeira "barra" do X
    mov ax,[bp+4] ;posicao c da tabela (1-3)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+offset_quadrado_x
    push ax ; posicao x1 da função line

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    dec ax
    mov bl,altura_y
    mul bl
    add ax,margem_y+offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y1 da função line

    mov ax,[bp+4] ;posicao c da tabela (1-3)
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x-offset_quadrado_x
    push ax ; posicao x2 da função line

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    mov bl,altura_y
    mul bl
    add ax,margem_y-offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y2 da função line

    call line

; desenhando a segunda "barra" do X
    mov ax,[bp+4] ;posicao c da tabela (1-3)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+offset_quadrado_x
    push ax ; posicao x1 da função line

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    mov bl,altura_y
    mul bl
    add ax,margem_y-offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y1 da função line

    mov ax,[bp+4] ;posicao c da tabela (1-3)
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x-offset_quadrado_x
    push ax ; posicao x2 da função line

    mov ax,[bp+6] ;posicao l da tabela (1-3)
    dec ax
    mov bl,altura_y
    mul bl
    add ax, margem_y+offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y2 da função line

    call line

    mov ax,'X'
    mov word[jogador_anterior],ax
    mov ax,'C'
    mov word[proximo_jogador],ax

    inc word[n_jogadas]

    jmp draw_position_end

draw_position_end:
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    pop		bp
    ret 6

segment data
; coordenadas do inicio (canto inferior esquerdo) e do fim (canto superior direito) da tabela do jogo da velha
    offset_tabela_x     equ     20
    offset_tabela_y     equ     120
    fim_tabela_x        equ     620
    fim_tabela_y        equ     450
    margem_y            equ     30

; dimensoes e offsets de cada quadradinho do jogo da velha
    offset_quadrado_x   equ     10
    offset_quadrado_y   equ     10
    largura_x           equ     200
    altura_y            equ     110

; matriz que representa o tabuleiro na memória
    matriz_tabela       db      ' ',' ',' ',' ',' ',' ',' ',' ',' '

; vez do jogador anterior
    jogador_anterior    dw      ' '
    proximo_jogador     dw      ' '

; valores possíveis de linhas e colunas
    n_linhas_colunas    db      '1','2','3'

; strings pertencentes à tela
    campo_input         db      'Digite o seu comando: '
    len_campo_input     equ     22
    altura_input        equ     0
    campo_cmd           db      'Campo de comando: '
    len_campo_cmd       equ     18
    altura_cmd          equ     25
    campo_msg           db      'Campo de mensagens: '
    len_campo_msg       equ     20
    altura_msg          equ     27

segment stack stack
    resb 128
stacktop: