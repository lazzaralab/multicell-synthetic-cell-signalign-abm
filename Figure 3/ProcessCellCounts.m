folders = dir('*-5*');
all_features_ratios = [];
avg_features_ratios = [];
std_features_ratios = [];
for i = 1:length(folders)
    curFolder = folders(i).name;
    disp(curFolder)
    cd(curFolder);
    curRatio = curFolder(1:5) + "";
    
    files = dir('*CellCount*');
    delimiter = ' ';

    features = [];
    average_features = [];
    std_features = [];
    feature_names = ["a-count", "b-count", "c-count", "d-count", "cell-count","a-fract","b-fract","c-fract","d-fract"];
    filenames = [];

    for k = 1:length(files)
        curFile = files(k).name;
        
        A = importdata(curFile, delimiter);
        row_features = [A.data]';
        row_features(6) = row_features(1) / row_features(5);
        row_features(7) = row_features(2) / row_features(5);
        row_features(8) = row_features(3) / row_features(5);
        row_features(9) = row_features(4) / row_features(5);
        features = [features; row_features];
    end
   
    average_features = mean(features);
    std_features = std(features);
    avg_features_ratios = [avg_features_ratios; curRatio average_features];
    std_features_ratios = [std_features_ratios; curRatio std_features];
    all_features_ratios = [all_features_ratios; repmat(curRatio,length(features(:,1)),1) features];
    writematrix([feature_names; features], folders(i).name+"_features.xlsx");
    cd ..
end
writematrix(["type" feature_names; all_features_ratios],"3DCellCounts.xlsx");
writematrix(["type" feature_names; avg_features_ratios],"3DCellCounts_avg.xlsx");
writematrix(["type" feature_names; std_features_ratios],"3DCellCounts_std.xlsx");