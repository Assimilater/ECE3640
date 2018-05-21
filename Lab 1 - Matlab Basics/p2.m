% Parse the data
[x1] = image2bin('liftingbody.png');
[x2] = image2bin('coloredchips.png');

% Read formatted data
[x1] = bin2image('liftingbody.bin');
[x2] = bin2image('coloredchips.bin');

figure;

% Show gray-scale
subplot(1,2,1);
imagesc(x1, [100, 200]);
axis image;
colormap(gray);
colorbar;

% Show color
subplot(1,2,2);
image(x2);
axis image;
