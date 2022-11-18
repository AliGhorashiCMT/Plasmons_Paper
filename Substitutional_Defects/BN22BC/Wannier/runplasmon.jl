idx = parse(Int, ARGS[1])

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

using PyCall, Peaks, Statistics, JJDFTX;

kpoints = bandstructkpoints2q(interpolate=5);
lattice_vectors = loadlattice("wannier.out")

HwannierUp, cell_mapUp = hwannier("wannierUp"), np.loadtxt("wannierUp.map.txt");
HwannierDn, cell_mapDn = hwannier("wannierDn"), np.loadtxt("wannierDn.map.txt");

mesh = 32
num_blocks = 100
histogram_width = 100
mu = -2.64

impol_up = ImΠ(HwannierUp, cell_mapUp, lattice_vectors, kpoints[idx], mu, Val(2); mesh=mesh, monte_carlo=true, num_blocks=num_blocks)
impol_dn = ImΠ(HwannierDn, cell_mapDn, lattice_vectors, kpoints[idx], mu, Val(2); mesh=mesh, monte_carlo=true, num_blocks=num_blocks)
impol = real.(impol_up) + real.(impol_dn)

open("Plasmon.out-$idx", "w") do io 
	for (i, pol) in enumerate(impol)
		write(io, "$pol \n" )
	end
end
