CC=clang 
CFLAGS=-c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g
LDFLAGS=-L/usr/local/opt/bison/lib

BISON=/usr/local/opt/bison/bin/bison
FLEX=/usr/bin/flex

LINK=$(CC)
BUILD_DEPS=./fbs_parser.h  
BUILD_INCS=-I ./

fbs_parser: fbs.tab.o \
	fbs_lex.yy.o \
	fbs_parser.o
	$(LINK) -o fbs_parser.bin fbs.tab.o \
	fbs_lex.yy.o \
	fbs_parser.o \
	-ldl -lpthread -lm -Wl $(LDFLAGS)

fbs.tab.c:
	$(BISON) -v -d\
		-Wmidrule-value \
		-Wno-other \
		--debug \
		--report=states,lookaheads \
		--report-file=states.report \
		--graph=automaton.dot \
		fbs.y

fbs_lex.yy.c:
	$(FLEX) fbs.l

fbs.tab.o: $(BUILD_DEPS)  \
    fbs.tab.c
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs.tab.o fbs.tab.c

fbs_lex.yy.o: $(BUILD_DEPS)  \
    fbs_lex.yy.c
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_lex.yy.o fbs_lex.yy.c

fbs_parser.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_parser.o fbs_parser.c

.PHONY:clean
clean:
	rm -rf *.o *.bin \
		core *.tab.* \
		fbs_yy_gen.h \
		states.report \
		automaton.dot \
		automaton.svg \
		*.output \
		fbs_lex.yy.c

.PHONY:clean-build
clean-build:
	rm -rf *.o *.bin
