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
# This small tests for FPU instructions.
#

class InstructionFpuTemplate < Mips64BaseTemplate

  def run
    trace "Run FPU instruction:"

    trace "\nMIPS 32:\n"

    # 1
    addi t0, zero, -5
    trace "(addi): t1 = %x", gpr_observer(8)
    nop
    abs_fmt s, f1, f2
    abs_fmt d, f1, f2
    abs_fmt ps, f1, f2

    add_fmt s, f1, f2, f3
    add_fmt d, f1, f2, f3
    add_fmt ps, f1, f2, f3

    div_fmt s, f1, f2, f3
    div_fmt d, f1, f2, f3
    div_fmt ps, f1, f2, f3

    madd_fmt s_3, f0, f1, f2, f3
    madd_fmt d_3, f0, f1, f2, f3
    madd_fmt ps_3, f0, f1, f2, f3

    msub_fmt s_3, f0, f1, f2, f3
    msub_fmt d_3, f0, f1, f2, f3
    msub_fmt ps_3, f0, f1, f2, f3

    mul_fmt s, f1, f2, f3
    mul_fmt d, f1, f2, f3
    mul_fmt ps, f1, f2, f3

    neg_fmt s, f1, f2
    neg_fmt d, f1, f2
    neg_fmt ps, f1, f2

    nmadd_fmt s_3, f0, f1, f2, f3
    nmadd_fmt d_3, f0, f1, f2, f3
    nmadd_fmt ps_3, f0, f1, f2, f3

    nmsub_fmt s_3, f0, f1, f2, f3
    nmsub_fmt d_3, f0, f1, f2, f3
    nmsub_fmt ps_3, f0, f1, f2, f3

    recip_fmt s, f1, f2
    recip_fmt d, f1, f2

    rsqrt_fmt s, f1, f2
    rsqrt_fmt d, f1, f2

    sqrt_fmt s, f1, f2
    sqrt_fmt d, f1, f2

    sub_fmt s, f1, f2, f3
    sub_fmt d, f1, f2, f3
    sub_fmt ps, f1, f2, f3

    C_cond f, s, 0, f31, f22
    C_cond2 un, d, f31, f22

    addi t0, zero, 2
    trace "(addi): t0 = %x", gpr_observer(8)

    daddi t0, t0, 1
    bc1f 0, :btothis
    daddi t0, t0, 1

    daddi t0, t0, 1
    daddi t0, t0, 1

    label :btothis
    daddi t0, t0, 1
    trace "(J = +5): t0 = %x", gpr_observer(8)

  end

end