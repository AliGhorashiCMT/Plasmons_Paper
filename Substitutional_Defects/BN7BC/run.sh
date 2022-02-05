#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 52
#SBATCH -c 3
#SBATCH -o BN7BC.out

source /etc/profile 

module load mpi/openmpi-4.0.5

mpirun jdftx -i BN7BC.in 
