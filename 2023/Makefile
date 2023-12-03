BUILDDIR = ./build
SRC := $(wildcard src/day*.cpp)
BIN := $(SRC:src/%.cpp=$(BUILDDIR)/%)
INCLUDE := $(wildcard include/*.hpp)
UTIL_O := util.o

# CONFIGURATION

ifeq "${VERBOSE}" ""
E=@printf "%-5s %s\n"
Q=@
else
E=@printf "\033[1;31m%-5s %s\033[0m\n"
Q=
endif

CXX = g++
LD = $(CXX)
RM = rm -rf

SHELL  ?= sh

CXXFLAGS = -std=c++20 -Wall -Werror -Wextra -Wshadow -g
LDFLAGS =
LDLIBS  =

all: $(BIN)

$(BUILDDIR)/%: src/%.cpp $(INCLUDE) $(BUILDDIR)/$(UTIL_O)
	$E "$(CXX)" "$@"
	$Q $(CXX) $(LDFLAGS) $(CXXFLAGS) $(BUILDDIR)/$(UTIL_O) -o $@ $<

$(BUILDDIR)/util.o: src/util.cpp $(INCLUDE)
	$E "$(CXX)" "$@"
	$Q $(CXX) $(LDFLAGS) $(CXXFLAGS) -c -o $@ $<

clean:
	$E "CLEAN" ""
	$Q $(RM) $(OBJ) $(BIN)

.PHONY: all clean test
