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
# This small tests for BPU instructions.
#

class InstructionBpuTemplate < Mips64BaseTemplate

  def run
    trace "Run BPU instruction:"

    trace "\nMIPS 32 branch:\n"

    # 1
    nop
   #beq zero, zero, 0
   #beq zero, zero, 0
    nop
    
  end

end