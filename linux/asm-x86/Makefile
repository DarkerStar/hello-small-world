
SHELL := /bin/sh

.SUFFIXES:
.SUFFIXES: .asm

# Normal executables are executables that are built in the "normal" way, where
# the asm source is assembled to an object file then linked.
# Rawbin executables are executables defined byte-by-byte, and must be assembled
# as flat binary files - no linking or anything.
normal_executables := hello
rawbin_executables := hello-small hello-teensy

executables := ${normal_executables} ${rawbin_executables}

src := $(patsubst %,%.asm,${executables})
obj := $(patsubst %,%.o,${normal_executables})

all : ${executables}

.PHONY : all

${normal_executables} : % : %.o
	ld -s -o $@ $<

${obj} : %.o : %.asm
	nasm -f elf -o $@ $<

${rawbin_executables} : % : %.asm
	nasm -f bin -o $@ $<
	chmod +x $@

.PHONY : clean
clean :
	-@rm -f -- ${executables} ${obj}
