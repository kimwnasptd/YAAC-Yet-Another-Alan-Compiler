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
	$(CC) $(CC_FLAGS) $(PSR_DIR)parser_run.hs -o Parser-bin

Parser.hs: $(PSR_DIR)Parser.y
	$(PSR) $(PSR_FLAGS) $(PSR_DIR)Parser.y

# ------------------------

clean:
	for i in $(CLEAN_DIRS); do \
		rm $$i/*.o $$i/*.hi $$i/*.info ; \
	done
