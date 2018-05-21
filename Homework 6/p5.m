clear all;

p = zeros(1, 5);
purple = [150 0 250] / 256;
F = @(N) (0:N-1)/N - 0.5; % Returns scale for FFT
N = @(k) 0:k-1; % Returns indexes for k samples

% Part a
x_a = @(n) 4 - n;
f_a = F(8); X_a = fftshift(fft(x_a(N(8)), 8));

% Part b
x_b = @(n) 4*sin(0.2*pi*n);
f_b = F(10); X_b = fftshift(fft(x_b(N(10)), 10));

% Part c
x_c = @(n) 6*cos(0.2*pi*n).*cos(0.2*pi*n);
f_c = F(10); X_c = fftshift(fft(x_c(N(10)), 10));

% Part d
x_d = @(n) 5*(0.8.^n);
f_d = F(16); X_d = fftshift(fft(x_d(N(16)), 16));

% Part e
x_e = [ ...
    3, -2, 3, -2, 3, -2, 3, -2, 3, -2, ...
    3, -2, 3, -2, 3, -2, 3, -2, 3, -2];
f_e = F(20); X_e = fftshift(fft(x_e, 20));

% Plot Magnitude
subplot(2, 1, 1);
p(1) = plot(f_a, abs(X_a), 'k'); hold on;
p(2) = plot(f_b, abs(X_b), 'r');
p(3) = plot(f_c, abs(X_c), 'g');
p(4) = plot(f_d, abs(X_d), 'b');
p(5) = stem(f_e, abs(X_e), 'Color', purple);
legend(p, 'a', 'b', 'c', 'd', 'e');
title('|X(F)|'); xlabel('F (Hz)'); ylabel('Magnitude (V)');
grid on; hold off;

% Plot Phase
subplot(2, 1, 2);
p(1) = plot(f_a, angle(X_a), 'k'); hold on;
p(2) = plot(f_b, angle(X_b), 'r');
p(3) = plot(f_c, angle(X_c), 'g');
p(4) = plot(f_d, angle(X_d), 'b');
p(5) = stem(f_e, angle(X_e), 'Color', purple);
legend(p, 'a', 'b', 'c', 'd', 'e');
title('<X(F)'); xlabel('F (Hz)'); ylabel('Phase (rad)');
grid on; hold off;

% Radian y-axis maker
ylim([-pi pi]);
set(gca,'ytick',[-pi,-pi/2,0,pi/2,pi]);
set(gca,'yticklabel',[' -pi ';'-pi/2';'  0  ';' pi/2';'  pi ']);
