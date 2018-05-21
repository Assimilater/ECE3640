clear all;

% delta matrix
d = zeros(3, 3);
d(2,2) = 1;

h = [0, 1, 0;
    1, -4, 1;
    0, 1, 0];

H = d - h;

x = imread('lena.jpg');
y = conv2(double(x), h);
f = conv2(double(x), H);

figure;

subplot(1, 3, 1);
imagesc(x);
title('Original');
axis image;
colormap gray;
colorbar;

subplot(1, 3, 2);
imagesc(y);
title('Laplacian');
axis image;
colormap gray;
colorbar;

subplot(1, 3, 3);
imagesc(f);
title('Final');
axis image;
colormap gray;
colorbar;
