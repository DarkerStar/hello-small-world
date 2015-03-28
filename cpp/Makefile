
SHELL := /bin/sh

.SUFFIXES:
.SUFFIXES: .cpp .o

executables := hello

src := $(patsubst %,%.cpp,${executables})
obj := $(patsubst %,%.o,${executables})

all : ${executables}

.PHONY : all

${executables} : % : %.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@

${obj} : %.o : %.cpp

.PHONY : clean
clean :
	-@rm -f -- ${executables} ${obj}
