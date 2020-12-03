%% Question 1: Demoisaicing
%
%
%

%% Part a)
% Create the sharp intensity image
image=zeros(500,500,3); 
image(:, 1: 250 ,1)=0.4;   
image(:,1:250,2)=0.4;   
image(:, 1:250, 3)= 0.4;  

image(:, 251:500, 1) = 0.8;
image(:, 251:500, 2) = 0.8;
image(:, 251:500, 3) = 0.8;
%imshow(image);
%title('original image');

% read in number of rows, of columns and of channels of the image
[numrows, numcols, numchannels] = size(image);

% split into color channels
% get the intensity image for each channel
redimage = image(:,:,1); 
greenimage = image(:,:,2);
blueimage = image(:,:,3);

% create all black image with the same size as the original image
allBlack = zeros(size(image, 1), size(image, 2));


% color the intensity images
onlyRedImage = cat(3, redimage, allBlack, allBlack);
onlyBlueImage = cat(3, allBlack, allBlack, blueimage);
onlyGreenImage = cat(3, allBlack, greenimage, allBlack);


% 4 x 4 square grid for each channel according to the Bayer pattern
% Note the bayer pattern is
%{
    G B
    R G
%}
redGrid = [0 0; 1 0];
greenGrid = [1 0; 0 1];
blueGrid = [0 1; 0 0];

% Masks for each channel using the above bayer pattern
% and we want to repeat this pattern over the image size 
red_mask = repmat(redGrid, numrows/2, numcols/2);
green_mask = repmat(greenGrid, numrows/2, numcols/2);
blue_mask = repmat(blueGrid, numrows/2, numcols/2);

% 'moisaiced' images
bayer_red = double(onlyRedImage) .* red_mask;
bayer_green = double(onlyGreenImage) .* green_mask;
bayer_blue  = double(onlyBlueImage) .* blue_mask;

subplot(1, 4, [1 2]);
imshow(bayer_blue);
title('Full mosaiced image');

% to zoom in on the mosaic
cropped_red = bayer_red(1:16, 1:16, :);
cropped_green = bayer_green(1:16, 1:16, :);
cropped_blue = bayer_blue(1:16, 1:16, :);

subplot(1, 4, [3 4]);
imshow(cropped_blue);
title('Zoomed-in mosaiced image');
%%
% filters for each color (red and blue are the same)
blue_filter = [1/4 2/4 1/4; 2/4 4/4 2/4; 1/4 2/4 1/4];
red_filter = blue_filter;
green_filter = [0 1/4  0;1/4 4/4 1/4; 0 1/4 0];

% interpolation using conv2
interpolated_red = conv2(bayer_red(:,:,1), red_filter);
rows = size(interpolated_red, 1);
cols = size(interpolated_red, 2);
final_red = zeros(rows, cols, 3);
% interpolated_red has only one channel, so we set that channel to red
% and initialize the other channels as all zeros
final_red(:,:,1) = interpolated_red(:,:,1);
final_red(:,:,2) = 0;
final_red(:,:,3) = 0;

% similarly for blue
interpolated_blue = conv2(bayer_blue(:,:,3), blue_filter);
final_blue = zeros(rows, cols, 3);
final_blue(:,:,1) = 0;
final_blue(:,:,2) = 0;
final_blue(:,:,3) = interpolated_blue(:,:,1);

% similarly for green
interpolated_green = conv2(bayer_green(:,:,2), green_filter);
final_green = zeros(rows,cols,3);
final_green(:,:,1) = 0;
final_green(:,:,2) = interpolated_green(:,:,1);
final_green(:,:,3) = 0;

imshow(imresize(final_green,10));
title('interpolated red channel');










