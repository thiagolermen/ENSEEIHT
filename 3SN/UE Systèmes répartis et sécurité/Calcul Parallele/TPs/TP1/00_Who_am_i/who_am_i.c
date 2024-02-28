#include <stdio.h>
#include <mpi.h>

int main( int argc, char *argv[] ) {

  int rank, size;
  int l;
  char name[MPI_MAX_PROCESSOR_NAME];

  // Initialize MPI
  MPI_Init(&argc, &argv);

  // Get my rank
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // Get the number of processors in the communicator MPI_COMM_WORLD
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  // Get the name of the processor
  MPI_Get_processor_name(name, &l);

  printf("Hello world from process %d of %d on processor named %s\n", rank, size, name);

  // Tell MPI to shut down.
  MPI_Finalize();
  
  return 0;
}
