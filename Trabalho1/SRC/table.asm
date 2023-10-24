extern circle, line, cursor, caracter
extern invalid_player, double_play, clear_header
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
    mov		ax,170
    push		ax
    mov		ax,fim_tabela_x
    push		ax
    mov		ax,170
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,offset_tabela_x
    push		ax
    mov		ax,310
    push		ax
    mov		ax,fim_tabela_x
    push		ax
    mov		ax,310
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,220
    push		ax
    mov		ax,offset_tabela_y
    push		ax
    mov		ax,220
    push		ax
    mov		ax,fim_tabela_y
    push		ax
    call		line

    mov		word[cor],branco_intenso
    mov		ax,420
    push		ax
    mov		ax,offset_tabela_y
    push		ax
    mov		ax,420
    push		ax
    mov		ax,fim_tabela_y
    push		ax
    call		line

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

draw_circle:
    mov ax,[bp+6] ;posicao x da tabela (0-2)
    mov bl,largura_x
    mul bl
    add ax,offset_tabela_x+(largura_x/2)
    push ax

    mov ax,[bp+4] ;posicao y da tabela (0-2)
    mov bl,altura_y
    mul bl
    add ax,offset_tabela_y+(altura_y/2)
    push ax

    mov word[cor], azul
    mov ax,(altura_y/2)-20
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
    mov ax,[bp+6] ;posicao x da tabela (0-2)
    mov bl,largura_x
    mul bl
    add ax,2*offset_tabela_x
    push ax ; posicao x1 da função line

    mov ax,[bp+4] ;posicao y da tabela (0-2)
    mov bl,altura_y
    mul bl
    add ax,2*offset_tabela_y
    push ax ; posicao y1 da função line

    mov ax,[bp+6] ;posicao x da tabela (0-2)
    inc ax ; pega o final do "quadradinho" da posição atual
    mov bl,largura_x
    mul bl
    push ax ; posicao x2 da função line

    mov ax,[bp+4] ;posicao y da tabela (0-2)
    inc ax ; pega o final do "quadradinho" da posição atual
    mov bl,altura_y
    mul bl
    push ax ; posicao y2 da função line

    call line

; desenhando a segunda "barra" do X
    mov ax,[bp+6] ;posicao x da tabela (0-2)
    mov bl,largura_x
    mul bl
    add ax,2*offset_tabela_x
    push ax ; posicao x1 da função line

    mov ax,[bp+4] ;posicao y da tabela (0-2)
    inc ax ; pega o canto superior esquerdo do "quadradinho"
    mov bl,altura_y
    mul bl
    push ax ; posicao y1 da função line

    mov ax,[bp+6] ;posicao x da tabela (0-2)
    inc ax ; pega o final do "quadradinho" da posição atual
    mov bl,largura_x
    mul bl
    push ax ; posicao x2 da função line

    mov ax,[bp+4] ;posicao y da tabela (0-2)
    mov bl,altura_y
    mul bl
    add ax, 2*offset_tabela_y
    push ax ; posicao y2 da função line

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
    offset_tabela_y     equ     30
    fim_tabela_x        equ     620
    fim_tabela_y        equ     450

; dimensoes de cada quadradinho do jogo da velha
    largura_x           equ     200
    altura_y            equ     140

; vez do jogador anterior
    jogador_anterior    dw      ' '
    proximo_jogador     dw      ' '

segment stack stack
    resb 128
stacktop: