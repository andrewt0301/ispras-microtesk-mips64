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
# design under test. The described program calculates the quotient and
# the remainder of division of two random numbers by using 
# the simple algorithm of repeated subtraction.
#
class IntDivideTemplate < Mips64BaseTemplate

  def run
    trace "Division: Debug Output"

    dividend = rand(0, 1023)
    divisor  = rand(1, 63) #zero is excluded

    addi s0, zero, dividend
    addi s1, zero, divisor

    trace "\nInput parameter values: dividend r16(s0) = %d, divisor r17(s1) = %d\n",
      gpr_observer(16), gpr_observer(17)

    add t0, zero, zero
    add t1, zero, s0

    label :cycle
    trace "\nCurrent register values: r8(t0) = %d, r9(t1) = %d, r10(t2) = %d\n",
      gpr_observer(8), gpr_observer(9), gpr_observer(10)

    sub t2, t1, s1
    slt t3, t2, zero

    bne t3, zero, :done
    nop

    add t1, zero, t2
    addi t0, t0, 1

    j :cycle
    nop

    label :done
    trace "\nResult: quotient r8(t0) = %d, remainder r9(t1) = %d",
      gpr_observer(8), gpr_observer(9)
  end

end
