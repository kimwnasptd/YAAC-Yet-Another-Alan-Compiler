SRC=$(wildcard *.c)
OBJ=$(SRC:.c=.o)

lib : $(OBJ)
	ar -cvq extra.a $^

%.o : %.c
	clang -c $<

distclean:
	make clean
	rm *.a

clean :
	rm *.o
