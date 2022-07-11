clear all; close all; clc;
folders = dir('*ing*');
all_features_ratios = [];

for k = 1:length(folders)
    curDir = folders(k).name;
    copyfile('CalcFeatures_HomoHetero_2.m', curDir);
    copyfile('findregionboundary.m', curDir);
    cd(curDir)
    features = CalcFeatures_HomoHetero_2(curDir);
    all_features_ratios = [all_features_ratios; features];
    cd ..
    disp("" + curDir + " done")
end
disp("all folders processed")
head = ["Ratio","Radius","Condition","Feature","Value"];
writematrix([head;all_features_ratios], 'DynamicCellSignallingEffect_all_features_ratios.xlsx');
cd ..