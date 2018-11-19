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
# This small tests for ALU instructions.
#

class InstructionAluTemplate < Mips64BaseTemplate

  def run
    trace "Run ALU instruction:"

    random_reg = r(_)
    random_reg2 = r(_)
    addi random_reg, zero, -5
    add random_reg2, random_reg, random_reg

    trace "\nMIPS 32 Arithmetic:\n"

    trace "(addi): t0 = %x", gpr_observer(8)
    addi t0, zero, -5
    trace "(addi): t0 = %x", gpr_observer(8)
    addiu t2, zero, 111
    trace "(addiu): t2 = %x", gpr_observer(10)
   # aui t2, zero, 0x1EAD
    trace "(aui): t2 = %x", gpr_observer(10)

    add t1, t0, t0
    trace "(add): t1 = %x", gpr_observer(9)
    addu t1, t0, t0
    trace "(addu): t1 = %x", gpr_observer(9)

    if mips64_r6 == true then
      addi t3, zero, 0xdead
    end
    #TODO: rev versions

    clo t2, t3
    trace "(clo): t2 = %d", gpr_observer(10)
    clz t2, t3
    trace "(clz): t2 = %d", gpr_observer(10)
    
   # addiupc t3, 0x0300
    trace "(addiupc): t1 = %x", gpr_observer(11)

    addi t6, zero, 5
    addi t7, zero, 3
    if mips64_r6 then
    div_reg t8, t6, t7
    mod_reg t9, t6, t7
    trace "(div_reg, mod_reg) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    divu_reg t8, t6, t7
    modu_reg t9, t6, t7
    trace "(divu_reg, modu_reg) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    end

    div t6, t7
    mflo t8
    mfhi t9
    trace "(div) t6 = %x", gpr_observer(14)
    trace "(div) t7 = %x", gpr_observer(15)
    trace "(div) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    divu t6, t7
    mflo t8
    mfhi t9
    trace "(divu) t6 = %x", gpr_observer(14)
    trace "(divu) t7 = %x", gpr_observer(15)
    trace "(divu) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)

    mthi zero
    mtlo zero
    addi t1, zero, 3
    addi t2, zero, 3
    madd t1, t2
    mflo t8
    mfhi t9
    trace "(madd) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    mthi zero
    mtlo zero
    maddu t1, t2
    mflo t8
    mfhi t9
    trace "(maddu) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    mthi zero
    mtlo zero
    addi t1, zero, -2
    addi t2, zero, 3
    msub t1, t2
    mflo t8
    mfhi t9
    trace "(msub) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    mthi zero
    mtlo zero
    msubu t1, t2
    mflo t8
    mfhi t9
    trace "(msubu) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)

    if mips64_r6 then
    mul_reg t1, t2, t3
    muh_reg t1, t2, t3
    end

    trace "\nMIPS 32 Logical:\n"

    AND t3, t1, t2
    trace "(and): t3 = %x", gpr_observer(11)
    OR t3, t1, t2
    trace "(or): t3 = %x", gpr_observer(11)
    nor t3, t1, t2
    trace "(nor): t3 = %x", gpr_observer(11)
    xor t3, t1, t2
    trace "(xor): t3 = %x", gpr_observer(11)
    slt  t3, t1, t2
    trace "(slt): t3 = %x", gpr_observer(11)
    sltu  t3, t1, t2
    trace "(sltu): t3 = %x", gpr_observer(11)

    andi t4, t1, 55
    trace "(andi): t4 = %x", gpr_observer(12)
    ori t4, t1, 55
    trace "(ori): t4 = %x", gpr_observer(12)
    xori t4, t1, 55
    trace "(xori): t4 = %x", gpr_observer(12)
    slti t4, t1, 55
    trace "(slti): t4 = %x", gpr_observer(12)
    sltiu t4, t1, 55
    trace "(sltiu): t4 = %x", gpr_observer(12)

    trace "\nMIPS 32 Shift:\n"

    # make: addi t1, zero, 0xDEADBEAF
    addi t1, zero, 0xDEAD
    sll  t8, t1, 16
    OR   t9, t8, zero
    addi t1, zero, 0x7EAF
    OR   t9, t9, t1
    trace "t9 = %x", gpr_observer(25)
    
    addiu t2, zero, 8
    #rotr t5, t9, 16
    trace "(rotr): t5 = %x", gpr_observer(13)
    sll t5, t9, 4
    trace "(sll): t5 = %x", gpr_observer(13)
    srl t7, t9, 24
    trace "(srl): t7 = %x", gpr_observer(15)
    sra t7, t9, 20
    trace "(sra): t7 = %x", gpr_observer(15)

    #rotrv t6, t9, t2
    trace "(rotrv): t6 = %x", gpr_observer(14)
    sllv t6, t9, t2
    trace "(sllv): t6 = %x", gpr_observer(14)
    srlv t7, t9, t2
    trace "(srlv): t7 = %x", gpr_observer(15)
    srav t7, t9, t2
    trace "(srav): t7 = %x", gpr_observer(15)

    trace "\nMIPS 64 Arithmetic:\n"

    #daui t2, t1, 0xAB
    trace "(daui): t2 = %x", gpr_observer(10)
    #dahi t2, 0xAB
    trace "(dahi): t2 = %x", gpr_observer(10)
    #dati t2, 0xAB
    trace "(dati): t2 = %x", gpr_observer(10)

    if mips64_r6 then
    addi t6, zero, 5
    addi t7, zero, 3
    ddiv_reg t8, t6, t7
    dmod_reg t9, t6, t7
    trace "(ddiv_reg, dmod_reg) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    ddivu_reg t8, t6, t7
    dmodu_reg t9, t6, t7
    trace "(ddivu_reg, dmodu_reg) t8 = %x, t9 = %x", gpr_observer(24), gpr_observer(25)
    end

    trace "\nMIPS 32/64 Insert:\n"
    la t1, 0xffffffffffffffff
    trace "(ins): t1 = %x", gpr_observer(9)
    la t2, 0x0000000000000000
    trace "(ins): t2 = %x", gpr_observer(10)
    ins t1, t2, 3, 6
    trace "(ins) result: t1 = %x", gpr_observer(9)

    trace "(------): t1 = %x", gpr_observer(9)
    trace "(------): t2 = %x", gpr_observer(10)
    addi t1, zero, 0
    addi t2, zero, 0
    trace "(------): t1 = %x", gpr_observer(9)
    trace "(------): t2 = %x", gpr_observer(10)

    la t1, 0xfabcdef1
    trace "(dins): t1 = %x", gpr_observer(9)
    la t2, 0x01010101
    trace "(dins): t2 = %x", gpr_observer(10)
    dins t2, t1, 12, 8
    trace "(dins) result: t2 = %x", gpr_observer(10)

    ori t2, zero, 0x1ead
    sll t2, t2, 16
    ori t2, t2, 0xdeaf
    dsll32 t8, t2, 0
    ori t2, zero, 0x1bcd
    sll t2, t2, 16
    ori t2, t2, 0x7efd
    OR    t4, t8, t2
    trace "t4 = %x", gpr_observer(12)
    ori t2, zero, 0x0101
    sll t2, t2, 16
    ori t2, t2, 0x0101
    dsll32 t8, t2, 0
    ori t2, zero, 0x0101
    sll t2, t2, 16
    ori t2, t2, 0x0101
    OR    t5, t8, t2
    trace "t5 = %x", gpr_observer(13)
    OR t6, zero, t5

    dinsm t6, t4, 12, 24
    trace "(dinsm) result: t6 = %x", gpr_observer(14)
    dinsu t5, t4, 36, 12
    trace "(dinsu) result: t5 = %x", gpr_observer(13)

    ext t5, t2, 4, 8
    trace "(ext) result: t5 = %x", gpr_observer(13)

    ori t2, zero, 0x1ead
    sll t2, t2, 16
    ori t2, t2, 0xdeaf
    wsbh t5, t2
    trace "(wsbh) result: t5 = %x", gpr_observer(13)
  end

end
