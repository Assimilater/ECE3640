clear all;

% Audio Portion
fid = fopen('lpf_260_400_44100_80db.bin', 'rb');
ndim = fread(fid, 1, 'int');
nchan = fread(fid, 1, 'int');
dim0 = fread(fid, 1, 'int');
dim1 = fread(fid, 1, 'int');
dim2 = fread(fid, 1, 'int');
h = fread(fid, inf, 'float');
fclose(fid);

% Calculate H(w)
N = 2^14; % FFT size
f = (0:N-1)*dim1/N; % Make frequency vector for plotting
H = abs(fft(h,N)).^2; % Compute the magnitude reponse

%Plot the filter response
figure(1);
subplot(2, 2, 1);
stem(h);
title('h[n]');
set(gca, 'FontSize', 16);
grid on;

subplot(2, 2, 2);
semilogx(f, 10*log10(H));
xlim([0 dim1/2]);
ylim([-100 10]);
title('H(w)');
xlabel('Frequncy (Hz)', 'FontSize', 18);
ylabel('Gain (db)', 'FontSize', 18);
set(gca, 'FontSize', 16);
grid on;

% Parse the audio
[x, fs] = audio2bin('fireflyintro.wav');
%sound(x, fs);

% Apply the filter
x2 = conv(x, h);
[x3, fs3] = bin2audio('fireflyintro_pfp.bin');
%sound(x2, fs);
%sound(x3, fs3);

% Plot the spectrograms
nfft = 2^8;
overlap = round(0.8*nfft);
window = hamming(nfft);

subplot(2, 2, 3);
spectrogram(x, window, overlap, nfft, fs);
title('Before Filter');
set(gca, 'FontSize', 16);
grid on;

subplot(2, 2, 4);
spectrogram(x3, window, overlap, nfft, fs);
title('After Filter');
set(gca, 'FontSize', 16);
grid on;

clear all;

% Video Portion
[x1] = image2bin('cameraman.tif');
[x2] = image2bin('John Fiddle.jpg');
