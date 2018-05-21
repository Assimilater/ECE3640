clear all;

F = -150:1/100:150;
X = @(T) ...
    (5 * (1 - exp(-20*T))) ./ ...
    (1 - ((2*exp(-10*T)) .* cos((2*pi*T) .* F)) + exp(-20*T));

figure(1);
subplot(3, 1, 1);
plot(F, X(1/100));
title('Fs = 100 Hz');

subplot(3, 1, 2);
plot(F, X(1/50));
title('Fs = 50 Hz');

subplot(3, 1, 3);
plot(F, X(1/25));
title('Fs = 25 Hz');
