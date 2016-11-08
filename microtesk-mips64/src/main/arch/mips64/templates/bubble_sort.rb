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
# This test template demonstrates how MicroTESK can simulate the execution
# of a test program to predict the resulting state of a microprocessor
# design under test. The described test program is a simple implemention of 
# the bubble sort algorithm. The algorithm in pseudocode (from Wikipedia):
#
# procedure bubbleSort( A : list of sortable items )
#   n = length(A)
#   repeat 
#     swapped = false
#     for i = 1 to n-1 inclusive do
#       /* if this pair is out of order */
#       if A[i-1] > A[i] then
#         /* swap them and remember something changed */
#         swap( A[i-1], A[i] )
#         swapped = true
#       end if
#     end for
#   until not swapped
# end procedure
#
class BubbleSortTemplate < MIPS64BaseTemplate
  def pre
    super

    data {
      label :data
      dword rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      dword rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      dword rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      label :end
      space 1
    }
  end

  def run
    trace_data :data, :end

    la s0, :data
    la s1, :end

    Or t0, zero, zero
    ########################### Outer loop starts ##############################
    label :repeat

    daddi t1, s0, 8
    ########################### Inner loop starts ##############################
    label :for
    beq t1, s1, :exit_for
    daddi t2, t1, -8

    ld t4, 0, t1
    ld t5, 0, t2

    slt t6, t4, t5
    beq t6, zero, :next
    nop

    nor t0, zero, zero

    sd t4, 0, t2
    sd t5, 0, t1

    label :next
    j :for
    daddi t1, t1, 8
    ############################ Inner loop ends ###############################
    label :exit_for

    bne t0, zero, :repeat
    Or t0, zero, zero
    ############################ Outer loop ends ###############################

    trace_data :data, :end
  end

end