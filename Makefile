CC = ghc

LXR = alex
LXR_DIR = Lexer/

PSR = happy
PSR_DIR = Parser/

CC_FLAGS = -i$(MODULES)
LXR_FLAGS = -i
PSR_FLAGS = -i

MODULES = Lexer:Parser
CLEAN_DIRS = Lexer Parser

# ------------------------

default: compiler

compiler: lexer parser

# ------------------------
# Compile the Parser
# ------------------------

lexer: Lexer.hs
	$(CC) $(CC_FLAGS) $(LXR_DIR)lexer_run.hs -o Lexer-bin

Lexer.hs: $(LXR_DIR)Lexer.x
	$(LXR) $(LXR_FLAGS) $(LXR_DIR)Lexer.x

# ------------------------
# Compile the Parser
# ------------------------

parser: Parser.hs Lexer.hs
	$(CC) -o Parser $(CC_FLAGS) $(PSR_DIR)Parser.hs $(LXR_DIR)Lexer.hs

Parser.hs: $(PSR_DIR)Parser.y
	$(PSR) $(PSR_FLAGS) $(PSR_DIR)Parser.y

# ------------------------

clean:
	for i in $(CLEAN_DIRS); do \
		rm $$i/*.o $$i/*.hi ; \
	done
