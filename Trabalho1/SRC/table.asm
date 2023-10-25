extern circle, line, cursor, caracter
extern invalid_player, double_play, invalid_position, clear_header
extern cor, azul, vermelho, branco_intenso, amarelo
global draw_table, draw_position
global proximo_jogador
segment code
..start:

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

    mov cx, 18 ; número de caracteres na mensagem "Campo de comando: "
    xor bx,bx
    mov dh,25
    mov dl,2
    mov word[cor], branco_intenso

draw_cmd:
    call	cursor
    mov     al,[bx+campo_cmd]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    draw_cmd

    mov cx, 20 ; número de caracteres na mensagem "Campo de mensagens: "
    xor bx,bx
    mov dh,27
    mov dl,2
    mov word[cor], branco_intenso

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
;   funcao desenha_posicao
;   push symbol; push x; push y; call draw_position; (0<=x<=2) e (0<=y<=2)
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

    mov ax,[bp+4] ;posicao c da tabela (0-2)
    cmp ax,3
    ja invalid_pos
    cmp ax,1
    jb invalid_pos

    mov ax,[bp+6] ;posicao l da tabela (0-2)
    cmp ax,3
    ja invalid_pos
    cmp ax,1
    jb invalid_pos

    call clear_header
    mov ax,[bp+8] ;caractere ASCII correspondente ao símbolo a ser desenhado
    cmp ax,[jogador_anterior]
    je double_play_jmp

    cmp ax,'X'
    je draw_ecks1
    cmp ax,'O'
    je draw_circle1

    call invalid_player

    jmp draw_position_end

draw_ecks1:
    jmp draw_ecks

draw_circle1:
    jmp draw_circle

double_play_jmp:
    call double_play

    jmp draw_position_end

invalid_pos:
    call invalid_position
    jmp draw_position_end
draw_circle:
    mov ax,[bp+4] ;posicao c da tabela (0-2)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+(largura_x/2)
    push ax

    mov ax,[bp+6] ;posicao l da tabela (0-2)
    dec ax
    mov bl,altura_y
    mul bl
    add ax,margem_y+(altura_y/2)
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx

    mov word[cor], azul
    mov ax,(altura_y/2)-offset_quadrado_y
    push ax

    call circle

    mov ax,'O'
    mov word[jogador_anterior],ax
    mov ax,'X'
    mov word[proximo_jogador],ax

    jmp draw_position_end

draw_ecks:
    mov word[cor], vermelho
; desenhando a primeira "barra" do X
    mov ax,[bp+4] ;posicao c da tabela (0-2)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+offset_quadrado_x
    push ax ; posicao x1 da função line

    mov ax,[bp+6] ;posicao l da tabela (0-2)
    dec ax
    mov bl,altura_y
    mul bl
    add ax,margem_y+offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y1 da função line

    mov ax,[bp+4] ;posicao c da tabela (0-2)
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x-offset_quadrado_x
    push ax ; posicao x2 da função line

    mov ax,[bp+6] ;posicao l da tabela (0-2)
    mov bl,altura_y
    mul bl
    add ax,margem_y-offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y2 da função line

    call line

; desenhando a segunda "barra" do X
    mov ax,[bp+4] ;posicao c da tabela (0-2)
    dec ax
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+offset_quadrado_x
    push ax ; posicao x1 da função line

    mov ax,[bp+6] ;posicao l da tabela (0-2)
    mov bl,altura_y
    mul bl
    add ax,margem_y-offset_quadrado_y
    xor bx,bx
    mov bx,479
    sub bx,ax
    push bx ; posicao y1 da função line

    mov ax,[bp+4] ;posicao c da tabela (0-2)
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x-offset_quadrado_x
    push ax ; posicao x2 da função line

    mov ax,[bp+6] ;posicao l da tabela (0-2)
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
    mov ax,'O'
    mov word[proximo_jogador],ax

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
;coordenadas do inicio (canto inferior esquerdo) e do fim (canto superior direito) da tabela do jogo da velha
    offset_tabela_x     equ     20
    offset_tabela_y     equ     120
    margem_y            equ     30
    fim_tabela_x        equ     620
    fim_tabela_y        equ     450

; dimensoes e offsets de cada quadradinho do jogo da velha
    offset_quadrado_x   equ     10
    offset_quadrado_y   equ     10
    largura_x           equ     200
    altura_y            equ     110

; vez do jogador anterior
    jogador_anterior    dw      ' '
    proximo_jogador     dw      ' '

; valores possíveis de linhas e colunas
    n_linhas_colunas    db      '1','2','3'

; strings pertencentes à tela
    campo_cmd           db      'Campo de comando: '
    campo_msg           db      'Campo de mensagens: '

segment stack stack
    resb 128
stacktop: