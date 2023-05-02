#!/bin/bash
#SBATCH -a 1-200
#SBATCH -n 1
#SBATCH -o tau_allen.out
##SBATCH --partition=xeon-g6-volta
##SBATCH --exclusive
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
julia run_tau_allen.jl $idx


