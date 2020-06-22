CC=clang 
CFLAGS=-c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g
LDFLAGS=-L/usr/local/opt/bison/lib

FLEX=/usr/bin/flex

LINK=$(CC)
BUILD_DEPS=./fbs_context.h
BUILD_INCS=-I ./

fbs_lexer: fbs_lex.yy.c \
	fbs_lex.yy.o \
	fbs_context.o \
	fbs_lexer.o
	$(LINK) -o fbs_lexer.bin \
	fbs_lex.yy.o \
	fbs_context.o \
	fbs_lexer.o \
	-ldl -lpthread -lm -Wl $(LDFLAGS)

fbs_lex.yy.c:
	$(FLEX) fbs.l

fbs_lex.yy.o: $(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_lex.yy.o fbs_lex.yy.c

fbs_context.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_context.o fbs_context.c

fbs_lexer.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_lexer.o fbs_lexer.c

.PHONY:clean
clean:
	rm -rf *.o *.bin \
		core *.tab.* \
		fbs_yy_gen.h \
		states.report \
		automaton.dot \
		automaton.svg \
		*.output \
		fbs_lex.yy.c \
		fbs_lex.yy.h

.PHONY:clean-build
clean-build:
	rm -rf *.o *.bin
