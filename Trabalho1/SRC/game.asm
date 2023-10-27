global game_loop, reset_game
global n_jogadas, vitoria
extern matriz_tabela, jogador_anterior, proximo_jogador
extern verify_winner, match_draw, match_win
extern draw_position, cmd_handler, draw_current_cmd, double_play, clear_character, clear_cmd
extern cmd, cmd_end, prox_posicao, fecha_jogo, reseta_jogo
extern len_campo_input, altura_input


segment code
..start:
game_loop:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

game_loop1:
    cmp word[n_jogadas],9
    je game_draw
    cmp word[vitoria],1
    je game_win
    call cmd_handler
    call draw_current_cmd
    cmp word[cmd_end],1
    je process_cmd
    jmp game_loop1

game_loop_end:
    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

game_draw:
    call match_draw
    jmp game_end

game_win:
    call match_win
    jmp game_end

game_end:
    mov word[cmd_end],0
    call cmd_handler
    call draw_current_cmd
    cmp word[cmd_end],1
    jne game_end
    cmp word[prox_posicao],1
    je verify_c_s2
    jmp game_end

process_cmd:
    cmp word[prox_posicao],1
    je verify_c_s

process_cmd1:
    mov cx,2 ; valor respectivo ao numero de coordenadas, no caso 2 para l e c
    xor si,si

    mov al,[si+cmd]
    push ax
    inc si
stack_cmd:
    mov al,[si+cmd]
    sub al,30h
    push ax
    inc si
    loop stack_cmd

    mov word[cmd_end],0
    mov word[prox_posicao],0

    call draw_position

    mov ax,len_campo_input
    push ax
    mov ax,3
    push ax
    mov ax,altura_input
    push ax
    call clear_character
    call clear_cmd

    call verify_winner

    jmp game_loop1

verify_c_s:
    cmp byte[cmd],'c'
    je c_handler
    cmp byte[cmd],'s'
    je s_handler
    jmp process_cmd1

verify_c_s2:
    cmp byte[cmd],'c'
    je c_handler
    cmp byte[cmd],'s'
    je s_handler
    jmp game_end

c_handler:
    mov word[reseta_jogo],1
    jmp game_loop_end

s_handler:
    mov word[fecha_jogo],1
    jmp game_loop_end

reset_game:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov word[reseta_jogo],0
    mov word[prox_posicao],0
    mov word[cmd_end],0
    mov word[jogador_anterior],' '
    mov word[proximo_jogador],' '
    mov word[n_jogadas],0
    mov word[vitoria],0


    mov cx, 9 ; número de posições na tabela
    xor bx,bx
clear_matrix:
    mov byte[bx+matriz_tabela],' '
    inc bx
    loop clear_matrix

    call clear_cmd

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
; variável responsável por armazenar quantas jogadas foram feitas no jogo
    n_jogadas   dw  0

; variável responsável por armazenar se um jogador venceu a partida
    vitoria     dw  0
segment stack stack
    resb 128
stacktop: