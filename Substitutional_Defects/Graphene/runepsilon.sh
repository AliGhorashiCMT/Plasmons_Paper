#!/bin/bash
#SBATCH -a 1-100
#SBATCH -n 1
#SBATCH -o Epsilon.out
#SBATCH --exclusive
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
export N=$SLURM_ARRAY_TASK_COUNT
julia runepsilon.jl $idx $N


