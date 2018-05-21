clear all;

p = zeros(1,4);
x = @(n) n.*(0.9.^n);
X = @(f) 0.9*exp(-1j*2*pi*f)./((1-0.9*exp(-1j*2*pi*f)).^2);
F = @(N) (0:N-1)/N - 0.5; % Returns scale for FFT
N = @(k) 0:k-1; % Returns indexes for k samples

f = F(1024); DTFT = X(f);
f_20 = F(20); X_20 = fftshift(fft(x(N(20)), 20));
f_50 = F(50); X_50 = fftshift(fft(x(N(50)), 50));
f_100 = F(100); X_100 = fftshift(fft(x(N(100)), 100));

% Plot Magnitude
subplot(2, 1, 1);
p(1) = plot(f, abs(DTFT), 'k'); hold on;
p(2) = plot(f_20, abs(X_20), 'r');
p(3) = plot(f_50, abs(X_50), 'g');
p(4) = plot(f_100, abs(X_100), 'b');
legend(p, 'DTFT', 'N = 20', 'N = 50', 'N = 100');
title('|X(F)|'); xlabel('F (Hz)'); ylabel('Magnitude (V)');
grid on; hold off;

% Plot Phase
subplot(2, 1, 2);
p(1) = plot(f, angle(DTFT), 'k'); hold on;
p(2) = plot(f_20, angle(X_20), 'r');
p(3) = plot(f_50, angle(X_50), 'g');
p(4) = plot(f_100, angle(X_100), 'b');
legend(p, 'DTFT', 'N = 20', 'N = 50', 'N = 100');
title('<X(F)'); xlabel('F (Hz)'); ylabel('Phase (rad)');
grid on; hold off;

% Radian y-axis maker
ylim([-pi pi]);
set(gca,'ytick',[-pi,-pi/2,0,pi/2,pi]);
set(gca,'yticklabel',[' -pi ';'-pi/2';'  0  ';' pi/2';'  pi ']);
