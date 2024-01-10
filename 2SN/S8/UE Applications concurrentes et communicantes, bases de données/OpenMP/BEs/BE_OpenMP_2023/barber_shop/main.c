#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void barber_shop_seq(int nbarbs, int nchairs);
void barber_shop_par_fixed(int nbarbs, int nchairs);
void barber_shop_par_any(int nbarbs, int nchairs);

int main(int argc, char **argv){
  long nbarbs, nchairs, nclients;
  long  t_start, t_end;
  float *xs, *xsd;
  double *xd, *xdd;
  
  // Command line arguments
  if ( argc == 4 ) {
    nbarbs   = atoi(argv[1]);    /* number of barbers */
    nchairs  = atoi(argv[2]);    /* number of chairs */
    nclients = atoi(argv[3]);    /* number of clients */
    if(nbarbs<=nchairs){
      printf("Please set nbarbs > nchairs.\n");
      return 1;
    }
  } else {
    printf("Usage:\n\n ./main nbarbs nchairs nclients\n where nbarbs is the number of barbers, nchairs the number of chairs and nclients the number of clients.\n");
    return 1;
  }

  init_data(nbarbs, nchairs, nclients);
  
 
  printf("\n\n========= Sequential ==================================================\n");
  t_start = usecs();
  barber_shop_seq(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time oop : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  printf("\n\n========= Parallel with assigned chair ================================\n");
  
  t_start = usecs();
  barber_shop_par_fixed(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  printf("\n\n========== Parallel with any chair ====================================\n");
  
  t_start = usecs();
  barber_shop_par_any(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  return 0;

}

void barber_shop_seq(int nbarbs, int nchairs){

  int barber, client, chair;
  
  barber = 0;

  for(;;){

    client = receive_client();

    /* No more clients to serve */
    if(client<0) break;
    
    chair = barber%nchairs;

    serve_client(barber, client, chair);

  }

}



void barber_shop_par_fixed(int nbarbs, int nchairs){

  int barber, client, chair;
  int i;
  omp_lock_t* locks_chairs = (omp_lock_t*)malloc(nchairs*sizeof(omp_lock_t));
  omp_lock_t* locks_barbs = (omp_lock_t*)malloc(nbarbs*sizeof(omp_lock_t));
  
  #pragma omp parallel private(client, barber, chair) num_threads(nbarbs)
  {
    // #pragma omp single nowait
    // {
    for(i = 0; i<nchairs; i++)
      omp_init_lock(locks_chairs+i);
    
    for(i = 0; i<nbarbs; i++)
      omp_init_lock(locks_barbs+i);

    barber = omp_get_thread_num();

    for(;;){

      client = receive_client();

      /* No more clients to serve */
      if(client<0) break;
      
      chair = barber%nchairs;

      omp_set_lock(locks_barbs + barber);
      omp_set_lock(locks_chairs + chair);
      serve_client(barber, client, chair);
      omp_unset_lock(locks_chairs + chair);
      omp_unset_lock(locks_barbs + barber);
    }
  }
  //}
  for(i = 0; i < nchairs; i++)
    omp_destroy_lock(locks_chairs+i);
  for(i = 0; i < nbarbs; i++)
    omp_destroy_lock(locks_barbs+i);
  free(locks_chairs);
  free(locks_barbs);

}


void barber_shop_par_any(int nbarbs, int nchairs){

  int barber, client, chair;
  int i;
  omp_lock_t* locks_chairs = (omp_lock_t*)malloc(nchairs*sizeof(omp_lock_t));
  omp_lock_t* locks_barbs = (omp_lock_t*)malloc(nbarbs*sizeof(omp_lock_t));
  
  #pragma omp parallel private(client, barber, chair, i) num_threads(nbarbs)
  {
    // #pragma omp single nowait
    // {
    for(i = 0; i<nchairs; i++)
      omp_init_lock(locks_chairs+i);
    
    for(i = 0; i<nbarbs; i++)
      omp_init_lock(locks_barbs+i);

    barber = omp_get_thread_num();

    for(;;){

      client = receive_client();

      /* No more clients to serve */
      if(client<0) break;

      srand(time(NULL));
      chair = rand()%((nchairs+1)-0) + 0;
      
      omp_set_lock(locks_barbs + barber);
      omp_set_lock(locks_chairs + chair);
      serve_client(barber, client, chair);
      omp_unset_lock(locks_chairs + chair);
      omp_unset_lock(locks_barbs + barber);
  
    }
  }
  //}
  for(i = 0; i < nchairs; i++)
    omp_destroy_lock(locks_chairs+i);
  for(i = 0; i < nbarbs; i++)
    omp_destroy_lock(locks_barbs+i);
  free(locks_chairs);
  free(locks_barbs);

}
