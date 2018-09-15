rm libs.a
make lib -C auxil
make lib -C math
make lib -C stdio
make lib -C stdlib
make lib -C string
make lib -C extra

ar -cvqs lib.a auxil/*.o math/*.o stdio/*.o stdlib/*.o string/*.o extra/*.o
objcopy --redefine-syms=change_syms lib.a 

make clean -C auxil
rm auxil/auxil.a
make clean -C math
rm math/math.a
make clean -C stdio
rm stdio/stdio.a
make clean -C stdlib
rm stdlib/stdlib.a
make clean -C string
rm string/string.a
make clean -C extra
rm extra/lib.a
