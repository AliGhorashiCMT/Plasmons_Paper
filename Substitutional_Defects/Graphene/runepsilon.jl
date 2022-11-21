idx, N = parse.(Int, ARGS)
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise

using PyPlot, PyCall, Peaks, Statistics, JJDFTX, LinearAlgebra;

energies = range(0, 100, length=100*10000)
energies = collect(energies)

numomegas = 200
epsilons_scipy = zeros(numomegas)

Hwannier, cell_map = hwannier("wannier"), np.loadtxt("wannier.map.txt")
lattice_vectors = loadlattice("wannier.out")
dirac_point = wannier_bands(Hwannier, cell_map, [2/3, -1/3, 0])[1][5]
μ = dirac_point + 0.5;

k = [idx/N*(μ-dirac_point)/12, 0, 0]

polarizations = np.loadtxt("Plasmon.out-$idx")

for (j, ω) in enumerate(range(0.001, 1, length=numomegas))
	epsilons_scipy[j] = real(ϵ(k, lattice_vectors, ω, energies, smooth(real.(polarizations), win_len=100), Val(2), Val(:scipy), limit=100, δ=0.001, normalized=false))
end

open("Epsilon.out-$idx", "w") do io
        for (i, epsilon) in enumerate(epsilons_scipy)
                write(io, "$epsilon \n" )
        end
end
