% Parse the data
[x, fs] = audio2bin('music.mp3');
sound(x, fs);

% Read formatted data
[x, fs] = bin2audio('music.bin');
sound(x, fs);

% Time range of interest
time = (0:(length(x) - 1)) / fs;
t1 = 1;
t2 = 1.01;

% Plot the time domain
subplot(2, 2, 1);
plot(time, x);
xlabel('time [seconds]', 'FontSize', 18);
ylabel('amplitude', 'FontSize', 18);
set(gca, 'FontSize', 16);
grid on;
xlim([t1 t2]);

% Plot the FFT
i1 = round(t1 * fs);
i2 = round(t2 * fs);
nfft = 2^12; % FFT size
freq = (((0:(nfft-1)) / nfft) - 0.5) * fs; % frequency [Hz]
X = fft(x(i1:i2,:), nfft); % Discrete Fourier Transform

subplot(2, 2, 2);
plot(freq, 20*log10(abs(fftshift(X)))); % use log axis
xlabel('frequency [Hz]', 'FontSize', 18);
ylabel('magnitude [dB]', 'FontSize', 18);
set(gca, 'FontSize', 16);
grid on;

% Plot the spectrograms
nfft = 2^8;
overlap = round(0.8*nfft);
window = hamming(nfft);

subplot(2, 2, 3);
spectrogram(x(:,1), window, overlap, nfft, fs);
set(gca, 'FontSize', 16);
grid on;

subplot(2, 2, 4);
spectrogram(x(:,2), window, overlap, nfft, fs);
set(gca, 'FontSize', 16);
grid on;

% View on oscilloscope
win_sec = 0.05;                 % window length [seconds]
win_sam = round(win_sec*fs);    % window length [samples]
step_sec = 0.001;               % step length [seconds]
step_sam = round(step_sec*fs);  % step length [samples]

figure;
han = plot(time(1:win_sam), x(1:win_sam));
drawnow;
ylim(0.1*[-1, 1]);
for i = win_sam:step_sam:length(x)
    ind = ((i - win_sam + 1):i);
    set(han, 'XData', time(ind), 'YData', x(ind));
    xlim(time(ind([1, end])));
    drawnow;
    pause(0.05);
end
