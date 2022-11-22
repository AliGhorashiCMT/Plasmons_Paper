idx = parse(Int, ARGS[1])

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

using PyCall, Peaks, Statistics, JJDFTX;

HwannierUp, cellmapUp = hwannier("wannierUp"), np.loadtxt("wannierUp.map.txt")
HwannierDn, cellmapDn = hwannier("wannierDn"), np.loadtxt("wannierDn.map.txt");
lattice_vectors = loadlattice("wannier.out");
Heph, celleph_map = hephwannier("wannierUp"), np.loadtxt("wannierUp.mapeph.txt");
force_matrix, cellph_map = phonon_force_matrix("../../BN22BC_Buckled/phonon");
Pwannier = pwannier("wannierUp");

tau_allen =  JJDFTX.τ_allen(HwannierUp, cellmapUp, Pwannier, force_matrix, cellph_map, Heph, celleph_map, collect(0.01:0.01:1), -2.65, Val(2); 
mesh=6, supplydos=2.023, num_blocks=50, fracroom=1, histogram_width=10)

open("./tau/tau.out-$idx", "w") do io 
	for (i, tau) in enumerate(tau_allen)
		write(io, "$tau \n" )
	end
end
