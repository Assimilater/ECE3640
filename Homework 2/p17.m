clear all;
N = 0:100;
a = [1, -1.15, 1.5, -.7, .25];
b = [.18, .1, .3, .1, .18];

figure;

% Part a
h = impz(b, a, N);
subplot(4, 1, 1);
dsplot(h, 'h[n]');

% Part b
x = ones(101, 1);
y = filter(b, a, x);
subplot(4, 1, 2);
dsplot(y, 'filter(b, a, u[n])');

% Part c
y = conv(h, x);
subplot(4, 1, 3);
dsplot(y, 'conv(h[n], u[n])');

% Part d
y = filter(h, 1, x);
subplot(4, 1, 4);
dsplot(y, 'filter(h[n], 1, u[n])');
