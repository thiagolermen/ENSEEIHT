CC=gcc
MPICC=smpicc #mpicc
CFLAGS=-g -O3 #-fsanitize=address
CLIBS=-lblas -llapack 
#INCLUDES=-I$(TOOLSDIR)/mpe2-2.4.9b/build/include/

all: limite

clean:
	rm -rf *.o limite

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $< $(CFLAGS)

limite: limite.o
	$(MPICC) -Dhave_mpi -o $@ $^ 
