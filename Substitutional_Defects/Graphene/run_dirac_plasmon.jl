idx, N = parse.(Int, ARGS)
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise

using PyPlot, PyCall, Peaks, Statistics, JJDFTX, LinearAlgebra;

dirac_epsilon = zeros(200)

k = (1/6)*(idx/N)

for i in 1:200
	dirac_epsilon[i]  = JJDFTX.graphene_epsilon(0.5, k, 1.5*(i/200), maxevals=100000)
end
open("Dirac.out-$idx", "w") do io
        for (i, epsilon) in enumerate(dirac_epsilon)
                write(io, "$epsilon \n" )
        end
end
