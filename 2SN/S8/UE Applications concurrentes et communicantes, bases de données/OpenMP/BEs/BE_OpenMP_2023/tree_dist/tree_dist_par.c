#include "aux.h"

void tree_dist_par(node_t *nodes, int n){

  int node;
  
  #pragma omp parallel
  {
    #pragma omp single nowait
    {
      for(node=0; node<n; node++){
        
        #pragma omp task firstprivate(node) depend(inout:nodes[node].weight) depend(in:(nodes[node].p)->dist) depend(out:nodes[node].dist)
        {
          nodes[node].weight = process(nodes[node]);
          nodes[node].dist    = nodes[node].weight;
          if(nodes[node].p) nodes[node].dist += (nodes[node].p)->dist;
        }
      }
    }
  }
}
