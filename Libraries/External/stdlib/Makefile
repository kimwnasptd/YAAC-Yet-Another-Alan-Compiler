SRC=$(wildcard *.asm)
OBJ=$(SRC:.asm=.o)

lib : $(OBJ)
	ar -cvq stdlib.a $^

%.o : %.asm
	nasm -f elf64 $<

distclean:
	make clean
	rm *.a

clean :
	rm *.o
