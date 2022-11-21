idx, N = parse.(Int, ARGS)

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

println("running $N calculations")
flush(stdout)
using PyCall, Peaks, Statistics, JJDFTX;

Hwannier, cell_map = hwannier("wannier"), np.loadtxt("wannier.map.txt")
#kpoints = bandstructkpoints2q(kpointsfile="../bandstruct.kpoints", interpolate=5);
lattice_vectors = loadlattice("wannier.out")
dirac_point = wannier_bands(Hwannier, cell_map, [2/3, -1/3, 0])[1][5]
kpoint = [idx/N*(0.5)/12, 0, 0]
mesh = 64
num_blocks = 1000
histogram_width = 10000
mu = dirac_point + 0.5

impol = ImΠ(Hwannier, cell_map, lattice_vectors, kpoint, mu, Val(2), histogram_width=histogram_width,
mesh=mesh, num_blocks=num_blocks, monte_carlo=true, degeneracy=2, normalized=false)
impol = real.(impol)

open("Plasmon.out-$idx", "w") do io 
	for (i, pol) in enumerate(impol)
		write(io, "$pol \n" )
	end
end
