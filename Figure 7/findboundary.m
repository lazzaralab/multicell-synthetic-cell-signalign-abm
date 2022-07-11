function[img_boundary] = findboundary(img)
    img_boundary = zeros(length(img),length(img));
    for i=3:length(img)-3
        for j = 3:length(img)-3
           if img(i,j) == 0
               top_left = img(i-1,j+1);
               top_left_2 = img(i-2,j+2);
               if top_left == 1 && top_left_2 == 1
                   img_boundary(i,j) = 1;
               end

               top = img(i,j+1);
               top_2 = img(i,j+2);
               if top == 1 && top_2 == 1
                   img_boundary(i,j) = 1;
               end

               top_right = img(i+1,j+1);
               top_right_2 = img(i+2,j+2);
               if top_right == 1 && top_right_2 == 1
                   img_boundary(i,j) = 1;
               end

               right = img(i+1,j);
               right_2 = img(i+2,j);
               if right == 1 && right_2 == 1
                   img_boundary(i,j) = 1;
               end

               bottom_right = img(i+1,j-1);
               bottom_right_2 = img(i+2,j-2);
               if bottom_right == 1 && bottom_right_2 == 1
                   img_boundary(i,j) = 1;
               end

               bottom = img(i,j-1);
               bottom_2 = img(i,j-2);
               if bottom == 1 && bottom_2 == 1
                   img_boundary(i,j) = 1;
               end

               bottom_left = img(i-1,j-1);
               bottom_left_2 = img(i-2,j-2);
               if bottom_left == 1 && bottom_left_2 == 1
                   img_boundary(i,j) = 1;
               end

               left = img(i-1,j);
               left_2 = img(i-2,j);
               if left == 1 && left_2 == 1
                   img_boundary(i,j) = 1;
               end
           end
        end 
    end
end