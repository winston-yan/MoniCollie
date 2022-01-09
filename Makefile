# BEGIN of VARIABLE def

# ASSIGNMENT for VARIABLES
# 		:= simple      assign: only valid to the variable in this current statement
# 		=  recursive   assign: will affect any variables referring to this one
# 		?= conditional assign: if the variable is undefined, using value on the right; if not, this statement is invalid
# 		+= appending   assign: append a new value separated by space ' ' 

ODIR = ./build
EDIR = $(ODIR)
IDIR = ./include
SRCDIR = ./src

TARGET = $(EDIR)/server
CC = gcc
CXX = g++
CFLAGS = -Wall -Werror -O2 -g 
CFLAGS += -I $(IDIR)
CXXFLAGS = -std=c++14 $(CFLAGS)
# VFLAGS = -DVERBOSE $(CFLAGS)
LDFLAGS = -lpthread -lm 

# addprefix	function: add prefix to extension (HERE * is not wildcard character)
# wildcard 	function: explicitly match * ? regex, used for unfolding Variables

SRCS = $(wildcard $(addprefix $(SRCDIR)/*, .cpp))
# notdir   	function: remove dirpath from absolute filepath
# patsubst 	function: substitute suffix .cpp for .o

OBJS = $(patsubst %.cpp, $(ODIR)/%.o, $(notdir $(SRCS)))

DEPS = $(wildcard $(addprefix $(IDIR)/*, .h))

# END of VARIABLES def

# filter-out		: filter out the matched files
# 		   $@ symbol: THE obj file
# 		   $^ symbol: all the dependent file list 
# 		   $< symbol: the 1st dependent file 
# 		   $? symbol: dependent file list that is newer than THE obj file

$(ODIR)/%.o: $(SRCDIR)/%.cpp 
		$(CXX) -c $(CFLAGS) $< -o $@ $(LDFLAGS)
	
$(TARGET): $(OBJS)
		$(CXX) $(CFLAGS) $^ -o $(TARGET) $(LDFLAGS)

.PHONY: all clean

all: $(TARGET)
	@echo $(SRCS)
	@echo $(OBJS)
	@echo $(DEPS)

clean:
		rm -f $(ODIR)/*.o $(TARGET)
		
