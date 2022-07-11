clear all; close all; clc;

mkdir 'Homotypic-Heterotypic_SensitivityAnalysis_11'
cd 'Homotypic-Heterotypic_SensitivityAnalysis_11'

homoC = [0 25 50 75 100];
homoD = [0 25 50 75 100];
hetero = [0];

for x = 1:length(homoC)
    for y = 1:length(homoD)
        for z = 1:length(hetero)
            mkdir("1A|1B_SphRad-6.4_HomoC-"+homoC(x)+"_HomoD-"+homoD(y)+"_Hetero-"+hetero(z))
        end
    end
end

cd ..