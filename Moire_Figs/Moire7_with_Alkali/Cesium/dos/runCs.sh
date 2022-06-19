#!/bin/bash
#SBATCH -a 80-90
#SBATCH -n 38
#SBATCH -o Cesium-dos-%a.out
#SBATCH --exclusive
##SBATCH --partition=normal
source /etc/profile
module load julia/1.6.1
module load mpi/openmpi-4.0.5

export alkali=Cs
export id=$SLURM_ARRAY_TASK_ID
export d=$(echo "print(round(0.07+0.3*($id-1)/100, digits=4))" | julia)
export d2=$(echo "print(round($d/2, digits=4))" | julia)
echo "Second Layer Distance is $d"
echo ""
mpirun jdftx -i Moire.dos.in 

