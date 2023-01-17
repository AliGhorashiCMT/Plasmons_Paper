idx = parse(Int, ARGS[1])
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise

using PyPlot, PyCall, Peaks, Statistics, JJDFTX;

dir = "wannier"
Hwannier, cell_map = hwannier("$dir/wannier"), np.loadtxt("$dir/wannier.map.txt")
Pwannier = pwannier("$dir/wannier");
Heph, celleph_map = hephwannier("$dir/wannier"), np.loadtxt("$dir/wannier.mapeph.txt");
force_matrix, cellph_map = phonon_force_matrix("$dir/totalE");
dirac_point = wannier_bands(Hwannier, cell_map, [2/3, -1/3, 0])[1][5]
lattice_vectors = loadlattice("$dir/wannier.out");
μ = dirac_point + 0.5;
subsampling_histogram = returnfermikpoint(Hwannier, cell_map, dirac_point+0.5, Val(2), mesh=30, num_blocks=1000, 
    weight=Val(:histogram), histogram_width=10, esmearing=0.01)

tau_histogram =  τ(Hwannier, cell_map, Pwannier, force_matrix, cellph_map,
    Heph, celleph_map, collect(0.01:0.01:1), dirac_point+0.5, Val(:histogram), Val(2); 
    esmearing=0.01, supplysampling=subsampling_histogram, supplydos = 0.028, histogram_width=10, intraband=5, mesh=10, num_blocks=100, fracroom=1)

open("./boltzmann/histogram-$(idx).txt", "w") do io 
	for t in tau_histogram
		write(io, "$t \n")
	end
end
