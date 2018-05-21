clear all;

% Problem 44
x1 = [1, -2, 1, -3];
x2 = [0, 2, -1, 0, 0, 4];

% Part a: c1 = [0, 2, -5, 4, -7, 7, -8, 4, -12]
c1 = conv(x1, x2);
% Part b: c2 = [-8, 6, -17, 4, -7, 7]
c2 = cconv(x1, x2, 6);
% Part c: minimum N = 9 = size(c1) = size(x1) + size(x2) - 1
c3 = cconv(x1, x2, 9);

% Problem 49
X = @(w) (1 - (0.8^10)*exp(-1j*w*10)) ./ (1 - 0.8*exp(-1j*w));
f = -0.5:0.00001:0.5;
n = (0:9);
xn = 0.8 .^ n;
fn = n/10 - 0.5;

figure(1);
p = zeros(1, 4);
p(1) = plot(f, abs(X(2*pi*f))); hold on;
p(2) = stem(fn, abs(fftshift(fft(xn, 10))));
p(3) = plot(f, abs(X(2*pi*(f+1/20)))); % For my beneift, not on problem
p(4) = stem(fn, abs(fftshift(fft(xn.*exp(-1j*pi*n/10), 10))));
legend(p, 'X(f)', 'X[N]', 'Y(f)', 'Y[N]'); hold off;
title('Problem 7.49 - For DFT: N = 10');
xlabel('Frequency (sample Hz)'); ylabel('Magnitude');
