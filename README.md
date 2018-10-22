# YAAC-Yet-Another-Alan-Compiler
A compiler made for the Alan programming language written in haskell.

## Installation
Firstly you'll need to install these haskell packages:
```
utf8-string 
alex
happy
llvm-hs
```

Then just use the makefile to create the executables
```
make
make lexer
make parser
```
To clean the files and keep the core ones use
```
make clean
make distclean  //to also remove the lib.so
```

## Executables
* Run/Lexer-bin: Reads a program text from standard input and returns a list with tokens read
* Run/Parser-bin: Reads a program text from standard input and returns the syntax tree
* Run/YAAC-bin: Reads a program text from standard input and creates the intermediate code (.ll)
* YAAC-kim: A script that takes a program.alan and maybe -O and creates the a.out (uses llc)
* YAAC-erm: A script that takes a program.alan and maybe -O and creates the a.out (uses llc-6.0)


## Contributors
* Kimonas Sotirchos
* Ermis Soumalias
