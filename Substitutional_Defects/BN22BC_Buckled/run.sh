#!/bin/bash
#SBATCH -n 19
#SBATCH -o BN22BC.out
#SBATCH --exclusive

source /etc/profile

module load mpi/openmpi-4.0.5

mpirun jdftx -i BN22BC.in 
