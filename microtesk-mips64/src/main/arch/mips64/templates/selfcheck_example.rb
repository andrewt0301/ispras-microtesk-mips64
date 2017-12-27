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
# Description: a very simple selfcheck template.
#
class SelfCheckExampleTemplate < Mips64BaseTemplate
  def run
    sequence {
      temp_value_0 = rand(0x0000000, 0x7FFFffff)
      temp_value_1 = rand(0x0000000, 0x7FFFffff)

      prepare t1, temp_value_0
      prepare t2, temp_value_1

      add t3, t1, t2
      trace "\n$t3($11) = $t1($9) + $t2($10) -> %d = %d + %d",
            gpr_observer(11), gpr_observer(9), gpr_observer(10)
    }.run
  end

end
