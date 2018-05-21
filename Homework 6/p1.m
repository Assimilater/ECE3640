clear all;

p = zeros(1, 2);
Xc = @(F) (100*pi)./(((1i*2*pi).*F + 10).^2 + (20*pi)^2);
F = (-50:0.1:50);
CTFT = Xc(F);

xc = @(t) 5*exp(-10*t).*sin(20*pi*t);
Fs = 150; % round(20*pi*2) = 126
N = 300; n = 0:N-1; t = n/Fs; NFFT = 10*N;
DFT = fftshift(fft(xc(t), NFFT))/Fs;
f = ((0:NFFT-1)/NFFT-0.5) * Fs;

% Plot Magnitude
subplot(2, 1, 1);
p(1) = plot(F, abs(CTFT)); hold on;
p(2) = plot(f, abs(DFT));
legend(p, 'CTFT', 'DFT');
title('|X(F)|'); xlabel('F (Hz)'); ylabel('Magnitude (V)');
grid on; hold off;
xlim([-50 50]);

% Plot Phase
subplot(2, 1, 2);
p(1) = plot(F, angle(CTFT)); hold on;
p(2) = plot(f, angle(DFT));
legend(p, 'CTFT', 'DFT');
title('<X(F))'); xlabel('F (Hz)'); ylabel('Phase (rad)');
grid on; hold off;
xlim([-50 50]);

% Radian y-axis maker
ylim([-pi pi]);
set(gca,'ytick',[-pi,-pi/2,0,pi/2,pi]);
set(gca,'yticklabel',[' -pi ';'-pi/2';'  0  ';' pi/2';'  pi ']);
