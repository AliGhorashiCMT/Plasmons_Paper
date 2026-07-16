idx = parse(Int, ARGS[1])
using Pkg
Pkg.activate("/home/gridsan/aligho/Github_Projects/JJDFTX.jl/")
ENV["JULIA_REVISE_POLL"]="1";
using Revise
using JJDFTX: fermi, bose, diagonalize_phonon
using PyPlot, PyCall, Statistics, JJDFTX;

mus = [-2.6892471879135815, -2.5793095160429926, -2.4693718441724037, -2.369428506108232, -2.26948516804406]

Hwannier, cell_map = hwannier("../wannierUp"), np.loadtxt("../wannierUp.map.txt")
lattice_vectors = loadlattice("../wannier.out");
Heph, celleph_map = hephwannier("../wannierUp"), np.loadtxt("../wannierUp.mapeph.txt");
force_matrix, cellph_map = phonon_force_matrix("../Na");
Pwannier = pwannier("../wannierUp");

meshing = 3; num_blocks = 500; D = 2
histogram_width = 10
histogram_width2 = 100
ϵ_min = -2
ϵ_max = 2

ϵ_range = range(ϵ_min, ϵ_max, length=Int((ϵ_max-ϵ_min)*(histogram_width2)))
ϵ_range = collect(ϵ_range)
num_ϵ = length(ϵ_range)

for (mu_idx, mu) in enumerate(mus)
    Σ_kk_ϵ = zeros(num_ϵ, 1)
    nums_at_epsilon = zeros(1)

    println("Running mu_idx: $(mu_idx)"); flush(stdout);
    for i in 1:num_blocks
        println("Block: $i"); flush(stdout)
        ks = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))
        kprimes = vcat(rand(D, meshing^D), zeros(3-D, meshing^D))
    
        Eks, Uks = wannier_bands(Hwannier, cell_map, ks)
        Ekprimes, Ukprimes = wannier_bands(Hwannier, cell_map, kprimes);
        nbands = size(Eks)[2]
            
        omegaphsquareds, Uphs = diagonalize_phonon(force_matrix, cellph_map, ks, kprimes)
        omegaphs = sqrt.(abs.(omegaphsquareds))
        
        ephmatrixelements = eph_matrix_elements(Heph, celleph_map, Uks, Ukprimes, omegaphs, Uphs, ks, kprimes)
        ephmatrixelements_sqrd  = (abs.(ephmatrixelements)).^2
        omegaphs = omegaphs ./ eV;
        nmodes = size(ephmatrixelements)[3]
        
        Ekprimes = np.repeat(np.repeat(np.reshape(Ekprimes, (1, 1, meshing^D, 1, 1, nbands)), meshing^D, axis=1), nmodes, axis=3)
        Ekprimes = np.repeat(np.repeat(Ekprimes, nbands, axis=4), num_ϵ, axis=0)
        
        omegaphs = np.repeat(np.repeat(np.repeat(np.reshape(omegaphs, (1, meshing^D, meshing^D, nmodes, 1, 1)), nbands, axis=4), nbands, axis=5), num_ϵ, axis=0)
        
        Nqs = bose.(max.(omegaphs, 3e-5), 1)
        fkprimes = fermi.(Ekprimes .- mu, 1)
    
        ϵs_ϵ_ϵk =  np.repeat(np.repeat(np.repeat(np.reshape(ϵ_range, (-1, 1, 1, 1, 1, 1)), meshing^D, axis=1), meshing^D, axis=2), nmodes, axis=3)
        ϵs_ϵ_ϵk =  np.repeat(np.repeat(ϵs_ϵ_ϵk, nbands, axis=4), nbands, axis=5)
    
        delta_emission = abs.(ϵs_ϵ_ϵk - Ekprimes .+ mu - omegaphs)*histogram_width .< 0.5
        delta_absorption = abs.(ϵs_ϵ_ϵk - Ekprimes .+ mu + omegaphs)*histogram_width .< 0.5
        
        emission_term =  (Nqs .+ 1 - fkprimes) .* delta_emission
        absorption_term = (Nqs + fkprimes) .* delta_absorption
        at_fermi = Int.(abs.(Eks .- mu)*histogram_width .< 0.5)
        
        y = np.einsum("kn, wkqanm, kqanm -> wn", at_fermi, emission_term + absorption_term, ephmatrixelements_sqrd)
    
        Σ_kk_ϵ += π*y*histogram_width/(num_blocks*(meshing^D))
        nums_at_epsilon += np.einsum("kn->n", at_fermi)/num_blocks
    end
    
    open("./self_energy-muidx$(mu_idx)-$(idx).txt", "w") do io 
        for row in eachrow(Σ_kk_ϵ)
            println(io, join(row, " "))  # Join elements with a space and write the row
        end
    end
    
    open("./self_energy-nums-muidx$(mu_idx)-$(idx).txt", "w") do io 
        for n in nums_at_epsilon
            write(io, "$n\n")
        end
    end
end
