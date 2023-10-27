FRASM\nasm16 -f obj -o OBJ\main.obj -l LST\main.lst SRC\main.asm
FRASM\nasm16 -f obj -o OBJ\table.obj -l LST\table.lst SRC\table.asm
FRASM\nasm16 -f obj -o OBJ\err.obj -l LST\err.lst SRC\err.asm
FRASM\nasm16 -f obj -o OBJ\io.obj -l LST\io.lst SRC\io.asm
FRASM\nasm16 -f obj -o OBJ\game.obj -l LST\game.lst SRC\game.asm
FRASM\nasm16 -f obj -o OBJ\win.obj -l LST\win.lst SRC\win.asm
FRASM\freelink OBJ\main OBJ\linec OBJ\table OBJ\err OBJ\io OBJ\game OBJ\win,main