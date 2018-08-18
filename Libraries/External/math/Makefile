SRC=$(wildcard *.asm)
OBJ=$(SRC:.asm=.o)

lib : $(OBJ)
	ar -cvq math.a $^

%.o : %.asm
	nasm -f elf64 $<

distclean:
	make clean
	rm *.a

clean :
	rm *.o
