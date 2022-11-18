#!/bin/bash
#SBATCH -a 1-100
#SBATCH -n 1
#SBATCH -o Plasmon.out
##SBATCH -o Plasmon.out-%a
#SBATCH --exclusive
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
julia runplasmon.jl $idx


