#!/bin/bash
#SBATCH -n 48
#SBATCH -o run.out
#SBATCH --exclusive
source /etc/profile
module load mpi/openmpi-4.1.3
mpirun wannier -i wannier.in | tee wannier.out
