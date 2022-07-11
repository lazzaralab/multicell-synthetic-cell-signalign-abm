function[ra] = regionaspectratio(img)
    CC = bwconncomp(img,8);
    table_props = regionprops("table",CC,"Area","PixelList");
    table_props = table_props((table_props.Area == max(table_props.Area)),:);
    ras = [];
    coords = table_props.PixelList(1);
    coords = coords{1};
    dim = [];
    dim = [(max(coords(:,1)) - min(coords(:,1))) , (max(coords(:,2)) - min(coords(:,2)))];
    [m, I] = max(dim);

    num = m;
    if I == 1
        den_i = round(median(coords(:,1)));
        coords_den = coords(coords(:,1) == den_i,:);
        den = max(coords_den(:,2)) - min(coords_den(:,2));
        l = size(coords_den);
        if l(1) == 1
            den = den + 0.1;
        end
    else
        den_i = round(median(coords(:,2)));
        coords_den = coords(coords(:,2) == den_i,:);
        den = max(coords_den(:,1)) - min(coords_den(:,1));
        l = size(coords_den);
        if l(1) == 1
            den = den + 0.1;
        end
    end
    ra = num / den;
end