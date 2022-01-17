#!/bin/bash
#SBATCH -a 1-100
#SBATCH -n 19
#SBATCH -o Cesium-%a.out
#SBATCH --exclusive

source /etc/profile

module load mpi/openmpi-4.0.5
module load julia/1.6.1

export id=$SLURM_ARRAY_TASK_ID
export scale=$(echo "print(round(0.5+$id/100*3, digits=3))" | julia)

echo $scale
mpirun jdftx -i Cesium.in 
