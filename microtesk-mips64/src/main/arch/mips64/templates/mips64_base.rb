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

require ENV['TEMPLATE']

class Mips64BaseTemplate < Template
  def initialize
    super
    # Initialize settings here 
    @setup_memory = false
    @setup_cache = false
    @kseg0_cache_policy = 0

    # Sets the indentation token used in test programs
    set_option_value 'indent-token', "\t"
    set_option_value 'comment-token', "#"

    # Sets the token used in separator lines printed into test programs
    set_option_value 'separator-token', "="
  end

  def boot
  end

  ##################################################################################################
  # Prologue
  ##################################################################################################

  def pre
    ################################################################################################

    def section_text_va
      0xFFFFffff80000000
    end
    def st_va_start # Special for boot definition
      0x8000
    end

    #
    # Boot definition (ROM).
    #
    section(:name => 'boot', :pa => 0x000000001fc00000, :va => 0xFFFFffffbfc00000, :file => true) {
      trace 'boot start (EPC = 0x%x)', location('CPR', 14 * 8)

      text ".text"
      text ".set noreorder"
      text ".list"
      newline

      # CP0 registers modification
      mfc0 t0, c0_status
      # prepare t2, 0x00400004 # Mask for bit(s) to be cleared: ERL->0
      lui t2, 0x0040
      ori t2, t2, 0x0004
      # prepare t1, 0x04000080 # Mask for bit(s) to be set: FR=1, KX=1
      lui t1, 0x0400
      ori t1, t1, 0x0080
      nor t2, zero, t2
      AND t0, t0, t2
      OR t0, t0, t1
      mtc0 t0, c0_status
      newline

      mfc0 t0, c0_config0
      # prepare t2, 0x00200007 # Mask for bit(s) to be cleared: L2->On, C
      lui t2, 0x0020
      ori t2, t2, 0x0007
      # prepare t1, 0x00000003 # Mask for bit(s) to be set: C=3
      lui t1, 0x0000
      ori t1, t1, 0x0003
      nor t2, zero, t2
      AND t0, t0, t2
      OR t0, t0, t1
      mtc0 t0, c0_config0
      mtc0 zero, c0_compare
      newline

      # Copy exception jumpers into RAM
      lui t0, 0xbfc0
      ori t0, t0, 0x0
      lui t1, st_va_start # pa => 0x00080000
      ori t1, t1, 0x0
      newline

      ld t2, 0x200, t0
      sd t2, 0x000, t1
      sd t2, 0x080, t1
      sd t2, 0x180, t1
      ld t2, 0x208, t0
      sd t2, 0x008, t1
      sd t2, 0x088, t1
      sd t2, 0x188, t1
      ld t2, 0x210, t0
      sd t2, 0x010, t1
      sd t2, 0x090, t1
      sd t2, 0x190, t1
      ld t2, 0x218, t0
      sd t2, 0x018, t1
      sd t2, 0x098, t1
      sd t2, 0x198, t1
      newline

      # Jump to test program 0xFFFFffffa0002000
      lui t0, st_va_start # pa => 0x00080000
      ori t0, t0, 0x2000
      jr t0
      nop
      newline

      # Next parts of the code will be copied to a0000000, a0000080, a0000180
      # WARNING: all handlers must be just the same
      org 0x200 # TLB Refill
      mthi t0
      mfc0 t0, c0_epc
      addiu t0, t0, 4
      mtc0 t0, c0_epc
      mfhi t0
      ssnop
      ssnop
      eret
      newline

      org 0x280 # XTLB Refill
      mthi t0
      mfc0 t0, c0_epc
      addiu t0, t0, 4
      mtc0 t0, c0_epc
      mfhi t0
      ssnop
      ssnop
      eret
      newline

      org 0x380 # Others
      mthi t0
      mfc0 t0, c0_epc
      addiu t0, t0, 4
      mtc0 t0, c0_epc
      mfhi t0
      ssnop
      ssnop
      eret
      newline

      nop
      nop
      nop
      nop
    }

    ################################################################################################

    #
    # Information on data types to be used in data sections.
    #
    data_config(:target => 'MEM') {
      define_type :id => :byte,  :text => '.byte',  :type => type('card', 8)
      define_type :id => :half,  :text => '.half',  :type => type('card', 16)
      define_type :id => :word,  :text => '.word',  :type => type('card', 32)
      define_type :id => :dword, :text => '.dword', :type => type('card', 64)

      define_space        :id => :space,  :text => '.space',  :fill_with => 0
      define_ascii_string :id => :ascii,  :text => '.ascii',  :zero_term => false
      define_ascii_string :id => :asciiz, :text => '.asciiz', :zero_term => true
    }

    #
    # Defines .text section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section_text(:pa => 0x0000000000000000, :va => section_text_va) {}

    #
    # Defines .data section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section_data(:pa => 0x0000000000080000, :va => 0xFFFFffff80080000) {}

    def mips64_r5
      if get_option_value('rev-id') == 'MIPS64_R5' then
        true
      else
        false
      end
    end

    def mips64_r6
      if get_option_value('rev-id') == 'MIPS64_R6' || get_option_value('rev-id') == 'MIPS64' then
        true
      else
        false
      end
    end

    #
    # Simple exception handler. Continues execution from the next instruction.
    #
    exception_handler {
      entry_point(:org => 0x200, :exception => ['TLB Refill']) {
        trace 'Exception handler (EPC = 0x%x)', location('CPR', 14 * 8)
        mfc0 ra, c0_epc
        addiu ra, ra, 4
        jr ra
        nop
      }
      entry_point(:org => 0x280, :exception => ['XTLB Refill']) {
        trace 'Exception handler (EPC = 0x%x)', location('CPR', 14 * 8)
        mfc0 ra, c0_epc
        addiu ra, ra, 4
        jr ra
        nop
      }
      entry_point(:org => 0x380, :exception => ['IntegerOverflow',
                                                'SystemCall',
                                                'Breakpoint',
                                                'TLBInvalid',
                                                'TLBMiss']) {
        trace 'Exception handler (EPC = 0x%x)', location('CPR', 14 * 8)
        mfc0 ra, c0_epc
        addiu ra, ra, 4
        jr ra
        nop
      }
    }

    ################################################################################################

    #
    # The code below specifies an instruction sequence that writes a value
    # to the specified register (target) via the R addressing mode.
    #
    # Default preparator: It is used when no special case previded below
    # is applicable.
    #
    preparator(:target => 'R') {
      ori  target, zero,   value(48, 63)
      dsll target, target, 16
      ori  target, target, value(32, 47)
      dsll target, target, 16
      ori  target, target, value(16, 31)
      dsll target, target, 16
      ori  target, target, value(0,  15)
    }

    preparator(:target => 'R', :arguments => {:i => 0}) {
      # Empty
    }

    preparator(:target => 'R', :mask => "0000000000000000") {
      Or target, zero, zero
    }

    preparator(:target => 'R', :mask => "FFFFFFFFFFFFFFFF") {
      nor target, zero, zero
    }

    preparator(:target => 'R', :mask => "000000000000XXXX") {
      ori target, zero, value(0, 15)
    }

    preparator(:target => 'R',
             :mask => "'b11111111_11111111_11111111_11111111_1xxxxxxx_xxxxxxxx_00000000_00000000") {
      lui target, value(16, 31)
    }

    preparator(:target => 'R',
             :mask => "'b00000000_00000000_00000000_00000000_0xxxxxxx_xxxxxxxx_00000000_00000000") {
      lui target, value(16, 31)
    }

    preparator(:target => 'R', :mask => "00000000XXXX0000") {
      ori  target, zero, value(16, 31)
      dsll target, target, 16
    }

    preparator(:target => 'R', :mask => "0000XXXX00000000") {
      ori    target, zero, value(32, 47)
      dsll32 target, target, 0
    }

    preparator(:target => 'R', :mask => "XXXX000000000000") {
      ori    target, zero,   value(48, 63)
      dsll32 target, target, 16
    }

    preparator(:target => 'R',
             :mask => "'b11111111_11111111_11111111_11111111_1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx") {
      lui target, value(16, 31)
      ori target, target, value(0, 15)
    }

    preparator(:target => 'R',
             :mask => "'b00000000_00000000_00000000_00000000_0xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx") {
      lui target, value(16, 31)
      ori target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "00000000XXXXXXXX") {
      ori  target, zero,   value(16, 31)
      dsll target, target, 16
      ori  target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "0000XXXX0000XXXX") {
      ori    target, zero,   value(32, 47)
      dsll32 target, target, 0
      ori    target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "XXXX00000000XXXX") {
      ori    target, zero,   value(48, 63)
      dsll32 target, target, 16
      ori    target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "0000XXXXXXXX0000") {
      ori  target, zero,   value(32, 47)
      dsll target, target, 16
      ori  target, target, value(16, 31)
      dsll target, target, 16
    }

    preparator(:target => 'R', :mask => "XXXX0000XXXX0000") {
      ori    target, zero,   value(48, 63)
      dsll32 target, target, 0
      ori    target, target, value(16, 31)
      dsll   target, target, 16
    }

    preparator(:target => 'R', :mask => "XXXXXXXX00000000") {
      ori    target, zero,   value(48, 63)
      dsll   target, target, 16
      ori    target, target, value(32, 47)
      dsll32 target, target, 0
    }

    preparator(:target => 'R', :mask => "0000XXXXXXXXXXXX") {
      ori  target, zero,   value(32, 47)
      dsll target, target, 16
      ori  target, target, value(16, 31)
      dsll target, target, 16
      ori  target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "XXXXXXXXXXXX0000") {
      ori  target, zero,   value(48, 63)
      dsll target, target, 16
      ori  target, target, value(32, 47)
      dsll target, target, 16
      ori  target, target, value(16, 31)
      dsll target, target, 16
    }

    preparator(:target => 'R', :mask => "XXXXXXXX0000XXXX") {
      ori    target, zero,   value(48, 63)
      dsll   target, target, 16
      ori    target, target, value(32, 47)
      dsll32 target, target, 0
      ori    target, target, value(0, 15)
    }

    preparator(:target => 'R', :mask => "XXXX0000XXXXXXXX") {
      ori    target, zero,   value(48, 63)
      dsll32 target, target, 0
      ori    target, target, value(16, 31)
      dsll   target, target, 16
      ori    target, target, value(0, 15)
    }

    preparator(:target => 'C0_R') {
      # Do nothing.
    }

    preparator(:target => 'FR') {
      # TODO
    }

    ################################################################################################

    buffer_preparator(:target => 'DTLB') {
      newline
      comment('Prepare DTLB')

      # TODO: Reuse the register preparator.
      prepare(t0, address)
      lb t0, 0, t0
    }

    buffer_preparator(:target => 'JTLB') {
      newline
      comment('Prepare JTLB')

      # TODO: Reuse the register preparator.
      ori  t0, zero, address
      mtc0 t0, c0_index

      ori  t0, zero, entry(64 + 48, 64 + 63)
      dsll t0, t0, 16
      ori  t0, t0, entry(64 + 32, 64 + 47)
      dsll t0, t0, 16
      ori  t0, t0, entry(64 + 16, 64 + 31)
      dsll t0, t0, 16
      ori  t0, t0, entry(64 + 0,  64 + 15)
      mtc0 t0, c0_entryhi

      lui  t0, entry(32 + 16, 32 + 31)
      ori  t0, zero, entry(32 + 0, 32 + 15)
      mtc0 t0, c0_entrylo0

      lui  t0, entry(0 + 16, 0 + 31)
      ori  t0, zero, entry(0 + 0, 0 + 15)
      mtc0 t0, c0_entrylo1

      ssnop
      ssnop
      tlbwi
      ssnop
      ssnop
    }

    buffer_preparator(:target => 'L1') {
      newline
      comment('Prepare L1')

      # TODO: Reuse the register preparator.
      ori  t0, zero, 0xb800 # XKPHYS with CCA=3.
      dsll t0, t0, 16
      ori  t0, t0, address(32, 35)
      dsll t0, t0, 16
      ori  t0, t0, address(16, 31)
      dsll t0, t0, 16
      ori  t0, t0, address(0,  15)
      lb   t0, 0, t0
    }

    buffer_preparator(:target => 'L2') {
      newline
      comment('Prepare L2')

      # TODO: Reuse the register preparator.
      ori  t0, zero, 0xb800 # XKPHYS with CCA=3.
      dsll t0, t0, 16
      ori  t0, t0, address(32, 35)
      dsll t0, t0, 16
      ori  t0, t0, address(16, 31)
      dsll t0, t0, 16
      ori  t0, t0, address(0,  15)
      lb   t0, 0, t0
    }

    ################################################################################################

    # The code below specifies a comparator sequence to be used in self-checking tests
    # to test values in the specified register (target) accessed via the REG
    # addressing mode.
    #
    # Comparators are described using the same syntax as in preparators and can be
    # overridden in the same way..
    #
    # Default comparator: It is used when no special case is applicable.
    #
    comparator(:target => 'R') {
      lui at, value(16, 31)
      ori at, at, value(0, 15)

      bne at, target, :check_failed
      nop
    }

    #
    # Special case: Target is $zero register. Since it is read only and
    # always equal zero, it makes no sence to test it.
    #
    comparator(:target => 'R', :arguments => {:i => 0}) {
      # Empty
    }

    #
    # Special case: Value equals 0x00000000. In this case, it is
    # more convenient to test the target against the $zero register.
    #
    comparator(:target => 'R', :mask => "00000000") {
      bne zero, target, :check_failed
      nop
    }

    ################################################################################################

    # The code below specifies default situations that generate random values
    # for instructions which require arguments to be 32-bit sign-extended values.

    # Generator of 32-bit random values which will be sign-extended to fit the target register.
    random_word = situation('random', :size => 32, :sign_extend => true)

    # Input arguments of all instructions listed below are random words.
    set_default_situation 'add'   do random_word end
    set_default_situation 'addi'  do random_word end
    set_default_situation 'addiu' do random_word end
    set_default_situation 'addu'  do random_word end
    set_default_situation 'sub'   do random_word end
    set_default_situation 'subu'  do random_word end

    ################################################################################################

    text ".nolist"
    text ".set noreorder"
    newline
    text "#include \"regdef_mips64.h\""
    text "#include \"kernel_mips64.h\""
    newline
    text ".list"
    text ".text"
    text ".globl __start"
    newline
    # TODO: this address seems wrong for QEMU4V emulation
    org 0x2000
    newline

