all:
	nasm shellcode.asm
	nasm test.asm
	ndisasm -u shellcode

run:
	./demo shellcode

hex:
	echo -n "$(STR)" | od -A n -t x1

clean:
	rm -f *.o shellcode

.PHONY: clean run

