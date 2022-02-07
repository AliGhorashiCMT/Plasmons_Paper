#!/bin/bash
#SBATCH -n 38
#SBATCH -a 13
##SBATCH -a 1-101
#SBATCH --exclusive
#SBATCH -o BN33BC-%a.out

export id=$SLURM_ARRAY_TASK_ID
source /etc/profile
module load julia/1.6.1
module load mpi/openmpi-4.0.5
export magnetization=$(echo "print(round(-1+($id-1)*2/100, digits=3))" | julia)
echo magnetization is $magnetization
mpirun jdftx -i BN33BC.in 
