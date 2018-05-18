#
# MicroTESK for MIPS64
#
# Copyright (c) 2016-2017 Institute for System Programming of the Russian Academy of Sciences
# All Rights Reserved
#
# Institute for System Programming of the Russian Academy of Sciences (ISP RAS)
# 25 Alexander Solzhenitsyn st., Moscow, 109004, Russia
# http://www.ispras.ru
#

require_relative 'mips64_base'

#
# Description:
#
# This small tests for MMU instructions.
#

class InstructionMmuTemplate < Mips64BaseTemplate

  def run
    trace "Run MMU instruction:"

    trace "\nMIPS 32 Load/Store:\n"

    # init
    addi t1, zero, 0x0000
    trace "t2 = %x", gpr_observer(10)
    trace "t3 = %x", gpr_observer(11)
    addi t2, zero, 0x1ead
    trace "t2 = %x", gpr_observer(10)
    sll t2, t2, 16
    trace "t2 = %x", gpr_observer(10)
    daddiu t2, t2, 0xdeaf
    trace "t2 = %x", gpr_observer(10)
    dsll32 t8, t2, 0
    trace "t8 = %x", gpr_observer(24)
    addi t2, zero, 0x1bcd
    trace "t2 = %x", gpr_observer(10)
    sll t2, t2, 16
    trace "t2 = %x", gpr_observer(10)
    daddiu t2, t2, 0x7efd
    trace "t2 = %x", gpr_observer(10)
    OR    t9, t8, t2
    trace "t9 = %x", gpr_observer(25)
    
    # double
    la t1, 0xffffffffa0002000
    trace "t1 = %x", gpr_observer(9)
    sd t9, 0x0, t1
    ld t3, 0x0, t1
    trace "t1 = %x", gpr_observer(9)
    trace "t3 = %x", gpr_observer(11)

    #word
    lw t4, 0x4, t1
    trace "t4 = %x", gpr_observer(12)
    lw t5, 0x0, t1
    trace "t5 = %x", gpr_observer(13)

    la t1, 0xffffffffa0002100

    sw t4, 0x0, t1
    sw t5, 0x4, t1
    ld t3, 0x0, t1
    trace "t3 = %x", gpr_observer(11)

    #byte
    la t2, 0xffffffffa0002200

    lb t4, 0x0, t1
    sb t4, 0x7, t2
    trace "t4 = %x", gpr_observer(12)
    lb t5, 0x1, t1
    sb t5, 0x6, t2
    trace "t5 = %x", gpr_observer(13)

    ld t3, 0x0, t2
    trace "t3 = %x", gpr_observer(11)

    lb t4, 0x2, t1
    sb t4, 0x5, t2
    trace "t4 = %x", gpr_observer(12)
    lb t5, 0x3, t1
    sb t5, 0x4, t2
    trace "t5 = %x", gpr_observer(13)

    ld t3, 0x0, t2
    trace "t3 = %x", gpr_observer(11)

    lb t4, 0x4, t1
    sb t4, 0x3, t2
    trace "t4 = %x", gpr_observer(12)
    lb t5, 0x5, t1
    sb t5, 0x2, t2
    trace "t5 = %x", gpr_observer(13)

    ld t3, 0x0, t2
    trace "t3 = %x", gpr_observer(11)

    lb t4, 0x6, t1
    sb t4, 0x1, t2
    trace "t4 = %x", gpr_observer(12)
    lb t5, 0x7, t1
    sb t5, 0x0, t2
    trace "t5 = %x", gpr_observer(13)

    ld t3, 0x0, t2
    trace "t3 = %x", gpr_observer(11)

    # unsigned
    lwu t5, 0x0, t2
    trace "lwu t5 = %x", gpr_observer(13)

    lw t6, 0x0, t2
    trace "lw t6 = %x", gpr_observer(14)
  end

end