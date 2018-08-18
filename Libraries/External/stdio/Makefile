SRC=$(wildcard *.asm)
OBJ=$(SRC:.asm=.o)

lib : $(OBJ)
	ar -cvq stdio.a $^

%.o : %.asm
	nasm -O2 -f elf64 $<

distclean:
	make clean
	rm *.a

clean :
	rm *.o
