; Yuri Aikau de Castro Reis Sanchez
; Turma: 05.1N

; última alteração: 28/10/2023
extern draw_table, draw_position
extern modo_anterior
extern read_input, cmd_handler
extern fecha_jogo, cmd_end
extern game_loop, reset_game
extern fecha_jogo, reseta_jogo

segment code
..start:
    mov 		ax,data
    mov 		ds,ax
    mov 		ax,stack
    mov 		ss,ax
    mov 		sp,stacktop

    call read_input
    cmp word[fecha_jogo],1
    je main_end

game_start:
; salvar modo corrente de video(vendo como está o modo de video da maquina)
    mov  		ah,0Fh
    int  		10h
    mov  		[modo_anterior],al   

; alterar modo de video para gráfico 640x480 16 cores
    mov     	al,12h
    mov     	ah,0
    int     	10h

    call draw_table ; desenha a tabela na tela

    call game_loop ; loop principal do jogo

    mov  	ah,0   			; set video mode
    mov  	al,[modo_anterior]   	; modo anterior
    int  	10h

    cmp word[fecha_jogo],1
    je main_end
    cmp word[reseta_jogo],1
    je game_reset
main_end:
    mov     ax,4c00h
    int     21h

game_reset:
    call reset_game
    jmp game_start
segment data


segment stack stack
	resb 		512
stacktop: