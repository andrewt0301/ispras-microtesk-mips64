#
# MicroTESK MIPS64 Edition
#
# Copyright (c) 2017-2018 Institute for System Programming of the Russian Academy of Sciences
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
# This test template demonstrates how to generate test cases for load/store instructions.
#
class LoadStoreTemplate < Mips64BaseTemplate
  def initialize
    super

    # Initialize settings here 
    @generate_data_files = false
    @align_test_case = true

    # Exception handler is executed many times
    set_option_value 'branch-exec-limit', 10000
  end

  def pre
    super

    memory_preparator(:size => 64) {
      prepare t0, value

      ori  t1, zero, 0x9000 # XKPHYS with CCA=2 (Uncacheable).
      dsll t1, t1, 16
      ori  t1, t1, address(32, 35)
      dsll t1, t1, 16
      ori  t1, t1, address(16, 31)
      dsll t1, t1, 16
      ori  t1, t1, address(0,  15)

      sd t0, 0, t1
    }

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
      nop
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
                        :count => 100,
                        :page_mask => 0x0fff}}) {
      label :m
      ld a0, 0x0, s0 do situation('memory', :engine => :memory, :base => 'ld.base') end
      sd a1, 0x0, s1 do situation('memory', :engine => :memory, :base => 'sd.base') end
    }.run
  end
end
