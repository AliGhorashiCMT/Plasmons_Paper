#!/bin/bash
#SBATCH -a 1-101
#SBATCH -n 19
#SBATCH -o Alkali-%a.out
#SBATCH --exclusive

source /etc/profile

module load mpi/openmpi-4.0.5
module load julia/1.6.1


export dir=$(echo "print(split(pwd(), '/')[end])" | julia)

export id=$SLURM_ARRAY_TASK_ID
if [[ $dir == "Sodium" ]]; then
	export alkali="Na"
elif [[ $dir == "Potassium" ]]; then
	export alkali="K"
elif [[ $dir == "Lithium" ]]; then
	export alkali="Li"
elif [[ $dir == "Cesium" ]]; then
	export alkali="Cs"
elif [[ $dir == "Rubidium" ]]; then
	export alkali="Rb"
fi

echo "The alkali metal is $alkali"

for scale in 2 3 4; do
	export scale
	echo "scale=$scale"
	export magnetization=$(echo "print(round(-1+($id-1)*2/100, digits=3))" | julia)
	echo "magnetization=$magnetization"
	mpirun jdftx -i Alkali.in  | tee $alkali-$scale-$magnetization.out
done
