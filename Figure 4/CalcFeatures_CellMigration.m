function[features] = CalcFeatures_CellMovement(curDir);
files = dir('*.txt');
features = [];

feature_name = ["tick" "color" "moves"];
feature_names=[];
filenames = [];
filelen = 200;

index1 = strfind(curDir,'-') + 1;
index2 = strfind(curDir,'_') - 1;

ratio = (curDir(1:5) + "");
radius = (curDir(index1(1):end) + "");
for k = 1:length(files)
    curFile = files(k).name;
    A = importdata(curFile,'\n');
    offset = 0;
    for j = 1:2:length(A)
        col_features = [];
        line1 = split(A{j} + "", ' ');
        line2 = split(A{j+1} + "", ' ');
        green_move = line1(3);
        red_move = line1(5);
        
        num_empty = line2(3);
        green_total = str2double(line2(5));
        red_total = str2double(line2(7));
        t = (mod(j, 200) / 2) - 0.5;        
        if green_total > 0
            green_move_fract = str2double(green_move) / (green_total);
            col_features = [col_features; green_move_fract];
        else
            col_features = [col_features; 0];
        end
        if red_total > 0
            red_move_fract = str2double(red_move) / (red_total);
            col_features = [col_features; red_move_fract];
        else
            col_features = [col_features; 0];
        end
        
        col_features = [col_features; num_empty];
        
        offset = offset + filelen;
        features = vertcat(features, col_features);
        ratios = [ratios; repmat(ratio, length(feature_name), 1)];
        radii = [radii; repmat(radius, length(feature_name), 1)];
        time = [time; repmat(t, length(feature_name), 1)];
        feature_names=[feature_names; feature_name];
        
    end
end
    features = [ratios, radii, time,feature_names, features];
    head = ["Ratio","Radius","Time","Feature","Value"];
    writematrix([head;features], "features_" + curDir + ".xlsx");
end