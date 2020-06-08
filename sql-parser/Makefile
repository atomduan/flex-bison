CC=clang 
CFLAGS=-c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g
LDFLAGS=-L/usr/local/opt/bison/lib

BISON=/usr/local/opt/bison/bin/bison
FLEX=/usr/bin/flex

LINK=$(CC)
BUILD_DEPS=./fbs_sql_parser.h  
BUILD_INCS=-I ./

fbs_parser: fbs_sql_lex.yy.c \
	fbs_sql.tab.c \
	fbs_sql_lex.yy.o \
	fbs_sql.tab.o \
	fbs_sql_parser.o
	$(LINK) -o fbs_parser.bin fbs_sql.tab.o \
	fbs_sql_lex.yy.o \
	fbs_sql_parser.o \
	-ldl -lpthread -lm -Wl $(LDFLAGS)

fbs_lexer: fbs_sql_lex.yy.c \
	fbs_sql.tab.c \
	fbs_sql_lex.yy.o \
	fbs_sql_lexer.o
	$(LINK) -o fbs_lexer.bin \
	fbs_sql_lex.yy.o \
	fbs_sql_lexer.o \
	-ldl -lpthread -lm -Wl $(LDFLAGS)

fbs_sql.tab.c:
	$(BISON) -v -d\
		-Wmidrule-value \
		-Wno-other \
		--debug \
		--report=states,lookaheads \
		--report-file=states.report \
		--graph=automaton.dot \
		fbs_sql.y

fbs_sql_lex.yy.c:
	$(FLEX) fbs_sql.l

fbs_sql.tab.o: $(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_sql.tab.o fbs_sql.tab.c

fbs_sql_lex.yy.o: $(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_sql_lex.yy.o fbs_sql_lex.yy.c

fbs_sql_parser.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_sql_parser.o fbs_sql_parser.c

fbs_sql_lexer.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_sql_lexer.o fbs_sql_lexer.c

.PHONY:clean
clean:
	rm -rf *.o *.bin \
		core *.tab.* \
		fbs_yy_gen.h \
		states.report \
		automaton.dot \
		automaton.svg \
		*.output \
		fbs_sql_lex.yy.c \
		fbs_sql_lex.yy.h

.PHONY:clean-build
clean-build:
	rm -rf *.o *.bin
