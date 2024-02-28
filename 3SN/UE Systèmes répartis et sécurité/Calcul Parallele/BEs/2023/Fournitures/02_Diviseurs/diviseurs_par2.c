#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

#define couleur(param) printf("\033[%sm", param)

// fonction calculant le nombre de diviseurs d'un entier (1 exclu)
int primes(int n) 
{
  int nb_divisors, i;

  nb_divisors = 1;
  for (i = 2; i <= n / 2; i++)
  {
    if (n % i == 0) {
      // printf("%d divise %d\n", i, n);
      nb_divisors++;
    }
  }
  return nb_divisors;
}

int main(int argc, char *argv[]) {

  if (argc != 2) {
    couleur("31");
    printf("usage : diviseurs_par <borne sup> \n");
    couleur("30");
    return EXIT_FAILURE;
  }

  // plus grand entier considéré
  int n = atoi(argv[1]);

  // variables MPI
  int my_rank, size;
  // variables pour prendre le temps global
  double start, stop;

  // Initialisation de MPI
  MPI_Init(NULL, NULL);

  // Récupération des informations MPI
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  // le nombre de processus doit diviser la borne sup de l'intervalle de recherche
  if (n % size != 0) {
    couleur("31");
    printf("Cette application doit s'exécuter avec un nombre de processus MPI qui divise %d\n", n);
    couleur("30");
    MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
  }

  // nombre ayant le plus de diviseurs et ce nombre max de diviseurs
  int local_nb_max, local_max;

  int global_nb_max, global_max;

  local_max = 1;
  local_nb_max = 1;

  // prise du temps total par le processeur 0
  if (my_rank == 0) {
    start = MPI_Wtime();
  }
  
  
  int n_per_process = n / size;
  int rest = n % size;
  int start_n, end_n;

  if (my_rank < rest) {
    start_n = my_rank * (n_per_process + 1) + 1;
    end_n = start_n + n_per_process;
  } else {
    start_n = my_rank * n_per_process + rest + 1;
    end_n = start_n + n_per_process - 1;
  }

  double p_time_start = MPI_Wtime();
  for(int i = start_n; i <= end_n; i++)
  {
    int nb = primes(i);
    // printf("[%d] le nombre de diviseurs de %d est %d\n", my_rank, i, nb);
    if(nb > local_max)
    {
        local_max = nb;
        local_nb_max = i;
    }
  }

  // durée calcul processus
  double p_time_stop = MPI_Wtime();
  double p_time = p_time_stop - p_time_start;
  printf("\n[%d] mon plus petit nombre qui possède le plus de diviseurs (%d) est %d - temps %e\n", my_rank, local_max, local_nb_max, p_time);

  // le zéro termine la prise du temps total
  if (my_rank == 0) {
    MPI_Gather(&local_nb_max, 1, MPI_INT, &global_nb_max, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Gather(&local_max, 1, MPI_INT, &global_max, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    int max = 1;
    int nb_max = 1;
    for (int i = 0; i < size; i++) {
      if (global_max[i] > max) {
        max = global_max[i];
        nb_max = global_nb_max[i];
      }
    }
    stop = MPI_Wtime();
    printf("temps total %e\n", stop - start);
  }

  MPI_Finalize();

  return 0;
}