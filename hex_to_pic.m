function [img] = hex_to_pic
inImg = (imread('baitap1_nhieu.jpg'));

fid = fopen('pic_output.txt','r');
img = fscanf(fid,'%x');
fclose(fid);

outImg = reshape(img,[554 430]);

subplot(121);
imshow(inImg);
title('input image');
subplot(122);
imshow(outImg,[]);
title('output image'); 
