TESTS = bubble_sort\
        bubble_sort_word\
        euclid\
        instruction_alu\
        instruction_mmu\
        load_store\
        load_store_situation

all: $(TESTS)

$(TESTS):
	sh run.sh $@

clean:
	rm *.s *.o *.bin *.elf *.stdout *.stderr -f
