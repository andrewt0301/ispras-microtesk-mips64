#!/bin/bash

# Copyright (c) 2017 Ivannikov Institute for System Programming of the Russian Academy of Sciences (ISP RAS)
# All Rights Reserved
#
# Script for running of ELF images on QEMU emulator.
#

ERR="Error: "
OUT_FILE_NAME="out"

# Executes command with a timeout
# Params:
#   $1 timeout in seconds
#   $2 command
# Returns 1 if timed out 0 otherwise
timeout() {

  time=$1

  # start the command in a subshell to avoid problem with pipes
  # (spawn accepts one command)
  command="/bin/sh -c \"$2\""

  expect -c "set echo \"-noecho\"; set timeout $time; spawn -noecho $command; expect timeout { exit 1 } eof { exit 0 }"
}

# Run the ELF image on QEMU with timeout
SCRIPT_DIR=$( dirname "$0" )
QEMU_MIPS=qemu-system-mips64
QEMU_SRV_INSTALL_DIR=${SCRIPT_DIR}/../../../build/tools/qemu
QEMU=${QEMU_SRV_INSTALL_DIR}/bin/${QEMU_MIPS}

if [ ! -f "${QEMU}" ] ; then

  QEMU=${QEMU_MIPS}

  if [ ! -f "${QEMU}" ] ; then
    echo "${ERR} can't find '${QEMU}' neither in '${QEMU_SRV_INSTALL_DIR}' nor in '${PATH}'" >&2
    exit 1
  fi
fi

TIMEOUT_SEC=1
timeout ${TIMEOUT_SEC} "${QEMU} -M mips -cpu mips64dspr2 -d unimp,nochain,in_asm -singlestep -nographic -trace-log -D ${OUT_FILE_NAME}-qemu.log -bios ${OUT_FILE_NAME}.elf"
