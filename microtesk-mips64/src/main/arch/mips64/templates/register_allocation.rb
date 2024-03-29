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
# This test template demonstrates how to randomly allocate registers so
# that they do not conflict with other registers used in the test case.
#
class RegisterAllocationTemplate < Mips64BaseTemplate

  def run
    # Destination of all instructions is a random register that
    # is not used in this sequence.
    sequence {
      # Randomly selects destination registers from free registers
      add reg1=r(_ FREE), t0, t1
      sub reg2=r(_ FREE), t2, t3
      slt reg3=r(_ FREE), t4, t5
      newline

      # Frees the previously reserved registers
      free_register reg1
      free_register reg2
      free_register reg3

      # Randomly selects destination registers from free registers including
      # those that were previosly freed
      And r(_ FREE), s0, s1
      Or  r(_ FREE), s2, s3
      Xor r(_ FREE), s4, s5
      newline
    }.run 5
  end

end
