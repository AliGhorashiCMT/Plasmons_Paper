#!/bin/bash
#SBATCH -n 48
##SBATCH -a 1-14
#SBATCH -o run.out
#SBATCH --exclusive
source /etc/profile
module load mpi/openmpi-4.1.3

#export phononParams="iPerturbation $SLURM_ARRAY_TASK_ID"
export phononParams="collectPerturbations"
#mpirun phonon -i phonon.in | tee phonon.out
#mpirun phonon -i phonon.in | tee phonon-$SLURM_ARRAY_TASK_ID.out
mpirun wannier -i wannier.in | tee wannier.out
