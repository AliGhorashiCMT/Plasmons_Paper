#!/bin/bash
#SBATCH -a 1-90
#SBATCH -n 58
#SBATCH -o Sodium-bands-%a.out
#SBATCH --exclusive
##SBATCH --partition=normal
source /etc/profile
module load julia/1.6.1
module load mpi/openmpi-4.0.5

export alkali=Na
export id=$SLURM_ARRAY_TASK_ID
export d=$(echo "print(round(0.1+0.3*($id-1)/100, digits=4))" | julia)
export d2=$(echo "print(round($d/2, digits=4))" | julia)
echo "Second Layer Distance is $d"
echo ""
mpirun jdftx -i Moire.bands.in 

