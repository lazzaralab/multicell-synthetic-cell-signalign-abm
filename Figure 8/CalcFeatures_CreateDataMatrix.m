clear all; close all; clc;
folders = dir('*A|*');
% delete('*.xlsx')
all_features_ratios = [];
for k = 1:length(folders)
    copyfile("findregionboundary.m",folders(k).name);
    copyfile("circularity.m",folders(k).name);
    copyfile("regionaspectratio.m",folders(k).name);
    curFolder = folders(k).name;
    cd(folders(k).name)
    
    ratio = (curFolder(1:5) + "");
    index1 = strfind(curFolder,'-') + 1;
    index2 = strfind(curFolder,'_') - 1;

    radius = (curFolder(index1(1):index2(2)) + "");
    homo_c = (curFolder(index1(2):index2(3))+ "");
    homo_d = (curFolder(index1(3):index2(4))+ "");
    hetero = (curFolder(index1(4):end) + "");
    
    delete('*.xlsx')
    delete('*.png')
    features = [];
    filenames = [];
    feature_names = ["file-path" "homo_c" "homo_d" "hetero" "a-count" "b-count" "c-color-count" "c-express-count" "d-color-count" "d-express-count" "cell-count" "num_green_regions" "num_lone_green_regions" "green_avg_regionArea_fract" "green_area_fract" "green_avg_cent_dist" "green_region_width" "green_region_height" "green_region_aspect_ratio" "green_region_circularity" "green_region_circularity_small" "num_red_regions" "num_red_lone" "red_avg_regionArea_fract" "red_area_fract" "red_avg_cent_dist" "red_region_width" "red_region_height"  "red_region_aspect_ratio" "red_region_circularity" "red_region_circularity_small" "green_red_centroid_dist" "green_region_avg_red_contig" "red_region_avg_green_contig" "green_red_contig_dif" "num_blue_regions" "num_blue_lone" "blue_avg_regionArea_fract" "blue_area_fract" "blue_avg_cent_dist" "contiguous_area"];
    files = dir('*.txt');
    filecount = 1;
    for i = 1:length(files)
        curFile = files(i).name;
        A = importdata(curFile,'\n');
        offset = 0;
        for j = 1:length(A)/91
            col_features = [];
            for i = 1+offset:7+offset
                line = split(A{i} + "", ' ');
                col_features = [col_features line(3)];
            end

            img_blue = zeros(17,17);
            img_green = zeros(17,17);
            img_red = zeros(17,17);
            spheroid_area = 80;
            thresh = 2;

            for m = (8+offset):(89+offset)
                line = split(A{m} + "", ' ');
                disp(line);
                color = line(2);
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
            end
            
            img= zeros(17,17,3);
            img(:,:,1)=img_red;
            img(:,:,2)=img_green;
            img(:,:,3)=img_blue;
            img_name= "run_"+filecount+".png";
            imwrite(img,img_name);
            
            file_path = curFolder + "/" + img_name;
            col_features = [file_path homo_c homo_d hetero col_features];
            filecount = filecount + 1;

        %   ----------------------Green Region Data---------------------------
            %counts number of green regions
            CC_green = bwconncomp(img_green,4);
            table_green = regionprops("table",CC_green,"Centroid","Area","PixelList","BoundingBox","Circularity");
            num_green_regions = sum(table_green.Area > thresh);
            num_green_lone = sum(table_green.Area <= thresh);
            col_features = [col_features num_green_regions num_green_lone];

            if num_green_regions > 0
                %average green region area
                green_regions = table_green(table_green.Area>thresh,:);
                green_avg_regionArea_fract = mean(green_regions.Area / spheroid_area);
                green_area_fract = sum(table_green.Area) / spheroid_area;

                col_features = [col_features green_avg_regionArea_fract green_area_fract];

                %average green region distance to center
                green_regions_dif = (green_regions.Centroid - 9);
                green_regions_dist = sqrt(green_regions_dif(:,1).^2 + green_regions_dif(:,2).^2);
                green_avg_cent_dist = mean(green_regions_dist);
                col_features = [col_features green_avg_cent_dist];
                
                %average width and height of freen regions
                green_region_width = mean(green_regions.BoundingBox(:,3));
                green_region_height = mean(green_regions.BoundingBox(:,4));
                green_region_aspect_ratio = regionaspectratio(img_green);
                col_features = [col_features green_region_width green_region_height green_region_aspect_ratio];
                
                %Green Region Circularity
                CC_green_8 = bwconncomp(img_green,8);
                table_green_8 = regionprops("table",CC_green_8,"Centroid","Area","PixelList","BoundingBox","Circularity");
                large_green_region = table_green_8(table_green_8.Area == max(table_green_8.Area),:);
                img_large_green_region = large_green_region.PixelList;
                img_large_green_region = img_large_green_region{1,1};
                [large_green_region_i_boundary,green_diam] = findregionboundary(img_green,img_large_green_region);
                green_region_circularity = circularity(large_green_region_i_boundary);
