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
class SelfCheckExample2Template < Mips64BaseTemplate
  def pre
    super
    data {
      label :data_start
      word rand(1, 2)
      label :data_end
      word rand(3, 4)
    }
  end

  def update_data(data_address, label_start, label_end)
    la s0, data_address
    daddi t1, s0, 0
    lw t4, 0, t1
    daddi t4, t4, 1
    sw t4, 0, t1
    daddi t1, t1, 4

    la s0, label_start
    daddi t2, s0, 0
    temp_value = rand(1, 111)
    daddi t5, zero, temp_value
    lw t4, 0, t2
    add t4, t4, t5
    sw t4, 0, t2

    la s0, label_end
    daddi t2, s0, 0
    temp_value = rand(112, 222)
    daddi t5, zero, temp_value
    lw t4, 0, t2
    add t4, t4, t5
    sw t4, 0, t2
  end

  def run
    trace_data(:data_start, :data_end)
    trace_data_addr(0xFFFFFFFFA0002060, 0xFFFFFFFFA0002080)

    block(:combinator => 'diagonal') {
      sequence {
        la s0, 0xFFFFFFFFA0002068
        daddi t1, s0, 0
        lw t5, 0, t1
        daddi t5, t5, 16
        sw t5, 0, t1
      }

      block(:combinator => 'product') {
        la s0, 0xFFFFFFFFA0002070
        daddi t1, s0, 0
        lw t4, 0, t1

        iterate {
          daddi t4, t4, 27
          daddi t4, t4, -15
          daddi t4, t4, 18
        }

        iterate {
          daddi t4, t4, -22
          daddi t4, t4, -67
          daddi t4, t4, 43
        }

        iterate {
          daddi t4, t4, 7
          daddi t4, t4, 6
          daddi t4, t4, 4
        }

        sw t4, 0, t1
      }

      update_data(0xFFFFFFFFA0002060, :data_start, :data_end)

      la s0, 0xFFFFFFFFA0002060
      daddi t1, s0, 0
      lw t3, 0, t1
      la s0, 0xFFFFFFFFA0002068
      daddi t1, s0, 0
      lw t6, 0, t1
      la s0, 0xFFFFFFFFA0002070
      daddi t1, s0, 0
      lw t7, 0, t1
      la s0, :data_start
      daddi t1, s0, 0
      lw t8, 0, t1
      la s0, :data_end
      daddi t1, s0, 0
      lw t9, 0, t1

      trace_data(:data_start, :data_end)
      trace_data_addr(0xFFFFFFFFA0002060, 0xFFFFFFFFA0002080)
    }.run
  end

end
