clear all;
[x, fs] = audio2bin('harry8noise.wav');
[y] = bin2audio('harry8.bin');

% helpers for plot axises
t = (0:size(x, 1) - 1)/fs;
tf = (size(y, 1) - 1)/fs;

% Plot the signals
subplot(2, 2, 1);
plot(t, x);
xlim([0 tf]);
title('Before Spectral Subtraction');

subplot(2, 2, 2);
plot(t, y);
xlim([0 tf]);
title('After Spectral Subtraction');

% Plot the spectrograms
subplot(2, 2, 3);
plot_spectrogram(x, 10, fs);

subplot(2, 2, 4);
plot_spectrogram(y, 10, fs);
