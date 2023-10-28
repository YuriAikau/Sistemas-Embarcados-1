global verify_winner, match_win
extern line, cursor, caracter
extern cor, verde_claro, cyan_claro, magenta_claro
extern offset_tabela_x, offset_tabela_y, fim_tabela_x, fim_tabela_y
extern matriz_tabela, jogador_anterior, vitoria
segment code
..start:

; função responsável por verificar se uma jogada vence a partida
verify_winner:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

; checa a primeira linha
cond1:
    mov al,byte[matriz_tabela+0]
    cmp ax, [jogador_anterior]
    jne cond2
    mov al,byte[matriz_tabela+1]
    cmp ax, [jogador_anterior]
    jne cond2
    mov al,byte[matriz_tabela+2]
    cmp ax, [jogador_anterior]
    jne cond2
    call draw_win1
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a segunda linha
cond2:
    mov al,byte[matriz_tabela+3]
    cmp ax, [jogador_anterior]
    jne cond3
    mov al,byte[matriz_tabela+4]
    cmp ax, [jogador_anterior]
    jne cond3
    mov al,byte[matriz_tabela+5]
    cmp ax, [jogador_anterior]
    jne cond3
    call draw_win2
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a terceira linha
cond3:
    mov al,byte[matriz_tabela+6]
    cmp ax, [jogador_anterior]
    jne cond4
    mov al,byte[matriz_tabela+7]
    cmp ax, [jogador_anterior]
    jne cond4
    mov al,byte[matriz_tabela+8]
    cmp ax, [jogador_anterior]
    jne cond4
    call draw_win3
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a primeira coluna
cond4:
    mov al,byte[matriz_tabela+0]
    cmp ax, [jogador_anterior]
    jne cond5
    mov al,byte[matriz_tabela+3]
    cmp ax, [jogador_anterior]
    jne cond5
    mov al,byte[matriz_tabela+6]
    cmp ax, [jogador_anterior]
    jne cond5
    call draw_win4
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a segunda coluna
cond5:
    mov al,byte[matriz_tabela+1]
    cmp ax, [jogador_anterior]
    jne cond6
    mov al,byte[matriz_tabela+4]
    cmp ax, [jogador_anterior]
    jne cond6
    mov al,byte[matriz_tabela+7]
    cmp ax, [jogador_anterior]
    jne cond6
    call draw_win5
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a terceira coluna
cond6:
    mov al,byte[matriz_tabela+2]
    cmp ax, [jogador_anterior]
    jne cond7
    mov al,byte[matriz_tabela+5]
    cmp ax, [jogador_anterior]
    jne cond7
    mov al,byte[matriz_tabela+8]
    cmp ax, [jogador_anterior]
    jne cond7
    call draw_win6
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a diagonal principal
cond7:
    mov al,byte[matriz_tabela+0]
    cmp ax, [jogador_anterior]
    jne cond8
    mov al,byte[matriz_tabela+4]
    cmp ax, [jogador_anterior]
    jne cond8
    mov al,byte[matriz_tabela+8]
    cmp ax, [jogador_anterior]
    jne cond8
    call draw_win7
    mov word[vitoria],1
    jmp verify_winner_end

;verifica a diagonal secundaria
cond8:
    mov al,byte[matriz_tabela+2]
    cmp ax, [jogador_anterior]
    jne verify_winner_end
    mov al,byte[matriz_tabela+4]
    cmp ax, [jogador_anterior]
    jne verify_winner_end
    mov al,byte[matriz_tabela+6]
    cmp ax, [jogador_anterior]
    jne verify_winner_end
    call draw_win8
    mov word[vitoria],1

verify_winner_end:
    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret
draw_win1:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x
    push ax ; x1 da função line
    mov ax,offset_tabela_y+275 ; 2*altura+altura/2
    mov dx,ax
    push ax ; y1 da função line

    mov ax,fim_tabela_x
    push ax ; x2 da função line
    mov ax,dx
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win2:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x
    push ax ; x1 da função line
    mov ax,offset_tabela_y+165 ; altura+altura/2
    mov dx,ax
    push ax ; y1 da função line

    mov ax,fim_tabela_x
    push ax ; x2 da função line
    mov ax,dx
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win3:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x
    push ax ; x1 da função line
    mov ax,offset_tabela_y+55 ; altura/2
    mov dx,ax
    push ax ; y1 da função line

    mov ax,fim_tabela_x
    push ax ; x2 da função line
    mov ax,dx
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win4:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x+100 ; largura/2
    mov dx,ax
    push ax ; x1 da função line
    mov ax,offset_tabela_y
    push ax ; y1 da função line

    mov ax,dx
    push ax ; x2 da função line
    mov ax,fim_tabela_y
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win5:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x+300 ; largura+largura/2
    mov dx,ax
    push ax ; x1 da função line
    mov ax,offset_tabela_y
    push ax ; y1 da função line

    mov ax,dx
    push ax ; x2 da função line
    mov ax,fim_tabela_y
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win6:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x+500 ; 2*largura+largura/2
    mov dx,ax
    push ax ; x1 da função line
    mov ax,offset_tabela_y
    push ax ; y1 da função line

    mov ax,dx
    push ax ; x2 da função line
    mov ax,fim_tabela_y
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win7:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x
    push ax ; x1 da função line
    mov ax,fim_tabela_y
    push ax ; y1 da função line

    mov ax,fim_tabela_x
    push ax ; x2 da função line
    mov ax,offset_tabela_y
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

draw_win8:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[cor], verde_claro

    mov ax,offset_tabela_x
    push ax ; x1 da função line
    mov ax,offset_tabela_y
    push ax ; y1 da função line

    mov ax,fim_tabela_x
    push ax ; x2 da função line
    mov ax,fim_tabela_y
    push ax ; y1 da função line

    call line

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

; função responsável por escrever a mensagem de vitória
; e o vencedor da partida
match_win:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, len_msg_vitoria ; número de caracteres na mensagem de vitória
    xor bx,bx
    mov dh,27
    mov dl,22
    mov word[cor], verde_claro

match_win1:
    call	cursor
    mov     al,[bx+msg_vitoria]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    match_win1

    cmp word[jogador_anterior],'X'
    je color_x
    mov word[cor], cyan_claro

; escreve o caractere do ganhador após a mensagem de vitória
winner_draw:
    call	cursor
    mov     al,[jogador_anterior]
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

color_x:
    mov word[cor], magenta_claro
    jmp winner_draw
segment data
; mensagem de vitória
    msg_vitoria     db      'Vitoria do jogador '
    len_msg_vitoria equ     19
segment stack stack
stacktop