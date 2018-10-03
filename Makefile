CC = ghc

LXR = alex
LXR_DIR = Lexer/

PSR = happy
PSR_DIR = Parser/

SEM_DIR = Semantic/
LIBS = Libraries/Source/

CC_FLAGS = -i$(MODULES)
LXR_FLAGS = -i
PSR_FLAGS = -i

MODULES = Lexer:Parser:Semantic:Codegen:Libraries
CLN_EXTN = .o .info .hi .out .ll

# ------------------------

default: compiler

all: parts compiler

parts: lexer parser

# ------------------------
# Rules
# ------------------------

compiler: $(LIBS)lib.so $(LXR_DIR)Lexer.hs $(PSR_DIR)Parser.hs
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
	clang -shared -fpic -o $(LIBS)lib.so $<

# ------------------------

clean:
	@echo "Cleaning .o .hi .info .out .ll Files..."
	for i in $(CLN_EXTN); do \
		find . -name "*$$i" -delete; \
	done
	@echo "Cleaning Lexer.hs and Parser.hs..."
	find . -name "Lexer.hs" -delete
	find . -name "Parser.hs" -delete

distclean:
	find . -name "lib.so" -delete
	find ./Run/ -type f -delete
	make clean
	rm Run/*
