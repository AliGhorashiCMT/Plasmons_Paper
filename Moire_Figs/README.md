This folder contains all DFT calculations relevant to plasmon calculations in intercalated Moire layers

Relevant python notebooks: 

- **./Moire7_with_Alkali/Rubidium/Plasmons/Analyze.ipynb** for width of Rb charge density (**Figure 1a**)

- **./Moire7_with_Alkali/Lithium/Plasmons/Analyze.ipynb** for width of Li charge density (**Figure 1a**)

- **./Moire7_with_Alkali/Potassium/Plasmons/Analyze.ipynb** for width of K charge density (**Figure 1a**)

- **./Moire7_with_Alkali/Cesium/Plasmons/Analyze.ipynb** for width of Cs charge density (**Figure 1a**)

- **./Moire7_with_Alkali/Sodium/plasmons/Analyze.ipynb** for width of Na charge density (**Figure 1a as well as Figure 1b**)

- **./Moire7_with_Alkali/Analyze.ipynb** for band structures of all intercalated lattices considered (**Figure 1a**)

- **Analyze_Fig2.ipynb** for everything relevant to **Figure 2**

- **../Substitutional_Defects/Graphene/Analyze_decay_time.ipynb** for **Figure 3b**

- **Moire7_with_Alkali/Sodium/optimize_from_3angstroms/Analyze_electron_phonon_losses.ipynb** for **Figure 3a** and **Figure 3c**.
  - For future reference (mostly for myself) the loaded files from the subdirectory `self_energy_2` which contain the number of states at each energy (these files are of the form `self_energy-muidx$(mu_idx)-nums-$(num).txt` are a little faulty. If you sum up the numbers and normalize, the value is slightly less than unity). This is because the the spacing of the energies is $\approx 0.010025062656641603$, whereas the binning is $1/100$. This introduces an error that is less than half a percent, so it's fine. 

