CC=clang 
CFLAGS=-c -pipe -O0 -W -Wall -Wpointer-arith -Wno-unused-parameter -Werror -g
LDFLAGS=-L/usr/local/opt/bison/lib

BISON=/usr/local/opt/bison/bin/bison
FLEX=/usr/bin/flex

LINK=$(CC)
BUILD_DEPS=./fbs_cal_parser.h  
BUILD_INCS=-I ./

fbs_parser: fbs_cal.tab.o \
    fbs_cal_lex.o \
	lex.yy.o \
	fbs_cal_parser.o
	$(LINK) -o fbs_cal_parser.bin fbs_cal.tab.o \
	fbs_cal_lex.o \
	lex.yy.o \
	fbs_cal_parser.o \
	-ldl -lpthread -lm -Wl $(LDFLAGS)

fbs_cal.tab.c:
	$(BISON) -v -Wmidrule-value -Wno-other --debug --report=states,lookaheads --report-file=states.report --graph=automaton.dot -d fbs_cal.y

lex.yy.c:
	$(FLEX) fbs_cal.l

fbs_cal.tab.o: $(BUILD_DEPS)  \
    fbs_cal.tab.c
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_cal.tab.o fbs_cal.tab.c

lex.yy.o: $(BUILD_DEPS)  \
    lex.yy.c
	$(CC) $(CFLAGS) $(BUILD_INCS) -o lex.yy.o lex.yy.c

fbs_cal_lex.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_cal_lex.o fbs_cal_lex.c

fbs_cal_parser.o:	$(BUILD_DEPS)
	$(CC) $(CFLAGS) $(BUILD_INCS) -o fbs_cal_parser.o fbs_cal_parser.c

.PHONY:clean
clean:
	rm -rf *.o *.bin core *.tab.* fbs_yy_gen.h states.report automaton.dot automaton.svg *.output lex.yy.c

.PHONY:clean-build
clean-build:
	rm -rf *.o *.bin
