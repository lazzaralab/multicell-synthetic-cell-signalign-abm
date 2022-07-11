function[features] = CalcFeatures_HomoHetero_2(curDir);
files = dir('*.txt');
features = [];
ratios = [];
radii = [];
homotypic_probs_c = [];
homotypic_probs_d = [];
heterotypic_probs = [];
feature_name = ["a-count"; "b-count";"c-color-count"; "c-express-count"; "d-color-count"; "d-express-count";"cell-count"; 
    "num_green_regions"; "num_lone_green_regions"; "green_avg_regionArea_fract"; "green_area_fract"; "green_avg_cent_dist";"green_region_width";"green_region_height"; "green_region_aspect_ratio";
    "num_red_regions"; "num_red_lone"; "red_avg_regionArea_fract"; "red_area_fract"; "red_avg_cent_dist";"red_region_width";"red_region_height"; "red_region_aspect_ratio"; "num_red_enclosed_green_75"; "num_red_enclosed_green_50";
    "num_blue_regions"; "num_blue_lone"; "blue_avg_regionArea_fract"; "blue_area_fract"; "blue_avg_cent_dist"; "num_blue_enclosed_green_75"; "num_blue_enclosed_green_50";
    "num_gray_regions"; "num_gray_lone"; "gray_avg_regionArea_fract"; "gray_area_fract"; "gray_avg_cent_dist"; "num_gray_enclosed_green_75"; "num_gray_enclosed_green_50";
    "contiguous_area"];
feature_names=[];
filenames = [];

ratio = (curDir(1:5) + "");
index1 = strfind(curDir,'-') + 1;
index2 = strfind(curDir,'_') - 1;

radius = (curDir(index1(1):end) + "");
if radius == "5.6"
    filelen = 71;
end
if radius == "6.4"
    filelen = 92;
end
if radius == "7.2"
    filelen = 113;
end
disp(filelen)
% homo_c = (curDir(index1(2):index2(3))+ "");
% homo_d = (curDir(index1(3):index2(4))+ "");
% hetero = (curDir(index1(4):end) + "");
filecount = 0;
for k = 1:length(files)
    curFile = files(k).name;
%     disp(curFile);
    A = importdata(curFile,'\n');
    offset = 0;
    for j = 1:length(A)/filelen
%         disp(j)
        col_features = [];
        for i = 1+offset:7+offset
            line = split(A{i} + "", ' ');
            col_features = [col_features; line(3)];
        end

        img_blue = zeros(17,17);
%         imshow(img_blue)
        img_green = zeros(17,17);
        img_red = zeros(17,17);
        img_gray = zeros(17,17);
        spheroid_area = filelen - 9;
        thresh = 2;
        
        for i = (8+offset):(spheroid_area+7+offset)
            line = split(A{i} + "", ' ');
