#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void pipeline(data *datas, resource *resources, int ndatas, int nsteps);


int main(int argc, char **argv){
  int   n, i, s, d, ndatas, nsteps;
  long  t_start, t_end;
  data *datas;
  resource *resources;

  // Command line arguments
  if ( argc == 3 ) {
    ndatas  = atoi(argv[1]);    /* num of datas */
    nsteps  = atoi(argv[2]);    /* num of steps */
  } else {
    printf("Usage:\n\n ./main ndatas nsteps\n where ndatas is the number of data and nsteps the number of steps.\n");
    return 1;
  }

  init_data(&datas, &resources, ndatas, nsteps);
  
  /* Process all the data */
  t_start = usecs();
  pipeline(datas, resources, ndatas, nsteps);
  t_end = usecs();
  printf("Execution   time    : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  
  check_result(datas, ndatas, nsteps);
  
  return 0;
  
}



void pipeline(data *datas, resource *resources, int ndatas, int nsteps){

  int d, s;
  
 
  #pragma omp parallel
  {
    #pragma omp master
    { 
      /* Loop over all the data */
      for (d=0; d<ndatas; d++){
        /* Loop over all the steps */
        for (s=0; s<nsteps; s++){
          #pragma omp task depend(in:resources[s]) depend(inout:datas) firstprivate(d,s)
          process_data(datas, d, s, &(resources[s]));
        }
      }
    }
  }
    

}
