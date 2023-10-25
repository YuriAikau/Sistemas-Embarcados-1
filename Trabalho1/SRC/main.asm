extern draw_table, draw_position
extern modo_anterior

segment code
..start:
    mov 		ax,data
    mov 		ds,ax
    mov 		ax,stack
    mov 		ss,ax
    mov 		sp,stacktop

; salvar modo corrente de video(vendo como est� o modo de video da maquina)
    mov  		ah,0Fh
    int  		10h
    mov  		[modo_anterior],al   

; alterar modo de video para gr�fico 640x480 16 cores
    mov     	al,12h
    mov     	ah,0
    int     	10h

    call draw_table

    mov ax,'O'
    push ax
    mov ax,1
    push ax
    mov ax,2
    push ax

    call draw_position

    mov ax,'a'
    push ax
    mov ax,1
    push ax
    mov ax,1
    push ax

    mov ax,'O'
    push ax
    mov ax,1
    push ax
    mov ax,1
    push ax

    call draw_position
        
    mov    	ah,08h
    int     21h
    mov  	ah,0   			; set video mode
    mov  	al,[modo_anterior]   	; modo anterior
    int  	10h
    mov     ax,4c00h
    int     21h

segment data

segment stack stack
	resb 		512
stacktop: