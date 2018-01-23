#
# MicroTESK for MIPS64
#
# Copyright (c) 2018 Institute for System Programming of the Russian Academy of Sciences
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

class Cp0ExceptionTemplate < Mips64BaseTemplate

  def run
    3.times {
      sequence {
        trace "Kernel mode: off"
        mfc0 t8, c0_status
        ori  t8, t8, 0x0018
        mtc0 t8, c0_status

        trace "Get CP0 exception"
        mfc0 t8, c0_status
      }.run
    }
  end

end
