clear all; close all; clc;
delete('*xls*')
params = ["exp-expression-const","c-express-delay","d-express-delay","c-express-thresh","d-express-thresh","cluster-pause-delay","cluster-move-size","homotypic-prob","heterotypic-prob"];
all_features_params = [];
all_features_params_avg = [];
all_features_params_std = [];
all_features_params_sens = [];
for i = 1:length(params)
    copyfile('CalcFeatures_1DSA_3.m', params(i));
    copyfile('CalcSensParam.m', params(i));
    cd(params(i))
    delete('*xls*')
    folders = dir('*A|*');
    all_features_ratios = [];
    all_features_avg = [];
    all_features_std = [];
    all_features_sens = [];
    for k = 1:length(folders)
        curDir = folders(k).name;
        copyfile('CalcFeatures_1DSA_3.m', curDir);
        cd(curDir)
        [features, average_features, std_features] = CalcFeatures_1DSA_3(curDir);
        all_features_ratios = [all_features_ratios; features];
        all_features_avg = [all_features_avg; average_features];
        all_features_std = [all_features_std; std_features];
        cd ..
        disp("" + curDir + " done")
    end
    disp("all folders processed")
    all_features_sens = CalcSensParam(all_features_avg);
    all_features_params_sens = [all_features_params_sens; all_features_sens];
    writematrix(all_features_ratios, '1DSA_all_features.xlsx');
    writematrix(all_features_avg, '1DSA_all_features_avg.xlsx');
    writematrix(all_features_std, '1DSA_all_features_std.xlsx');
    all_features_params = [all_features_params; all_features_ratios];
    all_features_params_avg = [all_features_params_avg; all_features_avg];
    all_features_params_std = [all_features_params_std; all_features_std];
    cd ..
end
feature_names = ["a-count", "b-count","c-color-count", "c-express-count", "d-color-count", "d-express-count", "cell-count", "contig-green","contig-red","contig-ratio", "spheroid_area", "num_green_regions", "num_lone_green_regions","green_avg_regionArea", "green_avg_regionAreaCell", "green_avg_regionArea_fract", "green_area_fract", "green_avg_cent_dist", "num_red_regions", "num_red_lone", "red_avg_regionArea", "red_avg_regionAreaCell", "red_avg_regionArea_fract", "red_area_fract", "red_avg_cent_dist", "num_blue_regions", "num_blue_lone", "blue_avg_regionArea", "blue_avg_regionAreaCell", "blue_avg_regionArea_fract", "blue_area_fract", "blue_avg_cent_dist","log_reg_score"];
all_features_params = ["Ratio","Radius","Var","Var_Value", feature_names; all_features_params];
all_features_params_avg = ["Ratio","Radius","Var","Var_Value", feature_names; all_features_params_avg];
all_features_params_std = ["Ratio","Radius","Var","Var_Value", feature_names; all_features_params_std];
all_features_params_sens = ["Var","Var_Value", feature_names; all_features_params_sens];
writematrix(all_features_params, '1DSA_all_features_params.xlsx');
writematrix(all_features_params_avg, '1DSA_all_features_params_avg.xlsx');
writematrix(all_features_params_std, '1DSA_all_features_params_std.xlsx');
writematrix(all_features_params_sens, '1DSA_all_features_params_sens.xlsx');