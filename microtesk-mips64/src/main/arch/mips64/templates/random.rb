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
# This test template demonstrates how to generate randomized test cases 
# by using biased values, intervals, arrays and distributions. 
#
class RandomTemplate < Mips64BaseTemplate

  def run
    # Predefined probability distribution.
    int_dist = dist(range(:value => 0,                                      :bias => 25), # Zero
                    range(:value => 1..2,                                   :bias => 25), # Small
                    range(:value => 0xffffFFFFffffFFFE..0xffffFFFFffffFFFF, :bias => 50)) # Large

    sequence {
      # DADD instruction with random operands and biased operand values.
      dadd r(_ FREE), r(_ FREE), r(_ FREE) do situation('random_biased',
        :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                      range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
      end
      # NOP instruction is used as a location to return from en exception
      nop
    }.run 1000
  end
end
