#!/bin/bash
#SBATCH -a 1-200
#SBATCH -o boltzmann.out
##SBATCH --exclusive
#SBATCH --partition=xeon-g6-volta
source /etc/profile
module load julia/1.6.1
export idx=$SLURM_ARRAY_TASK_ID
julia ./runboltzmann.jl $idx
