#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 4
#SBATCH -o BN22BC.out
#SBATCH -c 10

source /etc/profile
module load mpi/openmpi-4.0.5

mpirun jdftx -i BN22BC.in 
