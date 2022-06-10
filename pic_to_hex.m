function [img] = pic_to_hex
img = imread('baitap1_nhieu.jpg');
gray = rgb2gray(img);

%s = dec2hex(size(gray));
%writematrix(s, 'pic_input_size.txt', 'Delimiter', ' ');

img_hex = dec2hex(gray);
writematrix(img_hex, 'pic_input.txt', 'Delimiter', ' ');

imshow(gray,[]);
title('input image');
