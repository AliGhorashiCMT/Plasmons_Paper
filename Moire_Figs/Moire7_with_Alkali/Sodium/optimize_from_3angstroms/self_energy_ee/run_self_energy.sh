#!/bin/bash
#SBATCH -a 1-200
#SBATCH -n 1
#SBATCH -o Sigma.out
export idx=$SLURM_ARRAY_TASK_ID
source /etc/profile
module load julia/1.10.1
julia self_energy.jl $idx


