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
# This test template demonstrates how to generate test cases for integer arithmetics
# based on constraints describing certain situations. The template builds
# combinations of "add" and "sub" instructions with situations "IntegerOverflow" that
# causes an exception and "normal" that causes no exceptions.
#
class IntExceptionTemplate < Mips64BaseTemplate

  def run
    block(:combinator => 'product', :compositor => 'random') {
      epilogue {
        nop # Placeholder to return from an exception
      }

      iterate {
        add t0, t1, t2 do situation('normal') end
        add t0, t1, t2 do situation('IntegerOverflow') end;
      }

      iterate {
        sub t3, t4, t5 do situation('normal') end
        sub t3, t4, t5 do situation('IntegerOverflow') end;
      }
    }.run
  end

end
