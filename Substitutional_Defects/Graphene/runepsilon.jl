idx, N = parse.(Int, ARGS)
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise

using PyPlot, PyCall, Peaks, Statistics, JJDFTX, LinearAlgebra;

energies = range(0, 100, length=100*10000)
energies = collect(energies)
lattice_vectors = loadlattice("wannier/wannier.out")
numomegas = 400
epsilons_scipy = zeros(4, numomegas)

k = if idx > 200
        [(1/6)*(idx-200)/N, 0, 0] + [0.5/6, 0, 0]
elseif idx <= 200
        [(0.5/12)*(idx/N), 0, 0]
end

polarizations = np.loadtxt("Plasmon.out-$idx")

polarizations3, polarizations3_LFE, polarizations5, polarizations5_LFE = [collect(col) for col in eachcol(polarizations)]

for (j, ω) in enumerate(range(0.001, 2, length=numomegas))
	epsilons_scipy[1, j] = real((ϵ(k, lattice_vectors, ω, energies, smooth(real.(polarizations3), win_len=1000), Val(2), Val(:scipy),
epsrel=1e-20, epsabs=1e-20, limit=10000, δ=0.001, normalized=false, win_len=1000)))
end
for (j, ω) in enumerate(range(0.001, 2, length=numomegas))
        epsilons_scipy[2, j] = real((ϵ(k, lattice_vectors, ω, energies, smooth(real.(polarizations3_LFE), win_len=1000), Val(2), Val(:scipy),
epsrel=1e-20, epsabs=1e-20, limit=10000, δ=0.001, normalized=false, win_len=1000)))
end
for (j, ω) in enumerate(range(0.001, 2, length=numomegas))
        epsilons_scipy[3, j] = real((ϵ(k, lattice_vectors, ω, energies, smooth(real.(polarizations5), win_len=1000), Val(2), Val(:scipy),
epsrel=1e-20, epsabs=1e-20, limit=10000, δ=0.001, normalized=false, win_len=1000)))
end
for (j, ω) in enumerate(range(0.001, 2, length=numomegas))
        epsilons_scipy[4, j] = real((ϵ(k, lattice_vectors, ω, energies, smooth(real.(polarizations5_LFE), win_len=1000), Val(2), Val(:scipy),
epsrel=1e-20, epsabs=1e-20, limit=10000, δ=0.001, normalized=false, win_len=1000)))
end

open("Epsilon.out-$idx", "w") do io
        for (i, (epsilon3, epsilon3_LFE, epsilon5, epsilon5_LFE)) in enumerate(zip([collect(row) for row in eachrow(epsilons_scipy)]...))
                write(io, "$epsilon3 $epsilon3_LFE $epsilon5 $epsilon5_LFE \n" )
        end
end
