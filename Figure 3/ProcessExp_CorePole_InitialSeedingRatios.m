clear all; close all; clc;
folders = dir('*A|*');
all_features_ratios = [];

for k = 1:length(folders)
    curDir = folders(k).name;
    copyfile('CalcFeatures_CorePole_InitialSeedingRatios.m', curDir);
    cd(curDir)
    features = CalcFeatures_CorePole_InitialSeedingRatios(curDir);
    all_features_ratios = [all_features_ratios; features];
    cd ..
    disp("" + curDir + " done")
end
disp("all folders processed")
head = ["Ratio","Radius","Feature","Value"];
writematrix([head;all_features_ratios], 'all_features_ratios.xlsx');
cd ..