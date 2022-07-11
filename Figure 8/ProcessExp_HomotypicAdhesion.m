clear all; close all; clc;
folders = dir('*A|*');
all_features_ratios = [];

for k = 1:length(folders)
    curDir = folders(k).name;
    copyfile('CalcFeatures_HomotypicAdhesion.m', curDir);
    copyfile('findregionboundary.m', curDir);
    copyfile('regionaspectratio.m',curDir);
    copyfile('circularity.m',curDir);
    cd(curDir)
    features = CalcFeatures_HomotypicAdhesion(curDir);
    all_features_ratios = [all_features_ratios; features];
    cd ..
    disp("" + curDir + " done")
end
disp("all folders processed")
head = ["Ratio","Radius","Homotypic_Prob_C","Homotypic_Prob_D","Heterotypic_Prob","Feature","Value"];
writematrix([head;all_features_ratios], 'HomotypicHeterotypic_all_features_ratios.xlsx');
cd ..