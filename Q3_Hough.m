%% Question 3
% Read in the image, convert to grayscale, and detect edges.
% Creates an array edges where each row is    (x, y, cos theta, sin theta)   
vp_image = imread('lines.png');
vp_image = imresize(rgb2gray(vp_image), 0.5);
subplot(3,1,1);
imshow(vp_image);
title('original image');

Iedges = edge(vp_image,'canny');
%  imgradient computes the gradient magnitude and gradient direction
%  using the Sobel filter.  
[~,grad_dir]=imgradient(vp_image);
%  imgradient defines the gradient direction as an angle in degrees
%  with a positive angle going (CCW) from positive x axis toward
%  negative y axis.   However, the (cos theta, sin theta) formulas from the lectures define theta
%  positive to mean from positive x axis to positive y axis.  For this
%  reason,  I will flip the grad_dir variable:
grad_dir = - grad_dir;

subplot(3,1,2);
imshow(Iedges);
title('Output of canny edge detector');

%Now find all the edge locations, and add their orientations (cos theta,sin theta). 
%  row, col is  y,x
[row, col] = find(Iedges);
% Each edge is a 4-tuple:   (x, y, cos theta, sin theta)   
edges = [col, row, zeros(length(row),1), zeros(length(row),1) ];
for k = 1:length(row)
     edges(k,3) = cos(grad_dir(row(k),col(k))/180.0*pi);
     edges(k,4) = sin(grad_dir(row(k),col(k))/180.0*pi);
end


% create the threshold to check if edge is more vertical or horizontal
threshold = cos(pi/4);
[numcols, numrows] = size(Iedges);

% create the hough space where we will cast our votes as a binary image
hough_space = zeros(numcols, numrows);

[numrows, numcols] = size(Iedges);

% loop through the edges
for i = 1:length(edges)
    % current edge
    edge = edges(i, :);
    x_edge = edge(1);
    y_edge = edge(2);
    costheta_edge = edge(3);
    sintheta_edge = edge(4);
    % compute r for the current edge, round, and keep absolute value
    r_edge = (x_edge * costheta_edge) + (y_edge * sintheta_edge);
    r_edge = round(r_edge);
    r_edge = abs(r_edge);
    % if edge is more horizontal than vertical
    if abs(costheta_edge) < threshold
        % then loop over the columns
        for j = 1:numcols
            % compute r for every y_value in n, 
            % with the other parameters coming from the current edge
            r_i = (j*costheta_edge) + (y_edge * sintheta_edge);
            r_i = round(r_i);
            r_i = abs(r_i);
            hough_space(y_edge, j) = (r_edge == r_i);
        end
    else
        % else the edge is more vertical than horizontal,
        % so we do as above but while looping through the columns
        for j = 1:numrows
            r_i = (x_edge*costheta_edge) + (j*sintheta_edge);
            r_i = round(r_i);
            r_i = abs(r_i);
            hough_space(j, x_edge) = (r_edge == r_i);
        end
    end   
end

subplot(3,1,3);
imshow(hough_space);
title('Hough Transform image');



    



