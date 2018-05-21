clear all;

N = 100;
n = 0:N-1;
del = [1, zeros(1, N-1)];

b = 1;
a = [1, 0, -0.8];

y1 = 0.8.^(n/2);
for i = 2:2:N
    y1(i) = 0;
end

y2 = filter(b, a, del);

figure(1);
subplot(3, 1, 1);
stem(n, y1);
title('Piecewise value');

subplot(3, 1, 2);
stem(n, y2);
title('Inverse z-transform');

subplot(3, 1, 3);
stem(n, y2 - y1);
title('Error');
