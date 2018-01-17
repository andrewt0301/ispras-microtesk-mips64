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
# This test template demonstrates how to generate test cases for load/store instructions.
#
class LoadStoreTemplate < Mips64BaseTemplate
  def initialize
    super

    # Initialize settings here 
    @generate_data_files = false
    @align_test_case = true

    set_option_value 'branch-exec-limit', 90000
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
                        :count => -1,
                        :page_mask => 0x0fff}}) {
      label :m
      ld a0, 0x0, s0 do situation('memory', :engine => :memory, :base => 'ld.base') end
      sd a1, 0x0, s1 do situation('memory', :engine => :memory, :base => 'sd.base') end
    }.run
  end
end