%             disp(line)
            color = line(2);
            if length(line) < 4
               break; 
            end
            x = str2num(line(3))+8;
            y = str2num(line(4))+8;
            if color == "105"
                img_blue(x,y) = 1;
            end
            if color == "55"
                img_green(x,y) = 1;
            end
            if color == "15"
                img_red(x,y) = 1;
            end
            if color == "5"
                img_gray(x,y) = 1;
            end
        end
        
        img= zeros(17,17,3);
        img(:,:,1)=img_red;
        img(:,:,2)=img_green;
        img(:,:,3)=img_blue;
        
        img_name= "run_"+filecount+".png";
        imwrite(img,img_name);
        filecount = filecount + 1;

    %   ----------------------Green Region Data---------------------------
        %counts number of green regions
        CC_green = bwconncomp(img_green,4);
        table_green = regionprops("table",CC_green,"Area","Centroid","PixelList","BoundingBox");
        num_green_regions = sum(table_green.Area > thresh);
        num_green_lone = sum(table_green.Area <= thresh);
        col_features = [col_features; num_green_regions; num_green_lone];

        if num_green_regions > 0
            %average green region area
            green_regions = table_green(table_green.Area>thresh,:);
            green_avg_regionArea_fract = mean(green_regions.Area / spheroid_area);
            green_area_fract = sum(table_green.Area) / spheroid_area;

            col_features = [col_features; green_avg_regionArea_fract; green_area_fract];

            %average green region distance to center
            green_regions_dif = (green_regions.Centroid - 9);
            green_regions_dist = sqrt(green_regions_dif(:,1).^2 + green_regions_dif(:,2).^2);
            green_avg_cent_dist = mean(green_regions_dist);
            col_features = [col_features;green_avg_cent_dist];
            
            %average width and height of freen regions
            green_region_width = mean(green_regions.BoundingBox(:,3));
            green_region_height = mean(green_regions.BoundingBox(:,4));
            green_region_aspect_ratio = green_region_width / green_region_height;
            col_features = [col_features; green_region_width; green_region_height; green_region_aspect_ratio];

        else
            col_features = [col_features; 0; 0; 0;0;0;0];
        end

    %   ----------------------Red Region Data---------------------------
        %counts number of red regions
        CC_red = bwconncomp(img_red,4);
        table_red = regionprops("table",CC_red,"Area","Centroid","PixelList","BoundingBox");
        num_red_regions = sum(table_red.Area > thresh);
        num_red_lone = sum(table_red.Area <= thresh);
        col_features = [col_features; num_red_regions; num_red_lone];

        if num_red_regions > 0
            %average red region area
            red_regions = table_red(table_red.Area>2,:);
            red_avg_regionArea_fract = mean(red_regions.Area / spheroid_area);
            red_area_fract = sum(table_red.Area) / spheroid_area;
            col_features = [col_features;red_avg_regionArea_fract; red_area_fract];

            %average red region distance to center
            red_regions_dif = (red_regions.Centroid - 9);
            red_regions_dist = sqrt(red_regions_dif(:,1).^2 + red_regions_dif(:,2).^2);
            red_avg_cent_dist = mean(red_regions_dist);

            %radius of red core
    %         points = table_red.BoundingBox - length(img)/2;
    %         red_rad = mean((sqrt(points(:,1).^2 + points(:,2).^2)+sqrt(points(3).^2 + points(4).^2))/2);

            col_features = [col_features; red_avg_cent_dist];
            red_region_width = mean(red_regions.BoundingBox(:,3));
            red_region_height = mean(red_regions.BoundingBox(:,4));
            red_region_aspect_ratio = red_region_width / red_region_height;
            col_features = [col_features; red_region_width; red_region_height; red_region_aspect_ratio];
            
            num_red_enclosed_green_75 = 0;
            num_red_enclosed_green_50 = 0;
            for i=1:height(red_regions)
                red_region_i = red_regions.PixelList(i);
                red_region_i = red_region_i{1,1};
                red_region_boundary_i = findregionboundary(img_red,red_region_i);

                red_border = sum(red_region_boundary_i,"All");
                green_border = sum(red_region_boundary_i & img_green,"All");
                if (green_border / red_border) > 0.75
                    num_red_enclosed_green_75 = num_red_enclosed_green_75 + 1;  
                end
                if (green_border / red_border) > 0.50
                    num_red_enclosed_green_50 = num_red_enclosed_green_50 + 1;  
                end
            end
            col_features = [col_features; num_red_enclosed_green_75; num_red_enclosed_green_50];
        else
            col_features = [col_features; 0; 0;0;0;0;0;0;0];    
        end

        %   ----------------------Blue Region Data---------------------------
        %counts number of red regions
        CC_blue = bwconncomp(img_blue,4);
        table_blue = regionprops("table",CC_blue,"Area","Centroid","PixelList");
        num_blue_regions = sum(table_blue.Area > thresh);
        num_blue_lone = sum(table_blue.Area <= thresh);
        col_features = [col_features; num_blue_regions; num_blue_lone];

        if num_blue_regions > 0
            %average red region area
            blue_regions = table_blue(table_blue.Area>2,:);
            blue_avg_regionArea_fract = mean(blue_regions.Area / spheroid_area);
            blue_area_fract = sum(table_blue.Area) / spheroid_area;
            col_features = [col_features; blue_avg_regionArea_fract; blue_area_fract];

            %average red region distance to center
            blue_regions_dif = (blue_regions.Centroid - 9);
            blue_regions_dist = sqrt(blue_regions_dif(:,1).^2 + blue_regions_dif(:,2).^2);
            blue_avg_cent_dist = mean(blue_regions_dist);

            col_features = [col_features; blue_avg_cent_dist];
            
            %number of gray regions enveloped by green cells
            num_blue_enclosed_green_75 = 0;
            num_blue_enclosed_green_50 = 0;
            for i=1:height(blue_regions)
                blue_region_i = blue_regions.PixelList(i);
                blue_region_i = blue_region_i{1,1};
                blue_region_boundary_i = findregionboundary(img_blue,blue_region_i);

                blue_border = sum(blue_region_boundary_i,"All");
                green_border = sum(blue_region_boundary_i & img_green,"All");
                if (green_border / blue_border) > 0.75
                    num_blue_enclosed_green_75 = num_blue_enclosed_green_75 + 1;  
                end
                if (green_border / blue_border) > 0.50
                    num_blue_enclosed_green_50 = num_blue_enclosed_green_50 + 1;  
                end
            end
            col_features = [col_features; num_blue_enclosed_green_75; num_blue_enclosed_green_50];
        else
            col_features = [col_features; 0; 0; 0;0;0];        
        end

        %   ----------------------Gray Region Data---------------------------
        %counts number of red regions
        CC_gray = bwconncomp(img_gray,4);
        table_gray = regionprops("table",CC_gray,"Area","Centroid","PixelList");
        num_gray_regions = sum(table_gray.Area > thresh);
        num_gray_lone = sum(table_gray.Area <= thresh);
        col_features = [col_features; num_gray_regions; num_gray_lone];

        if num_gray_regions > 0
            %average red region area
            gray_regions = table_gray(table_gray.Area>2,:);
            gray_avg_regionArea_fract = mean(gray_regions.Area / spheroid_area);
            gray_area_fract = sum(table_gray.Area) / spheroid_area;
            col_features = [col_features; gray_avg_regionArea_fract; gray_area_fract];

            %average red region distance to center
            gray_regions_dif = (gray_regions.Centroid - 9);
            gray_regions_dist = sqrt(gray_regions_dif(:,1).^2 + gray_regions_dif(:,2).^2);
            gray_avg_cent_dist = mean(gray_regions_dist);

            col_features = [col_features; gray_avg_cent_dist];
            
            %number of gray regions enveloped by green cells
            num_gray_enclosed_green_75 = 0;
            num_gray_enclosed_green_50 = 0;
            for i=1:height(gray_regions)
                gray_region_k = gray_regions.PixelList(i);
                gray_region_k = gray_region_k{1,1};
                gray_region_boundary_k = findregionboundary(img_gray,gray_region_k);

                gray_border = sum(gray_region_boundary_k,"All");
                green_border = sum(gray_region_boundary_k & img_green,"All");
                if (green_border / gray_border) > 0.75
                    num_gray_enclosed_green_75 = num_gray_enclosed_green_75 + 1;  
                end
                if (green_border / gray_border) > 0.5
                    num_gray_enclosed_green_50 = num_gray_enclosed_green_50 + 1;  
                end
            end
            col_features = [col_features; num_gray_enclosed_green_75;num_gray_enclosed_green_50];
        else
            col_features = [col_features; 0; 0; 0;0;0];        
        end
        
        if num_green_regions > 3 & num_red_regions > 3
            col_features = [col_features; 0];
        else
            if max(table_green.Area) > max(table_red.Area)
                line = split(A{64+offset} + "",' ');
                col_features = [col_features; line(3)];
            else
                line = split(A{65+offset} + "",' ');
                col_features = [col_features; line(3)];
            end 
        end
        
        offset = offset + filelen;
        features = vertcat(features, col_features);
        ratios = [ratios; repmat(ratio, length(feature_name), 1)];
        radii = [radii; repmat(radius, length(feature_name), 1)];
        feature_names=[feature_names;feature_name];
    end
end
    features = [ratios, radii, feature_names, features];
    head = ["Ratio","Radius","Feature","Value"];
    writematrix([head;features], "features_" + curDir + ".xlsx");
end