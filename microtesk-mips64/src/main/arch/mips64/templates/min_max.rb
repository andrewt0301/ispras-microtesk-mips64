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
# This test template demonstrates how to work with data declaration constucts.
# The generated program finds minimum and maximum in a 5-element array
# storing random numbers from 0 to 31. 
#
class MinMaxTemplate < Mips64BaseTemplate

  def pre
    super

    data {
      org 0x0
      align 8
      label :data
      dword rand(0, 31), rand(0, 31), rand(0, 31), rand(0, 31), rand(0, 31)
      label :end
      space 1
    }
  end

  def run
    # trace_data :data, :end

    la t0, :data
    la t1, :end

    ld t2, 0, t0
    Or s0, zero, t2 
    Or s1, zero, t2

    label :cycle
    daddi t0, t0, 8

    beq t0, t1, :done
    ld t2, 0, t0

    slt t3, t2, s0
    beq t3, zero, :test_max
    nop
    Or s0, zero, t2 

    label :test_max
    slt t4, s1, t2
    beq t4, zero, :cycle
    nop
    Or s1, zero, t2

    j :cycle
    nop

    label :done
    trace "\nmin(r16)=%d, max(r17)=%d", gpr_observer(16), gpr_observer(17)
  end

end
