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
# This test template demonstrates how to use instruction groups in test templates.
#
class GroupsTemplate < Mips64BaseTemplate

  def run
    # Using groups defined in the specification

    10.times {
      sequence {
        # Placeholder to return from an exception
        epilogue { nop }

        # Selects from {add, addu, sub, ...}
        Mips64TArithmeticRRR t0, t1, t2

        # Selects from {addi, addiu, ...}
        Mips32ArithmeticRRI t3, t4, rand(0, 0xFFFF)

        # Selects from {{add, addu, sub, ... }, {and, or, slt, sltu, xor, ...}}
        Mips64AluOpRR t6, t7, t8
      }.run
    }

    # Using user-defined groups

    # Probability distribution for instruction names (NOTE: group names are not allowed here)
    xxx_dist = dist(range(:value => 'add',                       :bias => 40),
                    range(:value => 'sub',                       :bias => 30),
                    range(:value => ['and', 'or', 'xor'], :bias => 30))

    define_op_group('xxx', xxx_dist)
    10.times {
      atomic {
        # Placeholder to return from an exception
        epilogue { nop }

        # Selects an instruction according to the 'xxx_dist' distribution
        xxx t0, t1, t2
        xxx t3, t4, t5
        xxx t6, t7, t8
      }.run
    }
  end
end
