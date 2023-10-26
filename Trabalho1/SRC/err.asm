global invalid_player, double_play, invalid_position, clear_character
extern cursor, caracter
extern proximo_jogador
extern cor, branco_intenso, amarelo, magenta_claro, cyan_claro

segment code
..start:

; função responsável por escrever o erro na tela correspondente ao jogador ser inválido
invalid_player:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 17 ; número de caracteres na mensagem de erro
    xor bx,bx
    mov dh,27
    mov dl,22
    mov word[cor], amarelo

err_invalid_player:
    call	cursor
    mov     al,[bx+jogador_invalido]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    err_invalid_player

    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    pop		bp
    ret

; função responsável por escrever o erro na tela correspondente ao jogador tentar jogar 2 vezes seguidas
double_play:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 30 ; número de caracteres na mensagem de erro
    xor bx,bx
    mov dh,27
    mov dl,22
    mov word[cor], branco_intenso

err_dup_play:
    call	cursor
    mov     al,[bx+jogada_dupla]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    err_dup_play

    cmp word[proximo_jogador],'X'
    je red_x
    mov word[cor], cyan_claro

next_player_draw
    call	cursor
    mov     al,[proximo_jogador]
    call	caracter

    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    pop		bp
    ret

red_x:
    mov word[cor], magenta_claro
    jmp next_player_draw

; função responsável por escrever o erro na tela correspondente à posição na tabela se inválida
invalid_position:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 17 ; número de caracteres na mensagem de erro
    xor bx,bx
    mov dh,27
    mov dl,22
    mov word[cor], amarelo

err_invalid_position:
    call	cursor
    mov     al,[bx+posicao_invalida]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    err_invalid_position

    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    pop		bp
    ret

; limpa todos os caracteres de uma linha que não sejam parte do texto da tabela
; push offset_caracteres,push n_caracteres; push altura_linha; call clear_character
clear_character:
    push        bp
    mov         bp,sp
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di

    mov ax,[bp+8] ; recupera o número de caracteres "permanentes" da linha

    and ax,00FFh
    add al,2
    mov dl,al

    mov ax,[bp+6] ; recupera o numero de caracteres a serem apagados
    mov cx,ax

    mov ax,[bp+4] ; valor correspondente ao número da linha
    and ax,00FFh
    mov dh,al
    mov word[cor], branco_intenso

clearer:
    call	cursor
    mov     al,' '
    call	caracter
    inc		dl			;avanca a coluna
    loop    clearer

    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    pop		bp
    ret     6

segment data
; mensagens de status
    jogada_dupla        db      'Voce ja jogou, vez do jogador '
    jogador_invalido    db      'Jogador invalido!'
    posicao_invalida    db      'Posicao invalida!'

segment stack stack
    resb 512
stacktop: