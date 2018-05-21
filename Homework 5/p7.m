clear all;

x = @(t) exp(-1000 .* abs(t));
X = @(F) 0.002 ./ (1 + (((0.002*pi) .* F) .^ 2));

% Part a
t = -.005:0.00000001:.005; %ms
F = -2000:1:2000; %kHz

figure(4);
subplot(2, 1, 1);
plot(t, x(t));
title('x_c(t)');

subplot(2, 1, 2);
plot(F, X(F));
title('X_c(F)');

figure(5);
subplot(2, 2, 1);
ADC_FT(x, t, 1/1000, 'Part B');

subplot(2, 2, 3);
ADC_FT(x, t, 1/5000, 'Part C');

