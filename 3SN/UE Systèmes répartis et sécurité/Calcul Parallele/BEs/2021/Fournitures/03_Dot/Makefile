CC=gcc
MPICC=smpicc #mpicc
CFLAGS=-g -O3 #-fsanitize=address
CLIBS=-lblas -llapack 

all: dotp

clean:
	rm -rf *.o dotp

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $< $(CFLAGS)

dotp: dotp.o
	$(MPICC) -Dhave_mpi -o $@ $^  -lm
