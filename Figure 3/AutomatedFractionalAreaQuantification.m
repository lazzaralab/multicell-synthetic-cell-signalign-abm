clear all; close all; clc;
data = [];
keys = ["E8" "E9" "E10" "E11"];
for k = 1:length(keys)
    files = dir('*'+keys(k)+'*.jpg')
    row_data = [0 0 0 0];
    for i = 1:length(files)
        filename = files(i).name;
        index = strfind(filename, '_');
        index_2 = strfind(filename,'.')
        type = filename(index(9)+1:index_2(2)-1);
        if type == "c1"
            img_blue = imread(filename);
%             figure;
%             imshow(img_blue)

            img_blue = img_blue(:,:,3);
%             figure;
%             imshow(img_blue);

            th1=65;  
            img_blue(img_blue>th1)=255;
            img_blue(img_blue<th1)=0;
%             figure;
%             imshow(img_blue);
            row_data(1) = nnz(img_blue);
            imwrite(img_blue,"processed/"+filename+"_processed.jpg")
        end
        if type == "c2"
            img_green = imread(filename);
%             figure;
%             imshow(img_green)

            img_green = img_green(:,:,2);
%             figure;
%             imshow(img_green);

            th1=75;  
            img_green(img_green>th1)=255;
            img_green(img_green<th1)=0;
%             figure;
%             imshow(img_green);
            row_data(2) = nnz(img_green);
            imwrite(img_green,"processed/"+filename+"_processed.jpg")
        end
        if type == "c3"
            img_red = imread(filename);
%             figure;
%             imshow(img_red)

            img_red = img_red(:,:,1);
%             figure;
%             imshow(img_red);

            th1=65;  
            img_red(img_red>th1)=255;
            img_red(img_red<th1)=0;
%             figure;
%             imshow(img_red);
            row_data(3) = nnz(img_red);
            imwrite(img_red,"processed/"+filename+"_processed.jpg")
        end
        if type == "c4"
            img_phase = imread(filename);
            imshow(img_phase);

            radius = (7*18);
            h = drawcircle('Center',[456,368],'Radius',radius,'StripeColor','red');
            BW = createMask(h);
            imshow(BW);
            for i = 1:736
                for j = 1:912
                    if BW(i,j) == 1
                        img_phase(i,j,:) = img_phase(i,j,:) + 50;
                    end
                end
            end

            img_phase = img_phase(:,:,1);
            imshow(img_phase)

            phase_thresh = 70;
            img_phase(img_phase>phase_thresh)=255;

            img_phase(img_phase<phase_thresh)=0;


%             figure;
%             imshow(img_phase)
            row_data(4) = nnz(img_phase);
            imwrite(img_phase,"processed/"+filename+"_processed.jpg")
        end
    end
    data = [data; [keys(k) row_data]]
end
writematrix(data,'results.xlsx')