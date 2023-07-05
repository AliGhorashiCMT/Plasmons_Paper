idx, N = parse.(Int, ARGS)

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

println("running $N calculations")
flush(stdout)
using PyCall, Peaks, Statistics, JJDFTX;

dir = "./wannier/"

Hwannier, cell_map = hwannier(dir*"wannier"), np.loadtxt(dir*"wannier.map.txt")
lattice_vectors = loadlattice(dir*"wannier.out")
wannier_centers = parse_wannier_centers(dir*"wannier", Val('n'))

dirac_point = wannier_bands(Hwannier, cell_map, [2/3, -1/3, 0])[1][5]
kpoint = if idx > 200 
	[(1/6)*(idx-200)/N, 0, 0] + [0.5/6, 0, 0]
elseif idx <= 200
	[(0.5/12)*(idx/N), 0, 0]
end 
# we do a mesh of increments of 0.5/12*(idx/N) till kF, then we do a less extreme mesh 
mesh = 64
num_blocks = 1000
histogram_width = 10000

mu_5 = dirac_point + 0.5
mu_3 = dirac_point + 0.3

impol_5 = ImΠ(Hwannier, cell_map, lattice_vectors, kpoint, mu_5, Val(2), histogram_width=histogram_width,
mesh=mesh, num_blocks=num_blocks, monte_carlo=true, degeneracy=2, normalized=false)

impol_LFE_5 = ImΠ(Hwannier, cell_map, lattice_vectors, kpoint, mu_5, Val(2), wannier_centers, histogram_width=histogram_width,
mesh=mesh, num_blocks=num_blocks, monte_carlo=true, degeneracy=2, normalized=false)

impol_5 = real.(impol_5)
impol_LFE_5 = real.(impol_LFE_5)

impol_3 = ImΠ(Hwannier, cell_map, lattice_vectors, kpoint, mu_3, Val(2), histogram_width=histogram_width,
mesh=mesh, num_blocks=num_blocks, monte_carlo=true, degeneracy=2, normalized=false)

impol_LFE_3 = ImΠ(Hwannier, cell_map, lattice_vectors, kpoint, mu_3, Val(2), wannier_centers, histogram_width=histogram_width,
mesh=mesh, num_blocks=num_blocks, monte_carlo=true, degeneracy=2, normalized=false)

impol_3 = real.(impol_3)
impol_LFE_3 = real.(impol_LFE_3)

open("Plasmon.out-$idx", "w") do io 
	for (i, (pol_3, pol_LFE_3, pol_5, pol_LFE_5)) in enumerate(zip(impol_3, impol_LFE_3, impol_LFE_5, impol_LFE_5))
		write(io, "$pol_3 $pol_LFE_3 $pol_5 $pol_LFE_5 \n" )
	end
end
