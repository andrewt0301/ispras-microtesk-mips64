#
# MicroTESK MIPS64 Edition
#
# Copyright (c) 2017 Institute for System Programming of the Russian Academy of Sciences
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
# This test template demonstrates how MicroTESK can simulate the execution
# of a test program to predict the resulting state of a microprocessor
# design under test. The described program calculates the integer square root
# a positive integer.
#

class IntSqrt4Template < Mips64BaseTemplate

  def run
    trace "Integer square root: Debug Output\n"

    addi s0, zero, rand(0, 1023)
    trace "Input parameter value: r16(s0) = %d\n", gpr_observer(16)

    addi s1, zero, 1
    addi s2, zero, 2

    add t3, zero, s0
    lui t0, 0x4000
    add t1, zero, zero

    label :cycle
    trace "\nCurrent register values: r8(t0) = %d, r9(t1) = %d, r10(t2) = %d\n",
      gpr_observer(8), gpr_observer(9), gpr_observer(10)

    beq t0, zero, :done
    OR  t2, t1, t0

    srlv t1, t1, s1
    slt  t4, t3, t2

    bne t4, zero, :if_less
    nop

    sub t3, t3, t2
    OR  t1, t1, t0

    label :if_less
    j :cycle
    srlv t0, t0, s2

    label :done
    trace "\nInteger square root of %d: %d", gpr_observer(16), gpr_observer(9)
  end

end
