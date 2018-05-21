clear all;

h = [ ...
    {firpm(4, [0, 1/80, 1/2 - 1/80, 1/2]*2, [1, 1, 0, 0]), 'h1', 8*10^6}; ...
    {firpm(4, [0, 1/40, 1/2 - 1/40, 1/2]*2, [1, 1, 0, 0]), 'h2', 4*10^6}; ...
    {firpm(6, [0, 1/20, 1/2 - 1/20, 1/2]*2, [1, 1, 0, 0]), 'h3', 2*10^6}; ...
    {firpm(8, [0, 1/10, 1/2 - 1/10, 1/2]*2, [1, 1, 0, 0]), 'h4', 1*10^6}; ...
    {firpm(6, [0, 3/50, 1/2 - 3/50, 1/2]*2, [1, 1, 0, 0]), 'h5', 500*10^3}; ...
    {firpm(6, [0, 3/25, 1/2 - 3/25, 1/2]*2, [1, 1, 0, 0]), 'h6', 250*10^3}; ...
    {firpm(6, [0, 3/15, 1/2 - 3/15, 1/2]*2, [1, 1, 0, 0]), 'h7', 150*10^3}; ...
];

h{5, 1} = lpf(2, 256); % I gave up trying to make firpm work
h{6, 1} = lpf(5, 256); % I gave up trying to make firpm work
h{7, 1} = lpf(5, 256); % I gave up trying to make firpm work

% Write header binary files
for i = 1:7
    fid = fopen(sprintf('output\\%s.bin', h{i, 2}), 'wb');
    fwrite(fid, [1 1 length(h{i, 1}) 1 0], 'int');
    fwrite(fid, h{i, 1}, 'float');
    fclose(fid);
end

% Plot h1-h4
figure(1);
for i = 1:4
    subplot(4, 1, i);
    [w, F, theta, r, db] = getFFT(h{i, 1}, 10, h{i, 3});
    plot(w, db);
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    title(sprintf('LPF %i', i));
end

sig = [ ... % file, f, f_c
    {'freq94_8_bw_4', 0, 0, 'Original Signal', 8*10^6, 0, 0, 0, 0, 0}; ...
    {'y0', 0, 0, 'After Fruency Shift', 8*10^6, 0, 0, 0, 0, 0}; ...
    {'y1', 0, 0, 'After LPF 1', 4*10^6, 0, 0, 0, 0, 0}; ...
    {'y2', 0, 0, 'After LPF 2', 2*10^6, 0, 0, 0, 0, 0}; ...
    {'y3', 0, 0, 'After LPF 3', 1*10^6, 0, 0, 0, 0, 0}; ...
    {'y4', 0, 0, 'After LPF 4', 500*10^3, 0, 0, 0, 0, 0}; ...
];

% Read binary files for each stage
for file = 1:6
    fid = fopen(sprintf('output\\%s.bin', sig{file, 1}), 'rb');
    sig{file, 2} = fread(fid, inf, 'float');
    fclose(fid);
    sig{file, 3} = reshape(sig{file, 2}, [2, size(sig{file, 2}, 1)/2]).';
    sig{file, 3} = complex(sig{file, 3}(:,1), sig{file, 3}(:,2));
    
    [w, F, theta, r, db] = getFFT(sig{file, 3}, 21, sig{file, 5});
    sig{file, 6} = w;
    sig{file, 7} = F;
    sig{file, 8} = theta;
    sig{file, 9} = r;
    sig{file, 10} = db;
end

%Plot the FFT
figure(2);
for file = 1:6
    subplot(6, 1, file);
    plot(sig{file, 6}, sig{file, 10});
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    title(sig{file, 4});
end

% Recover x[n]
d = firpm(66, [0, 0.2, 0.25, 0.5]/0.5, [0, 1, 0, 0], 'differentiator');
f = sig{6, 3};
u1 = real(f);
v1 = imag(f);

v2 = conv(v1, d);
u2 = conv(u1, d);

delay = zeros(1, 67);
delay(34) = 1;

u1 = conv(u1, delay);
v1 = conv(v1, delay);

f = ((u1 .* v2) - (v1 .* u2)) ./ sqrt(abs(u1).^2 + abs(v1).^2);
f(isnan(f)) = 0;
[w, F, theta, r, db] = getFFT(f, 21, 500*10^3);

% Plot the spectrum of x[n]
figure(3);
plot(w, db);
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
title('Recovered Radio Signal');

% Plot h5-h7
figure(4);
for i = 5:7
    [w, F, theta, r, db] = getFFT(h{i, 1}, 10, h{i, 3});
    subplot(3, 1, i - 4);
    plot(w, db);
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    title(sprintf('LPF %i', i));
end

Write binary file for recovered x[n]
fid = fopen('output\\x.bin', 'wb');
fwrite(fid, f, 'float');
fclose(fid);

% Read binary files for each stage
audio = [ ... % file, x, fs
    {'r1.bin', 0, 0}; ...
    {'r2.bin', 0, 0}; ...
    {'r3.bin', 0, 0}; ...
];
figure(5);
for file = 1:3
    [audio{file, 2}, audio{file, 3}] = bin2audio(audio{file, 1});
    [w, F, theta, r, db] = getFFT(audio{file, 2}, 21, audio{file, 3});
    subplot(3, 1, file);
    plot(w, db);
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    title(sprintf('After LPF %i', file));
end

% Play the bad news
soundsc(audio{3,2}, audio{3,3});
