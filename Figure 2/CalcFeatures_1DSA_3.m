function[features, average_features,std_features] = CalcFeatures_1DSA_3(curDir);
delete('*xls*')
files = dir('*.png');
curFile = "";

filecounter = 0;
filename = "run_"+filecounter+".txt";
delimiter = ' ';

features = [];
average_features = [];
std_features = [];
ratios = [];
radii = [];
vars = [];
var_values = [];
feature_names = ["a-count", "b-count","c-color-count", "c-express-count", "d-color-count", "d-express-count", "cell-count","contig-green","contig-red","contig-ratio", "spheroid_area", "num_green_regions", "num_lone_green_regions","green_avg_regionArea", "green_avg_regionAreaCell", "green_avg_regionArea_fract", "green_area_fract", "green_avg_cent_dist", "num_red_regions", "num_red_lone", "red_avg_regionArea", "red_avg_regionAreaCell", "red_avg_regionArea_fract", "red_area_fract", "red_avg_cent_dist", "num_blue_regions", "num_blue_lone", "blue_avg_regionArea", "blue_avg_regionAreaCell", "blue_avg_regionArea_fract", "blue_area_fract", "blue_avg_cent_dist","log_reg_score"];
classification_weights = [-2.95021681e-01, -1.28663557e-01, -1.03753467e-01,-2.77341150e-02,  4.79158044e-01,  1.38624009e-01,-3.12795345e-01,  1.73927672e-01, -1.35384726e+00,-1.06325589e-01, -1.01539114e-03, -3.59799702e-03,4.37865026e-02, -3.05178695e-05, -4.27760400e-08,-8.83414063e-04, -6.29373957e-03,  7.49118554e-03,-5.97257815e-02, -2.98576960e-01,  1.08984392e-02,1.55691241e-05, -3.20599886e-04, -9.44001603e-03,5.35392618e-01,  1.12731265e-02,  3.34181233e-01,4.79965443e-03,  6.85670301e-06, -1.58946121e-04,3.58118612e-03, -1.09889039e-02];
log_reg_intercept=-0.0068263;

filenames = [];

index1 = strfind(curDir,'-');
index2 = strfind(curDir,'_') + 1;
ratio = (curDir(1:5) + "");
radius = (curDir(index1(1):index2(2)) + "");
var = (curDir(index2(2):index1(end) - 1)+ "");
var_value = (curDir(index1(end)+1:end) + "");

for k = 1:length(files)
    curFile = files(k).name;
%     disp(curFile)
    filenames = [filenames; (curFile + "")];
    img = imread(curFile);
    
    col_features = [];
    thresh = 700;
    
    A = importdata(filename, delimiter);
    col_features = [A.data]';
    col_features = col_features(1:10);
    filecounter = filecounter + 1;
    filename = "run_"+filecounter+".txt";
    
%   ----------------------Total Spheroid Stats---------------------------
    img_BW = img(:,:,1) > 0 & img(:,:,2) > 0 & img(:,:,3) > 0;
    table_fullImage = regionprops("table", img_BW);
    spheroid_area = sum(table_fullImage.Area);
    col_features = [col_features spheroid_area];

%   ----------------------Green Region Data---------------------------
    img_green = img(:,:,1) < 100 & img(:,:,2) > 100 & img(:,:,3) < 100;
    
    %counts number of green regions
    table_green = regionprops("table", img_green);
    num_green_regions = sum(table_green.Area > thresh);
    num_green_lone = sum(table_green.Area <= thresh);
    
    col_features = [col_features num_green_regions num_green_lone];
    
    if num_green_regions > 0
        %average green region area
        green_avg_regionArea = mean(table_green.Area);
        green_avg_regionAreaCell =  mean(table_green.Area / thresh);
        green_avg_regionArea_fract = mean(table_green.Area / spheroid_area);
        green_area_fract = sum(table_green.Area) / spheroid_area;
        
        col_features = [col_features green_avg_regionArea green_avg_regionAreaCell green_avg_regionArea_fract green_area_fract];
        
        %average green region distance to center
        green_regions_dif = (table_green.Centroid - length(img)/2);
        green_regions_dist = sqrt(green_regions_dif(:,1).^2 + green_regions_dif(:,2).^2);
        green_avg_cent_dist = mean(green_regions_dist);
        
        col_features = [col_features green_avg_cent_dist];
    else
        col_features = [col_features 0 0 0 0 0];
    end