%                 for m = 1:height(large_green_regions)
%                     green_region_k = large_green_regions.PixelList(m);
%                     green_region_k = green_region_k{1,1};
%                    [green_region_k_boundary,green_diam] = findregionboundary(img_green,green_region_k); 
%                    circularity_k = circularity(green_region_k_boundary);
%                    green_region_circularities =[green_region_circularities circularity_k];
%                 end
%                 green_region_circularity = mean(green_region_circularities);
                small_green_region = green_regions(green_regions.Area == min(green_regions.Area),:);
                img_small_green_region = small_green_region.PixelList;
                img_small_green_region = img_small_green_region{1,1};
                [small_green_region_i_boundary,green_diam] = findregionboundary(img_green,img_small_green_region);
                small_green_region_circularity = circularity(small_green_region_i_boundary);
                
                col_features = [col_features green_region_circularity small_green_region_circularity];
            else
                col_features = [col_features 0 0 0 0 0 0 0];
            end

        %   ----------------------Red Region Data---------------------------
            %counts number of red regions
            CC_red = bwconncomp(img_red,4);
            table_red = regionprops("table",CC_red,"Centroid","Area","PixelList","BoundingBox","Circularity");
            num_red_regions = sum(table_red.Area > thresh);
            num_red_lone = sum(table_red.Area <= thresh);
            col_features = [col_features num_red_regions num_red_lone];

            if num_red_regions > 0
                %average red region area
                red_regions = table_red(table_red.Area>2,:);
                red_avg_regionArea_fract = mean(red_regions.Area / spheroid_area);
                red_area_fract = sum(table_red.Area) / spheroid_area;
                col_features = [col_features red_avg_regionArea_fract red_area_fract];

                %average red region distance to center
                red_regions_dif = (red_regions.Centroid - 9);
                red_regions_dist = sqrt(red_regions_dif(:,1).^2 + red_regions_dif(:,2).^2);
                red_avg_cent_dist = mean(red_regions_dist);

                %radius of red core
        %         points = table_red.BoundingBox - length(img)/2;
        %         red_rad = mean((sqrt(points(:,1).^2 + points(:,2).^2)+sqrt(points(3).^2 + points(4).^2))/2);

                col_features = [col_features red_avg_cent_dist];
                
                %average width and height of freen regions
                red_region_width = mean(red_regions.BoundingBox(:,3));
                red_region_height = mean(red_regions.BoundingBox(:,4));
                red_region_aspect_ratio = regionaspectratio(img_red);
                if red_region_aspect_ratio == Inf
                    disp(file_path)
                end
                col_features = [col_features red_region_width red_region_height red_region_aspect_ratio];
            
                CC_red_8 = bwconncomp(img_red,8);
                table_red_8 = regionprops("table",CC_red_8,"Centroid","Area","PixelList","BoundingBox","Circularity");
                large_red_region = table_red_8(table_red_8.Area == max(table_red_8.Area),:);
                img_large_red_region = large_red_region.PixelList;
                img_large_red_region = img_large_red_region{1,1};
                [img_large_red_region_boundary,red_diam] = findregionboundary(img_red,img_large_red_region);
                red_region_circularity = circularity(img_large_red_region_boundary);
                
                small_red_region = red_regions(red_regions.Area == min(red_regions.Area),:);
                img_small_red_region = small_red_region.PixelList;
                img_small_red_region = img_small_red_region{1,1};
                [small_red_region_i_boundary,green_diam] = findregionboundary(img_red,img_small_red_region);
                small_red_region_circularity = circularity(small_red_region_i_boundary);
                
