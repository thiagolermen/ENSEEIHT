CC=gcc
MPICC=smpicc #mpicc
CFLAGS=-g -O3 #-fsanitize=address
CLIBS=-lblas -llapack 

all: MultAv

clean:
	rm -rf *.o MultAv

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $< $(CFLAGS)

MultAv: MultAv.o
	$(MPICC) -Dhave_mpi -o $@ $^ 
