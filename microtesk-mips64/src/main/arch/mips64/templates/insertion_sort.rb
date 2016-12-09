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
# design under test. The described test program is an implemention of 
# the insertion sort algorithm. The algorithm in pseudocode (from Wikipedia):
#
# for i = 1 to length(A) - 1
#   x = A[i]
#   j = i
#   while j > 0 and A[j-1] > x
#     A[j] = A[j-1]
#     j = j - 1
#   A[j] = x
#
class InsertionSortTemplate < Mips64BaseTemplate

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
    ori s2, zero, 8

    dadd t0, s0, s2
    ########################### Outer loop starts ##############################
    label :for
    beq t0, s1, :exit_for

    Or t1, zero, t0
    ld s3, 0, t0
    ########################### Inner loop starts ##############################
    label :while
    beq t1, s0, :exit_while

    dsub t3, t1, s2
    ld s4, 0, t3
    slt t2, s3, s4

    beq t2, zero, :exit_while
    nop

    sd s4, 0, t1

    j :while
    dsub t1, t1, s2
    ############################ Inner loop ends ###############################
    label :exit_while

    sd s3, 0, t1

    j :for
    dadd t0, t0, s2
    ############################ Outer loop ends ###############################
    label :exit_for

    trace_data :data, :end
  end

end
