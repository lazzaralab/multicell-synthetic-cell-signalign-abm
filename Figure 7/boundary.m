clear all; close all; clc;
img = imread('24-Jul-2020_radius_7.29A|1_run_24.png');
imshow(img);

img_red = img(:,:,1) > 100 & img(:,:,2) < 100 & img(:,:,3) < 100;
figure;
imshow(img_red)
img_red_boundary = findboundary(img_red);
figure;
imshow(img_red_boundary);

img_green = img(:,:,1) < 100 & img(:,:,2) > 100 & img(:,:,3) < 100;
figure;
imshow(img_green);
img_green_boundary = findboundary(img_green);
figure;
imshow(img_green_boundary);


% img_blue = img(:,:,1) < 100 & img(:,:,2) < 100 & img(:,:,3) > 100;
% figure;
% imshow(img_blue);
% img_blue_boundary = findboundary(img_blue);
% figure;
% imshow(img_blue_boundary);

img_overlap_green_red = (img_green_boundary & img_red_boundary);
figure;
imshow(img_overlap_green_red);