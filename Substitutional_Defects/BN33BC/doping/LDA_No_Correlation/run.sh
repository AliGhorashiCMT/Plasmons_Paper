#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 38
#SBATCH -o BN33BC-%a.out
#SBATCH -a 29
source /etc/profile
module load mpi/openmpi-4.0.5
module load julia/1.6.1
export id=$SLURM_ARRAY_TASK_ID
export charge=$(echo "print(round(-1+($id-1)/40, digits=3))" | julia)

echo "charge=$charge"

mpirun jdftx -i BN33BC.in
