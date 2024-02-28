#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main( int argc, char *argv[] ) {

  int value;
  int my_rank, size;
  int previous, next;
  MPI_Status status;

  MPI_Init (NULL, NULL);

  // Get number of processes
  MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size (MPI_COMM_WORLD, &size);

  // determine my neighbours according to my rank
  if(my_rank == 0){
    previous = size-1;
    next = my_rank + 1;
  } else if(my_rank == size -1){
    previous = my_rank -1;
    next = 0;
  } else {
    previous = my_rank -1;
    next = my_rank + 1;
  }

  value = 1;

  // The nodes, starting with node 0, transmit the value to each other,
  // each time multiplying it by 2.
  // At the end of the transmission, node 0 receives the value 2^(size-1)
  //
  // Instruction: before each send and after each receive, each node displays
  //   - its rank
  //   - the type communication (send, recv)
  //   - the value

  for (int i = 0; i < size; ++i) {
    if (my_rank == i) {
      // Display information before sending
      printf("Node %d sending: %d\n", my_rank, value);

      // Send the value to the next node in the ring
      MPI_Send(&value, 1, MPI_INT, next, 0, MPI_COMM_WORLD);
    } else if (my_rank == (i + 1) % size) {
      // Receive the value from the previous node in the ring
      MPI_Recv(&value, 1, MPI_INT, previous, 0, MPI_COMM_WORLD, &status);

      // Display information after receiving
      printf("Node %d receiving: %d\n", my_rank, value);

      // Multiply the received value by 2
      value *= 2;
    }
    // Synchronize processes
    MPI_Barrier(MPI_COMM_WORLD);
  }

  // Display the final result at Node 0
  if (my_rank == 0) {
    printf("Node %d received the final value: %d\n", my_rank, value);
  }
  
  printf("The End\n");

  MPI_Finalize();

  return EXIT_SUCCESS;

}
