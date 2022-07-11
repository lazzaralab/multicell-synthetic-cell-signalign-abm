# multicell-synthetic-cell-signaling-abm
Repository for the models reported in "A computational modeling approach for predicting multicell patterns based on signaling-induced differential adhesion" (https://doi.org/10.1101/2021.08.05.455232)

# Two-Dimenstional Agent-Based Model
The two-dimensional agent-based model (2D ABM) was implemented in Netlogo v. 6.0.4. You can download this software version here: http://ccl.northwestern.edu/netlogo/download.shtml

# Three-Dimensional Agent-Based Model
The three-dimensional agent-based model (3D ABM) was implemented in Netlogo v. 3D 6.0.4. This software is automatically downloaded when you download Netlogo (see above).

# 2D ABM univariate sensitivity analysis (Figure 2A-D)
1. Run Folder_Setup_1DSA.m to generate directories to populate with ABM data.
2. Open 2D ABM. Navigate to tools>BehaviorSpace>1DSA_<> to run experiments that vary each parameter.
3. Run ProcessExp_1DSA.m to calculate features for each experimental condition.
4. Run calcallsens.m to calculate sensitivity parameter for each experimental condition.
5. Run GraphFeatures_1DSA_3.R to generate heatmaps.

# 2D ABM Evolutionary Algorithm (Figure 2E)
1. The jupyter notebook evolutionary-algorithm-ExponentialError-HomotypicProb-ExpExpressionConst-Tuning-FINAL.ipynb describes the implementation of the evolutionary algorithm and generation of figures.

# Quantification of Total Fractional Areas or Compositions (Figure 3B-D)
**2D Simulations**
1. Run FolderSetup_CorePole_InitialSeedingRatios.m to generate directories to populate with ABM data.
2. To run 2D simulations navigate to Tools>BehaviorSpace>1,4,9A:1B-CorePole and Tools>BehaviorSpace>1A:4,9B-CorePole
3. Run ProcessExp_CorePole_InitialSeedingRatios.m to calculate features for each experimental condition.<br>

**3D Simulations**
1. To run 3D simulations navigate to Tools>BehaviorSpace>1,4,9A:1B_200 and Tools>BehaviorSpace>1A:4,9B_200
2. Run ProcessCellCounts.m to calculate features<br>

**i.v. data analysis**
1. See AutomatedFractionalAreaQuantification.m for quantification of total fractional areas in i.v. images.

# Tracking cell migration in 2D ABM (Figure 4)
1. Run FolderSetup.m to generate directories to populate with ABM data.
2. In the 2D ABM, Add outputIndivCellMovement to the go method. To run 2D simulations navigate to Tools>BehaviorSpace>1,4,9A:1B-CorePole and Tools>BehaviorSpace>1A:4,9B-CorePole. 
3. Run ProcessExp_CellMigration.m to calculate features for each experimental condition.

# Analyzing effect of cell-cell signaling (Figure 6)
1. To run 2D simulations navigate to Tools>BehaviorSpace>RulesetTests
2. Run ProcessExp_SignalingEffect.m to calculate features for each experimental condition.

# Finding instances were non-adhesive cells are surrouned by adhesive cells in Core-Pole ruleset (Figure 7)
1. Run FolderSetup.m to generate directories to populate with ABM data.
2. To run 2D simulations navigate to Tools>BehaviorSpace>1,4,9A:1B-CoreShell and Tools>BehaviorSpace>1:4,9B-CoreShell
3. Run ProcessExp_CoreShell.m to calculate features for each experimental condition.

# Bivariate parameter exploration of homotypic adhesion strength parameter (Figure 8)
1. Run FolderSetup_HomotypicAdhesion.m to generate directories to populate with ABM data.
2. To run 2D simulations navigate to Tools>BehaviorSpace>SphRad6.4_HomoHetero
3. Run ProcessExp_HomotypicAdesion.m to calculate features for each experimental condition.
4. Run CalcFeatures_CreateDataMatrix.m to generate data matrix for unsupervised clustering.
5. Refer to FinalSpheroidClustering.ipynb for unsupervised clustering and tSNE dimensionality reduction.

# Bivariate parameter exploration of cadherin induction constant parameter (Figure 9)
1. Run FolderSetup_CadherinInductionConstant.m to generate directories to populate with ABM data.
2. To run 2D simulations navigate to Tools>BehaviorSpace>SphRad6.4_HomoHetero
3. Run ProcessExp_CadherinInductionConstant.m to calculate features for each experimental condition.
4. Run CalcFeatures_CreateDataMatrix.m to generate data matrix for unsupervised clustering.
5. Refer to SpheroidClustering_HomoC_HomoD_ExpC_ExpD.ipynb for unsupervised clustering and tSNE dimensionality reduction.
