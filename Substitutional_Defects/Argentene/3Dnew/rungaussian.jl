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

subsampling_gaussian = returnfermikpoint(Hwannier, cell_map, 13, Val(3), weight=Val(:gaussian), esmearing=0.08, num_blocks=100, mesh=10, histogram_width=5)
tau_gaussian =  τ(Hwannier, cell_map, Pwannier, force_matrix, cellph_map,
    Heph, celleph_map, collect(0.01:0.01:1), 13, Val(:gaussian), Val(3); esmearing=0.08, histogram_width=5,
 supplysampling=subsampling_gaussian, num_blocks=100, supplydos=0.128, mesh=10, fracroom=1)

open("./boltzmann/gaussian-$(idx).txt", "w") do io 
	for t in tau_gaussian
		write(io, "$t \n")
	end
end
