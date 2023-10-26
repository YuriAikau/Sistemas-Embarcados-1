global read_input, cmd_handler, draw_current_cmd
global cmd
global fecha_jogo, cmd_end
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
    mov si,[prox_posicao]

    ; le caractere do teclado e armazena em AL
    mov ah,08h
    int 21h

    ;mov word[cmd_end],1 ;temporario

    ; verifica se a tecla foi backspace
    cmp al,k_backspace
    je backspace_handler

    ; verifica se a tecla foi backspace
    cmp al,k_enter
    je enter_handler

    ; verifica se o comando tem mais que 3 caracteres, ignora os digitados após isso
    cmp word[prox_posicao],2
    ja read_cmd_end

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
    dec word[prox_posicao]
    jmp read_cmd_end

enter_handler:
    mov word[cmd_end],1
    jmp read_cmd_end

draw_current_cmd:
    pushf
    push 		ax
    push 		bx
    push		cx
    push		dx
    push		si
    push		di
    push		bp

    mov cx, 2 ; número de numeros de cmd
    xor bx,bx
    mov dh,0
    mov dl,1
    mov word[cor], branco_intenso

    call	cursor
    mov     al,[bx+cmd]
    call	caracter
    inc     bx			;proximo caracter
    inc		dl			;avanca a coluna

cmd_draw:
    call	cursor
    mov     al,[bx+cmd]
    add     al,30h
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

segment data
; mensagens iniciais
    msg_inicio  db  10,'Jogo da velha x86',10,13,'c (jogo novo) / s (sair): ','$'

; status para saber se o jogo deve fechar
    fecha_jogo  dw  0

; status para saber se o comando foi confirmado
    cmd_end     dw  0

; vetor responsável pelo armazenamento da entrada
    cmd         db  'X',2,2

; variável auxiliar para armazenar a posição no vetor
    prox_posicao   dw  0

; numeros correspondentes ao caracteres na tabela ASCII
    k_backspace   equ 8
    k_enter       equ 13

segment stack stack
    resb 128
stacktop: