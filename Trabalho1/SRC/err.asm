global invalid_player, double_play, invalid_position, clear_header
extern cursor, caracter
extern proximo_jogador
extern cor, branco_intenso, amarelo, vermelho, azul

segment code
..start:

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
    mov word[cor], azul

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
    mov word[cor], vermelho
    jmp next_player_draw
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

; limpa o cabeçalho antes de escrever nele
clear_header:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push        bp
    mov cx, 58 ; número de caracteres possíveis na mensagem de erro
    xor bx,bx
    mov dh,27
    mov dl,22
    mov word[cor], branco_intenso

clearer:
    call	cursor
    mov     al,' '
    call	caracter
    inc		dl			;avanca a coluna
    loop    clearer

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

segment data
; mensagens de status
    jogada_dupla        db      'Voce ja jogou, vez do jogador '
    jogador_invalido    db      'Jogador invalido!'
    posicao_invalida    db      'Posicao invalida!'

segment stack stack
    resb 512
stacktop: