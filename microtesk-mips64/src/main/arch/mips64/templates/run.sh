#!/bin/bash
sh $MICROTESK_HOME/bin/generate.sh mips64 $1.rb --code-file-prefix $1 --code-file-extension s -v -sd 1>$1.stdout 2>$1.stderr
