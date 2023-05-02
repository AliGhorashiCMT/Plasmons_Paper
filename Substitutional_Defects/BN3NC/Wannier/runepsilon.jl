idx = parse(Int, ARGS[1])

using Pkg;
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";

using PyCall, Peaks, Statistics, JJDFTX;

kpoints = bandstructkpoints2q(interpolate=5);
lattice_vectors = loadlattice("wannier.out")
energies = collect(range(0, 100, length=10000));

epsilons_scipy = zeros(200)
polarizations = parse.(Float64, readlines("Plasmon.out-$idx"))

for (j, ω) in enumerate(range(0.05, 1.5, length=200))
	epsilons_scipy[j] = real(ϵ(kpoints[idx], lattice_vectors, ω, energies, smooth(real.(polarizations), win_len=10), Val(2), Val(:scipy), limit=1000, δ=0.001, normalized=true))
end
open("Epsilon.out-$idx", "w") do io
	for (i, pol) in enumerate(epsilons_scipy)
		write(io, "$pol \n" )
	end
end
