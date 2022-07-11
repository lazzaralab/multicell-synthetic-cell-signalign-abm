function[circularity] = circularity(img_boundary)
    CC = bwconncomp(img_boundary,8);
    table_props = regionprops("table",CC,"Area","PixelList");
    table_props = sortrows(table_props,1,'descend');    
    coords = table_props.PixelList(1);
    circularity = 0;
    if isa(coords, "cell")
        coords = coords{1,1};
        midpoints = [0,0];
        for i = 1:length(coords)
           y = coords(i,2);
           points = coords((coords(:,2) == y),:);
           m = [mean(points(:,1)) mean(points(:,2))];
           if sum(midpoints(midpoints(:,1)==m(1,1) & midpoints(:,2)==m(1,2))) == 0
                   midpoints = [midpoints; m];
           end
        end
        midpoints=midpoints(2:end,:);
        slope = [];
        slope_difs = [];
        k=0;
        check = size(midpoints);
        for i = 1:length(midpoints)-1
            if check(1) > 1
                if midpoints(i+1,1) ~= midpoints(i,1)
                    s = (midpoints(i+1,2) - midpoints(i,2)) / (midpoints(i+1,1) - midpoints(i,1));
                    slope = [slope;s];
                    k = k+1;
                end
            end
            if k > 1
                slope_dif = abs(slope(k) - slope(k-1));
                slope_difs = [slope_difs; slope_dif];
            end
        end
        if length(slope_difs) > 0
            circularity = mean(slope_difs);
        else
            circularity = 0;
        end
    end
end