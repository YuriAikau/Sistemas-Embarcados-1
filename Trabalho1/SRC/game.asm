global game_loop, reset_game
global n_jogadas
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

    jmp game_loop1

verify_c_s:
    cmp byte[cmd],'c'
    je c_handler
    cmp byte[cmd],'s'
    je s_handler
    jmp process_cmd1

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
segment stack stack
    resb 128
stacktop: