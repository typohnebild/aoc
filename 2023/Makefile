BUILDDIR = ./build
SRC := $(wildcard src/*.cpp)
BIN := $(SRC:src/%.cpp=$(BUILDDIR)/%)

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

$(BUILDDIR)/%: src/%.cpp
	$E "$(CXX)" "$@"
	$Q $(CXX) $(LDFLAGS) $(CXXFLAGS) -o $@ $<

clean:
	$E "CLEAN" ""
	$Q $(RM) $(OBJ) $(BIN)

.PHONY: all clean test
