clear all;
N = 10;
M = 5;
u = ones(1000, 1);

x = u(1:N);
h = 0:(M - 1) .* u(1:M);
y = conv(h, x);

figure;
dsplot(y, 'conv(h, x)');
