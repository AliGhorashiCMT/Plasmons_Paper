#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 148
#SBATCH -o SLURM.out
source /etc/profile
module load mpi/openmpi-4.0.5

mpirun jdftx -i BN44BC.in | tee -a BN44BC.out
#mpirun jdftx -i BN44BC.bands.in | tee BN44BC.bands.out
