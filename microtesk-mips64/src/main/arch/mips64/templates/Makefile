TESTS = arithmetic\
        block\
        branch_generation\
        branch_generation1\
        branch_generation2\
        bubble_sort\
        bubble_sort_byte\
        bubble_sort_hword\
        bubble_sort_word\
        coverage\
        data\
        euclid\
        groups\
        insertion_sort\
        instruction_alu\
        instruction_mmu\
        int_divide\
        int_exception\
        int_sqrt\
        int_sqrt4\
        load_store\
        load_store_situation\
        min_max\
        random\
        register_allocation

SELFCHECK_TESTS = selfcheck_example\
                  selfcheck_example2

all: $(TESTS) $(SELFCHECK_TESTS)

$(TESTS):
	sh run.sh $@

$(SELFCHECK_TESTS):
	sh run-sc.sh $@

clean:
	rm *.s *.o *.bin *.elf *.stdout *.stderr -f