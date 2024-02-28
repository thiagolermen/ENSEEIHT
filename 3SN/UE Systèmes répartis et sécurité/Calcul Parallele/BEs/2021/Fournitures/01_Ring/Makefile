CC=gcc
MPICC=smpicc #mpicc
CFLAGS=-g -O3 #-fsanitize=address
CLIBS=-lblas -llapack 
#INCLUDES=-I$(TOOLSDIR)/mpe2-2.4.9b/build/include/

all: ring

clean:
	rm -rf *.o ring

%.o: %.c
	echo $@
	$(MPICC) -c -Wall -o $@ $< $(CFLAGS) # $(INCLUDES)

ring: ring.o
	$(MPICC) -Dhave_mpi -o $@ $^ 
