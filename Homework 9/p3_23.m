clear all;

w0 = pi/3;

N = 14;
n = 0:N-1;
b = [1, 0];
a = @(r, w) [1, -2*r*cos(w), (r^2)];

figure(1);

r = 0.8;
subplot(3, 2, 1);
zplane(b, a(r, w0));
title(['zplane <-> r = ' num2str(r)]);

subplot(3, 2, 2);
stem(n, impz(b, a(r, w0), N));
title(['h[n] <-> r = ' num2str(r)]);

r = 1;
subplot(3, 2, 3);
zplane(b, a(r, w0));
title(['zplane <-> r = ' num2str(r)]);

subplot(3, 2, 4);
stem(n, impz(b, a(r, w0), N));
title(['h[n] <-> r = ' num2str(r)]);

r = 1.25;
subplot(3, 2, 5);
zplane(b, a(r, w0));
title(['zplane <-> r = ' num2str(r)]);

subplot(3, 2, 6);
stem(n, impz(b, a(r, w0), N));
title(['h[n] <-> r = ' num2str(r)]);
