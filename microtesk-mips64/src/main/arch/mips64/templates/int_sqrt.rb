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
# This test template demonstrates how MicroTESK can simulate the execution
# of a test program to predict the resulting state of a microprocessor
# design under test. The described program calculates the integer square root
# a positive integer.
#
class IntSqrtTemplate < Mips64BaseTemplate

  def run
    trace "Integer square root: Debug Output\n"

    addi s0, zero, rand(0, 1023)
    trace "Input parameter value: r16(s0) = %d\n", gpr_observer(16)

    add  t0, zero, s0
    addi t1, zero, 1

    add  t2, zero, zero
    addi t3, zero, 1

    label :cycle
    trace "\nCurrent register values: r8(t0) = %d, r9(t1) = %d, r10(t2) = %d\n",
      gpr_observer(8), gpr_observer(9), gpr_observer(10)

    slt t4, zero, t0
    beq t4, zero, :done
    nop

    sub  t0, t0, t1
    addi t1, t1, 2

    slt t4, t0, zero
    sub t5, t3, t4
    add t2, t2, t5

    j :cycle
    nop

    label :done
    trace "\nInteger square root of %d: %d", gpr_observer(16), gpr_observer(10)
  end

end
