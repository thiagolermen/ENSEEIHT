// variables MPI
int my_rank, size;

// Initialisation de MPI
MPI_Init(NULL, NULL);

// Récupération des informations MPI
MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
MPI_Comm_size(MPI_COMM_WORLD, &size);

// N nombre de pixels de l'image
int N = get_image_size(filename);

// allocation de la mémoire pour contenir l'image 
// variable pixels : tableau de 3*N octets (3 octets par pixels, RVB)
char *pixels = allocate_image(N);

// lecture de l'image
read_image(pixels, N, filename);

// tableau lumi contenant la luminance de chaque pixel
// (valeur entre 0 et 255 => tableau d'entiers de taille N)
int *lumi = allocate_lumi(N);

// tableau histo de taille 256 qui compte le nombre de pixels 
// ayant la luminance correspondante
int *histo = allocate_histo(256);


char *local_pixels = allocate_image(N/size);
char *local_lumi = allocate_lumi(N/size);
char *local_histo = allocate_histo(256);

// Scatter the pixels and the luminance to all the processes
MPI_Scatter(pixels, N/size, MPI_CHAR, local_pixels, N/size, MPI_CHAR, 0, MPI_COMM_WORLD);

// calcul de la luminance -> complexité : 1 calcul par pixel
compute_luminance(local_lumi, local_pixels, N/size);
// calcul de l'histogramme -> complexité : 1 calcul par pixel
compute_histo(local_histo, local_lumi, N/size);

// Reduce the histogram from all processes
MPI_Reduce(local_histo, histo, 256, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

// Équilibrage de l'image d'origine en utilisant l'histogramme : 
// on crée une nouvelle image -> complexité : 1 calcul par pixel
// la saturation (nombre de pixels ayant la valeur 0 ou la valeur 255)
// est aussi calculée

if (my_rank == 0) {
    char *new_pixels = allocate_image(N);
    int saturation;

    equalize(new_pixels, &saturation, pixels, histo, N);

    // sauvegarde de l'image égalisée
    save_image(new_pixels, N, filename2);

    // affichage de la saturation
    printf("la saturation est de %d\n", saturation)
}