label :__start
    j :test
    nop
    newline

label :test
    mfc0 t8, c0_config0
    lui  t9, 0xffff
    ori  t9, t9, 0xfffa # TODO a -> 8
    AND  t8, t8, t9

    if @kseg0_cache_policy != 0
      ori t8, t9, @kseg0_cache_policy
    end

    mtc0 t8, c0_config0
    ssnop
    ssnop

    if @setup_memory
      newline
      jal :memory_setup
      nop
    end

    if @setup_cache
      newline
      jal :cache_setup
      nop
    end
  end

  ##################################################################################################
  # Epilogue
  ##################################################################################################

  def post
label :success
    ori v0, zero, 0x1234
    ori v1, zero, 0x0
    nop
    wait 0x7ffff
    newline

label :error
    lui v0, 0xdead
    ori v0, v0, 0xbeef
    nop
    wait 0x7ffff
    newline

    if @setup_memory
      text "TODO: setup memory"
    end
    if @setup_cache
      text "TODO: setup cache"
    end

    6.times {
      nop
    }
  end

  ##################################################################################################
  # Aliases for GPR Registers
  ##################################################################################################

  def zero
    r(0)
  end

  def at
    r(1)
  end

  def v0
    r(2)
  end

  def v1
    r(3)
  end

  def a0
    r(4)
  end

  def a1
    r(5)
  end

  def a2
    r(6)
  end

  def a3
    r(7)
  end

  def t0
    r(8)
  end

  def t1
    r(9)
  end

  def t2
    r(10)
  end

  def t3
    r(11)
  end

  def t4
    r(12)
  end

  def t5
    r(13)
  end

  def t6
    r(14)
  end

  def t7
    r(15)
  end

  def s0
    r(16)
  end

  def s1
    r(17)
  end

  def s2
    r(18)
  end

  def s3
    r(19)
  end

  def s4
    r(20)
  end

  def s5
    r(21)
  end

  def s6
    r(22)
  end

  def s7
    r(23)
  end

  def t8 
    r(24)
  end

  def t9
    r(25)
  end

  def k0 
    r(26)
  end

  def k1 
    r(27)
  end

  def gp
    r(28)
  end

  def sp
    r(29)
  end

  def fp
    r(30)
  end

  def ra
    r(31)
  end

  ##################################################################################################
  # Aliases for CP0 Registers
  ##################################################################################################

  def c0_index
    c0_r(0, 0)
  end

  def c0_random
    c0_r(1, 0)
  end

  def c0_entrylo0
    c0_r(2, 0)
  end

  def c0_entrylo1
    c0_r(3, 0)
  end

  def c0_context
    c0_r(4, 0)
  end

  def c0_pagemask
    c0_r(5, 0)
  end

  def c0_wired
    c0_r(6, 0)
  end

  def c0_badvaddr
    c0_r(8, 0)
  end

  def c0_count
    c0_r(9, 0)
  end

  def c0_entryhi
    c0_r(10, 0)
  end

  def c0_compare
    c0_r(11, 0)
  end

  def c0_status
    c0_r(12, 0)
  end

  def c0_cause
    c0_r(13, 0)
  end

  def c0_epc
    c0_r(14, 0)
  end

  def c0_prid
    c0_r(15, 0)
  end

  def c0_config0
    c0_r(16, 0)
  end

  def c0_config1
    c0_r(16, 1)
  end

  def c0_xcontext
    c0_r(20, 0)
  end

  def c0_perfcnt0
    c0_r(25, 0)
  end

  def c0_perfcnt1
    c0_r(25, 1)
  end

  def c0_perfcnt2
    c0_r(25, 2)
  end

  def c0_perfcnt3
    c0_r(25, 3)
  end

  def c0_errctl
    c0_r(26, 0)
  end

  def c0_taglo
    c0_r(28, 0)
  end

  def c0_datalo
    c0_r(28, 1)
  end

  def c0_taghi
    c0_r(29, 0)
  end

  def c0_datahi
    c0_r(29, 1)
  end

  def c0_errorepc
    c0_r(30, 0)
  end

  ##################################################################################################
  # Aliases for FPU Registers
  ##################################################################################################

  def f0
    fr(0)
  end

  def f1
    fr(1)
  end

  def f2
    fr(2)
  end

  def f3
    fr(3)
  end

  def f4
    fr(4)
  end

  def f5
    fr(5)
  end

  def f6
    fr(6)
  end

  def f7
    fr(7)
  end

  def f8
    fr(8)
  end

  def f9
    fr(9)
  end

  def f10
    fr(10)
  end

  def f11
    fr(11)
  end

  def f12
    fr(12)
  end

  def f13
    fr(13)
  end

  def f14
    fr(14)
  end

  def f15
    fr(15)
  end

  def f16
    fr(16)
  end

  def f17
    fr(17)
  end

  def f18
    fr(18)
  end

  def f19
    fr(19)
  end

  def f20
    fr(20)
  end

  def f21
    fr(21)
  end

  def f22
    fr(22)
  end

  def f23
    fr(23)
  end

  def f24
    fr(24)
  end

  def f25
    fr(25)
  end

  def f26
    fr(26)
  end

  def f27
    fr(27)
  end

  def f28
    fr(28)
  end

  def f29
    fr(29)
  end

  def f30
    fr(30)
  end

  def f31
    fr(31)
  end

  ##################################################################################################
  # Aliases for fmt
  ##################################################################################################

  def s
    FMT_FORMAT_S()
  end

  def d
    FMT_FORMAT_D()
  end

  def ps
    FMT_FORMAT_PS()
  end

  def l
    FMT_FORMAT_L()
  end

  def w
    FMT_FORMAT_W()
  end

  ##################################################################################################
  # Aliases for 3 bit fmt
  ##################################################################################################

  def s_3
    FMT3_FORMAT_S()
  end

  def d_3
    FMT3_FORMAT_D()
  end

  def ps_3
    FMT3_FORMAT_PS()
  end

  ##################################################################################################
  # Aliases for fpu cond
  ##################################################################################################

  def f
    F_COND()
  end

  def un
    UN_COND()
  end

  def eq2
    EQ_COND()
  end

  def ueq
    UEQ_COND()
  end

  def olt
    OLT_COND()
  end

  def ult
    ULT_COND()
  end

  def ole
    OLE_COND()
  end

  def ule
    ULE_COND()
  end

  def sf
    SF_COND()
  end

  def ngle
    NGLE_COND()
  end

  def seq
    SEQ_COND()
  end

  def ngl
    NGL_COND()
  end

  def lt
    LT_COND()
  end

  def nge
    NGE_COND()
  end

  def le
    LE_COND()
  end

  def ngt
    NGT_COND()
  end

  ##################################################################################################
  # Shortcut methods to access memory resources in debug messages.
  ##################################################################################################

  def gpr_observer(index)
    location('GPR', index)
  end

  def mem_observer(index)
    location('MEM', index)
  end

  ##################################################################################################
  # Utility methods for printing data stored in memory using addresses/labels.
  ##################################################################################################

  def trace_data_addr(begin_addr, end_addr)
    count = (end_addr - begin_addr) / 8
    additional_count = (end_addr - begin_addr) % 8
    if additional_count > 0
       count = count + 1
    end
    begin_index = begin_addr / 8 

    trace "\nData starts: 0x%x", begin_addr
    trace "Data ends:   0x%x", end_addr
    trace "Data count:  %d", count

    index = begin_index
    addr = begin_addr

    trace "\nData values:"
    count.times {
      trace "%016x (MEM[0x%x]): 0x%016x", addr, index, mem_observer(index)
      index = index + 1
      addr = addr + 8
    }
    trace ""
  end

  def trace_data(begin_label, end_label)
    begin_addr = get_address_of(begin_label) - section_text_va
    end_addr = get_address_of(end_label) - section_text_va

    trace_data_addr(begin_addr, end_addr)
  end

  ###################################################################################################
  # Utility method to remove the specified addressing mode from the list of used registers.
  ###################################################################################################

  def free_register(mode)
    free_allocated_mode mode
  end

end # MIPS64BaseTemplate
