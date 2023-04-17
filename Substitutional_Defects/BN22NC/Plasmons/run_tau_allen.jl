idx = parse(Int, ARGS[1])

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

using PyCall, Peaks, Statistics, JJDFTX;

HwannierUp, cell_mapUp = hwannier("wannierUp"), np.loadtxt("wannierUp.map.txt")
HwannierDn, cell_mapDn = hwannier("wannierDn"), np.loadtxt("wannierDn.map.txt");
Pwannier = pwannier("wannierDn");
Heph, celleph_map = hephwannier("wannierDn"), np.loadtxt("wannierDn.mapeph.txt");
lattice_vectors = loadlattice("./wannier.out");
force_matrix, cellph_map = phonon_force_matrix("../phonon");


tau_allen =  JJDFTX.τ_allen(HwannierDn, cell_mapDn, Pwannier, force_matrix, cellph_map, Heph, celleph_map, collect(0.01:0.01:1), -4.74, Val(2); 
mesh=3, supplydos=2.82, num_blocks=500, fracroom=1, histogram_width=10)

open("./tau/tau.out-$idx", "w") do io 
	for (i, tau) in enumerate(tau_allen)
		write(io, "$tau \n" )
	end
end