%                 for m = 1:height(large_red_regions)
%                     red_region_k = large_red_regions.PixelList(m);
%                     red_region_k = red_region_k{1,1};
%                    [red_region_k_boundary,green_diam] = findregionboundary(img_red,red_region_k); 
%                    circularity_k = circularity(red_region_k_boundary);
%                    red_region_circularities =[red_region_circularities circularity_k];
%                 end
%                 red_region_circularity = mean(red_region_circularities);
                col_features = [col_features red_region_circularity small_red_region_circularity];
            else
                col_features = [col_features 0 0 0 0 0 0 0];    
            end
            
            if num_green_regions > 0 && num_red_regions > 0
               green_region_centroid = mean(green_regions.Centroid);
               red_region_centroid = mean(red_regions.Centroid);
               green_red_centroid_dist = sqrt(sum((green_region_centroid-red_region_centroid).^2));
               col_features = [col_features green_red_centroid_dist]; 
               
            green_contig = [];
            red_contig = [];
            for m=1:height(green_regions)
                green_region_i = green_regions.PixelList(m);
                green_region_i = green_region_i{1,1};
                [green_region_i_boundary,green_diam] = findregionboundary(img_green,green_region_i);
                red_border = sum(green_region_i_boundary & img_red,"All");
                ap = red_border / green_diam;
                green_contig = [green_contig ap];
            end
            green_region_avg_red_contig = mean(green_contig);

            for m=1:height(red_regions)
                red_region_i = red_regions.PixelList(m);
                red_region_i = red_region_i{1,1};
                [red_region_i_boundary,red_diam] = findregionboundary(img_red,red_region_i);
                green_border = sum(red_region_i_boundary & img_green,"All");
                ap = green_border / red_diam;
                red_contig = [red_contig ap];
            end
            red_region_avg_green_contig = mean(red_contig);
            green_red_contig_dif = abs(green_region_avg_red_contig - red_region_avg_green_contig);
            col_features = [col_features green_region_avg_red_contig red_region_avg_green_contig green_red_contig_dif];
            else
                col_features = [col_features 0 0 0 0]; 
            end

            %   ----------------------Blue Region Data---------------------------
            %counts number of red regions
            CC_blue = bwconncomp(img_blue,4);
            table_blue = regionprops("table",CC_blue);
            num_blue_regions = sum(table_blue.Area > thresh);
            num_blue_lone = sum(table_blue.Area <= thresh);
            col_features = [col_features num_blue_regions num_blue_lone];

            if num_blue_regions > 0
                %average red region area
                blue_regions = table_blue(table_blue.Area>2,:);
                blue_avg_regionArea_fract = mean(blue_regions.Area / spheroid_area);
                blue_area_fract = sum(table_blue.Area) / spheroid_area;
                col_features = [col_features blue_avg_regionArea_fract blue_area_fract];

                %average red region distance to center
                blue_regions_dif = (blue_regions.Centroid - 9);
                blue_regions_dist = sqrt(blue_regions_dif(:,1).^2 + blue_regions_dif(:,2).^2);
                blue_avg_cent_dist = mean(blue_regions_dist);

                col_features = [col_features blue_avg_cent_dist];
            else
                col_features = [col_features 0 0 0];        
            end

            if num_green_regions > 2 && num_red_regions > 2
                col_features = [col_features 0];
            else
                if min(red_regions_dist) > min(green_regions_dist)
                    core = table_green(table_green.Area == max(table_green.Area),:);
                    img_core = core.PixelList;
                    img_core = img_core{1,1};
                    [core_region_boundary,core_diam] = findregionboundary(img_green,img_core);
                    red_border = sum(core_region_boundary & img_red,"All");
                    contiguous_area = red_border / core_diam;
                    col_features = [col_features contiguous_area];
                else
                    core = table_red(table_red.Area == max(table_red.Area),:);
                    img_core = core.PixelList;
                    img_core = img_core{1,1};
                    [core_region_boundary,core_diam] = findregionboundary(img_red,img_core);
                    green_border = sum(core_region_boundary & img_green,"All");
                    contiguous_area = green_border / core_diam;
                    col_features = [col_features contiguous_area];
                end
            end
            
            offset = offset + 89;
            features = vertcat(features, col_features);
        end
    end
%     average_features = mean(features);
%     std_features = std(features);
    all_features_ratios = [all_features_ratios; features];
    writematrix([feature_names;features], "features_core_pole.xlsx");
    disp("" + folders(k).name + " done")
    cd ..
end
writematrix([feature_names;all_features_ratios], "features_spheroids.xlsx");