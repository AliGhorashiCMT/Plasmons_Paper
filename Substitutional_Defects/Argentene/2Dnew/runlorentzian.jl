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
esmearing = 0.05

subsampling_lorentzian = returnfermikpoint(Hwannier, cell_map, -4.78, Val(2), weight=Val(:lorentzian), mesh=20, num_blocks=2500, 
esmearing=esmearing, histogram_width=1, cutoff=1e-4)
 
tau_lorentzian = τ(Hwannier, cell_map, Pwannier, force_matrix, cellph_map, Heph, celleph_map, 
    collect(0.01:0.01:1), -4.78, Val(:lorentzian), supplydos=0.11, mesh=20, num_blocks=200, histogram_width=1, esmearing=esmearing, 
intraband = 6, supplysampling=subsampling_lorentzian)

open("./boltzmann/lorentzian-$(idx).txt", "w") do io 
	for t in tau_lorentzian
		write(io, "$t \n")
	end
end
