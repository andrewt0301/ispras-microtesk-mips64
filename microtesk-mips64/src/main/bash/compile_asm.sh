#!/bin/bash

#  Copyright (c) 2018 Ivannikov Institute for System Programming of the Russian Academy of Sciences (ISP RAS)
# All Rights Reserved
#
# Script that compiles MIPS assembler program by MIPS Linux GNU GCC toolchain.
#

ERR="Error: "
SCRIPT_DIR=$( dirname "$0" )
CURRENT_DIR=$(pwd)
OUT_FILE_NAME="out.elf"

# Returns program file path without ext from path
get_file_no_ext() {
  file=$1
  FILENAME=${file%.*}
}

# Toolchain-related parameters
if [[ -z "${MIPS64_TCHAIN// }" ]]; then
  echo "${ERR} create MIPS64_TCHAIN environment variable that contains a path to 'bin' catalogue inside the MIPS GCC."
  exit -1
fi
TCHAIN_PATH=${MIPS64_TCHAIN}/bin
TCHAIN_PREFIX=${TCHAIN_PATH}/mips-linux-gnu-

ASM="${TCHAIN_PREFIX}"as
LD="${TCHAIN_PREFIX}"ld

if ! type "${ASM}" > /dev/null ; then
  echo "${ERR} can't find '${ASM}', please install the toolchain" >&2
  exit -1
fi

if ! type "${LD}" > /dev/null ; then
  echo "${ERR} can't find '${LD}', please install the toolchain" >&2
  exit -1
fi

#
# Compile MIPS64 assembler test program components and create ELF binary
#

ASM_EXT="*.s"
OBJ_EXT="*.o"

FIND_ASM=`find "$CURRENT_DIR" -maxdepth 1 -type f -name "$ASM_EXT"`
ASM_FILES="$CURRENT_DIR"/"$ASM_EXT"
OBJ_FILES="$CURRENT_DIR"/"$OBJ_EXT"

if [ -n "$FIND_ASM" ]; then
  for FILE in ${ASM_FILES}; do
    echo "Compiling ${FILE}..."
    get_file_no_ext ${FILE}
    ${ASM} -march=mips64r5 -o ${FILENAME}.o ${FILE}
  done
else
  echo "Nothing to compile."
fi

${LD} ${OBJ_FILES} -T"${CURRENT_DIR}"/link_qemu.ld -o "${CURRENT_DIR}/${OUT_FILE_NAME}"
