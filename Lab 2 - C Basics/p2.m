clear all;

color = VideoReader('xylophone.mp4');
gray = VideoReader('xylophone_gray.mp4');

x = readFrame(color);
y = readFrame(gray);

figure;

subplot(1, 2, 1);
imagesc(x);
axis image;
title('Original Color');

subplot(1, 2, 2);
imagesc(y);
axis image;
title('Converted Grayscale');
