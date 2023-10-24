FRASM\nasm16 -f obj -o OBJ\main.obj -l LST\main.lst SRC\main.asm
FRASM\nasm16 -f obj -o OBJ\table.obj -l LST\table.lst SRC\table.asm
FRASM\freelink OBJ\main OBJ\linec OBJ\table,main