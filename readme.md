# Jogo da velha em assembly x86
Esse repositório é dedicado à um jogo da velha feito na linguagem de programação assembly na arquitetura x86 usando o sistema operacional DOS.\
Para a compilação e linkagem dos arquivos iremos utilizar o NASM e o FREELINK respectivamente.\
É recomendado a utilização do emulador dosBOX, já que este que foi utilizado na realização do trabalho.

# Como jogar
Para jogar, basta abrir o dosBOX nessa pasta e compilar e executar de acordo com os passos mais abaixo.\
Para realizar uma jogada basta digitar o caractere respectivo ao seu player ('X' para o Xis e 'C' para o círculo) e uma posição de linha e de coluna (Entre 1 e 3).\
Ex: X12, C22, C13, ...

## Para compilar e linkar o programa basta digitar:
```
    make compile
```

## E para executar o programa:
```
    main
```

## Para compilar e linkar os arquivos exceto o 'linec.asm':
```
    make adjust
```

## Para compilar e linkar um arquivo em específico (substituir %file% pelo arquivo desejado):
```
    make update %file%
```
## Para limpar os arquivos gerados para a compilação:
```
    make clear
```
