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
# Rules
# ------------------------

compiler: $(LIBS)/lib.c lexer parser
	$(CC) $(CC_FLAGS) Compiler.hs -o Run/YAAC-ll

lexer: $(LXR_DIR)Lexer.hs
	$(CC) $(CC_FLAGS) $(LXR_DIR)lexer_run.hs -o Run/Lexer-bin

parser: $(PSR_DIR)Parser.hs
	$(CC) $(CC_FLAGS) $(PSR_DIR)parser_run.hs -o Run/Parser-bin

%.o: %.hs
	$(CC) $(CC_FLAGS) $< -c

%.hs: %.x
	$(LXR) $(LXR_FLAGS) $<

%.hs: %.y
	$(PSR) $(PSR_FLAGS) $<

%.so: %.c
	clang -shared -fpic -o lib.so $<

# ------------------------

clean:
	# remove anything missed by the previous steps
	for i in $(CLEAN_DIRS); do \
		rm $$i/*.o $$i/*.hi $$i/*.info 2>/dev/null || echo "Nothing to remove"; \
	done
	rm $(LXR_DIR)Lexer.hs
	rm $(PSR_DIR)Parser.hs
	rm *.out *.ll 2>/dev/null

distclean:
	make clean
	rm Run/*
