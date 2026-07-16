### Plasmons_Paper

For the **Moire paper**, you may find detailed descriptions in the README in the directory **./Moire_Figs**

### Explanation of Folders

1) hBN_Optimization: Optimization of a single layer of hBN. Convergence output and the hBN lattice may be found in this folder
2) Isolated_Atom_Magnetization: Job arrays of 5 different Alkali metals at fixed magnetization for 3 different lattice sizes. 
3) Moire_Figs: In this folder, you may find the construction of the Moire lattice in the Make Lattice python notebook. 
    1) Optimization of layer distance
    2) Phonon Calculations
    3) Clustering Calculations
    4) Plasmon Calculations
    Top Level Folder Files: 
    Make_Lattice.ipynb: Code to make the smaller Moire lattice
    Make_Lattice_13.ipynb : Code to make the larger Moire lattice
    Subfolders: 
        Moire7_with_Alkali: 5 Folders for five alkali metals, optimization of distance of alkali metal (pattern is alkali-distance.out
        Moire13_with_Alkali: Exactly the same as above but for the larger moire superlattice. 
    
    

3) Integer_Superlattices: Here, for five alkali metals, we look at the energy as a function of distance from 2x2, 3x3, 4x4 hBN. We then look at the magnetization and the band structure at the equilibrium distance. 
