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
# This test template demonstrates how to generate test cases for load/store instructions
# using contraints on memory events.
#
class LoadStoreSituationTemplate < Mips64BaseTemplate
  def initialize
    super

    # Initialize settings here 
    @generate_data_files = false
    @align_test_case = true
  end

  def pre
    super

    prologue {
      if @align_test_case then
        align 4
        newline
      end
    }

    epilogue {
      newline
      comment('Additional load/store instructions')
      sd a0, 0x0, s0
      ld a1, 0x0, s1
    }
  end

  def run
    if @generate_data_files then
      # Generate data and place them into separate files.
      generate_data 0x00200000, :data_lo, 'dword', 4 * 1024 * 1024, :random
      generate_data 0x50200000, :data_hi, 'dword', 4 * 1024 * 1024, :random
    end

    # Generate pairs of LD/ST instructions.
    sequence(
        :engines => {
            :memory => {:classifier => 'event-based',
                        :page_mask => 0x0fff}}) {
      label :m

      ld a0, 0x0, s0 do situation(
        'memory',
        :engine => :memory,
        :base => 'ld.base',
        :path => constraints(
           hit('JTLB'),       # Hit in JTLB
           eq('JTLB.V0', 1),  # Validity bit is set
           eq('JTLB.V1', 1),  # Validity bit is set
           miss('L1'),        # Miss in L1
           hit('L2'))         # Hit in L2
           )
      end

      sd a1, 0x0, s1 do situation(
        'memory',
        :engine => :memory,
        :base => 'sd.base',
        :path => constraints(
           hit('JTLB'),       # Hit in JTLB
           eq('JTLB.V0', 1),  # Validity bit is set
           eq('JTLB.V1', 1),  # Validity bit is set
           event('L1',        # L1 event is randomly selected
             :hit => 70,      # Hit  in L1 is 70%
             :miss => 30))    # Miss in L1 is 30%
           )
      end
    }.run
  end
end
