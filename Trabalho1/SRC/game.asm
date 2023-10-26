global game_loop
global n_jogadas
extern draw_position, cmd_handler, draw_current_cmd
extern cmd, cmd_end

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

    call cmd_handler
    call draw_current_cmd
    cmp word[cmd_end],1
    je process_cmd
    jmp game_loop

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
    mov cx,3 ; número de caracteres em um comando
    xor si,si
stack_cmd:
    mov al,[si+cmd]
    push ax
    inc si
    loop stack_cmd

    call draw_position

segment data
; variável responsável por armazenar quantas jogadas foram feitas no jogo
    n_jogadas   dw  0
segment stack stack
    resb 128
stacktop: