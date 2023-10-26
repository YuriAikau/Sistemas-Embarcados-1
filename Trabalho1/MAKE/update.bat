FRASM\nasm16 -f obj -o OBJ\%1.obj -l LST\%1.lst SRC\%1.asm
FRASM\freelink OBJ\main OBJ\linec OBJ\table OBJ\err OBJ\io OBJ\game,main
