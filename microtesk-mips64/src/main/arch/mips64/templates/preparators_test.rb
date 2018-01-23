#
# MicroTESK for MIPS64
#
# Copyright (c) 2016-2018 Institute for System Programming of the Russian Academy of Sciences
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
#

class PreparatorsTest < Mips64BaseTemplate

  def run
    trace "Run preparators:"

    prepare t1, -1
    trace "prepare -1 in t1 = %x", gpr_observer(9)

    prepare t1, 0
    trace "prepare 0 in t1 = %x", gpr_observer(9)

    prepare t1, -2
    trace "prepare -2 in t1 = %x", gpr_observer(9)

    prepare t2, 0xFF120000
    trace "prepare 0xFF120000 in t2 = %x", gpr_observer(10)

    add t1, t0, t0
    trace "(add): t1 = %x", gpr_observer(9)
  end

end
