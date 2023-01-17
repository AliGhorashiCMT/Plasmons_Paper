#!/bin/bash
#SBATCH -a 1-200
#SBATCH -o lorentzian.out
#SBATCH --partition=xeon-g6-volta
##SBATCH --exclusive

source /etc/profile
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
julia ./runlorentzian.jl $idx
