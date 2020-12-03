%% Part a
% initialize an image of 300 rows and 300 columns which we'll crop later
image = zeros(300, 300);
 
% place 100 rectangles in the images at different random positions
% and of different random gray scales
for i = 1:100
    image(randi([24, 280]):randi([24,280]), randi([24, 280]):randi([24,280])) = rand;
end

% crop the image to avoid boundary problems
cropped_image = imcrop(image, [25 25 249 249]);
imshow(imresize(cropped_image,3 ));


%% Part b
% Laplacian of a Gaussian
% Params: 
%   hsize(width) = 20
%   sigma (standard deviation) = 3
LoG_filter = fspecial('log', [20 20], 3);
imagesc(LoG_filter);
colormap(gray);
colorbar;
%% Part c
filtered_image = imfilter(cropped_image, LoG_filter); % Filter image with LoG filter
subplot(2,1,1);
imagesc(filtered_image);
title('Filtered Image');
colormap(gray);

% function which checks if point in the middle of a 3x3 matrix has a
% zero-crossing with any of its neighbors
f = @(p) ~(sign(p(5) * p(1)) == -1 |...
    sign(p(5) * p(2)) == -1 | ...
    sign(p(5) * p(3)) == -1 | ...
    sign(p(5) * p(4)) == -1 | ...
    sign(p(5) * p(6)) == -1 | ...
    sign(p(5) * p(7)) == -1 | ...
    sign(p(5) * p(8)) == -1 | ...
    sign(p(5) * p(9)) == -1);
    
% apply above function to every 3x3 square grid of the filtered image
zero_crossing_image = nlfilter(filtered_image, [3 3], f);
subplot(2,1,2);
imagesc(zero_crossing_image);
title('Zero crossings');
%% Part d
% add noise to the cropped image
%
%
image_std = std2(cropped_image); % standard dev of cropped image pixel values
m = size(cropped_image, 1);
n = size(cropped_image, 2);

% Create noisy image
noise = randn(n); 
noise = noise * image_std/10;
noisy_image = cropped_image + noise;

% Show noisy image
subplot(2,1,1);
imagesc(noisy_image);
title('Noisy Image');


% Filter noisy image
filtered_noisy_image = imfilter(noisy_image, LoG_filter);
% Show noisy image
%subplot(3,1,2)
%imagesc(filtered_noisy_image);
%title('Filtered Noisy Image w/ G(20, 3)');
%colormap(gray);

% zero crossing of filtered noisy image
zero_crossing_noise = nlfilter(filtered_noisy_image, [3 3], f);

subplot(2,1,2);
imagesc(zero_crossing_noise);
title('Zero crossings of filtered noisy image');
colormap(gray);
%% Part e

% LoG filter with width 40 and sigma 6
LoG_filter2 = fspecial('log', [40 40], 6);
% filter noisy image as before
filtered_noisy_image2 = imfilter(noisy_image, LoG_filter2);
subplot(2,1,1);
imagesc(filtered_noisy_image2);
title('Filtered noisy image w/ G(40, 6)');
colormap(gray);


% zero crossings as before
zero_crossing_noise2 = nlfilter(filtered_noisy_image2, [3 3], f);
subplot(2,1,2);
imagesc(zero_crossing_noise2);
title('Zero crossing of filtered noisy image2');
colormap(gray);


%% Way more false edges are detected for the gaussian with larger weight 
% and larger std















    