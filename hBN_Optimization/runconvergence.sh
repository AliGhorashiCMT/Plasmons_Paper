#!/bin/bash
#SBATCH -o hBN.out
#SBATCH -n 127
#SBATCH --exclusive

source /etc/profile
module load mpi/openmpi-4.0.5

mpirun jdftx -i hBN.in | tee -a hBN-convergence.out
