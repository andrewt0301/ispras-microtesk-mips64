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
# This test template demonstrates how to generate test cases with branch instructions.
#
class BranchGeneration2Template < Mips64BaseTemplate 

  def pre
    super

    data {
      org 0x0
      align 8
      # Arrays to store test data for branch instructions.
      label :branch_data_0
      dword 0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0
      label :branch_data_1
      dword 0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0
      label :branch_data_2
      dword 0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0
      label :branch_data_3
      dword 0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,
            0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0,    0x0, 0x0, 0x0, 0x0
    }

    stream_preparator(:data_source => 'R', :index_source => 'R') {
      init {
        la index_source, start_label
      }

      read {
        ld data_source, 0x0, index_source
        addiu index_source, index_source, 8
      }

      write {
        sd data_source, 0x0, index_source
        addiu index_source, index_source, 8
      }
    }
  end

  def run
    # Stream  Label            Data  Addr   Size
    stream   :branch_data_0,   s0,   s4,   128
    stream   :branch_data_1,   s1,   s5,   128
    stream   :branch_data_2,   s2,   s6,   128
    stream   :branch_data_3,   s3,   s7,   128

    # Parameter 'branch_exec_limit' bounds the number of executions of a single branch:
    #   the default value is 1.
    # Parameter 'trace_count_limit' bounds the number of execution traces to be created:
    #   the default value is -1 (no limitation).
    block(
        :combinator => 'diagonal',
        :compositor => 'catenation',
        :engines => {
            :branch => {:branch_exec_limit => 3,
                        :block_exec_limit => 3,
                        :trace_count_limit => 10}}) {
      sequence {
        label :labelA
        pseudo '// Start Label'
      }

      block(:compositor => 'random', :permurator => 'random', :rearranger => 'expand') {
        # Labels
        iterate {
          sequence {
            label :label0
              pseudo '// Basic Block 0'
          }

          sequence {
            label :label1
              pseudo '// Basic Block 1'
          }

          sequence {
            label :label2
              pseudo '// Basic Block 2'
          }

          sequence {}
          sequence {}
        }

        block(:combinator => 'diagonal') {
          sequence {
            nop
          }

          block(:combinator => 'diagonal') {
            # Branches
            iterate {
              bgez s0, :label0 do
                situation('bgez-if-then', :engine => :branch, :stream => 'branch_data_0')
              end
              bgtz s1, :label1 do
                situation('bgtz-if-then', :engine => :branch, :stream => 'branch_data_1')
              end
              blez s2, :label2 do
                situation('blez-if-then', :engine => :branch, :stream => 'branch_data_2')
              end
              bltz s3, :labelZ do
                situation('bltz-if-then', :engine => :branch, :stream => 'branch_data_3')
              end
              b :labelA do
                situation('b-goto', :engine => :branch)
              end
            }

            # Injected Code placed in delay slot
            iterate {
              # The code must not modify registers s0-s7
              addiu reg1=get_register, reg1, 1
              ori   reg2=get_register, reg2, 2
              addiu reg3=get_register, reg3, 3
              ori   reg4=get_register, reg4, 4
              addiu reg5=get_register, reg5, 5
            }
          }
        }
      }

      sequence {
        label :labelZ
        pseudo '// End Label'
      }
    }.run 10 # Try several random compositions
  end
end
