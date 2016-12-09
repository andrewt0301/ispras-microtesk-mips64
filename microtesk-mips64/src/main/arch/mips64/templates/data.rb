#
# MicroTESK MIPS64 Edition
#
# Copyright (c) 2016 Institute for System Programming of the Russian Academy of Sciences
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
# This test template demonstrates how to work with data definitions.
#
class DataTemplate < Mips64BaseTemplate

  def pre
    super

    data {
      org 0x0
      align 8
      label :data
      dword 0x00000000BAADF00D, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFBEEF00FF
      label :end
      space 1
    }
  end

  def run
    # Loading and storing dwords:

    trace_data :data, :end

    la t0, :data
    trace "r8 = 0x%x", gpr_observer(8)

    ld s1, 0, t0
    trace "r17 = 0x%x", gpr_observer(17)

    prepare s0, 0xAC0DEF0EDEADBEEF
    trace "r16 = 0x%x", gpr_observer(16)

    sd s0, 0, t0
    trace_data :data, :end

    ld s1, 0, t0
    trace "r17 = 0x%x", gpr_observer(17)
  end

end
