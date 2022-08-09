#!/bin/bash
##SBATCH -o phonon-%a.out
#SBATCH -o phonon.out
##SBATCH -o phonon.dryrun.out
#SBATCH -n 38
##SBATCH -a 89
##SBATCH -a 1-112
#SBATCH --exclusive
#SBATCH -c 3
#SBATCH --mem=0

source /etc/profile
module load mpi/openmpi-4.0.5
#export perturbation="iPerturbation $SLURM_ARRAY_TASK_ID"
export perturbation="collectPerturbations"
mpirun phonon -i phonon.in 
#mpirun phonon -ni phonon.in
