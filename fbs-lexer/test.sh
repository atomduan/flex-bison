#!/bin/bash -
curr=$(cd `dirname $(which $0)`; pwd)

cd $curr
if [ -f "fbs_lexer.bin" ]; then
    cat patters.txt | ./fbs_lexer.bin
else
    echo "can not find fbs_lexer.bin, run build first"
    exit 1
fi
