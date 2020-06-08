#!/bin/bash -x
#The equivalent shell script for Makefile
rm -rf *.o *.bin \
		core *.tab.* \
		fbs_yy_gen.h \
		states.report \
		automaton.dot \
		automaton.svg \
		*.output \
		fbs_sql_lex.yy.c \
		fbs_sql_lex.yy.h

/usr/bin/flex fbs_sql.l

/usr/local/opt/bison/bin/bison -v -d \
		-Wmidrule-value \
		-Wno-other \
		--debug \
		--report=states,lookaheads \
		--report-file=states.report \
		--graph=automaton.dot \
		fbs_sql.y

clang  -c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -I ./ -o fbs_sql_lex.yy.o fbs_sql_lex.yy.c
clang  -c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -I ./ -o fbs_sql.tab.o fbs_sql.tab.c
clang  -c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -I ./ -o fbs_sql_parser.o fbs_sql_parser.c

clang  -o fbs_parser.bin fbs_sql.tab.o \
	fbs_sql_lex.yy.o \
	fbs_sql_parser.o \
	-ldl -lpthread -lm -Wl -L/usr/local/opt/bison/lib

clang  -c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g -I ./ -o fbs_sql_lexer.o fbs_sql_lexer.c

clang  -o fbs_lexer.bin \
	fbs_sql_lex.yy.o \
	fbs_sql_lexer.o \
	-ldl -lpthread -lm -Wl -L/usr/local/opt/bison/lib
