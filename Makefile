CC = ghc

LXR = alex
LXR_DIR = Lexer/

PSR = happy
PSR_DIR = Parser/

SEM_DIR = Semantic/
LIBS = Libraries/Source

CC_FLAGS = -i$(MODULES)
LXR_FLAGS = -i
PSR_FLAGS = -i

MODULES = Lexer:Parser:Semantic:Codegen:Libraries
CLEAN_DIRS = . Lexer Parser Semantic Codegen Run Libraries

# ------------------------

default: compiler

all: parts compiler

parts: lexer parser

# ------------------------
# Compile the Parser
# ------------------------

lexer: Lexer.o
	$(CC) $(CC_FLAGS) $(LXR_DIR)lexer_run.hs -o Run/Lexer-bin

Lexer.o: Lexer.hs
	$(CC) $(CC_FLAGS) $(LXR_DIR)Lexer.hs -c

Lexer.hs: $(LXR_DIR)Lexer.x
	$(LXR) $(LXR_FLAGS) $(LXR_DIR)Lexer.x

# ------------------------
# Compile the Parser
# ------------------------

parser: Parser.hs
	$(CC) $(CC_FLAGS) $(PSR_DIR)parser_run.hs -o Run/Parser-bin

Parser.hs: $(PSR_DIR)Parser.y
	$(PSR) $(PSR_FLAGS) $(PSR_DIR)Parser.y

# ------------------------
# Compile the Compiler
# ------------------------

libs: $(LIBS)/lib.c
	make -C $(LIBS)

compiler: libs 
	$(CC) $(CC_FLAGS) Compiler.hs -o Run/YAAC-ll

# ------------------------

clean:
	# remove anything missed by the previous steps
	for i in $(CLEAN_DIRS); do \
		rm $$i/*.o $$i/*.hi $$i/*.info 2>/dev/null || echo "Nothing to remove"; \
	done
	rm *.out *.ll 2>/dev/null

distclean:
	make clean
	rm Run/*
