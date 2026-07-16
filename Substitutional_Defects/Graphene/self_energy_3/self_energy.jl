idx = parse(Int, ARGS[1])
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise
using JJDFTX: fermi, bose, diagonalize_phonon
using PyPlot, PyCall, Statistics, JJDFTX;


dir = "../wannier"
Hwannier, cell_map = hwannier("$dir/wannier"), np.loadtxt("$dir/wannier.map.txt")
Pwannier = pwannier("$dir/wannier");
Heph, celleph_map = hephwannier("$dir/wannier"), np.loadtxt("$dir/wannier.mapeph.txt");
force_matrix, cellph_map = phonon_force_matrix("$dir/totalE");
dirac_point = wannier_bands(Hwannier, cell_map, [2/3, -1/3, 0])[1][5]
lattice_vectors = loadlattice("$dir/wannier.out");

meshing = 3; num_blocks = 10000; D = 2
histogram_width = 100
histogram_width2 = histogram_width

mu = dirac_point + 0.5
ϵ_min = -1
ϵ_max = 1

ϵ_range = range(ϵ_min, ϵ_max, length=Int((ϵ_max-ϵ_min)*(histogram_width2)))
ϵ_range = collect(ϵ_range)

omega_range = range(ϵ_min, ϵ_max, length=Int((ϵ_max-ϵ_min)*(histogram_width2)))
omega_range = collect(omega_range)

num_ϵ = length(ϵ_range)

Σ_kk_ϵ_omega = zeros(num_ϵ, num_ϵ)
nums_at_epsilon = zeros(num_ϵ)

for i in 1:num_blocks
    println("Block: $i"); flush(stdout)
    ks = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))
    kprimes = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))

    Eks, Uks = wannier_bands(Hwannier, cell_map, ks)
    Ekprimes, Ukprimes = wannier_bands(Hwannier, cell_map, kprimes);
    nbands = size(Eks)[2]
    
    fifth_band = Eks[:, 5] # Only consider band at Fermi level
    fifth_band = np.repeat(np.reshape(fifth_band, (1, meshing^D)), length(ϵ_range), axis=0)
    ϵ_range_reshaped = np.repeat(np.reshape(ϵ_range, (length(ϵ_range), -1)), meshing^D, axis=1)
    at_epsilon = Int.(abs.(fifth_band .- mu .- ϵ_range_reshaped)*histogram_width .< 0.5)
    
    omegaphsquareds, Uphs = diagonalize_phonon(force_matrix, cellph_map, ks, kprimes)
    omegaphs = sqrt.(abs.(omegaphsquareds))
    
    ephmatrixelements = eph_matrix_elements(Heph, celleph_map, Uks, Ukprimes, omegaphs, Uphs, ks, kprimes)
    ephmatrixelements_sqrd  = (abs.(ephmatrixelements)).^2
    ephmatrixelements_sqrd = ephmatrixelements_sqrd[:, :, :, 5, :] # Only consider band at Fermi level
    omegaphs = omegaphs ./ eV;
    nmodes = size(ephmatrixelements)[3]
    
    Ekprimes = np.repeat(np.repeat(np.reshape(Ekprimes, (1, 1, meshing^D, 1, 1, nbands)), meshing^D, axis=1), nmodes, axis=3)
    Ekprimes = np.repeat(np.repeat(Ekprimes, nbands, axis=4), num_ϵ, axis=0)
    
    omegaphs = np.repeat(np.repeat(np.repeat(np.reshape(omegaphs, (1, meshing^D, meshing^D, nmodes, 1, 1)), nbands, axis=4), nbands, axis=5), num_ϵ, axis=0)
    
    Nqs = bose.(max.(omegaphs, 3e-5), 1)
    fkprimes = fermi.(Ekprimes .- mu, 1)

    omegas_ϵ_ϵk =  np.repeat(np.repeat(np.repeat(np.reshape(omega_range, (-1, 1, 1, 1, 1, 1)), meshing^D, axis=1), meshing^D, axis=2), nmodes, axis=3)
    omegas_ϵ_ϵk =  np.repeat(np.repeat(omegas_ϵ_ϵk, nbands, axis=4), nbands, axis=5)

    delta_emission = abs.(omegas_ϵ_ϵk - Ekprimes .+ mu - omegaphs)*histogram_width .< 0.5
    delta_absorption = abs.(omegas_ϵ_ϵk - Ekprimes .+ mu + omegaphs)*histogram_width .< 0.5
    
    emission_term =  ((Nqs .+ 1 - fkprimes) .* delta_emission)[:, :, :, :, 5, :]
    absorption_term = ((Nqs + fkprimes) .* delta_absorption)[:, :, :, :, 5, :]
    
    y = np.einsum("vk, wkqam, kqam -> vw", at_epsilon, emission_term + absorption_term, ephmatrixelements_sqrd)

    global  Σ_kk_ϵ_omega += π*y*histogram_width/(num_blocks*(meshing^D))
    global nums_at_epsilon += np.einsum("vk->v", at_epsilon)/num_blocks
end

open("./revisit_after_a_year/self_energy-$(idx).txt", "w") do io 
    for row in eachrow(Σ_kk_ϵ_omega)
        println(io, join(row, " "))  # Join elements with a space and write the row
    end
end

open("./revisit_after_a_year/self_energy-nums-$(idx).txt", "w") do io 
    for n in nums_at_epsilon
        write(io, "$n\n")
    end
end
