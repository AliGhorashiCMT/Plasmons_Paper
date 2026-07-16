idx = parse(Int, ARGS[1])
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise
using JJDFTX: fermi, bose, diagonalize_phonon
using PyPlot, PyCall, Statistics, JJDFTX;

lattice_vectors = loadlattice("../wannier.out")
b1, b2, b3 = reciprocal_vectors(lattice_vectors);
reciprocal_lattice_matrix = hcat(b1, b2, b3);

area = unit_cell_area(lattice_vectors)
doping = 0.1
n = 2*doping/area
plasmon_factor = ħ*sqrt(n*e²ϵ/(2*mₑ))
prefactor = (π/2)*(1/area)*(e²ϵ/2)
D = 2;
mu = -2.6892471879135815;
meshing = 10;
Hwannier, cell_map = hwannier("../wannierUp"), np.loadtxt("../wannierUp.map.txt");
histogram_width = 100;
histogram_width2 = histogram_width;
num_blocks = 100;


ϵ_min = -2
ϵ_max = 2

ϵ_range = range(ϵ_min, ϵ_max, length=Int((ϵ_max-ϵ_min)*(histogram_width2)))
ϵ_range = collect(ϵ_range)

omega_range = range(ϵ_min, ϵ_max, length=Int((ϵ_max-ϵ_min)*(histogram_width2)))
omega_range = collect(omega_range)

num_ϵ = length(ϵ_range);

Σ_kk_ϵ_omega = zeros(num_ϵ, num_ϵ)
nums_at_epsilon = zeros(num_ϵ);
for i in 1:num_blocks
    if (i % 20 == 0)
        println("Block: $i"); flush(stdout);
    end
    ks = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))
    kprimes = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))
    qs = np.repeat(np.reshape(ks, (3, -1, 1)), size(kprimes)[2], axis=2) - 
                np.repeat(np.reshape(kprimes, (3, 1, -1)), size(ks)[2], axis=1)
    qs_cartesian = np.einsum("ij, jkl->ikl", reciprocal_lattice_matrix, qs);
    qs_cartesian_norm = sqrt.(np.einsum("ikl->kl", qs_cartesian.^2))
    omega_qs = plasmon_factor * sqrt.(qs_cartesian_norm);
    omega_qs_reshaped = np.repeat(np.reshape(omega_qs, (1, meshing^D, meshing^D)), num_ϵ, axis=0)
    Eks, Uks = wannier_bands(Hwannier, cell_map, ks)
    Eks_reshaped = np.repeat(np.reshape(Eks, (1, meshing^D)), num_ϵ, axis=0)
    ϵ_range_reshaped = np.repeat(np.reshape(ϵ_range, (num_ϵ, 1)), meshing^D, axis=1)
    Ekprimes, Ukprimes = wannier_bands(Hwannier, cell_map, kprimes);
    
    Ekprimes_reshaped = np.repeat(np.repeat(np.reshape(Ekprimes, (1, 1, meshing^D)), meshing^D, axis=1), num_ϵ, axis=0)
    fkprimes = fermi.(Ekprimes_reshaped .- mu, 1);
    
    #fkprimes = fermi.(Ekprimes .- mu, 1);
    Nqs = bose.(omega_qs_reshaped, 1)

    at_epsilon = Int.(abs.(Eks_reshaped .- mu .- ϵ_range_reshaped)*histogram_width .< 0.5)
    omegas_reshaped = np.repeat(np.repeat(np.reshape(omega_range, (-1, 1, 1)), meshing^D, axis=1), meshing^D, axis=2)
    
    delta_emission = abs.(omegas_reshaped - Ekprimes_reshaped .+ mu - omega_qs_reshaped)*histogram_width .< 0.5
    delta_absorption = abs.(omegas_reshaped - Ekprimes_reshaped .+ mu + omega_qs_reshaped)*histogram_width .< 0.5
    
    emission_term = np.einsum("ijk, jk, ijk-> ij", delta_emission, (prefactor ./ qs_cartesian_norm),  (1 .+ Nqs .- fkprimes))
    absorption_term = np.einsum("ijk, jk, ijk-> ij", delta_absorption, (prefactor ./ qs_cartesian_norm), (Nqs .+ fkprimes));
    #emission_term = np.einsum("ijk, jk, jk-> ij", delta_emission, (prefactor ./ qs_cartesian_norm),  (1  .- fkprimes))
    #absorption_term = np.einsum("ijk, jk, jk-> ij", delta_absorption, (prefactor ./ qs_cartesian_norm), (fkprimes));

    y = np.einsum("vk, wk->vw", at_epsilon, emission_term + absorption_term)*histogram_width/((meshing^D));
    global nums_at_epsilon += np.einsum("vk->v", at_epsilon)/num_blocks
    global Σ_kk_ϵ_omega += y/num_blocks
end
open("./self_energy-$(idx).txt", "w") do io 
    for row in eachrow(Σ_kk_ϵ_omega)
        println(io, join(row, " "))  # Join elements with a space and write the row
    end
end

open("./self_energy--nums-$(idx).txt", "w") do io 
    for n in nums_at_epsilon
        write(io, "$n\n")
    end
end
