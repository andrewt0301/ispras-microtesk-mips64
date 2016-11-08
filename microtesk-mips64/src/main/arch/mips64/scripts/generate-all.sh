#!/bin/sh

#
# MicroTESK MIPS64 Edition
#
# Copyright (c) 2015-2016 Institute for System Programming of the Russian Academy of Sciences
# All Rights Reserved
#
# Institute for System Programming of the Russian Academy of Sciences (ISP RAS)
# 25 Alexander Solzhenitsyn st., Moscow, 109004, Russia
# http://www.ispras.ru
#

#
# This script generates assembler files for every template.
#
# Note that target model should be translated first.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GENERATE="$SCRIPT_DIR"/generate.sh

# Test template parameters
TEMPLATE_EXT="*.rb"
EXCLUDE_TEMPLATE="_base.rb"
TEMPLATE_DIR="$SCRIPT_DIR"/../templates
TEMPLATE_FILES="$TEMPLATE_DIR"/"$TEMPLATE_EXT"

FIND_TEMPLATES=`find "$TEMPLATE_DIR" -maxdepth 1 -type f -name "$TEMPLATE_EXT"`

if [ -n "$FIND_TEMPLATES" ]; then
  for TEMPLATE in $TEMPLATE_FILES; do
    if [[ "$TEMPLATE" != *"$EXCLUDE_TEMPLATE" ]]; then
      $GENERATE $TEMPLATE
    fi
  done
else
  echo "No template files have been found."
fi
