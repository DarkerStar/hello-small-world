
SHELL := /bin/sh

.SUFFIXES:
.SUFFIXES: .c .o

executables := hello

src := $(patsubst %,%.c,${executables})
obj := $(patsubst %,%.o,${executables})

all : ${executables}

.PHONY : all

.PHONY : clean
clean :
	-@rm -f -- ${executables} ${obj}
