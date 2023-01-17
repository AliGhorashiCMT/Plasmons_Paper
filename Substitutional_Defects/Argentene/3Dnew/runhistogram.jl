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

subsampling_histogram = returnfermikpoint(Hwannier, cell_map, 13, Val(3), num_blocks=100, mesh=10, histogram_width=5)
tau_histogram =  τ(Hwannier, cell_map, Pwannier, force_matrix, cellph_map,
    Heph, celleph_map, collect(0.01:0.01:1), 13, Val(:histogram), Val(3); histogram_width=5, supplysampling=subsampling_histogram, num_blocks=100, supplydos=0.128, mesh=10, fracroom=1)

open("./boltzmann/histogram-$(idx).txt", "w") do io 
	for t in tau_histogram
		write(io, "$t \n")
	end
end
