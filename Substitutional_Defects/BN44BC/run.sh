#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 38

source /etc/profile
module load mpi/openmpi-4.0.5

mpirun jdftx -i BN44BC.in | tee -a BN44BC.out
