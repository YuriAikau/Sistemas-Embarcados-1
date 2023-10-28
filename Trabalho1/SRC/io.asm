global read_input, cmd_handler, draw_current_cmd, draw_previous_cmd, clear_cmd
global cmd
global fecha_jogo, reseta_jogo, cmd_end, prox_posicao
extern cursor, caracter
extern cor, branco_intenso

segment code
..start:

read_input:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov ah,09h
    mov dx,msg_inicio
    int 21h

    mov ah,01h
    int 21h

    cmp al,'s'
    je end_game
    cmp al,'c'
    jne read_input

read_input_end:
    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

end_game:
    mov word[fecha_jogo],1
    jmp read_input_end

; função responsável por registar os comandos digitados na variável cmd
; ou modificar o estado do comando (no caso o backspace apaga um caracter
; e enter termina o comando).
cmd_handler:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

read_cmd:
    mov si,[prox_posicao] ; avança a referência da posição no vetor cmd

    ; le caractere do teclado e armazena em AL
    mov ah,07h
    int 21h

    ; verifica se a tecla foi backspace
    cmp al,k_backspace
    je backspace_handler

    ; verifica se a tecla foi backspace
    cmp al,k_enter
    je enter_handler

    ; verifica se o comando tem mais que 3 caracteres, ignora os digitados após isso
    cmp word[prox_posicao],2
    ja read_cmd_end

; escreve o caracter no vetor cmd
save_char:
    mov [si+cmd],al
    inc word[prox_posicao]

read_cmd_end:
    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

; decrementa a posição do vetor e "apaga o valor na posição"
backspace_handler:
    dec si
    mov byte[si+cmd],' '
    cmp word[prox_posicao],0
    je read_cmd_end
    dec word[prox_posicao]
    jmp read_cmd_end

; caso seja apertado enter o comando é finalizado
enter_handler:
    mov word[cmd_end],1
    jmp read_cmd_end

; escreve o comando atual na tela
draw_current_cmd:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 3 ; número de caracteres no cmd
    xor bx,bx
    mov dh,0
    mov dl,24
    mov word[cor], branco_intenso

cmd_draw:
    call	cursor
    mov     al,[bx+cmd]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    cmd_draw

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

; função responsável por escrever o comando anterior na tela
draw_previous_cmd:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 3 ; número de caracteres no cmd
    xor bx,bx
    mov dh,25
    mov dl,20

cmd_draw1:
    call	cursor
    mov     al,[bx+cmd]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna
    loop    cmd_draw1

    pop		bp
    pop		di
    pop		si
    pop		dx
    pop		cx
    pop		bx
    pop		ax
    popf
    ret

; função responsável por limpar o campo de comandos
clear_cmd:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx,3
    xor bx,bx
clear_cmd1:
    mov byte[bx+cmd],' '
    inc bx
    loop clear_cmd1

    call draw_current_cmd

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
; mensagens iniciais
    msg_inicio  db  10,'Jogo da velha x86',10,13,'c (jogo novo) / s (sair): ','$'

; status para saber se o jogo deve fechar ou resetar
    fecha_jogo  dw  0
    reseta_jogo dw  0

; status para saber se o comando foi confirmado
    cmd_end     dw  0

; vetor responsável pelo armazenamento da entrada
    cmd         db  ' ',' ',' '

; variável auxiliar para armazenar a posição no vetor
    prox_posicao   dw  0

; numeros correspondentes ao caracteres na tabela ASCII
    k_backspace equ 8
    k_enter     equ 13

segment stack stack
    resb 128
stacktop: