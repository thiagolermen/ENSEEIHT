#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"


void out_of_place_cast(long n, float *xs, double *xd);
void in_place_cast(long n, float *xs);
void check(long n, float *xs, double *xd);


int main(int argc, char **argv){
  long n, i, s, t;
  long  t_start, t_end;
  float *xs, *xsd;
  double *xd, *xdd;
  
  // Command line arguments
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* size of x */
  } else {
    printf("Usage:\n\n ./main n\n where n is the size of the array to be cast.\n");
    return 1;
  }
  
  xs  = (float*) malloc(n*sizeof(float));
  xd  = (double*) malloc(n*sizeof(double));
  xsd = (float*) malloc(n*sizeof(double));
  xdd = (double*) xsd;

  /* init arrays with random values */
  for(i=0; i<n; i++){
    xs[i] = (float)rand()/(float)(RAND_MAX/10.0);
    xsd[i] = xs[i];
  }
  
  printf("===== Out-of-place cast =======================================\n");
  t_start = usecs();
  out_of_place_cast(n, xs, xd);
  t_end = usecs();
  printf("Execution   time oop : %8.2f msec.\n",((double)t_end-t_start)/1000.0);
  check(n, xs, xd);

  printf("\n===== In-place cast ===========================================\n");
  t_start = usecs();
  in_place_cast(n, xsd);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);
  check(n, xs, xdd);

  /* Uncomment this to print the beginning and end of arrays */
  /* printf("\n\n"); */
  /* for(i=0; i<5; i++) */
  /*   printf("%10d -- xs:%8.5f xd:%8.5f  xdd:%8.5f\n",i, xs[i], xd[i], xdd[i]); */
  /* printf("       ...\n"); */
  /* for(i=n-5; i<n; i++) */
  /*   printf("%10d -- xs:%8.5f xd:%8.5f  xdd:%8.5f\n",i, xs[i], xd[i], xdd[i]); */

  return 0;

}


void out_of_place_cast(long n, float *xs, double *xd){

  long i;
  
  #pragma omp parallel for num_threads(1)
  for(i=0; i<n; i++)
    xd[i] = (double) xs[i];

  return;

}


void in_place_cast(long n, float *xs){

  long i;
  double *xd;
  
  /* make xd point to the xs array */
  xd = (double*)xs;

  #pragma omp parallel private(i) num_threads(1)
  {
    #pragma omp master
    {
      for(i=n-1; i>=0; i--){
        #pragma omp task depend(inout:xd[i])
        xd[i] = (double) xs[i];
        #pragma omp taskwait
      }
    }   
  }
}



void check(long n, float *xs, double *xd){

  long i;
  double max, d;

  max = 0;
  for(i=0; i<n; i++){
    d = fabs((((double)xs[i])-xd[i])/((double)xs[i]));
    if(d>max) max=d;
  }

  printf("Maximum difference is %f\n",max);
  /* Normally, max should be equal to zero... */
  if(max<1e-6){
    printf("The result is correct.\n");
  } else {
    printf("The result is wrong!!!\n");
  }
}


/*

ANSWER :

Running for 1 thread:
===== Out-of-place cast =======================================
Execution   time oop :     4.47 msec.
Maximum difference is 0.000000
The result is correct.

===== In-place cast ===========================================
Execution   time  ip :   164.00 msec.
Maximum difference is 0.000000
The result is correct.



Running for 2 threads:
===== Out-of-place cast =======================================
Execution   time oop :     3.22 msec.
Maximum difference is 0.000000
The result is correct.

===== In-place cast ===========================================
Execution   time  ip :  2443.19 msec.
Maximum difference is 0.000000
The result is correct.




Running for 4 threads:
===== Out-of-place cast =======================================
Execution   time oop :     1.78 msec.
Maximum difference is 0.000000
The result is correct.

===== In-place cast ===========================================
Execution   time  ip :  5095.98 msec.
Maximum difference is 0.000000
The result is correct.


With the data we can verify that for all the executions, the Out-of-place
method was faster when paralelized. It happens especially because insead of
using tasks (small for calls of small complexity), for directive was used.

We can also see an interesting behavior for the Out-of-place method which
decreases its time of execution as long as we increase the number of threads.
It makes sense because more loops are being executed at the same time.

Even though, for the case of In-place, it became very slow and it got even slower
as long as we increased the number of threads, especially because of the time taken
to create the parallel region and do the attribution of the task for each available thread.
Also, we use taskwait directive to avoid replacing values in the vector and keep the good result, which
also increses the execution time.

It is important to mention that I used task directive for the In-place because I was not able to
finish this question on time using another kind of directive, for example loop with some kind of barrier.
It was not giving the right result.

Concluding, we can verify that in this case the Out-of-place was so much more faster with a bigger number
of threads. But in the case of the In-place it got slower, it happened especially because tasks we used instead
and for this type of operations, tasks are not recommended to be used.

*/