#!/bin/bash

#SBATCH -o BN22BC-%a.out
#SBATCH -a 1-41
#SBATCH -n 19
#SBATCH --exclusive

source /etc/profile
module load mpi/openmpi-4.0.5
module load julia/1.6.1

export id=$SLURM_ARRAY_TASK_ID
export charge=$(echo "print(round(-1+($id-1)/40, digits=3))" | julia)
mpirun jdftx -i BN22BC.in
