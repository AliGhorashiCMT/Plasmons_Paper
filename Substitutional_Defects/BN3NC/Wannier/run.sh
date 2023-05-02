#!/bin/bash
#SBATCH -n  56
##SBATCH -N 2
#SBATCH --exclusive
#SBATCH -o run.out

source /etc/profile
module load mpi/openmpi-4.1.3
mpirun wannier -i wannier.in | tee wannier.out
