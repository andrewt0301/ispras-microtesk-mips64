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
# This test template demonstrates how to generate test cases by using combinators and compositors.
#
class ArithmeticTemplate < Mips64BaseTemplate

  def run
    # :combinator => 'product': all possible combinations of the inner blocks' instructions.
    # :compositor => 'random' : random composition (merging) of the combined instructions.
    block(:combinator => 'product', :compositor => 'random') {
      iterate {
        xor r(_), r(_), r(_)
        ori r(_), r(_), _
      }

      iterate {
        AND   r(_), r(_), r(_)
        OR    r(_), r(_), r(_)
      }

      iterate {
        lui   r(_), _
      }
    }.run
  end
end
