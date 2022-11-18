idx = parse(Int, ARGS[1])
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise

using PyPlot, PyCall, Peaks, Statistics, JJDFTX;

Hwannier, cell_map = hwannier("wannier"), np.loadtxt("wannier.map.txt");
force_matrix, cellph_map = phonon_force_matrix("totalE");
Pwannier = pwannier("wannier");
Heph, celleph_map = hephwannier("wannier"), np.loadtxt("wannier.mapeph.txt");
lattice_vectors = loadlattice("wannier.out");

tau_allen =  JJDFTX.τ_allen(Hwannier, cell_map, Pwannier, force_matrix, cellph_map,
    Heph, celleph_map, collect(0.01:0.01:1), 13, Val(3); 
mesh=2, supplydos=0.129, num_blocks=1000, fracroom=1, histogram_width=1)

open("./boltzmann/boltzmann-$(idx).txt", "w") do io 
	for t in tau_allen
		write(io, "$t \n")
	end
end
