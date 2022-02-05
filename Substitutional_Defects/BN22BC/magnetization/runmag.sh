#!/bin/bash
#SBATCH -n 38
#SBATCH --exclusive
#SBATCH -a 40
#SBATCH -o BN22BC-%a.out

export id=$SLURM_ARRAY_TASK_ID
source /etc/profile
module load julia/1.6.1
module load mpi/openmpi-4.0.5
export magnetization=$(echo "print(round(-1+$id*2/100, digits=3))" | julia)
echo magnetization is $magnetization
mpirun jdftx -i BN22BC.in 
