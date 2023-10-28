global game_loop, reset_game
global n_jogadas, vitoria
extern matriz_tabela, jogador_anterior, proximo_jogador
extern verify_winner, match_draw, match_win
extern draw_position, cmd_handler, draw_current_cmd, double_play, clear_character, clear_cmd
extern cmd, cmd_end, prox_posicao, fecha_jogo, reseta_jogo
extern len_campo_input, altura_input


segment code
..start:
; função responsável por manter o loop principal do jogo rodando
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
; verfica se algum dos jogadores venceu
    cmp word[vitoria],1
    je game_win
; verifica se 9 jogadas já foram feitas, já que nesse caso
; se não houve nenhum vencedor isso significa que houve um
; empate
    cmp word[n_jogadas],9
    je game_draw
    call cmd_handler ; tratador da entrada dos comandos
    call draw_current_cmd ; desenha o comando na tela (quality of life)
    cmp word[cmd_end],1 ; caso o jogador pressiona enter, cmd_end = 1
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
    call match_draw ; imprime a mensagem de empate na tela
    jmp game_end

game_win:
    call match_win ; imprime a mensagem de vitória na tela
    jmp game_end

; quando o jogo acaba, tanto em empate como vitória, espera o jogador
; digitar 'c' ou 's' suas respectivas ações de novo jogo e sair.
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
    je verify_c_s ; verifica se o comando é composto somente de um 'c' ou 's'

; prepara a passagem de parâmetros para a função draw_position
process_cmd1:
    mov cx,2 ; valor respectivo ao numero de coordenadas, no caso 2 para l e c
    xor si,si

    mov al,[si+cmd]
    push ax
    inc si
stack_cmd:
    mov al,[si+cmd]
    sub al,30h ; ajuste do valor na tabela ascii para seu valor decimal (se for um número)
    push ax
    inc si
    loop stack_cmd

    mov word[cmd_end],0
    mov word[prox_posicao],0

    call draw_position ; faz todas as verificações para ver se o comando é válido

; limpeza de caracteres de comando e do comando em si
    mov ax,len_campo_input
    push ax
    mov ax,3
    push ax
    mov ax,altura_input
    push ax
    call clear_character
    call clear_cmd

    call verify_winner ; verifica se a jogada atual determina a vitória do jogador

    jmp game_loop1 ; retorna para receber mais comandos

; verifica se o primeiro caractere do comando é 'c' ou 's', se não volta para o loop
verify_c_s:
    cmp byte[cmd],'c'
    je c_handler
    cmp byte[cmd],'s'
    je s_handler
    jmp process_cmd1

; idem a função anterior mas essa é para quando o jogo finaliza
verify_c_s2:
    cmp byte[cmd],'c'
    je c_handler
    cmp byte[cmd],'s'
    je s_handler
    jmp game_end

c_handler:
    mov word[reseta_jogo],1 ; se for 'c' o jogo deve reiniciar
    jmp game_loop_end

s_handler:
    mov word[fecha_jogo],1 ; se for 's' o jogo deve fechar
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

; limpa todas as variáveis para suas condições iniciais
    mov word[reseta_jogo],0
    mov word[prox_posicao],0
    mov word[cmd_end],0
    mov word[jogador_anterior],' '
    mov word[proximo_jogador],' '
    mov word[n_jogadas],0
    mov word[vitoria],0

    mov cx, 9 ; número de posições na tabela
    xor bx,bx
; limpa a matriz que representa a tabela na memória
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