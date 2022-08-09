#!/bin/bash
##SBATCH -o phonon-%a.out
#SBATCH -o phonon.out
#SBATCH -n 20
##SBATCH -a 1-22
##SBATCH --exclusive

source /etc/profile
module load mpi/openmpi-4.0.5
#export perturbation="iPerturbation $SLURM_ARRAY_TASK_ID"
export perturbation="collectPerturbations"
mpirun phonon -i phonon.in