%   ----------------------Red Region Data---------------------------
    img_red =  img(:,:,1) > 100 & img(:,:,2) < 100 & img(:,:,3) < 100;
    
    %counts number of red regions
    table_red = regionprops("table", img_red);
    num_red_regions = sum(table_red.Area > thresh);
    num_red_lone = sum(table_red.Area <= thresh);
    
    col_features = [col_features num_red_regions num_red_lone];
    if num_red_regions > 0
        %average red region area
        red_avg_regionArea = mean(table_red.Area);
        red_avg_regionAreaCell =  mean(table_red.Area / thresh);
        red_avg_regionArea_fract = mean(table_red.Area / spheroid_area);
        red_area_fract = sum(table_red.Area) / spheroid_area;
        
        col_features = [col_features red_avg_regionArea red_avg_regionAreaCell red_avg_regionArea_fract red_area_fract];
        
        %average red region distance to center
        red_regions_dif = (table_red.Centroid - length(img)/2);
        red_regions_dist = sqrt(red_regions_dif(:,1).^2 + red_regions_dif(:,2).^2);
        red_avg_cent_dist = mean(red_regions_dist);
        
        col_features = [col_features red_avg_cent_dist];
    else
        col_features = [col_features 0 0 0 0 0];    
    end
    %   ----------------------Blue Region Data---------------------------
    img_blue =  img(:,:,1) < 100 & img(:,:,2) < 100 & img(:,:,3) > 100;
    
    %counts number of red regions
    table_blue = regionprops("table", img_blue);
    num_blue_regions = sum(table_blue.Area > thresh);
    num_blue_lone = sum(table_blue.Area <= thresh);
    
    col_features = [col_features num_blue_regions num_blue_lone];
    if num_blue_regions > 0
        %average red region area
        blue_avg_regionArea = mean(table_blue.Area);
        blue_avg_regionAreaCell =  mean(table_blue.Area / thresh);
        blue_avg_regionArea_fract = blue_avg_regionArea / spheroid_area;
        blue_area_fract = sum(table_blue.Area) / spheroid_area;
        
        col_features = [col_features blue_avg_regionArea blue_avg_regionAreaCell blue_avg_regionArea_fract blue_area_fract];
        
        %average red region distance to center
        blue_regions_dif = (table_blue.Centroid - length(img)/2);
        blue_regions_dist = sqrt(blue_regions_dif(:,1).^2 + blue_regions_dif(:,2).^2);
        blue_avg_cent_dist = mean(blue_regions_dist);
        
        col_features = [col_features blue_avg_cent_dist];
    else
        col_features = [col_features 0 0 0 0 0];  
    end
    log_reg_value = dot(col_features,classification_weights)+log_reg_intercept;
    col_features = [col_features log_reg_value];
    features = vertcat(features, col_features);
    ratios = [ratios; ratio];
    radii = [radii; radius];
    vars = [vars; var];
    var_values = [var_values; var_value];
end
%     disp(length(ratios))
%     disp(length(radii))
%     disp(length(vars))
%     disp(length(var_values))
%      disp(length(features))
    average_features = [ratio, radius, var, var_value, mean(features)];
    std_features = [ratio, radius, var, var_value, std(features)];
    features = [ratios, radii, vars, var_values, features];
    writematrix(features, "features_" + curDir + ".xlsx");
end