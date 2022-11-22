#!/bin/bash
#SBATCH -a 1-200
#SBATCH -n 1
#SBATCH -o Dirac.out
##SBATCH --exclusive
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
export N=$SLURM_ARRAY_TASK_COUNT
julia run_dirac_plasmon.jl $idx $N


